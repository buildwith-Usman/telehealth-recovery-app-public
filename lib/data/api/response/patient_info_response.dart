import 'package:json_annotation/json_annotation.dart';

part 'patient_info_response.g.dart';

@JsonSerializable()
class PatientInfoResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'user_id')
  final int userId;

  @JsonKey(name: 'looking_for')
  final String? lookingFor;

  @JsonKey(name: 'dob')
  final String? dob;

  @JsonKey(name: 'gender')
  final String? gender;

  @JsonKey(name: 'blood_group')
  final String? bloodGroup;

  @JsonKey(name: 'completed')
  final int? completed;

  @JsonKey(name: 'age')
  final int? age;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  PatientInfoResponse({
    required this.id,
    required this.userId,
    this.lookingFor,
    this.dob,
    this.gender,
    this.bloodGroup,
    this.completed,
    this.age,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method for JSON deserialization
  factory PatientInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PatientInfoResponseFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$PatientInfoResponseToJson(this);
}
