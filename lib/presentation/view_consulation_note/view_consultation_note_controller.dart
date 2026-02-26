import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_patient_history_use_case.dart';

class ViewConsultationNoteController extends BaseController {
  final GetPatientHistoryUseCase getPatientHistoryUseCase;

  ViewConsultationNoteController({
    required this.getPatientHistoryUseCase,
  });

  // Observable properties (isLoading inherited from BaseController)
  final _patientHistory = <AppointmentEntity>[].obs;
  final _currentAppointment = Rx<AppointmentEntity?>(null);

  // Getters
  List<AppointmentEntity> get patientHistory => _patientHistory;
  AppointmentEntity? get currentAppointment => _currentAppointment.value;

  // Parameters passed from previous page
  late final String appointmentType; // 'upcoming' or 'completed'
  late final int? patientId;
  late final AppointmentEntity? appointment;

  @override
  void onInit() {
    super.onInit();
    _initializeParameters();
    _loadData();
  }

  void _initializeParameters() {
    try {
      final args = Get.arguments as Map<String, dynamic>?;

      appointmentType = args?['appointmentType'] ?? 'completed';
      patientId = args?['patientId'];
      appointment = args?['appointment'];

      if (kDebugMode) {
        print('ViewConsultationNoteController initialized with:');
        print('- appointmentType: $appointmentType');
        print('- patientId: $patientId');
        print('- appointment: ${appointment?.id}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing parameters: $e');
      }
    }
  }

  Future<void> _loadData() async {
    if (appointmentType == 'upcoming') {
      // Load patient history for upcoming appointments
      await _loadPatientHistory();
    } else {
      // For completed appointments, just use the passed appointment
      if (appointment != null) {
        _currentAppointment.value = appointment;
      }
    }
  }

  Future<void> _loadPatientHistory() async {
    if (patientId == null) {
      if (kDebugMode) {
        print('Cannot load patient history: patientId is null');
      }
      return;
    }

    try {
      setLoading(true);

      final params = GetPatientHistoryParams.withDefaults(
        patientId: patientId!,
        page: 1,
        limit: 50, // Get all completed sessions
      );

      final result = await getPatientHistoryUseCase.execute(params);

      if (result != null && result.appointments != null) {
        // Filter only completed appointments with notes
        _patientHistory.value = result.appointments!
            .where((apt) => apt.isCompleted)
            .toList();

        if (kDebugMode) {
          print('Loaded ${_patientHistory.length} completed sessions for patient history');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading patient history: $e');
      }
      setGeneralError('Failed to load patient history');
    } finally {
      setLoading(false);
    }
  }

  /// Get page title based on appointment type
  String getPageTitle() {
    return appointmentType == 'upcoming'
        ? 'Patient History'
        : 'Session Notes';
  }

  /// Check if we should show patient history (for upcoming appointments)
  bool get shouldShowPatientHistory => appointmentType == 'upcoming';

  /// Check if we should show current appointment notes (for completed appointments)
  bool get shouldShowCurrentNotes => appointmentType == 'completed';

  /// Get notes from current appointment
  String getCurrentNotes() {
    // This would come from the appointment entity
    // You'll need to add a notes field to AppointmentEntity or fetch it separately

    // TODO: Replace with actual notes from appointment entity
    return 'The patient presented with symptoms of mild anxiety and reported difficulty sleeping over the past two weeks. After a thorough consultation, we discussed various coping mechanisms and lifestyle changes that could help manage the symptoms.\n\nThe patient was advised to practice deep breathing exercises twice daily, maintain a regular sleep schedule, and reduce caffeine intake, especially in the evening hours. We also discussed the importance of regular physical activity and maintaining social connections.\n\nA follow-up appointment has been scheduled in two weeks to monitor progress and assess the effectiveness of the recommended interventions. The patient was encouraged to keep a daily journal to track mood and sleep patterns.';
  }

  /// Get prescription URL from current appointment
  String? getPrescriptionUrl() {
    // If appointment has a prescription URL, use it, otherwise return dummy URL for testing
    if (currentAppointment?.prescriptionUrl != null &&
        currentAppointment!.prescriptionUrl!.isNotEmpty) {
      return currentAppointment?.prescriptionUrl;
    }

    // TODO: Remove this dummy URL when real prescription data is available
    return 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800&q=80';
  }

  /// Check if doctor is psychiatrist to show prescription
  bool get isPsychiatrist {
    final specialization = currentAppointment?.doctor?.doctorInfo?.specialization?.toLowerCase() ?? '';
    return specialization.contains('psychiatrist');
  }

  /// Format appointment date and time - "May 28, 2025 - 01:30 PM"
  String formatAppointmentDateTime(AppointmentEntity appointment) {
    try {
      if (appointment.date == null || appointment.startTime == null) {
        return 'Date not available';
      }

      // Parse the date string (format: "2025-05-28")
      final dateParts = appointment.date!.split('-');
      if (dateParts.length != 3) return 'Invalid date';

      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      // Parse the time string (format: "13:30:00" or "13:30")
      final timeParts = appointment.startTime!.split(':');
      if (timeParts.length < 2) return 'Invalid time';

      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Create DateTime object
      final dateTime = DateTime(year, month, day, hour, minute);

      // Format date part: "May 28, 2025"
      final dateFormat = DateFormat('MMM dd, yyyy');
      final formattedDate = dateFormat.format(dateTime);

      // Format time part: "01:30 PM"
      final timeFormat = DateFormat('hh:mm a');
      final formattedTime = timeFormat.format(dateTime);

      return '$formattedDate - $formattedTime';
    } catch (e) {
      if (kDebugMode) {
        print('Error formatting date/time: $e');
      }
      return 'Invalid date/time';
    }
  }

  /// Refresh data
  @override
  Future<void> refresh() async {
    await _loadData();
  }
}
