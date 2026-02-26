import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request.g.dart';

@JsonSerializable()
class ResetPasswordRequest {
  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'reset_code')
  final String resetCode;

  @JsonKey(name: 'password')
  final String password;

  ResetPasswordRequest({
    required this.email,
    required this.resetCode,
    required this.password,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}
