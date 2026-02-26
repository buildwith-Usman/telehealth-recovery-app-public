import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';

class DoctorsListEntity {
  final List<DoctorEntity>? doctors;

  DoctorsListEntity({
    this.doctors,
  });

  @override
  String toString() {
    return 'DoctorsListEntity{doctors: $doctors}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorsListEntity &&
          runtimeType == other.runtimeType &&
          doctors == other.doctors;

  @override
  int get hashCode => doctors.hashCode;
}

class DoctorEntity {
  final int? id;
  final String? name;
  final String? email;
  final String? emailVerifiedAt;
  final String? type;
  final String? phone;
  final int? profileImageId;
  final String? profileImageUrl;
  final String? emailVerificationCode;
  final String? emailVerificationCodeExpiresAt;
  final bool? isVerified;
  final String? passwordResetCode;
  final String? passwordResetCodeExpiresAt;
  final String? createdAt;
  final String? updatedAt;
  final DoctorInfoEntity? doctorInfo;
  final List<dynamic>? questionnaires;
  final List<UserLanguageEntity>? userLanguages;
  final List<ReviewEntity>? reviews;

  DoctorEntity({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.type,
    this.phone,
    this.profileImageId,
    this.profileImageUrl,
    this.emailVerificationCode,
    this.emailVerificationCodeExpiresAt,
    this.isVerified,
    this.passwordResetCode,
    this.passwordResetCodeExpiresAt,
    this.createdAt,
    this.updatedAt,
    this.doctorInfo,
    this.questionnaires,
    this.userLanguages,
    this.reviews,
  });

  @override
  String toString() {
    return 'DoctorEntity{id: $id, name: $name, email: $email, type: $type, phone: $phone, profileImageUrl: $profileImageUrl, isVerified: $isVerified, doctorInfo: $doctorInfo}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          emailVerifiedAt == other.emailVerifiedAt &&
          type == other.type &&
          phone == other.phone &&
          emailVerificationCode == other.emailVerificationCode &&
          emailVerificationCodeExpiresAt ==
              other.emailVerificationCodeExpiresAt &&
          isVerified == other.isVerified &&
          passwordResetCode == other.passwordResetCode &&
          passwordResetCodeExpiresAt == other.passwordResetCodeExpiresAt &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          doctorInfo == other.doctorInfo &&
          questionnaires == other.questionnaires;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      emailVerifiedAt.hashCode ^
      type.hashCode ^
      phone.hashCode ^
      emailVerificationCode.hashCode ^
      emailVerificationCodeExpiresAt.hashCode ^
      isVerified.hashCode ^
      passwordResetCode.hashCode ^
      passwordResetCodeExpiresAt.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      doctorInfo.hashCode ^
      questionnaires.hashCode;
}

class UserLanguageEntity {
  final int? id;
  final int? userId;
  final String? language;
  final String? createdAt;
  final String? updatedAt;

  UserLanguageEntity({
    this.id,
    this.userId,
    this.language,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'UserLanguageEntity{id: $id, userId: $userId, language: $language}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLanguageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          language == other.language;

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ language.hashCode;
}

class ReviewEntity {
  final int? id;
  final int? userId;
  final int? doctorId;
  final double? rating;
  final String? comment;
  final String? createdAt;
  final String? updatedAt;

  ReviewEntity({
    this.id,
    this.userId,
    this.doctorId,
    this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'ReviewEntity{id: $id, userId: $userId, doctorId: $doctorId, rating: $rating}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          doctorId == other.doctorId &&
          rating == other.rating;

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ doctorId.hashCode ^ rating.hashCode;
}
