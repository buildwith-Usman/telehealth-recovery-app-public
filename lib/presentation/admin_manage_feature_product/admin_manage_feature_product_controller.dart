import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_favorites_use_case.dart';

import '../../app/controllers/base_controller.dart';

class Product {
  final String id;
  final String name;
  final String? imageUrl;
  final double? discountPercentage;
  final double? price;

  Product({
    required this.id,
    required this.name,
    this.imageUrl,
    this.discountPercentage,
    this.price,
  });

  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;
}

class AdminManageFeatureProductController extends BaseController {
  AdminManageFeatureProductController({
    required this.getFavoritesUseCase,
  });

  final GetFavoritesUseCase getFavoritesUseCase;

  final products = <Product>[].obs;
  final favoriteProducts = <ProductEntity>[].obs;
  @override
  final isLoading = false.obs;
  String? errorMessage;
  final int maxFeaturedProducts = 5;

  @override
  void onInit() {
    super.onInit();
    fetchFeatureProducts();
  }

  Future<void> fetchFeatureProducts() async {
    logger.method('📦 Fetching featured products...');

    final result = await executeApiCall<List<ProductEntity>>(
      () => getFavoritesUseCase.execute(),
      onSuccess: () {
        logger.method('✅ Featured products fetched successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to fetch featured products: $errorMessage');
        this.errorMessage = errorMessage;
      },
    );

    if (result != null) {
      logger.method('📦 API Response - Total favorites: ${result.length}');

      // Store original entities
      favoriteProducts.value = result;

      // Map to view model for UI display
      products.value = result.map((entity) {
        logger.method('  Mapping product: ${entity.medicineName}');

        // Calculate discount percentage if available
        double? discountPercentage;
        if (entity.discountType == 'percentage' && entity.discountValue != null) {
          discountPercentage = entity.discountValue;
        }

        return Product(
          id: entity.id.toString(),
          name: entity.medicineName ?? 'Unknown Product',
          imageUrl: entity.imageUrl,
          discountPercentage: discountPercentage,
        );
      }).toList();

      logger.method('✅ Total featured products mapped: ${products.length}');
    } else {
      logger.error('❌ API result is null');
    }
  }

  Future<void> refreshFeatureProducts() async {
    await fetchFeatureProducts();
  }

  void removeProduct(String productId) {
    products.removeWhere((product) => product.id == productId);
  }
}
