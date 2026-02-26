import 'package:json_annotation/json_annotation.dart';

part 'sign_up_response.g.dart';

@JsonSerializable()
class SignUpResponse {
  @JsonKey(name: 'verification_required')
  final bool verificationRequired;

  @JsonKey(name: 'user')
  final SignUpUserData user;

  SignUpResponse({
    required this.verificationRequired,
    required this.user,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}

@JsonSerializable()
class SignUpUserData {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'is_verified')
  final bool isVerified;

  SignUpUserData({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.phone,
    required this.isVerified,
  });

  factory SignUpUserData.fromJson(Map<String, dynamic> json) =>
      _$SignUpUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpUserDataToJson(this);
}
