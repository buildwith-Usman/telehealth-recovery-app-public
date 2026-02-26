import 'package:json_annotation/json_annotation.dart';
import 'file_response.dart';
import 'user_response.dart';

part 'ad_banner_response.g.dart';

@JsonSerializable()
class AdBannerResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'image_id')
  final int? imageId;

  @JsonKey(name: 'start_date')
  final String? startDate;

  @JsonKey(name: 'end_date')
  final String? endDate;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'created_by')
  final int? createdBy;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'image')
  final FileData? image;

  @JsonKey(name: 'creator')
  final UserResponse? creator;

  AdBannerResponse({
    this.id,
    this.title,
    this.imageId,
    this.startDate,
    this.endDate,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.creator,
  });

  factory AdBannerResponse.fromJson(Map<String, dynamic> json) =>
      _$AdBannerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdBannerResponseToJson(this);
}
