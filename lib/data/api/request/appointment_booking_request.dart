import 'package:json_annotation/json_annotation.dart';

part 'appointment_booking_request.g.dart';

@JsonSerializable()
class AppointmentBookingRequest {
  @JsonKey(name: 'doc_user_id')
  final int docUserId;

  @JsonKey(name: 'date')
  final String date;

  @JsonKey(name: 'time_slot_id')
  final int timeSlotId;

  AppointmentBookingRequest({
    required this.docUserId,
    required this.date,
    required this.timeSlotId,
  });

  // Factory method for JSON deserialization
  factory AppointmentBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentBookingRequestFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$AppointmentBookingRequestToJson(this);
}