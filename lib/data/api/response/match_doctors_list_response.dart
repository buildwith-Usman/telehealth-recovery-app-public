import 'package:json_annotation/json_annotation.dart';
import 'doctor_user_response.dart';

part 'match_doctors_list_response.g.dart';

@JsonSerializable()
class MatchDoctorsListResponse {
  @JsonKey(name: 'doctors')
  final List<DoctorUserResponse>? doctors;

  MatchDoctorsListResponse({
    this.doctors,
  });

  factory MatchDoctorsListResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchDoctorsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MatchDoctorsListResponseToJson(this);
}


