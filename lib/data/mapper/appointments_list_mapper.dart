import 'package:recovery_consultation_app/data/api/response/base_response.dart';
import 'package:recovery_consultation_app/data/api/response/appointment_response.dart';
import 'package:recovery_consultation_app/data/mapper/user_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/time_slot_mapper.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_appointments_list_entity.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_doctors_list_entity.dart';

class AppointmentsListMapper {
  static PaginatedAppointmentsListEntity toEntity(BasePagingResponse<AppointmentResponse> response) {
    return PaginatedAppointmentsListEntity(
      appointments: response.data?.map((appointmentResponse) => toAppointmentEntity(appointmentResponse)).toList(),
      pagination: response.total != null || response.currentPage != null
          ? PaginationEntity(
              total: response.total,
              currentPage: response.currentPage,
              perPage: response.perPage,
              lastPage: response.lastPage,
              from: response.from,
              to: response.to,
            )
          : null,
    );
  }

  static AppointmentEntity toAppointmentEntity(AppointmentResponse response) {
    return AppointmentEntity(
      id: response.id,
      patUserId: response.patUserId,
      docUserId: response.docUserId,
      date: response.date,
      startTime: response.startTime,
      endTime: response.endTime,
      startTimeInSeconds: response.startTimeInSeconds,
      endTimeInSeconds: response.endTimeInSeconds,
      price: response.price,
      status: response.status,
      deletedAt: response.deletedAt,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
      timeSlotId: response.timeSlotId,
      agoraVideoUrl: response.agoraVideoUrl,
      agoraChannelName: response.agoraChannelName,
      agoraToken: response.agoraToken,
      agoraUid: response.agoraUid,
      patient: response.patient != null ? UserMapper.toUserEntity(response.patient!) : null,
      doctor: response.doctor != null ? UserMapper.toUserEntity(response.doctor!) : null,
      timeSlot: response.timeSlot != null ? TimeSlotMapper.toEntity(response.timeSlot!) : null,
    );
  }
}