import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/domain/models/session_data.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_appointments_list_use_case.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_appointments_list_entity.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';

class AdminSessionsController extends BaseController {
  final GetPaginatedAppointmentsListUseCase getPaginatedAppointmentsListUseCase;

  AdminSessionsController({required this.getPaginatedAppointmentsListUseCase});

  // Reactive variables
  final Rx<AdminSessionType> _selectedType = AdminSessionType.upcoming.obs;
  final RxList<AdminSessionData> _filteredSessions = <AdminSessionData>[].obs;

  // Separate lists for each tab
  final RxList<AdminSessionData> upcomingSessions = <AdminSessionData>[].obs;
  final RxList<AdminSessionData> ongoingSessions = <AdminSessionData>[].obs;
  final RxList<AdminSessionData> completedSessions = <AdminSessionData>[].obs;

  // Getters
  AdminSessionType get selectedType => _selectedType.value;
  List<AdminSessionData> get filteredSessions => _filteredSessions.toList();

  @override
  void onInit() {
    super.onInit();
    // Load all three types initially
    loadUpComingAppointments();
    loadOnGoingAppointments();
    loadCompletedAppointments();
  }

  void selectType(AdminSessionType type) {
    _selectedType.value = type;
    _updateFilteredSessions();
  }

  void _updateFilteredSessions() {
    switch (selectedType) {
      case AdminSessionType.upcoming:
        _filteredSessions.value = upcomingSessions.toList();
        break;
      case AdminSessionType.ongoing:
        _filteredSessions.value = ongoingSessions.toList();
        break;
      case AdminSessionType.completed:
        _filteredSessions.value = completedSessions.toList();
        break;
      case AdminSessionType.cancelled:
        // Map cancelled to completed list or filter if needed
        _filteredSessions.value = completedSessions.where((s) => s.status?.toLowerCase() == 'cancelled').toList();
        break;
    }
  }

  void navigateToSessionDetails(AdminSessionData session) {
    if (kDebugMode) {
      print('Tapped on session: ${session.id}');
    }

    // Navigate to session detail page
    Get.toNamed(
      AppRoutes.sessionDetails,
      arguments: {
        'sessionId': session.id,
        'patientName': session.patientName,
        'specialistName': session.specialistName,
        'sessionType': session.sessionType.name,
      },
    );
  }

  void joinSession(AdminSessionData session) {
    if (kDebugMode) {
      print('Admin joining session: ${session.id}');
    }

    // Navigate to video call as admin observer
    Get.toNamed(
      AppRoutes.videoCall,
      arguments: {
        'sessionId': session.id,
        'userRole': 'admin',
        'patientName': session.patientName,
        'specialistName': session.specialistName,
      },
    );
  }

  void viewSessionDetails(AdminSessionData session) {
    if (kDebugMode) {
      print('Viewing session details: ${session.id}');
    }
    navigateToSessionDetails(session);
  }

  void cancelSession(String sessionId, String reason) {
    if (kDebugMode) {
      print('Admin cancelling session: $sessionId, reason: $reason');
    }
    // In real app, this would call an API to cancel the session.
    Get.snackbar(
      'Session Cancelled',
      'The session has been cancelled successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Refresh current tab
    refreshData();
  }

  void rescheduleSession(String sessionId) {
    if (kDebugMode) {
      print('Admin rescheduling session: $sessionId');
    }

  }
  
  /// Load upcoming appointments from API
  void loadUpComingAppointments() {
    _fetchAppointments(type: 'upcoming', status: null, targetList: upcomingSessions);
  }

  /// Load ongoing appointments from API
  void loadOnGoingAppointments() {
    _fetchAppointments(type: 'ongoing', status: null, targetList: ongoingSessions);
  }

  /// Load completed appointments from API (uses status param)
  void loadCompletedAppointments() {
    _fetchAppointments(type: null, status: 'completed', targetList: completedSessions);
  }

  void refreshData() async {
    // Refresh current tab only for efficiency
    switch (selectedType) {
      case AdminSessionType.upcoming:
        loadUpComingAppointments();
        break;
      case AdminSessionType.ongoing:
        loadOnGoingAppointments();
        break;
      case AdminSessionType.completed:
      case AdminSessionType.cancelled:
        loadCompletedAppointments();
        break;
    }
  }

  // Common fetch helper that loads appointments from API and maps to AdminSessionData
  Future<void> _fetchAppointments({String? type, String? status, required RxList<AdminSessionData> targetList}) async {
    try {
      isLoading.value = true;
      final params = GetPaginatedAppointmentsListParams(
        type: type,
        status: status,
        page: 1,
        limit: 20,
      );

      final result = await executeApiCall<PaginatedAppointmentsListEntity?>(() => getPaginatedAppointmentsListUseCase.execute(params),
          onSuccess: () => logger.method('✅ Appointments fetched'), onError: (e) => logger.method('⚠️ Failed to fetch appointments: $e'));

      if (result != null && result.appointments != null) {
        // Convert AppointmentEntity -> AdminSessionData
        final items = result.appointments!.map((a) => _convertAppointmentToSession(a, type == 'ongoing' ? AdminSessionType.ongoing : (status == 'completed' ? AdminSessionType.completed : AdminSessionType.upcoming))).toList();
        targetList.assignAll(items);
      } else {
        targetList.clear();
      }

      // Update filtered sessions if current tab matches
      _updateFilteredSessions();
    } catch (e, st) {
      logger.method('❌ Error fetching appointments: $e\n$st');
      targetList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  AdminSessionData _convertAppointmentToSession(AppointmentEntity appointment, AdminSessionType sessionType) {
    final dateTime = _parseAppointmentDateTime(appointment.date, appointment.startTime);
    final duration = _calculateDuration(appointment.startTimeInSeconds, appointment.endTimeInSeconds);
    return AdminSessionData(
      id: appointment.id?.toString() ?? 'unknown',
      patientName: appointment.patient?.name ?? 'Unknown Patient',
      patientImageUrl: appointment.patient?.imageUrl ?? '',
      specialistName: appointment.doctor?.name ?? 'Unknown Specialist',
      specialistSpecialty: appointment.doctor?.doctorInfo?.specialization ?? 'Specialist',
      specialistImageUrl: appointment.doctor?.imageUrl ?? '',
      dateTime: dateTime,
      duration: duration,
      status: appointment.status ?? 'Scheduled',
      consultationFee: double.tryParse(appointment.price?.toString() ?? '0') ?? 0.0,
      sessionType: sessionType,
    );
  }

  DateTime _parseAppointmentDateTime(String? date, String? startTime) {
    try {
      if (date == null || startTime == null) return DateTime.now();
      final cleaned = '${date.trim()} ${startTime.trim()}';
      // Try parsing common formats
      return DateTime.parse(cleaned);
    } catch (_) {
      return DateTime.now();
    }
  }

  String _calculateDuration(int? startSeconds, int? endSeconds) {
    try {
      if (startSeconds == null || endSeconds == null) return '60 min';
      final mins = ((endSeconds - startSeconds) / 60).toInt();
      return '$mins min';
    } catch (_) {
      return '60 min';
    }
  }

  // Note: sample data removed - data now fetched from API
}
