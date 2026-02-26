import 'package:json_annotation/json_annotation.dart';
import 'package:recovery_consultation_app/data/api/request/available_time_slot.dart';
import 'package:recovery_consultation_app/data/api/request/questionnaire_item.dart';

part 'update_profile_request.g.dart';

@JsonSerializable(includeIfNull: false)
class UpdateProfileRequest {

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'looking_for')
  final String? lookingFor;

  @JsonKey(name: 'completed')
  final int? completed;

  @JsonKey(name: 'age')
  final int? age;

  @JsonKey(name: 'dob')
  final String? dob;

  @JsonKey(name: 'gender')
  final String? gender;

  @JsonKey(name: 'blood_group')
  final String? bloodGroup;

  @JsonKey(name: 'specialization')
  final String? specialization;

  @JsonKey(name: 'experience')
  final int? experience;

  @JsonKey(name: 'degree')
  final String? degree;

  @JsonKey(name: 'license_no')
  final String? licenseNo;

  @JsonKey(name: 'bio')
  final String? bio;

  @JsonKey(name: 'questionnaires')
  final List<QuestionnaireItem>? questionnaires;

  @JsonKey(name: 'file_id')
  final int? fileId;

  @JsonKey(name: 'commision_type')
  final String? commisionType;

  @JsonKey(name: 'commision_value')
  final String? commisionValue;
  
  @JsonKey(name: 'status')
  final String? status;

   @JsonKey(name: 'languages')
  final List<String>? languages;

  @JsonKey(name: 'available_times')
  final List<AvailableTimeSlot>? availableTimes;

  UpdateProfileRequest({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.lookingFor,
    this.completed,
    this.age,
    this.dob,
    this.gender,
    this.bloodGroup,
    this.specialization,
    this.experience,
    this.degree,
    this.licenseNo,
    this.bio,
    this.questionnaires,
    this.commisionType,
    this.commisionValue,
    this.fileId,
    this.status,
    this.languages,
    this.availableTimes
  });

  // Factory method for JSON deserialization
  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$UpdateProfileRequestToJson(this);
}
