import 'package:flutter/cupertino.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';
import 'package:recovery_consultation_app/domain/entity/patient_info_entity.dart';

class ProfileCardItem {
  final String? name;
  final String? email;
  final int? totalPayments;
  final int? totalSessions;
  final String? age;
  final String? note;
  final String? sessionDate;
  final String? sessionDuration;
  final String? profession;
  final String? degree;
  final String? experience;
  final double? rating;
  final String? imageUrl;
  final String? noOfRatings;
  final String? timeAvailability;
  final String? licenseNo;
  final PatientInfoEntity? patientInfo;
  final DoctorInfoEntity? doctorInfo;
  final bool? viewProfileCardButton;
  final VoidCallback? onTap;

  const ProfileCardItem({
    this.name,
    this.email,
    this.totalPayments,
    this.totalSessions,
    this.age,
    this.note,
    this.sessionDate,
    this.sessionDuration,
    this.profession,
    this.degree,
    this.experience,
    this.rating,
    this.imageUrl,
    this.noOfRatings,
    this.licenseNo,
    this.timeAvailability,
    this.patientInfo,
    this.doctorInfo,
    this.viewProfileCardButton = true,
    this.onTap,
  });
}
