import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request.g.dart';

@JsonSerializable()
class ForgotPasswordRequest {
  @JsonKey(name: 'email')
  final String email;

  ForgotPasswordRequest({
    required this.email,
  });

  // Factory method for JSON deserialization
  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);

}
