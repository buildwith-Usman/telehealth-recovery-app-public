import '../../domain/entity/match_doctors_list_entity.dart';
import '../api/response/match_doctors_list_response.dart';
import '../api/response/doctor_user_response.dart';
import '../api/response/doctor_info_details_response.dart';
import '../api/response/user_language_response.dart';
import '../api/response/add_questionnaires_response.dart';

class MatchDoctorsListMapper {
  static MatchDoctorsListEntity toEntity(MatchDoctorsListResponse response) {
    return MatchDoctorsListEntity(
      doctors: response.doctors?.map((doctor) => _toDoctorUserEntity(doctor)).toList(),
    );
  }

  static DoctorUserEntity _toDoctorUserEntity(DoctorUserResponse response) {
    return DoctorUserEntity(
      id: response.id,
      name: response.name,
      email: response.email,
      phone: response.phone,
      type: response.type,
      isVerified: response.isVerified,
      profileImage: response.profileImage,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
      doctorInfo: response.doctorInfo != null ? _toDoctorInfoDetailsEntity(response.doctorInfo!) : null,
      userLanguages: response.userLanguages?.map((language) => _toUserLanguageEntity(language)).toList(),
      userQuestionnaires: response.userQuestionnaires?.map((questionnaire) => _toUserQuestionnaireEntity(questionnaire)).toList(),
    );
  }

  static DoctorInfoDetailsEntity _toDoctorInfoDetailsEntity(DoctorInfoDetailsResponse response) {
    return DoctorInfoDetailsEntity(
      id: response.id,
      userId: response.userId,
      specialization: response.specialization,
      experience: response.experience,
      dob: response.dob,
      degree: response.degree,
      licenseNo: response.licenseNo,
      countryId: response.countryId,
      gender: response.gender,
      age: response.age,
      approved: response.approved,
      completed: response.completed,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  static UserLanguageEntity _toUserLanguageEntity(UserLanguageResponse response) {
    return UserLanguageEntity(
      id: response.id,
      userId: response.userId,
      language: response.language,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  static UserQuestionnaireEntity _toUserQuestionnaireEntity(QuestionnaireItemResponse response) {
    return UserQuestionnaireEntity(
      id: response.id,
      userId: response.userId,
      key: response.key,
      answer: response.answer,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }
}
