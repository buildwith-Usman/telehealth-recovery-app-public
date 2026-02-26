import 'package:json_annotation/json_annotation.dart';

part 'create_ad_banner_request.g.dart';

@JsonSerializable()
class CreateAdBannerRequest {
  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'image_id')
  final int imageId;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'start_date')
  final String startDate;

  CreateAdBannerRequest({
    required this.title,
    required this.imageId,
    required this.status,
    required this.startDate,
  });

  factory CreateAdBannerRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAdBannerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAdBannerRequestToJson(this);
}
