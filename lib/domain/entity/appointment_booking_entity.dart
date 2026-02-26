class AppointmentBookingRequestEntity {
  final int docUserId;
  final String date;
  final int timeSlotId;

  const AppointmentBookingRequestEntity({
    required this.docUserId,
    required this.date,
    required this.timeSlotId,
  });

  @override
  String toString() {
    return 'AppointmentBookingRequestEntity{docUserId: $docUserId, date: $date, timeSlotId: $timeSlotId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentBookingRequestEntity &&
          runtimeType == other.runtimeType &&
          docUserId == other.docUserId &&
          date == other.date &&
          timeSlotId == other.timeSlotId;

  @override
  int get hashCode =>
      docUserId.hashCode ^
      date.hashCode ^
      timeSlotId.hashCode;
}

class AppointmentBookingResponseEntity {
  final int id;
  final int patUserId;
  final int docUserId;
  final String date;
  final String startTime;
  final String endTime;
  final int startTimeInSeconds;
  final int endTimeInSeconds;
  final double price;
  final int timeSlotId;
  final String? agoraVideoUrl;
  final String createdAt;
  final String updatedAt;

  const AppointmentBookingResponseEntity({
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
  });

  @override
  String toString() {
    return 'AppointmentBookingResponseEntity{id: $id, patUserId: $patUserId, docUserId: $docUserId, date: $date, startTime: $startTime, endTime: $endTime, startTimeInSeconds: $startTimeInSeconds, endTimeInSeconds: $endTimeInSeconds, price: $price, timeSlotId: $timeSlotId, agoraVideoUrl: $agoraVideoUrl, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentBookingResponseEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          patUserId == other.patUserId &&
          docUserId == other.docUserId &&
          date == other.date &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          startTimeInSeconds == other.startTimeInSeconds &&
          endTimeInSeconds == other.endTimeInSeconds &&
          price == other.price &&
          timeSlotId == other.timeSlotId &&
          agoraVideoUrl == other.agoraVideoUrl &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      patUserId.hashCode ^
      docUserId.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      startTimeInSeconds.hashCode ^
      endTimeInSeconds.hashCode ^
      price.hashCode ^
      timeSlotId.hashCode ^
      agoraVideoUrl.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}