import 'package:json_annotation/json_annotation.dart';

part 'time_slot_response.g.dart';

@JsonSerializable()
class TimeSlotResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'available_time_id')
  final int? availableTimeId;

  @JsonKey(name: 'weekday')
  final String? weekday;

  @JsonKey(name: 'slot_start_time')
  final String? slotStartTime;

  @JsonKey(name: 'slot_end_time')
  final String? slotEndTime;

  @JsonKey(name: 'is_booked')
  final bool? isBooked;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const TimeSlotResponse({
    this.id,
    this.userId,
    this.availableTimeId,
    this.weekday,
    this.slotStartTime,
    this.slotEndTime,
    this.isBooked,
    this.createdAt,
    this.updatedAt,
  });

  factory TimeSlotResponse.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotResponseToJson(this);
}
