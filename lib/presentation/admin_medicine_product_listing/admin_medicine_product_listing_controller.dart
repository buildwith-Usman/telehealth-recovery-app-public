import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/data/api/request/update_product_request.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/delete_product_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_products_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/update_product_use_case.dart';

// Enum for stock status
enum StockStatus { all, inStock, outOfStock, hidden }

// Class for product data
class MedicineProduct {
  final String id;
  final String name;
  final String? imageUrl;
  final String? categoryName;
  final double? price;
  final double? finalPrice;
  final int? stockQuantity;
  final String? availabilityStatus;
  final bool? isVisible;
  final bool? isTemporarilyHidden;
  final StockStatus status;

  MedicineProduct({
    required this.id,
    required this.name,
    this.imageUrl,
    this.categoryName,
    this.price,
    this.finalPrice,
    this.stockQuantity,
    this.availabilityStatus,
    this.isVisible,
    this.isTemporarilyHidden,
    required this.status,
  });
}

class AdminMedicineProductListingController extends BaseController {
  AdminMedicineProductListingController({
    required this.getProductsUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  });

  final GetProductsUseCase getProductsUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  // Original product list from the source
  final products = <MedicineProduct>[].obs;
  // The list that will be displayed in the UI
  final filteredProducts = <MedicineProduct>[].obs;
  // Store original ProductEntity objects for edit operations
  final productEntities = <ProductEntity>[].obs;
  String? errorMessage;

  final searchController = TextEditingController();
  final Rx<StockStatus> selectedStockFilter = StockStatus.all.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMedicineProducts();
    // Add listener to the search controller to trigger filtering
    searchController.addListener(() {
      filterProducts();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // A getter for the display text of the current filter
  String get stockFilterDisplayText {
    switch (selectedStockFilter.value) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.hidden:
        return 'Hidden';
      case StockStatus.all:
      default:
        return 'All';
    }
  }

  // Method to update the filter and trigger re-filtering
  void onStockFilterChanged(StockStatus? newFilter) {
    if (newFilter != null) {
      selectedStockFilter.value = newFilter;
      filterProducts(); // Re-run the filter logic
    }
  }

  // Combined filtering logic
  void filterProducts() {
    logger.method('🔍 Filtering products...');
    logger.method('📊 Total products: ${products.length}');

    final query = searchController.text.toLowerCase();
    final stockFilter = selectedStockFilter.value;

    logger.method('🔎 Search query: "$query"');
    logger.method('🏷️ Stock filter: $stockFilter');

    var tempFilteredList = products.where((product) {
      // Search query check
      final nameMatches = product.name.toLowerCase().contains(query);

      // Stock status check
      final statusMatches =
          stockFilter == StockStatus.all || product.status == stockFilter;

      logger.method('  Product: ${product.name} | nameMatches: $nameMatches | statusMatches: $statusMatches | status: ${product.status}');

      return nameMatches && statusMatches;
    }).toList();

    logger.method('✅ Filtered products: ${tempFilteredList.length}');
    filteredProducts.value = tempFilteredList;
  }

  Future<void> fetchMedicineProducts() async {
    final result = await executeApiCall(
      () => getProductsUseCase.execute(
        GetProductsParams(
          limit: 100, // Fetch up to 100 products
          page: 1,
        ),
      ),
      onSuccess: () {
        logger.method('✅ Products fetched successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to fetch products: $errorMessage');
        this.errorMessage = errorMessage;
      },
    );

    if (result != null) {
      logger.method('📦 API Response - Total items: ${result.data.length}');
      if (result.pagination != null) {
        logger.method('📄 Pagination - Total: ${result.pagination!.total}, Page: ${result.pagination!.currentPage}, PerPage: ${result.pagination!.perPage}');
      }

      // Store original entities for edit operations
      productEntities.value = result.data;

      // Map entities to view models
      products.value = result.data.map((entity) {
        logger.method('  Mapping product: ${entity.medicineName} | availability: ${entity.availabilityStatus} | hidden: ${entity.isTemporarilyHidden}');

        // Determine stock status
        StockStatus status;
        if (entity.isTemporarilyHidden == true) {
          status = StockStatus.hidden;
        } else if (entity.availabilityStatus == 'in_stock') {
          status = StockStatus.inStock;
        } else if (entity.availabilityStatus == 'out_of_stock') {
          status = StockStatus.outOfStock;
        } else {
          status = StockStatus.inStock; // Default
        }

        return MedicineProduct(
          id: entity.id.toString(),
          name: entity.medicineName ?? 'Unknown Product',
          imageUrl: entity.imageUrl,
          categoryName: entity.category?.name,
          price: entity.price,
          finalPrice: entity.finalPrice,
          stockQuantity: entity.stockQuantity,
          availabilityStatus: entity.availabilityStatus,
          isVisible: entity.isVisible,
          isTemporarilyHidden: entity.isTemporarilyHidden,
          status: status,
        );
      }).toList();

      logger.method('✅ Total products mapped: ${products.length}');

      // Initially, apply filters to show all products
      filterProducts();
    } else {
      logger.error('❌ API result is null');
    }
  }

  Future<void> refreshMedicineProducts() async {
    await fetchMedicineProducts();
  }

  Future<void> deleteProduct(String productId) async {
    logger.method('🗑️ Deleting product ID: $productId');

    // Get the product entity
    final productEntity = getProductEntityById(productId);
    if (productEntity == null) {
      logger.error('❌ Cannot delete product - product entity not found');
      return;
    }

    logger.method('  Product to delete: ${productEntity.medicineName}');

    // Call API to delete product
    final result = await executeApiCall(
      () => deleteProductUseCase.execute(productEntity.id),
      onSuccess: () {
        logger.method('✅ Product deleted successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to delete product: $errorMessage');
      },
    );

    if (result == true) {
      // Remove from local lists
      products.removeWhere((product) => product.id == productId);
      productEntities.removeWhere((entity) => entity.id == productEntity.id);

      // Re-apply filters
      filterProducts();

      logger.method('✅ Product removed from local state');

      // Show success message
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      logger.error('❌ Delete returned false');
    }
  }

  Future<void> toggleProductVisibility(String productId) async {
    logger.method('🔄 Toggling visibility for product ID: $productId');

    // Get the product entity
    final productEntity = getProductEntityById(productId);
    if (productEntity == null) {
      logger.error('❌ Cannot toggle visibility - product entity not found');
      return;
    }

    // Determine new visibility status
    final isCurrentlyHidden = productEntity.isTemporarilyHidden == true;
    final newIsTemporarilyHidden = !isCurrentlyHidden;

    logger.method('  Current hidden status: $isCurrentlyHidden');
    logger.method('  New hidden status: $newIsTemporarilyHidden');

    // Create update request with only the isTemporarilyHidden field
    final request = UpdateProductRequest(
      isTemporarilyHidden: newIsTemporarilyHidden,
    );

    // Call API to update product
    final result = await executeApiCall(
      () => updateProductUseCase.execute(
        UpdateProductParams(
          id: productEntity.id,
          request: request,
        ),
      ),
      onSuccess: () {
        logger.method('✅ Product visibility updated successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to update product visibility: $errorMessage');
      },
    );

    if (result != null) {
      // Update local state with new data from API response
      final productIndex = products.indexWhere((p) => p.id == productId);
      if (productIndex != -1) {
        // Determine new stock status
        StockStatus newStatus;
        if (result.isTemporarilyHidden == true) {
          newStatus = StockStatus.hidden;
        } else if (result.availabilityStatus == 'in_stock') {
          newStatus = StockStatus.inStock;
        } else if (result.availabilityStatus == 'out_of_stock') {
          newStatus = StockStatus.outOfStock;
        } else {
          newStatus = StockStatus.inStock;
        }

        // Update products list
        products[productIndex] = MedicineProduct(
          id: productId,
          name: result.medicineName ?? 'Unknown Product',
          imageUrl: result.imageUrl,
          categoryName: result.category?.name,
          price: result.price,
          finalPrice: result.finalPrice,
          stockQuantity: result.stockQuantity,
          availabilityStatus: result.availabilityStatus,
          isVisible: result.isVisible,
          isTemporarilyHidden: result.isTemporarilyHidden,
          status: newStatus,
        );

        // Update product entities list
        final entityIndex = productEntities.indexWhere((e) => e.id == productEntity.id);
        if (entityIndex != -1) {
          productEntities[entityIndex] = result;
        }

        // Re-apply filters
        filterProducts();

        logger.method('✅ Local state updated with new visibility status');
      }
    } else {
      logger.error('❌ Update returned null result');
    }
  }

  /// Get ProductEntity by product ID for edit operations
  ProductEntity? getProductEntityById(String productId) {
    logger.method('🔍 Looking for product entity with ID: $productId');
    logger.method('🔍 Total entities available: ${productEntities.length}');

    try {
      final entity = productEntities.firstWhere((entity) => entity.id.toString() == productId);
      logger.method('✅ Found product entity: ${entity.medicineName}');
      return entity;
    } catch (e) {
      logger.error('❌ Product entity not found for ID: $productId');
      logger.error('❌ Available IDs: ${productEntities.map((e) => e.id).toList()}');
      return null;
    }
  }

  void editProduct(String productId) {
    // Navigate to edit page - will be implemented in the page
  }
}
