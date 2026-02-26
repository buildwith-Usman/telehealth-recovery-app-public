import 'package:json_annotation/json_annotation.dart';
import 'package:recovery_consultation_app/data/api/response/specialist_available_time_response.dart';
import 'patient_info_response.dart';
import 'doctor_info_response.dart';
import 'add_questionnaires_response.dart'; // For QuestionnaireItemResponse
import 'review_response.dart';
import 'file_response.dart';
import 'user_language_response.dart';
import 'time_slot_response.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'profile_image_id')
  final int? profileImageId;

  @JsonKey(name: 'bio')
  final String? bio;

  @JsonKey(name: 'email_verification_code')
  final String? emailVerificationCode;

  @JsonKey(name: 'email_verification_code_expires_at')
  final String? emailVerificationCodeExpiresAt;

  @JsonKey(name: 'is_verified')
  final bool isVerified;

  @JsonKey(name: 'password_reset_code')
  final String? passwordResetCode;

  @JsonKey(name: 'password_reset_code_expires_at')
  final String? passwordResetCodeExpiresAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'doc_appointments_count')
  final int? docAppointmentsCount;

  @JsonKey(name: 'total_rating')
  final int? totalRating;

  @JsonKey(name: 'distinct_patients_count')
  final int? distinctPatientsCount;

  @JsonKey(name: 'patient_info')
  final PatientInfoResponse? patientInfo;

  @JsonKey(name: 'doctor_info')
  final DoctorInfoResponse? doctorInfo;

  @JsonKey(name: 'questionnaires')
  final List<QuestionnaireItemResponse>? questionnaires;

  @JsonKey(name: 'user_languages')
  final List<UserLanguageResponse>? userLanguages;

  @JsonKey(name: 'file')
  final FileData? file;

  @JsonKey(name: 'available_times')
  final List<SpecialistAvailableTimeResponse>? availableTimes;

  @JsonKey(name: 'time_slots')
  final List<TimeSlotResponse>? timeSlots;

  @JsonKey(name: 'reviews')
  final List<ReviewResponse>? reviews;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.type,
    this.phone,
    this.profileImageId,
    this.bio,
    this.emailVerificationCode,
    this.emailVerificationCodeExpiresAt,
    required this.isVerified,
    this.passwordResetCode,
    this.passwordResetCodeExpiresAt,
    this.createdAt,
    this.updatedAt,
    this.docAppointmentsCount,
    this.totalRating,
    this.distinctPatientsCount,
    this.patientInfo,
    this.doctorInfo,
    this.questionnaires,
    this.userLanguages,
    this.file,
    this.availableTimes,
    this.timeSlots,
    this.reviews,
  });

  // Factory method for JSON deserialization
  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
