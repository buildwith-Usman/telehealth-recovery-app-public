// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPVerificationResponse _$OTPVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    OTPVerificationResponse(
      user: json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String?,
      tokenType: json['token_type'] as String?,
    );

Map<String, dynamic> _$OTPVerificationResponseToJson(
        OTPVerificationResponse instance) =>
    <String, dynamic>{
      'user': instance.user,
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      type: json['type'] as String?,
      phone: json['phone'] as String?,
      isVerified: json['is_verified'] as bool?,
      emailVerifiedAt: json['email_verified_at'] as String?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'type': instance.type,
      'phone': instance.phone,
      'is_verified': instance.isVerified,
      'email_verified_at': instance.emailVerifiedAt,
    };
