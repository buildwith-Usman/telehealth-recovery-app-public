import 'package:json_annotation/json_annotation.dart';
import 'user_response.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'user')
  final UserResponse user;

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  LoginResponse({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  // Factory method for JSON deserialization
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
