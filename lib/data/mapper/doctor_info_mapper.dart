import '../../domain/entity/doctor_info_entity.dart';
import '../api/response/doctor_info_response.dart';

class DoctorInfoMapper {
  static DoctorInfoEntity toDoctorInfoEntity(DoctorInfoResponse response) {
    return DoctorInfoEntity(
      id: response.id ?? 0,
      userId: response.userId ?? 0,
      experience: response.experience,
      degree: response.degree,
      specialization: response.specialization,
      dob: response.dateOfBirth,
      licenseNo: response.licenseNumber,
      countryId: response.countryId,
      gender: _capitalizeGender(response.gender),
      status: response.status,
      commissionType: response.commisionType,
      commissionValue: response.comissionValue,
      age: response.age,
      bio: response.bio,
      isCompleted: response.completed == 1,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  /// Capitalize gender value (male -> Male, female -> Female)
  static String? _capitalizeGender(String? gender) {
    if (gender == null || gender.isEmpty) return gender;
    return gender[0].toUpperCase() + gender.substring(1).toLowerCase();
  }
}
