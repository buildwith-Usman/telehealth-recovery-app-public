import 'user_entity.dart';
import 'time_slot_entity.dart';

class AppointmentEntity {
  final int? id;
  final int? patUserId;
  final int? docUserId;
  final String? date;
  final String? startTime;
  final String? endTime;
  final int? startTimeInSeconds;
  final int? endTimeInSeconds;
  final String? price;
  final String? status;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final int? timeSlotId;
  final String? agoraVideoUrl;
  final String? agoraChannelName;
  final String? agoraToken;
  final int? agoraUid;
  final String? prescriptionUrl;
  final UserEntity? patient;
  final UserEntity? doctor;
  final TimeSlotEntity? timeSlot;

  AppointmentEntity({
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
    this.prescriptionUrl,
    this.patient,
    this.doctor,
    this.timeSlot,
  });

  // Helper methods for appointment status
  bool get isPending => status?.toLowerCase() == 'pending';
  bool get isConfirmed => status?.toLowerCase() == 'confirmed';
  bool get isCancelled => status?.toLowerCase() == 'cancelled';
  bool get isCompleted => status?.toLowerCase() == 'completed';

  // Helper methods for price
  double? get priceAsDouble {
    if (price == null) return null;
    return double.tryParse(price!);
  }

  // Helper methods for patient/doctor info
  String? get patientName => patient?.name;
  String? get doctorName => doctor?.name;
  String? get patientProfileImageUrl => patient?.imageUrl;
  String? get doctorProfileImageUrl => doctor?.imageUrl;

  // Helper method for formatted date time
  String? get formattedDateTime {
    if (date == null || startTime == null) return null;
    return '$date $startTime';
  }

  // Helper method for duration
  int? get durationInMinutes {
    if (startTimeInSeconds == null || endTimeInSeconds == null) return null;
    return ((endTimeInSeconds! - startTimeInSeconds!) / 60).round();
  }

  // Helper methods for Agora video call parameters
  /// Get Agora channel name, with fallback to generated name from appointment ID
  String getAgoraChannelName() {
    if (agoraChannelName != null && agoraChannelName!.isNotEmpty) {
      return agoraChannelName!;
    }
    // Fallback: generate channel name from appointment ID
    return id != null ? 'appointment_$id' : 'default_channel';
  }

  /// Get Agora token, returns empty string if not available (for testing mode)
  String getAgoraToken() {
    return agoraToken ?? '';
  }

  /// Get Agora UID, returns 0 for auto-assignment if not specified
  int getAgoraUid() {
    return agoraUid ?? 0;
  }

  @override
  String toString() {
    return 'AppointmentEntity{id: $id, status: $status, date: $date, startTime: $startTime, patientName: $patientName, doctorName: $doctorName, prescriptionUrl: $prescriptionUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          patUserId == other.patUserId &&
          docUserId == other.docUserId &&
          date == other.date &&
          startTime == other.startTime &&
          status == other.status &&
          prescriptionUrl == other.prescriptionUrl;

  @override
  int get hashCode => 
      id.hashCode ^
      patUserId.hashCode ^
      docUserId.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      status.hashCode ^
      (prescriptionUrl?.hashCode ?? 0);
}