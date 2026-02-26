
import 'package:recovery_consultation_app/data/api/request/appointment_booking_request.dart';
import 'package:recovery_consultation_app/data/api/request/appointment_update_request.dart';

import '../entity/appointment_booking_entity.dart';
import '../entity/appointment_entity.dart';
import '../entity/paginated_appointments_list_entity.dart';

abstract class AppointmentRepository {

  Future<AppointmentBookingResponseEntity?> bookAppointment(
      AppointmentBookingRequest request);

  Future<PaginatedAppointmentsListEntity> getAppointmentsList({
    String? type,
    String? status,
    int? doctorUserId,
    int? patientUserId,
    String? dateFrom,
    String? dateTo,
    int? page,
    int? limit,
  });

  Future<AppointmentEntity?> getAppointmentDetail({
    required int appointmentId,
  });

  Future<AppointmentEntity?> updateAppointment(AppointmentUpdateRequest request);
}
