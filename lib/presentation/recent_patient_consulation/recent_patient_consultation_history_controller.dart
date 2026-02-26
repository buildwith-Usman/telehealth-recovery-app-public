import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_appointments_list_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_patient_history_use_case.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/item_horizontal_content_card.dart';
import '../../app/config/app_constant.dart';
import '../../app/controllers/base_controller.dart';

class RecentPatientConsultationHistoryController extends BaseController {
  RecentPatientConsultationHistoryController({
    required this.getPatientHistoryUseCase,
  });

  final GetPatientHistoryUseCase getPatientHistoryUseCase;

  final historyItems = <ItemHorizontalContentCardData>[].obs;
  int? _patientId;

  @override
  void onInit() {
    super.onInit();
    _loadPatientIdFromArguments();
    fetchConsultationHistory();
  }

  void _loadPatientIdFromArguments() {
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null && args[Arguments.patientId] != null) {
        _patientId = args[Arguments.patientId] as int;
        logger.method('Patient ID loaded from arguments: $_patientId');
      } else {
        logger.error('No patient ID found in arguments');
        Get.back();
      }
    } catch (e) {
      logger.error('Error loading patient ID from arguments: $e');
      Get.back();
    }
  }

  Future<void> fetchConsultationHistory() async {
    final patientId = _patientId;
    if (patientId == null) {
      logger.error('Cannot fetch consultation history: Patient ID is null');
      return;
    }

    logger.method('fetchConsultationHistory - Loading patient history for patient ID: $patientId');

    final params = GetPatientHistoryParams.withDefaults(
      patientId: patientId,
      page: 1,
      limit: 20,
    );

    final result = await executeApiCall<PaginatedAppointmentsListEntity?>(
      () => getPatientHistoryUseCase.execute(params),
      onSuccess: () => logger.method('✅ Patient consultation history loaded successfully'),
      onError: (error) => logger.error('Failed to fetch patient consultation history: $error'),
    );

    if (result != null && result.appointments?.isNotEmpty == true) {
      final items = result.appointments!
          .map((appointment) => _mapAppointmentToItemData(appointment))
          .whereType<ItemHorizontalContentCardData>()
          .toList();
      historyItems.assignAll(items);
      logger.method('Loaded ${items.length} consultation history items');
    } else {
      historyItems.clear();
      logger.method('No consultation history found');
    }
  }

  ItemHorizontalContentCardData? _mapAppointmentToItemData(AppointmentEntity appointment) {
    final patient = appointment.patient;
    if (patient == null) return null;

    DateTime? appointmentDate;
    if (appointment.date != null && appointment.startTime != null) {
      try {
        final dateParts = appointment.date!.split('-');
        final timeParts = appointment.startTime!.split(':');
        if (dateParts.length == 3 && timeParts.length >= 2) {
          appointmentDate = DateTime(
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
    }

    return ItemHorizontalContentCardData(
      id: appointment.id?.toString() ?? '',
      name: patient.name,
      imageUrl: patient.imageUrl ?? '',
      appointmentDate: appointmentDate ?? DateTime.now(),
      notes: null, // Notes would come from a different field if available
      prescriptionUrl: appointment.prescriptionUrl,
      status: appointment.status ?? '',
      onTap: () {
        // Handle tap if needed
        logger.method('Tapped consultation history item: ${appointment.id}');
      },
      onDropdownTap: () {
        // Handle dropdown tap if needed
        logger.method('Tapped dropdown for consultation history item: ${appointment.id}');
      },
    );
  }
}
