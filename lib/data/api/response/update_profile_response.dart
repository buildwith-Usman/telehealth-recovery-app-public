import 'package:json_annotation/json_annotation.dart';
import 'user_response.dart';

part 'update_profile_response.g.dart';

@JsonSerializable()
class UpdateProfileResponse {
  @JsonKey(name: 'user')
  final UserResponse user;

  UpdateProfileResponse({
    required this.user,
  });

  // Factory method for JSON deserialization
  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileResponseFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$UpdateProfileResponseToJson(this);
}
