// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponse _$SignUpResponseFromJson(Map<String, dynamic> json) =>
    SignUpResponse(
      verificationRequired: json['verification_required'] as bool,
      user: SignUpUserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SignUpResponseToJson(SignUpResponse instance) =>
    <String, dynamic>{
      'verification_required': instance.verificationRequired,
      'user': instance.user,
    };

SignUpUserData _$SignUpUserDataFromJson(Map<String, dynamic> json) =>
    SignUpUserData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      type: json['type'] as String,
      phone: json['phone'] as String,
      isVerified: json['is_verified'] as bool,
    );

Map<String, dynamic> _$SignUpUserDataToJson(SignUpUserData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'type': instance.type,
      'phone': instance.phone,
      'is_verified': instance.isVerified,
    };
