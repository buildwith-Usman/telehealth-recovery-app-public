import 'package:recovery_consultation_app/data/api/response/time_slot_response.dart';
import 'package:recovery_consultation_app/domain/entity/time_slot_entity.dart';

class TimeSlotMapper {
  static TimeSlotEntity toEntity(TimeSlotResponse response) {
    return TimeSlotEntity(
      id: response.id ?? 0,
      userId: response.userId ?? 0,
      availableTimeId: response.availableTimeId ?? 0,
      weekday: response.weekday,
      slotStartTime: response.slotStartTime,
      slotEndTime: response.slotEndTime,
      isBooked: response.isBooked ?? false,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  static List<TimeSlotEntity> toEntityList(List<TimeSlotResponse>? responses) {
    if (responses == null || responses.isEmpty) return [];
    return responses.map((response) => toEntity(response)).toList();
  }
}
