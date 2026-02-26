import '../../domain/entity/specialist_available_time_entity.dart';
import '../api/response/specialist_available_time_response.dart';

class SpecialistAvailableTimeMapper {
  static SpecialistAvailableTimeEntity toEntity(
    SpecialistAvailableTimeResponse response,
  ) {
    return SpecialistAvailableTimeEntity(
      id: response.id ?? 0,
      userId: response.userId ?? 0,
      weekday: response.weekday,
      sessionDuration: response.sessionDuration,
      status: response.status,
      startTime: response.startTime,
      endTime: response.endTime,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  static List<SpecialistAvailableTimeEntity> toEntityList(
    List<SpecialistAvailableTimeResponse>? responses,
  ) {
    if (responses == null) return [];
    return responses.map(toEntity).toList();
  }
}
