// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_password_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePasswordResponse _$CreatePasswordResponseFromJson(
        Map<String, dynamic> json) =>
    CreatePasswordResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
      level: json['level'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$CreatePasswordResponseToJson(
        CreatePasswordResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'status': instance.status,
      'level': instance.level,
      'phone': instance.phone,
    };
