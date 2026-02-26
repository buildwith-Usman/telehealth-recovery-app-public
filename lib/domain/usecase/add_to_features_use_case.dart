import 'package:recovery_consultation_app/domain/repositories/pharmacy_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

/// Use Case for adding a product to features (favorites)
/// This follows the same pattern as AddReviewUseCase
class AddToFeaturesUseCase implements ParamUseCase<bool, int> {
  final PharmacyRepository repository;

  AddToFeaturesUseCase({required this.repository});

  @override
  Future<bool> execute(int productId) async {
    return await repository.addProductToFeatures(productId);
  }
}
