import 'package:json_annotation/json_annotation.dart';
import 'doctor_info_details_response.dart';
import 'user_language_response.dart';
import 'add_questionnaires_response.dart'; // For QuestionnaireItemResponse
import 'file_response.dart';

part 'doctor_user_response.g.dart';

@JsonSerializable()
class DoctorUserResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'profile_image_id')
  final int? profileImageId;

  @JsonKey(name: 'email_verification_code')
  final String? emailVerificationCode;

  @JsonKey(name: 'email_verification_code_expires_at')
  final String? emailVerificationCodeExpiresAt;

  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  @JsonKey(name: 'password_reset_code')
  final String? passwordResetCode;

  @JsonKey(name: 'password_reset_code_expires_at')
  final String? passwordResetCodeExpiresAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'file')
  final FileResponse? file;

  @JsonKey(name: 'doctor_info')
  final DoctorInfoDetailsResponse? doctorInfo;

  @JsonKey(name: 'user_languages')
  final List<UserLanguageResponse>? userLanguages;

  @JsonKey(name: 'user_questionnaires')
  final List<QuestionnaireItemResponse>? userQuestionnaires;

  @JsonKey(name: 'questionnaires')
  final List<QuestionnaireItemResponse>? questionnaires;

  @JsonKey(name: 'reviews')
  final List<dynamic>? reviews;

  DoctorUserResponse({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.phone,
    this.type,
    this.profileImageId,
    this.emailVerificationCode,
    this.emailVerificationCodeExpiresAt,
    this.isVerified,
    this.passwordResetCode,
    this.passwordResetCodeExpiresAt,
    this.createdAt,
    this.updatedAt,
    this.file,
    this.doctorInfo,
    this.userLanguages,
    this.userQuestionnaires,
    this.questionnaires,
    this.reviews,
  });

  factory DoctorUserResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorUserResponseToJson(this);

  // Helper methods for file handling
  
  /// Get the profile image URL from the file
  String? get profileImageUrl {
    return file?.file?.getFullUrl();
  }
  
  /// Get the profile image URL with a base URL
  String? getProfileImageUrl({String? baseUrl}) {
    return file?.file?.getFullUrl(baseUrl: baseUrl);
  }
  
  /// Check if the doctor has a profile image
  
  /// Get the file name if available
  String? get profileImageName {
    return file?.file?.fileName;
  }
  
  /// Get formatted file size for profile image
  String? get profileImageSize {
    return file?.file?.formattedSize;
  }
  
  /// Get the profile image directly (backward compatibility)
  String? get profileImage {
    return profileImageUrl;
  }
}

