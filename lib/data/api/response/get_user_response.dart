import 'package:json_annotation/json_annotation.dart';
import 'user_response.dart';

part 'get_user_response.g.dart';

@JsonSerializable()
class GetUserResponse {
  @JsonKey(name: 'user')
  final UserResponse user;

  GetUserResponse({
    required this.user,
  });

  // Factory method for JSON deserialization
  factory GetUserResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserResponseFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$GetUserResponseToJson(this);
}
