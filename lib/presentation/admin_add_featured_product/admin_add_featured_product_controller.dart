import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/add_to_features_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_products_use_case.dart';
import '../admin_manage_feature_product/admin_manage_feature_product_controller.dart';

class AdminAddFeaturedProductController extends BaseController {
  AdminAddFeaturedProductController({
    required this.getProductsUseCase,
    required this.addToFeaturesUseCase,
  });

  final GetProductsUseCase getProductsUseCase;
  final AddToFeaturesUseCase addToFeaturesUseCase;

  final products = <Product>[].obs;
  final filteredProducts = <Product>[].obs;
  final productEntities = <ProductEntity>[].obs;
  @override
  final isLoading = false.obs;
  String? errorMessage;

  var searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    searchController.addListener(() {
      filterProducts();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void filterProducts() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products
          .where((product) => product.name.toLowerCase().contains(query))
          .toList();
    }
  }

  Future<void> fetchProducts() async {
    logger.method('📦 Fetching products for featured selection...');

    final result = await executeApiCall(
      () => getProductsUseCase.execute(GetProductsParams()),
      onSuccess: () {
        logger.method('✅ Products fetched successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to fetch products: $errorMessage');
        this.errorMessage = errorMessage;
      },
    );

    if (result != null && result.data != null) {
      logger.method('📦 API Response - Total products: ${result.data.length}');

      // Store original entities
      productEntities.value = result.data;

      // Map to view model for UI display
      products.value = result.data.map((entity) {
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
          price: entity.price,
        );
      }).toList();

      logger.method('✅ Total products mapped: ${products.length}');

      // Update filtered list
      filteredProducts.value = products;
    } else {
      logger.error('❌ API result is null or has no data');
      products.value = [];
      filteredProducts.value = [];
    }
  }

  Future<void> addToFeatured(Product product) async {
    logger.method('⭐ Adding product to featured: ${product.name}');

    final productId = int.tryParse(product.id);
    if (productId == null) {
      Get.snackbar(
        'Error',
        'Invalid product ID',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await executeApiCall<bool>(
      () => addToFeaturesUseCase.execute(productId),
      onSuccess: () async {
        logger.method('✅ Product added to featured successfully');
        // Navigate back first
        Get.back();
        // Refresh the manage feature product page if it exists
        if (Get.isRegistered<AdminManageFeatureProductController>()) {
          Get.find<AdminManageFeatureProductController>().refreshFeatureProducts();
        }
        // Show snackbar after navigation with a small delay
        await Future.delayed(const Duration(milliseconds: 100));
        Get.snackbar(
          'Success',
          'Product added to featured',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to add product to featured: $errorMessage');
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
