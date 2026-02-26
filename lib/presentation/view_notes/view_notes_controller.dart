import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_patient_history_use_case.dart';

class ViewNotesController extends BaseController {
  final GetPatientHistoryUseCase getPatientHistoryUseCase;

  ViewNotesController({
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
        print('ViewNotesController initialized with:');
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
    // For now, returning placeholder text
    // You'll need to add a notes field to AppointmentEntity or fetch it separately
    return 'Session notes would be displayed here.\n\nThis is where the specialist\'s notes about the consultation would appear.';
  }

  /// Get prescription URL from current appointment
  String? getPrescriptionUrl() {
    return currentAppointment?.prescriptionUrl;
  }

  /// Check if doctor is psychiatrist to show prescription
  bool get isPsychiatrist {
    final specialization = currentAppointment?.doctor?.doctorInfo?.specialization?.toLowerCase() ?? '';
    return specialization.contains('psychiatrist');
  }

  /// Refresh data
  @override
  Future<void> refresh() async {
    await _loadData();
  }
}
