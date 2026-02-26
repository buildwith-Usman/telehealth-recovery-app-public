import 'package:json_annotation/json_annotation.dart';

part 'create_password_response.g.dart';

@JsonSerializable()
class CreatePasswordResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'level')
  final String? level;

  @JsonKey(name: 'phone')
  final String? phone;

  CreatePasswordResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.level,
    required this.phone,
  });

  factory CreatePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePasswordResponseToJson(this);

}
