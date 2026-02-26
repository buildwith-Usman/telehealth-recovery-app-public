import 'package:json_annotation/json_annotation.dart';

part 'specialist_available_time_response.g.dart';

@JsonSerializable()
class SpecialistAvailableTimeResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'weekday')
  final String? weekday;

  @JsonKey(name: 'session_duration')
  final String? sessionDuration;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'start_time')
  final String? startTime;

  @JsonKey(name: 'end_time')
  final String? endTime;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  SpecialistAvailableTimeResponse({
    this.id,
    this.userId,
    this.weekday,
    this.sessionDuration,
    this.status,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
  });

  factory SpecialistAvailableTimeResponse.fromJson(Map<String, dynamic> json) =>
      _$SpecialistAvailableTimeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialistAvailableTimeResponseToJson(this);
}