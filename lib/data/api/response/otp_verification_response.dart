import 'package:json_annotation/json_annotation.dart';

part 'otp_verification_response.g.dart';

@JsonSerializable()
class OTPVerificationResponse {
  @JsonKey(name: 'user')
  final UserData? user;

  @JsonKey(name: 'access_token')
  final String? accessToken;

  @JsonKey(name: 'token_type')
  final String? tokenType;

  OTPVerificationResponse({
    this.user,
    this.accessToken,
    this.tokenType,
  });

  factory OTPVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$OTPVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OTPVerificationResponseToJson(this);
}

@JsonSerializable()
class UserData {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;

  UserData({
    this.id,
    this.name,
    this.email,
    this.type,
    this.phone,
    this.isVerified,
    this.emailVerifiedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
