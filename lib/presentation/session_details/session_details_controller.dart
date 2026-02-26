import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import '../../app/controllers/base_controller.dart';
import '../../domain/entity/appointment_entity.dart';
import '../../domain/models/session_data.dart';
import '../../domain/usecase/get_appointment_detail_use_case.dart';

class SessionDetailsController extends BaseController {
  final GetAppointmentDetailUseCase getAppointmentDetailUseCase;

  SessionDetailsController({required this.getAppointmentDetailUseCase});

  // Reactive variables
  final Rxn<AppointmentEntity> _appointmentDetail = Rxn<AppointmentEntity>();
  final Rxn<AdminSessionData> _sessions = Rxn<AdminSessionData>();

  // Getters
  AdminSessionData? get sessions => _sessions.value;
  AppointmentEntity? get appointmentDetail => _appointmentDetail.value;

  @override
  void onInit() {
    super.onInit();
    _loadSessionDetails();
  }

  void _loadSessionDetails() {
    // Get sessionId from navigation arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    final sessionId = arguments?[Arguments.sessionId] as String?;

    if (sessionId != null) {
      final appointmentId = int.tryParse(sessionId);
      if (appointmentId != null) {
        loadAppointmentDetail(appointmentId);
      } else {
        logger.warning('Invalid session ID: $sessionId');
      }
    } else {
      logger.warning('No session ID provided in arguments');
    }
  }

  Future<void> loadAppointmentDetail(int appointmentId) async {
    try {
      isLoading.value = true;

      final params = GetAppointmentDetailParams(
        appointmentId: appointmentId,
      );

      final result = await executeApiCall<AppointmentEntity?>(
        () => getAppointmentDetailUseCase.execute(params),
        onSuccess: () => logger.method('✅ Appointment detail fetched'),
        onError: (e) => logger.method('⚠️ Failed to fetch appointment detail: $e'),
      );

      if (result != null) {
        _appointmentDetail.value = result;
        _updateSessionDataFromAppointment(result);
        logger.controller('Loaded appointment detail: ${result.id}');
      }
    } catch (e, st) {
      logger.method('❌ Error fetching appointment detail: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateSessionDataFromAppointment(AppointmentEntity appointment) {
    // Convert AppointmentEntity to AdminSessionData for UI compatibility
    final sessionType = _determineSessionType(appointment.status);

    _sessions.value = AdminSessionData(
      id: appointment.id?.toString() ?? '0',
      patientName: appointment.patientName ?? 'Unknown Patient',
      patientImageUrl: appointment.patientProfileImageUrl ?? '',
      specialistName: appointment.doctorName ?? 'Unknown Doctor',
      specialistSpecialty: appointment.doctor?.doctorInfo?.specialization ?? 'Specialist',
      specialistImageUrl: appointment.doctorProfileImageUrl ?? '',
      dateTime: _parseDateTime(appointment.date, appointment.startTime),
      duration: _formatDuration(appointment.durationInMinutes),
      status: appointment.status ?? 'Unknown',
      consultationFee: appointment.priceAsDouble ?? 0.0,
      sessionType: sessionType,
    );
  }

  AdminSessionType _determineSessionType(String? status) {
    if (status == null) return AdminSessionType.upcoming;

    switch (status.toLowerCase()) {
      case 'completed':
        return AdminSessionType.completed;
      case 'cancelled':
        return AdminSessionType.cancelled;
      case 'ongoing':
        return AdminSessionType.ongoing;
      default:
        return AdminSessionType.upcoming;
    }
  }

  DateTime _parseDateTime(String? date, String? time) {
    try {
      if (date == null || time == null) return DateTime.now();
      final dateTimeStr = '$date $time';
      return DateTime.parse(dateTimeStr);
    } catch (_) {
      return DateTime.now();
    }
  }

  String _formatDuration(int? minutes) {
    if (minutes == null) return '60 min';
    return '$minutes min';
  }
}
