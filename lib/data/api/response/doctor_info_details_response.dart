import 'package:json_annotation/json_annotation.dart';

part 'doctor_info_details_response.g.dart';

@JsonSerializable()
class DoctorInfoDetailsResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'specialization')
  final String? specialization;

  @JsonKey(name: 'experience')
  final String? experience;

  @JsonKey(name: 'dob')
  final String? dob;

  @JsonKey(name: 'degree')
  final String? degree;

  @JsonKey(name: 'license_no')
  final String? licenseNo;

  @JsonKey(name: 'country_id')
  final int? countryId;

  @JsonKey(name: 'gender')
  final String? gender;

  @JsonKey(name: 'age')
  final int? age;

  @JsonKey(name: 'approved')
  final int? approved;

  @JsonKey(name: 'completed')
  final int? completed;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  DoctorInfoDetailsResponse({
    this.id,
    this.userId,
    this.specialization,
    this.experience,
    this.dob,
    this.degree,
    this.licenseNo,
    this.countryId,
    this.gender,
    this.age,
    this.approved,
    this.completed,
    this.createdAt,
    this.updatedAt,
  });

  factory DoctorInfoDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorInfoDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorInfoDetailsResponseToJson(this);
}