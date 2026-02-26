import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/pharmacy_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

/// Use Case for fetching a product by ID from Pharmacy Repository
/// This follows the same pattern as GetFeaturedProductsUseCase
class GetProductByIdUseCase implements ParamUseCase<ProductEntity?, int> {
  final PharmacyRepository repository;

  GetProductByIdUseCase({required this.repository});

  @override
  Future<ProductEntity?> execute(int productId) async {
    return await repository.getProductById(productId);
  }
}
