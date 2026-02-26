import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_product_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_product_request.dart';
import 'package:recovery_consultation_app/data/api/response/error_response.dart';
import 'package:recovery_consultation_app/data/api/response/base_response.dart';
import 'package:recovery_consultation_app/data/api/response/get_user_response.dart';
import 'package:recovery_consultation_app/data/api/response/user_response.dart';
import 'package:recovery_consultation_app/data/api/response/ad_banner_response.dart';
import 'package:recovery_consultation_app/data/api/response/product_response.dart';
import 'package:recovery_consultation_app/data/datasource/admin/admin_datasource.dart';

import '../../api/api_client/api_client_type.dart';


class AdminDatasourceImpl implements AdminDatasource {
  AdminDatasourceImpl({
    required this.apiClient,
  });

  final APIClientType apiClient;

  @override
  Future<BasePagingResponse<GetUserResponse>?> getPaginatedDoctorsList({
    String? specialization,
    String? type,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await apiClient.getUserListForAdmin(
        specialization: specialization,
        type: type,
        page: page,
        limit: limit,
      );
      return response;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('SpecialistDatasourceImpl - getPaginatedDoctorsList error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }

    @override
  Future<UserResponse?> updateProfile(UpdateProfileRequest updateProfileRequest) async {
    try {
      debugPrint("🔍 DATASOURCE DEBUG: About to call update profile API");
      debugPrint("🔍 DATASOURCE DEBUG: Request - name: ${updateProfileRequest.name}");
      debugPrint("🔍 DATASOURCE DEBUG: Request - phone: ${updateProfileRequest.phone}");
      debugPrint("🔍 DATASOURCE DEBUG: Request - completed: ${updateProfileRequest.completed}");

      final response = await apiClient.updateUser(updateProfileRequest);

      debugPrint("🔍 DATASOURCE DEBUG: Update profile API call completed successfully");
      debugPrint("🔍 DATASOURCE DEBUG: Response data: ${response.data != null}");
      return response.data;
    } on DioException catch (error) {
      debugPrint("❌ DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse");
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<AdBannerResponse?> createAdBanner(CreateAdBannerRequest request) async {
    try {
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: About to call create ad banner API');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - title: ${request.title}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - image_id: ${request.imageId}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - status: ${request.status}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - start_date: ${request.startDate}');

      final response = await apiClient.createAdBanner(request);

      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Create ad banner API call completed successfully');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Response ID: ${response.data?.id}');
      return response.data;
    } on DioException catch (error) {
      debugPrint('❌ ADMIN DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<BasePagingResponse<AdBannerResponse>?> getAdBannersList({
    int? limit,
    int? page,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: About to call get ad banners list API');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Params - limit: $limit, page: $page, dateFrom: $dateFrom, dateTo: $dateTo');

      final response = await apiClient.getAdBannersList(
        limit: limit,
        page: page,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Get ad banners list API call completed successfully');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Total banners: ${response.total}');
      return response;
    } on DioException catch (error) {
      debugPrint('❌ ADMIN DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<AdBannerResponse?> updateAdBanner(int id, UpdateAdBannerRequest request) async {
    try {
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: About to call update ad banner API');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Banner ID: $id');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - title: ${request.title}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - status: ${request.status}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - image_id: ${request.imageId}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - start_date: ${request.startDate}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - end_date: ${request.endDate}');

      final response = await apiClient.updateAdBanner(id, request);

      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Update ad banner API call completed successfully');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Response ID: ${response.data?.id}');
      return response.data;
    } on DioException catch (error) {
      debugPrint('❌ ADMIN DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<ProductResponse?> createProduct(CreateProductRequest request) async {
    try {
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: About to call create product API');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - medicine_name: ${request.medicineName}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - image_id: ${request.imageId}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - category_id: ${request.categoryId}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - price: ${request.price}');

      final response = await apiClient.createProduct(request);

      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Create product API call completed successfully');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Response ID: ${response.data?.id}');
      return response.data;
    } on DioException catch (error) {
      debugPrint('❌ ADMIN DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<BasePagingResponse<ProductResponse>?> getProductsList({
    int? limit,
    int? page,
    int? categoryId,
    String? availabilityStatus,
  }) async {
    try {
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: About to call get products list API');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Params - limit: $limit, page: $page, categoryId: $categoryId, availabilityStatus: $availabilityStatus');

      final response = await apiClient.getProductsList(
        limit: limit,
        page: page,
        categoryId: categoryId,
        availabilityStatus: availabilityStatus,
      );

      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Get products list API call completed successfully');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Total products: ${response.total}');
      return response;
    } on DioException catch (error) {
      debugPrint('❌ ADMIN DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<ProductResponse?> updateProduct(int id, UpdateProductRequest request) async {
    try {
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: About to call update product API');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Product ID: $id');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - medicine_name: ${request.medicineName}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - price: ${request.price}');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Request - stock_quantity: ${request.stockQuantity}');

      final response = await apiClient.updateProduct(id, request);

      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Update product API call completed successfully');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Response ID: ${response.data?.id}');
      return response.data;
    } on DioException catch (error) {
      debugPrint('❌ ADMIN DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<bool> deleteProduct(int id) async {
    try {
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: About to call delete product API');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Product ID: $id');

      final response = await apiClient.deleteProduct(id);

      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Delete product API call completed successfully');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Response message: ${response.message}');
      return true;
    } on DioException catch (error) {
      debugPrint('❌ ADMIN DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<List<ProductResponse>?> getFavorites() async {
    try {
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: About to call get favorites API');

      final response = await apiClient.getFavorites();

      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Get favorites API call completed successfully');
      debugPrint('🔍 ADMIN DATASOURCE DEBUG: Total favorites: ${response.data?.length ?? 0}');

      return response.data;
    } on DioException catch (error) {
      debugPrint('❌ ADMIN DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse');
      throw BaseErrorResponse.fromDioException(error);
    }
  }

}
