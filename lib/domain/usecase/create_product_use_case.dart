import 'package:recovery_consultation_app/data/api/request/create_product_request.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';

class CreateProductUseCase {
  CreateProductUseCase({required this.adminRepository});

  final AdminRepository adminRepository;

  Future<ProductEntity?> execute(CreateProductRequest request) async {
    return await adminRepository.createProduct(request);
  }
}
