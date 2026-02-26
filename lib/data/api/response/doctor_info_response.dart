import 'package:json_annotation/json_annotation.dart';

part 'doctor_info_response.g.dart';

@JsonSerializable()
class DoctorInfoResponse {
  
  @JsonKey(name: 'id')
  final int? id;
  
  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;
  
  @JsonKey(name: 'specialization')
  final String? specialization;
  
  @JsonKey(name: 'experience')
  final String? experience;

  @JsonKey(name: 'dob')
  final String? dateOfBirth;

  @JsonKey(name: 'degree')
  final String? degree;

  @JsonKey(name: 'license_no')
  final String? licenseNumber;

  @JsonKey(name: 'country_id')
  final int? countryId;
  
  @JsonKey(name: 'gender')
  final String? gender;
  
  @JsonKey(name: 'age')
  final int? age;

  @JsonKey(name: 'commision_type')
  final String? commisionType;

  @JsonKey(name: 'commision_value')
  final String? comissionValue;

  @JsonKey(name: 'completed')
  final int? completed;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'bio')
  final String? bio;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const DoctorInfoResponse({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.specialization,
    this.experience,
    this.dateOfBirth,
    this.degree,
    this.licenseNumber,
    this.countryId,
    this.gender,
    this.age,
    this.commisionType,
    this.comissionValue,
    this.completed,
    this.status,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  factory DoctorInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorInfoResponseToJson(this);
}
