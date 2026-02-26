import 'package:recovery_consultation_app/data/api/response/ad_banner_response.dart';
import 'package:recovery_consultation_app/domain/entity/ad_banner_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/app/config/app_config.dart';
import 'user_mapper.dart';

class AdBannerMapper {
  static AdBannerEntity toAdBannerEntity(AdBannerResponse response) {
    // Get full image URL if available
    String? imageUrl;
    if (response.image != null) {
      imageUrl = response.image!.getFullUrl(baseUrl: AppConfig.shared.baseUrl);
    }

    // Map creator if available
    UserEntity? creator;
    if (response.creator != null) {
      creator = UserMapper.toUserEntity(response.creator!);
    }

    return AdBannerEntity(
      id: response.id ?? 0,
      title: response.title ?? '',
      imageId: response.imageId ?? 0,
      startDate: response.startDate ?? '',
      endDate: response.endDate,
      status: response.status ?? '',
      createdBy: response.createdBy ?? 0,
      imageUrl: imageUrl,
      creator: creator,
      createdAt: response.createdAt ?? '',
      updatedAt: response.updatedAt ?? '',
    );
  }
}
