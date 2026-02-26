import 'package:json_annotation/json_annotation.dart';

part 'appointment_update_request.g.dart';

@JsonSerializable()
class AppointmentUpdateRequest {
  @JsonKey(name: 'appointment_id')
  final int appointmentId;

  @JsonKey(name: 'status')
  final String status;

  AppointmentUpdateRequest({
    required this.appointmentId,
    required this.status,
  });

  factory AppointmentUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentUpdateRequestToJson(this);
}
