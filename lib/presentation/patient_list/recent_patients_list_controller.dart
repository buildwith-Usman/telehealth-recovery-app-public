import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_appointments_list_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_patients_list_use_case.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/item_vertical_card.dart';
import '../../app/config/app_constant.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';

class RecentPatientsListController extends BaseController {
  RecentPatientsListController({
    required this.getPaginatedPatientsListUseCase,
  });

  final GetPaginatedPatientsListUseCase getPaginatedPatientsListUseCase;

  // Reactive variables
  final RxList<ItemData> recentPatients = <ItemData>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    logger.method('_loadPatients - Loading patients from API');

    final params = GetPaginatedPatientsListParams.withDefaults(
      page: 1,
      limit: 20,
    );

    final result = await executeApiCall<PaginatedAppointmentsListEntity?>(
      () => getPaginatedPatientsListUseCase.execute(params),
      onSuccess: () => logger.method('✅ Patients loaded successfully'),
      onError: (error) => logger.error('Failed to fetch patients: $error'),
    );

    if (result != null && result.appointments?.isNotEmpty == true) {
      final items = result.appointments!
          .map((appointment) => _mapAppointmentToItemData(appointment))
          .whereType<ItemData>()
          .toList();
      recentPatients.assignAll(items);
      logger.method('Loaded ${items.length} patients');
    } else {
      recentPatients.clear();
      logger.method('No patients found');
    }
  }

  void goBack() {
    Get.back();
  }

  ItemData? _mapAppointmentToItemData(AppointmentEntity appointment) {
    final patient = appointment.patient;
    // if (patient == null) return null;

    final sessionDate = _formatDate(appointment.date);
    final sessionDuration = _getDuration(appointment);

    return ItemData(
      name: patient?.name ?? '',
      age: null,
      note: _capitalize(appointment.status),
      sessionDate: sessionDate,
      sessionDuration: sessionDuration,
      imageUrl: patient?.imageUrl ?? '',
      onTap: () => navigateToRecentPatientConsultationHistory(appointment.patUserId ?? 0),
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

  void navigateToRecentPatientConsultationHistory(int patientId) {
    Get.toNamed(
      AppRoutes.recentPatientConsultationHistory,
      arguments: {
        Arguments.patientId: patientId,
      },
    );
    logger.navigation('Navigating to patient consultation history for patient ID: $patientId');
  }

}
