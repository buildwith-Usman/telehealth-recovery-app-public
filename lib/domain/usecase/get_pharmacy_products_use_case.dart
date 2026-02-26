import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/pharmacy_repository.dart';

class GetPharmacyProductsParams {
  final int? limit;
  final int? categoryId;
  final String? search;
  final String? sortBy;
  final String? sortOrder;

  GetPharmacyProductsParams({
    this.limit,
    this.categoryId,
    this.search,
    this.sortBy,
    this.sortOrder,
  });
}

class GetPharmacyProductsUseCase {
  final PharmacyRepository repository;

  GetPharmacyProductsUseCase({required this.repository});

  Future<List<ProductEntity>> execute(GetPharmacyProductsParams params) async {
    return await repository.getProducts(
      limit: params.limit,
      categoryId: params.categoryId,
      search: params.search,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}
