import 'package:recovery_consultation_app/data/api/response/product_response.dart';

/// Pharmacy Datasource - Interface for pharmacy-related API calls
abstract class PharmacyDatasource {
  /// Get products list with optional filters, search, and sorting
  Future<List<ProductResponse>?> getProducts({
    int? limit,
    int? categoryId,
    String? search,
    String? sortBy,
    String? sortOrder,
  });

  /// Get featured products (uses products endpoint with limit)
  Future<List<ProductResponse>?> getFeaturedProducts({int? limit});

  /// Get product by ID
  Future<ProductResponse?> getProductById(int id);

  /// Add product to features (favorites)
  Future<bool> addToFeatures(int productId);
}
