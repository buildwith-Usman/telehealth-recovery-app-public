// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      type: json['type'] as String,
      phone: json['phone'] as String?,
      profileImageId: (json['profile_image_id'] as num?)?.toInt(),
      bio: json['bio'] as String?,
      emailVerificationCode: json['email_verification_code'] as String?,
      emailVerificationCodeExpiresAt:
          json['email_verification_code_expires_at'] as String?,
      isVerified: json['is_verified'] as bool,
      passwordResetCode: json['password_reset_code'] as String?,
      passwordResetCodeExpiresAt:
          json['password_reset_code_expires_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      docAppointmentsCount: (json['doc_appointments_count'] as num?)?.toInt(),
      totalRating: (json['total_rating'] as num?)?.toInt(),
      distinctPatientsCount: (json['distinct_patients_count'] as num?)?.toInt(),
      patientInfo: json['patient_info'] == null
          ? null
          : PatientInfoResponse.fromJson(
              json['patient_info'] as Map<String, dynamic>),
      doctorInfo: json['doctor_info'] == null
          ? null
          : DoctorInfoResponse.fromJson(
              json['doctor_info'] as Map<String, dynamic>),
      questionnaires: (json['questionnaires'] as List<dynamic>?)
          ?.map((e) =>
              QuestionnaireItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      userLanguages: (json['user_languages'] as List<dynamic>?)
          ?.map((e) => UserLanguageResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      file: json['file'] == null
          ? null
          : FileData.fromJson(json['file'] as Map<String, dynamic>),
      availableTimes: (json['available_times'] as List<dynamic>?)
          ?.map((e) => SpecialistAvailableTimeResponse.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      timeSlots: (json['time_slots'] as List<dynamic>?)
          ?.map((e) => TimeSlotResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'email_verified_at': instance.emailVerifiedAt,
      'type': instance.type,
      'phone': instance.phone,
      'profile_image_id': instance.profileImageId,
      'bio': instance.bio,
      'email_verification_code': instance.emailVerificationCode,
      'email_verification_code_expires_at':
          instance.emailVerificationCodeExpiresAt,
      'is_verified': instance.isVerified,
      'password_reset_code': instance.passwordResetCode,
      'password_reset_code_expires_at': instance.passwordResetCodeExpiresAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'doc_appointments_count': instance.docAppointmentsCount,
      'total_rating': instance.totalRating,
      'distinct_patients_count': instance.distinctPatientsCount,
      'patient_info': instance.patientInfo,
      'doctor_info': instance.doctorInfo,
      'questionnaires': instance.questionnaires,
      'user_languages': instance.userLanguages,
      'file': instance.file,
      'available_times': instance.availableTimes,
      'time_slots': instance.timeSlots,
      'reviews': instance.reviews,
    };
