import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_product_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_product_request.dart';
import 'package:recovery_consultation_app/data/api/response/base_response.dart';
import 'package:recovery_consultation_app/data/api/response/get_user_response.dart';
import 'package:recovery_consultation_app/data/api/response/user_response.dart';
import 'package:recovery_consultation_app/data/api/response/ad_banner_response.dart';
import 'package:recovery_consultation_app/data/api/response/product_response.dart';

abstract class AdminDatasource {

  /// Get paginated doctors list with optional specialization filter
  Future<BasePagingResponse<GetUserResponse>?> getPaginatedDoctorsList({
    String? specialization,
    String? type,
    int? page,
    int? limit,
  });

  /// Admin Update user profile with form data
  Future<UserResponse?> updateProfile(
      UpdateProfileRequest updateProfileRequest);

  /// Create ad banner
  Future<AdBannerResponse?> createAdBanner(CreateAdBannerRequest request);

  /// Get ad banners list with pagination and filters
  Future<BasePagingResponse<AdBannerResponse>?> getAdBannersList({
    int? limit,
    int? page,
    String? dateFrom,
    String? dateTo,
  });

  /// Update ad banner
  Future<AdBannerResponse?> updateAdBanner(int id, UpdateAdBannerRequest request);

  /// Create product
  Future<ProductResponse?> createProduct(CreateProductRequest request);

  /// Get products list with pagination and filters
  Future<BasePagingResponse<ProductResponse>?> getProductsList({
    int? limit,
    int? page,
    int? categoryId,
    String? availabilityStatus,
  });

  /// Update product
  Future<ProductResponse?> updateProduct(int id, UpdateProductRequest request);

  /// Delete product
  Future<bool> deleteProduct(int id);

  /// Get favorites (featured products)
  Future<List<ProductResponse>?> getFavorites();

}
