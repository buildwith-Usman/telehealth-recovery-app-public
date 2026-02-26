import 'package:json_annotation/json_annotation.dart';

part 'resend_otp_response.g.dart';

@JsonSerializable()
class ResendOtpResponse {
  @JsonKey(name: 'message')
  final String message;

  ResendOtpResponse({
    required this.message,
  });

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$ResendOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResendOtpResponseToJson(this);
}
