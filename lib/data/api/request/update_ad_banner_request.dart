import 'package:json_annotation/json_annotation.dart';

part 'update_ad_banner_request.g.dart';

@JsonSerializable()
class UpdateAdBannerRequest {
  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'image_id')
  final int? imageId;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'start_date')
  final String? startDate;

  @JsonKey(name: 'end_date')
  final String? endDate;

  UpdateAdBannerRequest({
    this.title,
    this.imageId,
    this.status,
    this.startDate,
    this.endDate,
  });

  factory UpdateAdBannerRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdBannerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAdBannerRequestToJson(this);
}
