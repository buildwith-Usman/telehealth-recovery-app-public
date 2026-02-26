import 'package:json_annotation/json_annotation.dart';

part 'available_time_slot.g.dart';

@JsonSerializable()
class AvailableTimeSlot {
  @JsonKey(name: 'weekday')
  final String weekday;

  @JsonKey(name: 'session_duration')
  final String sessionDuration;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  AvailableTimeSlot({
    required this.weekday,
    required this.sessionDuration,
    required this.status,
    required this.startTime,
    required this.endTime,
  });

  factory AvailableTimeSlot.fromJson(Map<String, dynamic> json) =>
      _$AvailableTimeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableTimeSlotToJson(this);
}