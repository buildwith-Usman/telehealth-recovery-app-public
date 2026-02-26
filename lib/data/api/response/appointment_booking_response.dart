import 'package:json_annotation/json_annotation.dart';
import 'time_slot_response.dart';
import 'user_response.dart';

part 'appointment_booking_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentBookingResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'pat_user_id')
  final int patUserId;

  @JsonKey(name: 'doc_user_id')
  final int docUserId;

  @JsonKey(name: 'date')
  final String date;

  @JsonKey(name: 'start_time')
  final String startTime;

  @JsonKey(name: 'end_time')
  final String endTime;

  @JsonKey(name: 'start_time_in_secconds')
  final int startTimeInSeconds;

  @JsonKey(name: 'end_time_in_secconds')
  final int endTimeInSeconds;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'time_slot_id')
  final int timeSlotId;

  @JsonKey(name: 'agora_video_url')
  final String? agoraVideoUrl;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @JsonKey(name: 'patient')
  final UserResponse? patient;

  @JsonKey(name: 'doctor')
  final UserResponse? doctor;

  @JsonKey(name: 'time_slot')
  final TimeSlotResponse? timeSlot;

  AppointmentBookingResponse({
    required this.id,
    required this.patUserId,
    required this.docUserId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.startTimeInSeconds,
    required this.endTimeInSeconds,
    required this.price,
    required this.timeSlotId,
    this.agoraVideoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.patient,
    this.doctor,
    this.timeSlot,
  });

  // Factory method for JSON deserialization
  factory AppointmentBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentBookingResponseFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$AppointmentBookingResponseToJson(this);
}