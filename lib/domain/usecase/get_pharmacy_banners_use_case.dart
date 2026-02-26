import 'package:recovery_consultation_app/domain/entity/pharmacy_banner_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/pharmacy_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

/// Use Case for fetching pharmacy promotional banners
/// This follows the same pattern as GetUserUseCase, GetPaginatedDoctorsListUseCase
class GetPharmacyBannersUseCase implements NoParamUseCase<List<PharmacyBannerEntity>> {
  final PharmacyRepository repository;

  GetPharmacyBannersUseCase({required this.repository});

  @override
  Future<List<PharmacyBannerEntity>> execute() async {
    final banners = await repository.getPromotionalBanners();
    return banners;
  }
}
