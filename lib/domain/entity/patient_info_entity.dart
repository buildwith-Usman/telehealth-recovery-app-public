import 'base_entity.dart';

class PatientInfoEntity extends BaseEntity {
  final int userId;
  final String? lookingFor;
  final String? gender;
  final String? bloodGroup;
  final String? dob;
  final int? age;
  final bool isCompleted;

  const PatientInfoEntity({
    required super.id,
    required this.userId,
    this.lookingFor,
    this.gender,
    this.bloodGroup,
    this.dob,
    this.age,
    this.isCompleted = false,
    super.createdAt,
    super.updatedAt,
  });
}