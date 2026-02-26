// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePasswordRequest _$CreatePasswordRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePasswordRequest(
      verificationToken: json['verification_token'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$CreatePasswordRequestToJson(
        CreatePasswordRequest instance) =>
    <String, dynamic>{
      'verification_token': instance.verificationToken,
      'password': instance.password,
    };
