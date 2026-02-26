import 'package:recovery_consultation_app/domain/entity/featured_product_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/pharmacy_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

/// Use Case for fetching featured products from Pharmacy Repository
/// This follows the same pattern as GetPharmacyBannersUseCase
class GetFeaturedProductsUseCase
    implements NoParamUseCase<List<FeaturedProductEntity>> {
  final PharmacyRepository repository;

  GetFeaturedProductsUseCase({required this.repository});

  @override
  Future<List<FeaturedProductEntity>> execute() async {
    final featuredProducts = await repository.getFeaturedProducts();
    return featuredProducts;
  }
}
