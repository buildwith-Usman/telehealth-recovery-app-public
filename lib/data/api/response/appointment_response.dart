import 'package:json_annotation/json_annotation.dart';
import 'user_response.dart';
import 'time_slot_response.dart';

part 'appointment_response.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'pat_user_id')
  final int? patUserId;

  @JsonKey(name: 'doc_user_id')
  final int? docUserId;

  @JsonKey(name: 'date')
  final String? date;

  @JsonKey(name: 'start_time')
  final String? startTime;

  @JsonKey(name: 'end_time')
  final String? endTime;

  @JsonKey(name: 'start_time_in_secconds')
  final int? startTimeInSeconds;

  @JsonKey(name: 'end_time_in_secconds')
  final int? endTimeInSeconds;

  @JsonKey(name: 'price')
  final String? price;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'time_slot_id')
  final int? timeSlotId;

  @JsonKey(name: 'agora_video_url')
  final String? agoraVideoUrl;

  @JsonKey(name: 'agora_channel_name')
  final String? agoraChannelName;

  @JsonKey(name: 'agora_token')
  final String? agoraToken;

  @JsonKey(name: 'agora_uid')
  final int? agoraUid;

  @JsonKey(name: 'patient')
  final UserResponse? patient;

  @JsonKey(name: 'doctor')
  final UserResponse? doctor;

  @JsonKey(name: 'time_slot')
  final TimeSlotResponse? timeSlot;

  AppointmentResponse({
    this.id,
    this.patUserId,
    this.docUserId,
    this.date,
    this.startTime,
    this.endTime,
    this.startTimeInSeconds,
    this.endTimeInSeconds,
    this.price,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.timeSlotId,
    this.agoraVideoUrl,
    this.agoraChannelName,
    this.agoraToken,
    this.agoraUid,
    this.patient,
    this.doctor,
    this.timeSlot,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentResponseToJson(this);

  // Helper methods for appointment data
  
  /// Check if the appointment is pending
  bool get isPending => status?.toLowerCase() == 'pending';
  
  /// Check if the appointment is confirmed
  bool get isConfirmed => status?.toLowerCase() == 'confirmed';
  
  /// Check if the appointment is cancelled
  bool get isCancelled => status?.toLowerCase() == 'cancelled';
  
  /// Check if the appointment is completed
  bool get isCompleted => status?.toLowerCase() == 'completed';
  
  /// Get formatted price
  double? get priceAsDouble {
    if (price == null) return null;
    return double.tryParse(price!);
  }
  
  /// Get patient profile image URL
  String? get patientProfileImageUrl {
    return patient?.file?.url;
  }

  /// Get doctor profile image URL
  String? get doctorProfileImageUrl {
    return doctor?.file?.url;
  }
  
  /// Get patient name
  String? get patientName {
    return patient?.name;
  }
  
  /// Get doctor name
  String? get doctorName {
    return doctor?.name;
  }
  
  /// Get formatted date and time
  String? get formattedDateTime {
    if (date == null || startTime == null) return null;
    return '$date $startTime';
  }
  
  /// Get duration in minutes
  int? get durationInMinutes {
    if (startTimeInSeconds == null || endTimeInSeconds == null) return null;
    return ((endTimeInSeconds! - startTimeInSeconds!) / 60).round();
  }
}