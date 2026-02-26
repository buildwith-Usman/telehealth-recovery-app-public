import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';

import '../../data/api/response/doctor_user_response.dart';
import '../../data/api/response/doctor_info_details_response.dart';
import '../../data/api/response/user_language_response.dart' as user_lang;
import '../../data/api/response/review_response.dart';
import '../../data/api/response/base_response.dart';
import '../../domain/entity/doctors_list_entity.dart';

class DoctorsListMapper {
  /// Convert a list of DoctorUserResponse to DoctorsListEntity
  static DoctorsListEntity toEntity(List<DoctorUserResponse> doctors) {
    return DoctorsListEntity(
      doctors: doctors.map((doctor) => _toDoctorEntity(doctor)).toList(),
    );
  }

  /// Convert BasePagingResponse<DoctorUserResponse> to DoctorsListEntity
  static DoctorsListEntity fromPagingResponse(BasePagingResponse<DoctorUserResponse> response) {
    return DoctorsListEntity(
      doctors: response.data?.map((doctor) => _toDoctorEntity(doctor)).toList(),
    );
  }

  static DoctorEntity _toDoctorEntity(DoctorUserResponse response) {
    return DoctorEntity(
      id: response.id,
      name: response.name,
      email: response.email,
      emailVerifiedAt: response.emailVerifiedAt,
      type: response.type,
      phone: response.phone,
      profileImageId: response.profileImageId,
      profileImageUrl: response.profileImageUrl,
      emailVerificationCode: response.emailVerificationCode,
      emailVerificationCodeExpiresAt: response.emailVerificationCodeExpiresAt,
      isVerified: response.isVerified,
      passwordResetCode: response.passwordResetCode,
      passwordResetCodeExpiresAt: response.passwordResetCodeExpiresAt,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
      doctorInfo: response.doctorInfo != null
          ? _toDoctorInfoEntity(response.doctorInfo!)
          : null,
      questionnaires: response.questionnaires,
      userLanguages: response.userLanguages?.map((lang) => _toUserLanguageEntity(lang)).toList(),
      reviews: _mapReviews(response.reviews),
    );
  }

  static DoctorInfoEntity _toDoctorInfoEntity(DoctorInfoDetailsResponse response) {
    return DoctorInfoEntity(
      id: response.id ?? 0,
      userId: response.userId ?? 0,
      specialization: response.specialization,
      experience: response.experience,
      dob: response.dob,
      degree: response.degree,
      licenseNo: response.licenseNo,
      countryId: response.countryId,
      gender: response.gender,
      age: response.age,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  static UserLanguageEntity _toUserLanguageEntity(user_lang.UserLanguageResponse response) {
    return UserLanguageEntity(
      id: response.id,
      userId: response.userId,
      language: response.language,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  /// Map reviews from dynamic list to ReviewEntity list
  static List<ReviewEntity>? _mapReviews(List<dynamic>? reviews) {
    if (reviews == null || reviews.isEmpty) return null;
    
    return reviews
        .whereType<Map<String, dynamic>>()
        .map((review) => _toReviewEntity(ReviewResponse.fromJson(review)))
        .toList();
  }

  static ReviewEntity _toReviewEntity(ReviewResponse response) {
    return ReviewEntity(
      id: response.id,
      userId: response.receiverId, // receiver_id maps to userId
      doctorId: response.senderId, // sender_id maps to doctorId/reviewerId
      rating: (response.rating ?? 0).toDouble(), // Convert int to double, handle null
      comment: response.message, // message maps to comment
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  // Public method for external mappers
  static DoctorEntity toDoctorEntity(DoctorUserResponse response) {
    return _toDoctorEntity(response);
  }
}
