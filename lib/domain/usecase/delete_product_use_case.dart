import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';

class DeleteProductUseCase {
  final AdminRepository repository;

  DeleteProductUseCase({required this.repository});

  Future<bool> execute(int id) async {
    return await repository.deleteProduct(id);
  }
}
