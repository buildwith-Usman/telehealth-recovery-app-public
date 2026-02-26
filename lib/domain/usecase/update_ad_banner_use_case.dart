import 'package:recovery_consultation_app/data/api/request/update_ad_banner_request.dart';
import 'package:recovery_consultation_app/domain/entity/ad_banner_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';

class UpdateAdBannerParams {
  final int id;
  final UpdateAdBannerRequest request;

  UpdateAdBannerParams({
    required this.id,
    required this.request,
  });
}

class UpdateAdBannerUseCase {
  final AdminRepository repository;

  UpdateAdBannerUseCase({required this.repository});

  Future<AdBannerEntity?> execute(UpdateAdBannerParams params) async {
    return await repository.updateAdBanner(params.id, params.request);
  }
}
