import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';

class GetProductsParams {
  final int? limit;
  final int? page;
  final int? categoryId;
  final String? availabilityStatus;

  GetProductsParams({
    this.limit,
    this.page,
    this.categoryId,
    this.availabilityStatus,
  });
}

class GetProductsUseCase {
  final AdminRepository repository;

  GetProductsUseCase({required this.repository});

  Future<PaginatedListEntity<ProductEntity>> execute(GetProductsParams params) async {
    return await repository.getProductsList(
      limit: params.limit,
      page: params.page,
      categoryId: params.categoryId,
      availabilityStatus: params.availabilityStatus,
    );
  }
}
