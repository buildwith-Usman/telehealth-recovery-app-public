import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_product_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_product_request.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/entity/ad_banner_entity.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';

abstract class AdminRepository {

  /// Get paginated doctors list with optional specialization filter
  Future<PaginatedListEntity<UserEntity>> getPaginatedUserList({
    String? specialization,
    String? type,
    int? page,
    int? limit,
  });

  /// Admin Update user profile
  Future<UserEntity?> updateProfile(
      UpdateProfileRequest updateProfileRequest);

  /// Create ad banner
  Future<AdBannerEntity?> createAdBanner(CreateAdBannerRequest request);

  /// Get ad banners list with pagination and filters
  Future<PaginatedListEntity<AdBannerEntity>> getAdBannersList({
    int? limit,
    int? page,
    String? dateFrom,
    String? dateTo,
  });

  /// Update ad banner
  Future<AdBannerEntity?> updateAdBanner(int id, UpdateAdBannerRequest request);

  /// Create product
  Future<ProductEntity?> createProduct(CreateProductRequest request);

  /// Get products list with pagination and filters
  Future<PaginatedListEntity<ProductEntity>> getProductsList({
    int? limit,
    int? page,
    int? categoryId,
    String? availabilityStatus,
  });

  /// Update product
  Future<ProductEntity?> updateProduct(int id, UpdateProductRequest request);

  /// Delete product
  Future<bool> deleteProduct(int id);

  /// Get favorites (featured products)
  Future<List<ProductEntity>> getFavorites();

}
