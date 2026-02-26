import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import '../../app/config/app_routes.dart';
import '../../app/config/app_enum.dart';
import '../../app/controllers/base_controller.dart';
import '../../app/services/role_manager.dart';
import '../../domain/entity/appointment_entity.dart';
import '../../domain/entity/paginated_appointments_list_entity.dart';
import '../../domain/entity/prescription_entity.dart';
import '../../domain/usecase/get_paginated_appointments_list_use_case.dart';
import '../widgets/cards/appointment_card.dart';
import '../widgets/notes_bottom_sheet.dart';

class AppointmentsController extends BaseController {
  final GetPaginatedAppointmentsListUseCase getPaginatedAppointmentsListUseCase;

  AppointmentsController({
    required this.getPaginatedAppointmentsListUseCase,
  });

  // Reactive variables
  final Rx<AppointmentStatus> _selectedStatus = AppointmentStatus.pending.obs;
  final RxList<AppointmentData> _appointments = <AppointmentData>[].obs;
  
  // Pagination state
  final RxInt _currentPage = 1.obs;
  final RxBool _hasMoreData = true.obs;
  final RxBool _isLoadingMore = false.obs;

  // Getters
  AppointmentStatus get selectedStatus => _selectedStatus.value;
  List<AppointmentData> get appointments => _appointments.toList();
  bool get hasMoreData => _hasMoreData.value;
  bool get isLoadingMore => _isLoadingMore.value;

  // Get role manager instance
  RoleManager get roleManager => RoleManager.instance;

  @override
  void onInit() {
    super.onInit();
    _loadAppointments();
  }

  /// Load appointments from API
  Future<void> _loadAppointments({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _appointments.clear();
      _hasMoreData.value = true;
    }

    if (_currentPage.value == 1) {
      setLoading(true);
    } else {
      _isLoadingMore.value = true;
    }

    try {
      // Build params with status filter
      final params = GetPaginatedAppointmentsListParams.withDefaults(
        status: _getStatusStringFromEnum(selectedStatus),
        page: _currentPage.value,
        limit: 20,
      );

      final result = await executeApiCall<PaginatedAppointmentsListEntity?>(
        () => getPaginatedAppointmentsListUseCase.execute(params),
        onSuccess: () {
          logger.controller('✅ Appointments loaded successfully');
        },
        onError: (error) {
          logger.error('❌ Failed to load appointments: $error');
        },
      );

      if (result != null && result.appointments != null && result.appointments!.isNotEmpty) {
        // Convert entities to AppointmentData
        final newAppointments = result.appointments!
            .map((entity) => _entityToAppointmentData(entity))
            .toList();

        if (_currentPage.value == 1) {
          _appointments.assignAll(newAppointments);
        } else {
          _appointments.addAll(newAppointments);
        }

        // Update pagination state
        final hasNextPage = result.pagination?.hasNextPage ?? false;
        _hasMoreData.value = hasNextPage;
        _currentPage.value = (result.pagination?.currentPage ?? 1) + (hasNextPage ? 1 : 0);
      } else {
        if (_currentPage.value == 1) {
          _appointments.clear();
        }
        _hasMoreData.value = false;
      }
    } finally {
      setLoading(false);
      _isLoadingMore.value = false;
    }
  }

  /// Convert AppointmentEntity to AppointmentData
  AppointmentData _entityToAppointmentData(AppointmentEntity entity) {
    // Get doctor/patient info based on role
    final displayUser = roleManager.isPatient ? entity.doctor : entity.patient;
    final displayName = displayUser?.name ?? 'Unknown';
    final displayImageUrl = displayUser?.imageUrl ?? '';
    final displaySpecialty = roleManager.isPatient 
        ? (entity.doctor?.doctorInfo?.specialization ?? 'Specialist')
        : 'Patient';

    final appointmentDate = _parseAppointmentDateTime(entity);
    final status = entity.status?.toLowerCase() ?? 'pending';
    final isCompleted = status == 'completed' || status == 'cancelled';

    return AppointmentData(
      id: entity.id?.toString() ?? '',
      name: displayName,
      title: displaySpecialty,
      specialization: displaySpecialty,
      imageUrl: displayImageUrl,
      rating: _calculateRating(entity),
      nextAvailable: '${appointmentDate.hour}:${appointmentDate.minute.toString().padLeft(2, '0')}',
      isOnline: true,
      appointmentDate: appointmentDate,
      appointmentType: isCompleted ? 'completed' : 'upcoming',
      userRole: roleManager.currentRole!.name,
      onTap: () => _onAppointmentTap(entity, displayName, displaySpecialty, displayImageUrl),
      onViewPrescriptionPressed: isCompleted ? () => _onViewPrescriptionPressed(entity, displayName) : null,
      onBookAgainPressed: isCompleted ? () => _onBookAgainPressed(entity, displayName, displaySpecialty, displayImageUrl) : null,
      onViewNotePressed: () => _navigateToViewNote(entity, isCompleted),
      onButtonPressed: !isCompleted ? () => startVideoCallSession(entity) : null,
      entity: entity,
    );
  }

  /// Calculate rating from doctor reviews
  /// Returns null if no ratings available (follows industry best practice - no fake ratings)
  double? _calculateRating(AppointmentEntity entity) {
    // Only calculate rating for patients viewing doctor appointments
    if (!roleManager.isPatient || entity.doctor == null) {
      return null;
    }

    final reviews = entity.doctor!.reviews;
    if (reviews == null || reviews.isEmpty) {
      return null; // No reviews available yet
    }

    // Filter out reviews without ratings
    final validReviews = reviews.where((review) => review.rating != null).toList();
    if (validReviews.isEmpty) {
      return null; // No valid ratings found
    }

    // Calculate average rating
    final totalRating = validReviews.fold<double>(
      0.0,
      (sum, review) => sum + (review.rating ?? 0).toDouble(),
    );
    
    // Round to 1 decimal place (industry standard for rating display)
    final averageRating = totalRating / validReviews.length;
    return double.parse(averageRating.toStringAsFixed(1));
  }

  /// Parse appointment date and time from entity
  DateTime _parseAppointmentDateTime(AppointmentEntity entity) {
    if (entity.date == null || entity.startTime == null) {
      return DateTime.now();
    }

    try {
      final dateParts = entity.date!.split('-');
      final timeParts = entity.startTime!.split(':');
      if (dateParts.length == 3 && timeParts.length >= 2) {
        return DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      }
    } catch (e) {
      logger.error('Error parsing appointment date/time: $e');
    }
    return DateTime.now();
  }


  void selectStatus(AppointmentStatus status) {
    if (_selectedStatus.value != status) {
      _selectedStatus.value = status;
      _currentPage.value = 1;
      _appointments.clear();
      _hasMoreData.value = true;
      _loadAppointments();
    }
  }

  /// Convert AppointmentStatus enum to API status string
  String? _getStatusStringFromEnum(AppointmentStatus status) {
    return status.name;
  }

  /// Refresh appointments list
  Future<void> refreshAppointments() async {
    await _loadAppointments(refresh: true);
  }

  /// Load more appointments (pagination)
  Future<void> loadMoreAppointments() async {
    if (!_hasMoreData.value || _isLoadingMore.value) {
      return;
    }
    await _loadAppointments();
  }

  void _onAppointmentTap(AppointmentEntity entity, String name, String specialty, String imageUrl) {
    if (kDebugMode) {
      print('Tapped on appointment with $name');
    }

    final status = entity.status?.toLowerCase() ?? 'pending';
    final isCompleted = status == 'completed' || status == 'cancelled';

    if (isCompleted && roleManager.isAdmin) {
      Get.toNamed(
        AppRoutes.sessionDetails,
        arguments: {
          'name': name,
          'profession': specialty,
          'imageUrl': imageUrl,
          'appointmentId': entity.id?.toString() ?? '',
        },
      );
    }
  }

  void bookNewAppointment() {
    if (kDebugMode) {
      print('Navigate to book new appointment');
    }
    // Navigate to specialist list to book new appointment
    Get.toNamed(AppRoutes.specialistList);
  }

  void cancelAppointment(String appointmentId) {
    if (kDebugMode) {
      print('Cancel appointment: $appointmentId');
    }
    // Cancel appointment logic
    Get.snackbar(
      'Appointment Cancelled',
      'Your appointment has been cancelled successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rescheduleAppointment(String appointmentId) {
    if (kDebugMode) {
      print('Reschedule appointment: $appointmentId');
    }
    // Reschedule appointment logic
  }

  void _onViewPrescriptionPressed(AppointmentEntity entity, String doctorName) {
    if (kDebugMode) {
      print('View prescription for appointment with $doctorName');
    }

    // Check if prescription URL exists
    // if (entity.prescriptionUrl == null || entity.prescriptionUrl!.isEmpty) {
    //   if (kDebugMode) {
    //     print('No prescription URL found for appointment ${entity.id}');
    //   }
    //   Get.snackbar(
    //     'No Prescription',
    //     'Prescription is not available for this appointment',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return;
    // }

    // Create PrescriptionEntity from appointment data with dummy medicines
    final prescription = PrescriptionEntity(
      id: entity.id?.toString() ?? '',
      appointmentId: entity.id?.toString() ?? '',
      doctorId: entity.docUserId?.toString() ?? '',
      doctorName: doctorName,
      doctorImageUrl: entity.doctorProfileImageUrl,
      patientId: entity.patUserId?.toString() ?? '',
      patientName: entity.patientName ?? 'Patient',
      prescriptionDate: entity.date != null
          ? DateTime.tryParse(entity.date!) ?? DateTime.now()
          : DateTime.now(),
      medicines: _getDummyMedicines(), // Dummy medicines data
      prescriptionImageUrl: entity.prescriptionUrl,
    );

    // Navigate to order prescription screen
    Get.toNamed(
      AppRoutes.orderPrescription,
      arguments: {
        'prescription': prescription,
      },
    );
  }

  void _onAddNotesPressed(String patientName, String? patientImageUrl, String appointmentId, {String? specialization}) {
    if (kDebugMode) {
      print('Add notes for appointment with $patientName');
    }
    showNotesBottomSheet(
      Get.context!,
      patientName: patientName,
      patientImageUrl: patientImageUrl,
      appointmentId: appointmentId,
      specialization: specialization,
      onSave: ({String? notes, List<PrescribedMedicine>? medicines}) async {
        // Build combined notes from consultation notes and prescription
        String combinedNotes = '';

        if (notes != null && notes.isNotEmpty) {
          combinedNotes = notes;
        }

        if (medicines != null && medicines.isNotEmpty) {
          final medicineList = medicines.map((m) =>
            '${m.name}${m.additionalNotes != null ? " - ${m.additionalNotes}" : ""}'
          ).join('\n');

          if (combinedNotes.isNotEmpty) {
            combinedNotes += '\n\nPrescribed Medicines:\n$medicineList';
          } else {
            combinedNotes = 'Prescribed Medicines:\n$medicineList';
          }
        }

        await _saveConsultationNotes(appointmentId, combinedNotes);
      },
    );
  }

  Future<void> _saveConsultationNotes(String appointmentId, String notes) async {
    try {
      if (kDebugMode) {
        print('Saving consultation notes for appointment: $appointmentId');
        print('Notes length: ${notes.length} characters');
      }

      // TODO: Implement API call to save consultation notes
      // Example API call structure:
      /*
      final response = await apiService.saveConsultationNotes({
        'appointmentId': appointmentId,
        'patientId': participantId, // You might need to pass patient ID in arguments
        'patientName': participantName,
        'notes': notes,
        'doctorId': currentUserId,
        'createdAt': DateTime.now().toIso8601String(),
      });
      */

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Navigate back to navigation screen after successful submission
      Get.offAllNamed(AppRoutes.navScreen);

    } catch (e) {
      if (kDebugMode) {
        print('Error saving consultation notes: $e');
      }
      // Re-throw to let the bottom sheet handle the error
      throw Exception('Failed to save consultation notes');
    }
  }

  /// Submit doctor rating and review
  Future<void> _submitDoctorRating(AppointmentEntity entity, int rating, String review) async {
    try {
      if (kDebugMode) {
        print('Submitting rating: $rating stars, review: $review');
        print('Appointment ID: ${entity.id}, Role: ${roleManager.currentRole!.name}');
      }

      // TODO: Implement API call to submit rating
      // Example API call structure:
      /*
      final response = await apiService.submitDoctorRating({
        'appointmentId': appointmentId,
        'doctorId': participantId, // You might need to pass doctor ID in arguments
        'rating': rating,
        'review': review,
        'patientId': currentUserId,
      });
      */

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Navigate back to navigation screen after successful submission
      Get.offAllNamed(AppRoutes.navScreen);
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting rating: $e');
      }
      // Re-throw to let the bottom sheet handle the error
      throw Exception('Failed to submit rating');
    }
  }

  void _onBookAgainPressed(AppointmentEntity entity, String name, String specialty, String imageUrl) {
    if (kDebugMode) {
      print('Book another session with $name');
    }

    if (roleManager.isSpecialist) {
      // For specialists, show add notes dialog
      final patientName = entity.patient?.name ?? 'Patient';
      final patientImageUrl = entity.patient?.imageUrl;
      _onAddNotesPressed(patientName, patientImageUrl, entity.id?.toString() ?? '', specialization: specialty);
    } else {
      // Navigate to booking page for the same doctor
      Get.toNamed(
        AppRoutes.specialistView,
        arguments: {
          Arguments.doctorId: entity.docUserId, 
        },
      );
    }
  }

  /// Start video call session from appointment
  void startVideoCallSession(AppointmentEntity appointment) {
    // Validate required appointment data
    if (appointment.id == null) {
      logger.error('Cannot start video call: Appointment ID is null');
      Get.snackbar(
        'Error',
        'Unable to start video call. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Navigate to video call screen with complete appointment entity
    Get.toNamed(
      AppRoutes.videoCall,
      arguments: appointment,
    );
    
    logger.navigation('Starting video call for appointment: ${appointment.id}');
  }

  /// Navigate to View Notes page with appropriate context
  void _navigateToViewNote(AppointmentEntity entity, bool isCompleted) {
    final appointmentType = isCompleted ? 'completed' : 'upcoming';
    final patientId = roleManager.isSpecialist ? entity.patUserId : null;

    Get.toNamed(
      AppRoutes.viewConsultationNotes,
      arguments: {
        'appointmentType': appointmentType,
        'patientId': patientId,
        'appointment': entity,
      },
    );

    logger.navigation('Navigating to view notes: type=$appointmentType, patientId=$patientId');
  }

  /// Get dummy medicines data for prescription
  List<PrescribedMedicineEntity> _getDummyMedicines() {
    return [
      const PrescribedMedicineEntity(
        id: '1',
        medicineId: '101',
        medicineName: 'Paracetamol',
        medicineImage: null,
        manufacturer: 'PharmaCorp',
        unitPrice: 15.00,
        dosage: '500mg',
        frequency: 'Three times daily',
        duration: '5 days',
        instructions: 'Take after meals',
        quantity: 15,
        isAvailable: true,
      ),
      const PrescribedMedicineEntity(
        id: '2',
        medicineId: '102',
        medicineName: 'Ibuprofen',
        medicineImage: null,
        manufacturer: 'HealthPlus',
        unitPrice: 20.00,
        dosage: '400mg',
        frequency: 'Twice daily',
        duration: '5 days',
        instructions: 'Take with food to avoid stomach upset',
        quantity: 10,
        isAvailable: true,
      ),
      const PrescribedMedicineEntity(
        id: '3',
        medicineId: '103',
        medicineName: 'Vitamin C Tablets',
        medicineImage: null,
        manufacturer: 'VitaLife',
        unitPrice: 12.00,
        dosage: '1000mg',
        frequency: 'Once daily',
        duration: '7 days',
        instructions: 'Take in the morning',
        quantity: 7,
        isAvailable: true,
      ),
      const PrescribedMedicineEntity(
        id: '4',
        medicineId: '104',
        medicineName: 'Cough Syrup',
        medicineImage: null,
        manufacturer: 'MediCare',
        unitPrice: 25.00,
        dosage: '10ml',
        frequency: 'Three times daily',
        duration: '5 days',
        instructions: 'Take before meals',
        quantity: 1,
        isAvailable: true,
      ),
    ];
  }
}
