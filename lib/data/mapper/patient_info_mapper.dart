import '../../domain/entity/patient_info_entity.dart';
import '../api/response/patient_info_response.dart';

class PatientInfoMapper {
  static PatientInfoEntity toPatientInfoEntity(PatientInfoResponse response) {
    return PatientInfoEntity(
      id: response.id,
      userId: response.userId,
      lookingFor: response.lookingFor,
      dob: response.dob,
      gender: _capitalizeGender(response.gender),
      bloodGroup: response.bloodGroup,
      age: response.age,
      isCompleted: (response.completed ?? 0) == 1,
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
