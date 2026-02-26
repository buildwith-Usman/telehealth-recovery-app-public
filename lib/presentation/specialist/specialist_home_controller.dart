import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/app/services/app_storage.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_appointments_list_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_appointments_list_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_patients_list_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_user_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/create_prescription_use_case.dart';
import 'package:flutter/foundation.dart';
import '../widgets/banner/sliding_banner.dart';
import '../widgets/cards/item_vertical_card.dart';
import '../widgets/notes_bottom_sheet.dart';
import '../navigation/nav_controller.dart';

class SpecialistHomeController extends BaseController {
  SpecialistHomeController({
    required this.getUserUseCase,
    required this.getPaginatedAppointmentsListUseCase,
    required this.getPaginatedPatientsListUseCase,
    required this.createPrescriptionUseCase,
  });

  final GetUserUseCase getUserUseCase;
  final GetPaginatedAppointmentsListUseCase getPaginatedAppointmentsListUseCase;
  final GetPaginatedPatientsListUseCase getPaginatedPatientsListUseCase;
  final CreatePrescriptionUseCase createPrescriptionUseCase;
  final RoleManager roleManager = RoleManager.instance;

  // ==================== REACTIVE VARIABLES ====================
  final Rxn<UserEntity> _currentUserData = Rxn<UserEntity>();
  final RxList<BannerItem> _upcomingAppointmentsBanner = <BannerItem>[].obs;
  final RxList<ItemData> _recentPatients = <ItemData>[].obs;

  // ==================== GETTERS ====================
  UserEntity? get currentUserData => _currentUserData.value;
  String get userName => currentUserData?.name ?? 'Specialist';
  String? get userImageUrl => currentUserData?.imageUrl;
  List<BannerItem> get upcomingAppointmentsBanner =>
      _upcomingAppointmentsBanner.toList();
  List<ItemData> get recentPatients => _recentPatients.toList();

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    // Check for post-call data and show dialogs after screen is ready
    final hasPostCallData = _checkAndShowPostCallDialog();
    // Only check for pending notes if there's no post-call data (to prevent double showing)
    if (!hasPostCallData) {
      _checkPendingNotes();
    }
  }

  void _initializeData() {
    logger.controller('SpecialistHomeController initialized');
    _loadUserData();
    _loadUpcomingAppointments();
    _loadRecentPatients();
  }

  /// Check for post-call data from NavController and show notes dialog
  /// Returns true if post-call data was found and dialog will be shown
  bool _checkAndShowPostCallDialog() {
    try {
      if (Get.isRegistered<NavController>()) {
        final navController = Get.find<NavController>();
        final data = navController.postCallData;

        if (data != null && data['showNotes'] == true) {
          if (kDebugMode) {
            print('SpecialistHomeController: Post-call data detected, scheduling dialog...');
          }

          // Save pending notes data before showing dialog (in case app closes)
          _savePendingNotesData(data);

          // Use WidgetsBinding to wait for the frame to settle
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Make the delayed callback async so we can await the dialog
            Future.delayed(const Duration(milliseconds: 800), () async {
              await _showPostCallNotesDialog(data);
              // Clear the data after the dialog has completed
              navController.clearPostCallData();
            });
          });

          return true; // Post-call data found
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking post-call data: $e');
      }
    }
    return false; // No post-call data
  }

  /// Check for pending notes from previous app session
  void _checkPendingNotes() {
    try {
      final pendingData = AppStorage.instance.pendingNotesData;

      if (kDebugMode) {
        print('========================================');
        print('SpecialistHomeController: _checkPendingNotes called');
        print('Pending data in storage: $pendingData');
        print('========================================');
      }

      if (pendingData != null && pendingData['showNotes'] == true) {
        if (kDebugMode) {
          print('SpecialistHomeController: Pending notes data found from previous session - WILL SHOW DIALOG');
        }

        // Use WidgetsBinding to wait for the frame to settle
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Make the delayed callback async so we can await the dialog
          Future.delayed(const Duration(milliseconds: 1000), () async {
            await _showPostCallNotesDialog(pendingData);
          });
        });
      } else {
        if (kDebugMode) {
          print('SpecialistHomeController: No pending notes data - dialog will NOT show');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking pending notes: $e');
      }
    }
  }

  /// Save pending notes data to storage
  void _savePendingNotesData(Map<String, dynamic> data) {
    try {
      AppStorage.instance.setPendingNotesData(data);
      if (kDebugMode) {
        print('SpecialistHomeController: Saved pending notes data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving pending notes data: $e');
      }
    }
  }

  /// Clear pending notes data from storage
  void _clearPendingNotesData() {
    try {
      AppStorage.instance.clearPendingNotesData();
      if (kDebugMode) {
        print('SpecialistHomeController: Cleared pending notes data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing pending notes data: $e');
      }
    }
  }

  /// Internal method to show the notes dialog
  Future<void> _showPostCallNotesDialog(Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print('SpecialistHomeController: Showing post-call notes dialog');
      }

      if (Get.context == null || !Get.context!.mounted) {
        if (kDebugMode) {
          print('SpecialistHomeController: Context is invalid, cannot show dialog');
        }
        return;
      }

      // Use the actual notes bottom sheet from widgets
      await showNotesBottomSheet(
        Get.context!,
        patientName: data['patientName'] ?? '',
        patientImageUrl: data['patientImageUrl'],
        appointmentId: data['appointmentId'] ?? '',
        specialization: currentUserData?.doctorInfo?.specialization,
        onSave: ({String? notes, List<PrescribedMedicine>? medicines}) async {
          if (kDebugMode) {
            print('========================================');
            print('SpecialistHomeController: onSave callback triggered');
            print('Notes: $notes');
            print('Medicines: ${medicines?.length ?? 0}');
            print('========================================');
          }

          // Build the combined notes text
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

          try {
            // Submit via API
            final success = await _savePrescriptionNotes(
              appointmentId: int.tryParse(data['appointmentId'] ?? '0') ?? 0,
              notes: combinedNotes,
            );

            if (kDebugMode) {
              print('SpecialistHomeController: API call success: $success');
            }

            // If save failed, throw error so user sees the error message
            if (!success) {
              if (kDebugMode) {
                print('SpecialistHomeController: API call failed, throwing exception');
              }
              throw Exception('Failed to save consultation notes');
            }
          } finally {
            // Clear pending notes data in all cases (success or failure)
            if (kDebugMode) {
              print('SpecialistHomeController: Calling _clearPendingNotesData');
            }
            _clearPendingNotesData();

            // Verify it was cleared
            final verify = AppStorage.instance.pendingNotesData;
            if (kDebugMode) {
              print('SpecialistHomeController: Storage after clear: $verify');
              print('========================================');
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error showing post-call notes dialog: $e');
      }
       _clearPendingNotesData();
    }
  }

  /// Save prescription notes via API
  /// Returns true if successful, false otherwise
  Future<bool> _savePrescriptionNotes({
    required int appointmentId,
    required String notes,
  }) async {
    logger.method('_savePrescriptionNotes - Saving prescription for appointment $appointmentId');

    try {
      final result = await executeApiCall<bool>(
        () => createPrescriptionUseCase.execute(
          appointmentId: appointmentId,
          prescriptionDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          notes: notes,
        ),
        onSuccess: () {
          logger.method('✅ Prescription saved successfully');
          if (kDebugMode) {
            print('Prescription saved successfully for appointment $appointmentId');
          }
        },
        onError: (error) {
          logger.error('⚠️ Failed to save prescription: $error');
          if (kDebugMode) {
            print('Error saving prescription: $error');
          }
        },
      );

      if (kDebugMode) {
        print('SpecialistHomeController: API call result: $result');
      }

      if (result == true) {
        // Refresh appointments list after saving prescription
        await _loadUpcomingAppointments();
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('SpecialistHomeController: Exception occurred: $e');
      }
      return false;
    }
  }

  Future<void> refreshData() async {
    await Future.wait([
      _loadUserData(),
      _loadUpcomingAppointments(),
      _loadRecentPatients(),
    ]);
  }

  /// Load current user data
  Future<void> _loadUserData() async {
    logger.method('_loadUserData - Loading specialist user data');

    final result = await executeApiCall<UserEntity>(
      () => getUserUseCase.execute(),
      onSuccess: () => logger.method('✅ User data fetched successfully'),
      onError: (error) => logger.error('⚠️ Failed to fetch user data: $error'),
    );

    if (result != null) {
      _currentUserData.value = result;
      logger.method('User data loaded: ${result.name}');
      if (kDebugMode) {
        print('SpecialistHomeController: User data loaded');
        print('SpecialistHomeController: User name: ${result.name}');
      }
    } else {
      logger.warning('User data is null');
    }
  }

  void navigateToPatientDetail({
    required String patientId,
    required String patientName,
    required String condition,
    required String lastSession,
    required String imageUrl,
  }) {
    Get.toNamed(
      '/patientDetail', 
      arguments: {
        'patientId': patientId,
        'patientName': patientName,
        'condition': condition,
        'lastSession': lastSession,
        'imageUrl': imageUrl,
      },
    );
  }

  void navigateToPatientsList() {
    Get.toNamed(AppRoutes.recentPatientsList);
  }

  void navigateToSpecialistProfile() {
    Get.toNamed(AppRoutes.specialistView);
  }

  void navigateToRecentPatientConsultationHistory(int patientId) {
    Get.toNamed(
      AppRoutes.recentPatientConsultationHistory,
      arguments: {
        Arguments.patientId: patientId,
      },
    );
    logger.navigation('Navigating to patient consultation history for patient ID: $patientId');
  }

  /// Start video call with complete appointment entity
  void startVideoCall(AppointmentEntity appointment) {
    if (appointment.id == null) {
      logger.error('Cannot start video call: Appointment ID is null');
      Get.snackbar('Error', 'Unable to start video call. Please try again.');
      return;
    }

    Get.toNamed(
      AppRoutes.videoCall,
      arguments: appointment,
    );

    logger.navigation('Starting video call for appointment: ${appointment.id}');
  }

  // ==================== Data Loading ====================

  Future<void> _loadUpcomingAppointments() async {
    logger.method('_loadUpcomingAppointments - Loading upcoming sessions for specialist');

    final userId = AppStorage.instance.userId;
    if (userId == null) {
      logger.warning('Cannot load appointments: User ID is null');
      _upcomingAppointmentsBanner.clear();
      return;
    }

    final params = GetPaginatedAppointmentsListParams.pending(
      doctorUserId: userId,
      page: 1,
      limit: 5,
    );

    final result = await executeApiCall<PaginatedAppointmentsListEntity?>(
      () => getPaginatedAppointmentsListUseCase.execute(params),
      onError: (error) => logger.error('Failed to fetch upcoming sessions: $error'),
    );

    if (result != null && result.appointments?.isNotEmpty == true) {
      final appointments = result.appointments!.take(3).toList();
      final items = appointments.asMap().entries.map((entry) {
        final index = entry.key;
        final appointment = entry.value;
        return _mapAppointmentToBannerItem(appointment, index);
      }).toList();
      _upcomingAppointmentsBanner.assignAll(items);
    } else {
      _upcomingAppointmentsBanner.clear();
    }
  }

  Future<void> _loadRecentPatients() async {
    logger.method('_loadRecentPatients - Loading recent patients from API');

    final params = GetPaginatedPatientsListParams.withDefaults(
      page: 1,
      limit: 10,
    );

    final result = await executeApiCall<PaginatedAppointmentsListEntity?>(
      () => getPaginatedPatientsListUseCase.execute(params),
      onSuccess: () => logger.method('✅ Recent patients loaded successfully'),
      onError: (error) => logger.error('Failed to fetch recent patients: $error'),
    );

    if (result != null && result.appointments?.isNotEmpty == true) {
      final items = result.appointments!
          .map((appointment) => _mapAppointmentToItemData(appointment))
          .whereType<ItemData>()
          .toList();
      _recentPatients.assignAll(items);
      logger.method('Loaded ${items.length} recent patients');
    } else {
      _recentPatients.clear();
      logger.method('No recent patients found');
    }
  }

  // ==================== Mapping Helpers ====================

  BannerItem _mapAppointmentToBannerItem(AppointmentEntity appointment, int index) {
    final patient = appointment.patient;
    final patientName = patient?.name ?? 'Patient';
    final patientImageUrl = patient?.imageUrl;

    // Parse and format date/time
    String formattedTime = 'Upcoming';
    if (appointment.date != null && appointment.startTime != null) {
      try {
        final dateParts = appointment.date!.split('-');
        final timeParts = appointment.startTime!.split(':');
        if (dateParts.length == 3 && timeParts.length >= 2) {
          final appointmentDateTime = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );

          final dateFormat = DateFormat('MMM dd, yyyy');
          final timeFormat = DateFormat('hh:mm a');
          formattedTime = '${dateFormat.format(appointmentDateTime)}, ${timeFormat.format(appointmentDateTime)}';
        }
      } catch (e) {
        logger.error('Error parsing appointment date/time: $e');
      }
    }

    final bannerColors = [
      AppColors.primary,
      const Color(0xFF2E7D7D),
      const Color(0xFF1B5E5E),
    ];
    final backgroundColor = bannerColors[index % bannerColors.length];

    return BannerItem(
      time: formattedTime,
      name: patientName,
      buttonText: 'Start Session',
      backgroundColor: backgroundColor,
      imageUrl: patientImageUrl,
      onButtonPressed: () => startVideoCall(appointment),
    );
  }

  ItemData? _mapAppointmentToItemData(AppointmentEntity appointment) {
    final patient = appointment.patient;
    // if (patient == null) return null;

    final sessionDate = _formatDate(appointment.date);
    final sessionDuration = _getDuration(appointment);
    final patientId = appointment.patUserId;

    return ItemData(
      name: patient?.name ?? '',
      age: null,
      note: _capitalize(appointment.status),
      sessionDate: sessionDate,
      sessionDuration: sessionDuration,
      imageUrl: patient?.imageUrl ?? '',
      onTap: () => navigateToRecentPatientConsultationHistory(patientId ?? 0),
    );
  }

  String? _formatDate(String? date) {
    if (date == null) return null;
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        return DateFormat('d MMM yyyy').format(dt);
      }
    } catch (e) {
      logger.error('Error formatting date: $e');
    }
    return date;
  }

  String? _getDuration(AppointmentEntity appointment) {
    if (appointment.startTime == null || appointment.endTime == null) return null;
    try {
      return '${appointment.startTime} - ${appointment.endTime}';
    } catch (_) {
      return null;
    }
  }

  String? _capitalize(String? value) {
    if (value == null || value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }
}
