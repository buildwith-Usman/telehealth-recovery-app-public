import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/data/api/api_client/api_client_type.dart';
import 'package:recovery_consultation_app/data/api/response/product_response.dart';
import 'package:recovery_consultation_app/data/api/response/error_response.dart';
import 'package:recovery_consultation_app/data/datasource/pharmacy/pharmacy_datasource.dart';

class PharmacyDatasourceImpl implements PharmacyDatasource {
  final APIClientType apiClient;

  PharmacyDatasourceImpl({required this.apiClient});

  @override
  Future<List<ProductResponse>?> getProducts({
    int? limit,
    int? categoryId,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: About to call get products API');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: limit: $limit');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: categoryId: $categoryId');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: search: $search');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: sortBy: $sortBy');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: sortOrder: $sortOrder');

      final response = await apiClient.getProducts(
        limit: limit,
        categoryId: categoryId,
        search: search,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Get products API call completed successfully');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Total products: ${response.data?.length ?? 0}');

      return response.data;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<List<ProductResponse>?> getFeaturedProducts({int? limit}) async {
    try {
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: About to call get featured products API');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: limit: $limit');

      // Use the same products endpoint - featured products are typically sorted by popularity or rating
      final response = await apiClient.getProducts(
        limit: limit,
        sortBy: 'created_at',
        sortOrder: 'desc',
      );

      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Get featured products API call completed successfully');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Total featured products: ${response.data?.length ?? 0}');

      return response.data;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<ProductResponse?> getProductById(int id) async {
    try {
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: About to call get product by ID API');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Product ID: $id');

      final response = await apiClient.getProductById(id);

      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Get product by ID API call completed successfully');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Product name: ${response.data?.medicineName}');

      return response.data;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<bool> addToFeatures(int productId) async {
    try {
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: About to call add to features API');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Product ID: $productId');

      final response = await apiClient.addToFeatures(productId);

      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Add to features API call completed successfully');
      debugPrint('🔍 PHARMACY DATASOURCE DEBUG: Message: ${response.message}');

      return true;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }
}
