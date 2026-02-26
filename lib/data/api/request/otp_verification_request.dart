import 'package:json_annotation/json_annotation.dart';

part 'otp_verification_request.g.dart';

@JsonSerializable()
class OPTVerificationRequest {
  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'verification_code')
  final String verificationCode;

  OPTVerificationRequest({
    required this.type,
    required this.email,
    required this.verificationCode,
  });

  // Factory method for JSON deserialization
  factory OPTVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$OPTVerificationRequestFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$OPTVerificationRequestToJson(this);
}
