import 'base_entity.dart';

class SpecialistAvailableTimeEntity extends BaseEntity {
  final int userId;
  final String? weekday;
  final String? sessionDuration;
  final String? status;
  final String? startTime;
  final String? endTime;

  const SpecialistAvailableTimeEntity({
    required super.id,
    required this.userId,
    this.weekday,
    this.sessionDuration,
    this.status,
    this.startTime,
    this.endTime,
    super.createdAt,
    super.updatedAt,
  });

  // Helper getters
  bool get isAvailable => status?.toLowerCase() == 'available';
  bool get isUnavailable => status?.toLowerCase() == 'unavailable';

  // Parse session duration to minutes
  int? get sessionDurationMinutes {
    if (sessionDuration == null) return null;
    return int.tryParse(sessionDuration!);
  }
}
