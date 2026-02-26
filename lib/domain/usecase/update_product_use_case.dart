import 'package:recovery_consultation_app/data/api/request/update_product_request.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';

class UpdateProductParams {
  final int id;
  final UpdateProductRequest request;

  UpdateProductParams({
    required this.id,
    required this.request,
  });
}

class UpdateProductUseCase {
  final AdminRepository repository;

  UpdateProductUseCase({required this.repository});

  Future<ProductEntity?> execute(UpdateProductParams params) async {
    return await repository.updateProduct(params.id, params.request);
  }
}
