import 'package:json_annotation/json_annotation.dart';

part 'create_password_request.g.dart';

@JsonSerializable()
class CreatePasswordRequest {

  @JsonKey(name: 'verification_token')
  final String verificationToken;

  @JsonKey(name: 'password')
  final String password;

  CreatePasswordRequest({
    this.verificationToken = '',
    this.password = '',
  });

  // Factory method for JSON deserialization
  factory CreatePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePasswordRequestFromJson(json);

  // Method for JSON serialization
  Map<String, dynamic> toJson() => _$CreatePasswordRequestToJson(this);

}
