import 'package:json_annotation/json_annotation.dart';

part 'user_language_response.g.dart';

@JsonSerializable()
class UserLanguageResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'language')
  final String? language;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  UserLanguageResponse({
    this.id,
    this.userId,
    this.language,
    this.createdAt,
    this.updatedAt,
  });

  factory UserLanguageResponse.fromJson(Map<String, dynamic> json) =>
      _$UserLanguageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserLanguageResponseToJson(this);
}