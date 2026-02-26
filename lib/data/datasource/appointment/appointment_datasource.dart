import '../../api/request/appointment_booking_request.dart';
import '../../api/request/appointment_update_request.dart';
import '../../api/response/appointment_booking_response.dart';
import '../../api/response/appointment_response.dart';
import '../../api/response/base_response.dart';

abstract class AppointmentDatasource {
  Future<AppointmentBookingResponse?> bookAppointment(AppointmentBookingRequest request);

  Future<BasePagingResponse<AppointmentResponse>?> getAppointmentsList({
    String? type,
    String? status,
    int? doctorUserId,
    int? patientUserId,
    String? dateFrom,
    String? dateTo,
    int? page,
    int? limit,
  });

  Future<AppointmentResponse?> getAppointmentDetail({
    required int appointmentId,
  });

  Future<AppointmentResponse?> updateAppointment(AppointmentUpdateRequest request);
}
