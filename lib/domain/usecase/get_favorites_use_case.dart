import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';

class GetFavoritesUseCase {
  final AdminRepository repository;

  GetFavoritesUseCase({required this.repository});

  Future<List<ProductEntity>> execute() async {
    return await repository.getFavorites();
  }
}
