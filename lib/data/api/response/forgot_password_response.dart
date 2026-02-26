import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_response.g.dart';

@JsonSerializable()
class ForgotPasswordResponse {
  @JsonKey(name: 'message')
  final String message;

  ForgotPasswordResponse({
    required this.message,
  });

  // Factory method for JSON deserialization
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$ForgotPasswordResponseToJson(this);

}
