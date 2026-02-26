import 'base_entity.dart';

class TimeSlotEntity extends BaseEntity {
  final int userId;
  final int availableTimeId;
  final String? weekday;
  final String? slotStartTime;
  final String? slotEndTime;
  final bool isBooked;

  const TimeSlotEntity({
    required super.id,
    required this.userId,
    required this.availableTimeId,
    this.weekday,
    this.slotStartTime,
    this.slotEndTime,
    required this.isBooked,
    super.createdAt,
    super.updatedAt,
  });

  // Check if this slot is available (not booked)
  bool get isAvailable => !isBooked;

  // Get formatted time slot (e.g., "10:00 AM - 10:30 AM")
  String getFormattedSlot() {
    if (slotStartTime == null || slotEndTime == null) return '';
    return '$slotStartTime - $slotEndTime';
  }
}
