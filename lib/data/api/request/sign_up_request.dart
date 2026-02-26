import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request.g.dart';

@JsonSerializable()
class SignUpRequest {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'password')
  final String password;

  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'phone')
  final String phone;

  SignUpRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.type,
    required this.phone,
  });

  // Factory method for JSON deserialization
  factory SignUpRequest.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}
