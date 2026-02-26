import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';

class AdminSessionData {
  final String id;
  final String patientName;
  final String patientImageUrl;
  final String specialistName;
  final String specialistSpecialty;
  final String specialistImageUrl;
  final DateTime dateTime;
  final String duration;
  final String status;
  final double consultationFee;
  final AdminSessionType sessionType;
  final String? cancelReason;
  final VoidCallback? onTap;

  // Legacy support for existing card implementation
  String get therapistName => specialistName;
  String get therapistImage => specialistImageUrl;
  String get patientImage => patientImageUrl;
  String get time =>
      '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  String get date => '${dateTime.day}/${dateTime.month}/${dateTime.year}';

  AdminSessionData({
    required this.id,
    required this.patientName,
    required this.patientImageUrl,
    required this.specialistName,
    required this.specialistSpecialty,
    required this.specialistImageUrl,
    required this.dateTime,
    required this.duration,
    required this.status,
    required this.consultationFee,
    required this.sessionType,
    this.cancelReason,
    this.onTap,
  });
}
