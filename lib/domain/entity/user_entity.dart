import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/entity/questionnaire_item_entity.dart';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';
import 'package:recovery_consultation_app/domain/entity/specialist_available_time_entity.dart';
import 'package:recovery_consultation_app/domain/entity/time_slot_entity.dart';
import 'base_entity.dart';
import 'patient_info_entity.dart';
import 'doctor_info_entity.dart';
import 'doctor_language_entity.dart';

/// User entity that represents a user in the system (patient, doctor, or admin)
/// Aligned with UserResponse from API
class UserEntity extends BaseEntity {
  // Basic user info
  final String name;
  final String email;
  final String? type; // admin, patient, doctor
  final String? phone;
  final bool? isVerified;
  final String? emailVerifiedAt;
  final String? emailVerificationCode;
  final String? emailVerificationCodeExpiresAt;
  final String? passwordResetCode;
  final String? passwordResetCodeExpiresAt;

  // Image/File related
  final String? imageUrl; // Derived from file.url for convenience
  final int? profileImageId;

  // Bio
  final String? bio;

  // Doctor-specific stats
  final int? docAppointmentsCount;
  final int? totalRating;
  final int? distinctPatientsCount;

  // Related entities
  final PatientInfoEntity? patientInfo;
  final DoctorInfoEntity? doctorInfo;
  final FileEntity? fileInfo;
  final List<DoctorReviewEntity>? reviews;
  final List<DoctorLanguageEntity>? languages;
  final List<QuestionnaireItemEntity>? questionnaires;
  final List<SpecialistAvailableTimeEntity>? availableTimes;
  final List<TimeSlotEntity>? timeSlots;

  const UserEntity({
    required super.id,
    required this.name,
    required this.email,
    super.createdAt,
    super.updatedAt,
    this.type,
    this.phone,
    this.isVerified,
    this.emailVerifiedAt,
    this.emailVerificationCode,
    this.emailVerificationCodeExpiresAt,
    this.passwordResetCode,
    this.passwordResetCodeExpiresAt,
    this.imageUrl,
    this.profileImageId,
    this.bio,
    this.docAppointmentsCount,
    this.totalRating,
    this.distinctPatientsCount,
    this.patientInfo,
    this.doctorInfo,
    this.fileInfo,
    this.reviews,
    this.languages,
    this.questionnaires,
    this.availableTimes,
    this.timeSlots,
  });

  bool get isDoctor => type == UserRole.doctor.name;
  bool get isPatient => type == UserRole.patient.name;
  bool get isAdmin => type == UserRole.admin.name;
}
