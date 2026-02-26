import '../../domain/entity/appointment_booking_entity.dart';
import '../api/request/appointment_booking_request.dart';
import '../api/response/appointment_booking_response.dart';

class AppointmentBookingMapper {
  static AppointmentBookingResponseEntity toAppointmentBookingResponseEntity(
      AppointmentBookingResponse response) {
    return AppointmentBookingResponseEntity(
      id: response.id,
      patUserId: response.patUserId,
      docUserId: response.docUserId,
      date: response.date,
      startTime: response.startTime,
      endTime: response.endTime,
      startTimeInSeconds: response.startTimeInSeconds,
      endTimeInSeconds: response.endTimeInSeconds,
      price: response.price,
      timeSlotId: response.timeSlotId,
      agoraVideoUrl: response.agoraVideoUrl,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  static AppointmentBookingRequest fromAppointmentBookingRequestEntity(
      AppointmentBookingRequestEntity entity) {
    return AppointmentBookingRequest(
      docUserId: entity.docUserId,
      date: entity.date,
      timeSlotId: entity.timeSlotId,
    );
  }
}