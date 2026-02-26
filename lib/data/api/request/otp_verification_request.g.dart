// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OPTVerificationRequest _$OPTVerificationRequestFromJson(
        Map<String, dynamic> json) =>
    OPTVerificationRequest(
      type: json['type'] as String,
      email: json['email'] as String,
      verificationCode: json['verification_code'] as String,
    );

Map<String, dynamic> _$OPTVerificationRequestToJson(
        OPTVerificationRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'email': instance.email,
      'verification_code': instance.verificationCode,
    };
