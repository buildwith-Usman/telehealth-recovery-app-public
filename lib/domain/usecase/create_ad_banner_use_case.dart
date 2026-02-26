import 'package:recovery_consultation_app/data/api/request/create_ad_banner_request.dart';
import 'package:recovery_consultation_app/domain/entity/ad_banner_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

class CreateAdBannerUseCase
    implements ParamUseCase<AdBannerEntity?, CreateAdBannerRequest> {
  final AdminRepository repository;

  CreateAdBannerUseCase({required this.repository});

  @override
  Future<AdBannerEntity?> execute(CreateAdBannerRequest request) async {
    return await repository.createAdBanner(request);
  }
}
