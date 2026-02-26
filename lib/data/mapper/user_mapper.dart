import 'package:recovery_consultation_app/data/mapper/doctor_language_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/file_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/questionnaires_list_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/review_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/specialist_available_time_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/time_slot_mapper.dart';

import '../../domain/entity/user_entity.dart';
import '../api/response/user_response.dart';
import 'patient_info_mapper.dart';
import 'doctor_info_mapper.dart';

class UserMapper {
  static UserEntity toUserEntity(UserResponse response) {
    return UserEntity(
      id: response.id,
      name: response.name,
      email: response.email,
      emailVerifiedAt: response.emailVerifiedAt,
      type: response.type,
      phone: response.phone,
      emailVerificationCode: response.emailVerificationCode,
      emailVerificationCodeExpiresAt: response.emailVerificationCodeExpiresAt,
      isVerified: response.isVerified,
      passwordResetCode: response.passwordResetCode,
      passwordResetCodeExpiresAt: response.passwordResetCodeExpiresAt,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
      profileImageId: response.profileImageId,
      bio: response.bio,
      docAppointmentsCount: response.docAppointmentsCount,
      totalRating: response.totalRating,
      distinctPatientsCount: response.distinctPatientsCount,
      languages: response.userLanguages
          ?.map(DoctorLanguageMapper.toDoctorLanguageEntity)
          .toList(),
      patientInfo: response.patientInfo != null
          ? PatientInfoMapper.toPatientInfoEntity(response.patientInfo!)
          : null,
      doctorInfo: response.doctorInfo != null
          ? DoctorInfoMapper.toDoctorInfoEntity(response.doctorInfo!)
          : null,
      fileInfo: response.file != null
          ? FileMapper.toFileEntity(response.file!)
          : null,
      reviews: response.reviews
          ?.map((r) => ReviewMapper.toReviewEntity(r))
          .toList(),
      questionnaires: response.questionnaires
          ?.map((q) => QuestionnairesListMapper.toQuestionnaireItemEntity(q))
          .toList(),
      imageUrl: response.file?.getFullUrl(),
      availableTimes: response.availableTimes?.isNotEmpty == true
          ? SpecialistAvailableTimeMapper.toEntityList(response.availableTimes)
          : null,
      timeSlots: response.timeSlots?.isNotEmpty == true
          ? TimeSlotMapper.toEntityList(response.timeSlots)
          : null,
    );
  }
}
