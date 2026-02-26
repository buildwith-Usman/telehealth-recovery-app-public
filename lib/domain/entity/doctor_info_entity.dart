import 'package:recovery_consultation_app/app/config/app_enum.dart';

import 'base_entity.dart';

class DoctorInfoEntity extends BaseEntity {
  final int userId;
  final String? specialization;
  final String? degree;
  final String? experience;
  final String? licenseNo;
  final int? countryId;
  final String? gender;
  final int? age;
  final bool? isCompleted;
  final String? status;
  final String? dob;
  final String? commissionType;
  final String? commissionValue;
  final String? bio;

  const DoctorInfoEntity({
    required super.id,
    required this.userId,
    required this.specialization,
    required this.degree,
    this.experience,
    this.licenseNo,
    this.countryId,
    this.gender,
    this.age,
    this.status,
    this.isCompleted = false,
    this.dob,
    this.commissionType,
    this.commissionValue,
    this.bio,
    super.createdAt,
    super.updatedAt,
  });

  bool get isPending => status?.toLowerCase() == SpecialistStatus.pending.name;
  bool get isRejected => status?.toLowerCase() == SpecialistStatus.rejected.name;
  bool get isApproved =>
      status?.toLowerCase() == SpecialistStatus.approved.name;
  bool get isIncomplete => !(isCompleted ?? false);
}
