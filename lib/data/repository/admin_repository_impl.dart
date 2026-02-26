import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/create_product_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_product_request.dart';
import 'package:recovery_consultation_app/data/api/response/get_user_response.dart';
import 'package:recovery_consultation_app/data/datasource/admin/admin_datasource.dart';
import 'package:recovery_consultation_app/data/mapper/paginated_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/user_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/ad_banner_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/product_mapper.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/entity/ad_banner_entity.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';
import '../../data/api/response/error_response.dart';
import '../../data/mapper/exception_mapper.dart';
import '../../domain/entity/error_entity.dart';

class AdminRepositoryImpl extends AdminRepository {
  AdminRepositoryImpl({required this.adminDatasource});

  final AdminDatasource adminDatasource;

  @override
  Future<PaginatedListEntity<UserEntity>> getPaginatedUserList({
    String? specialization,
    String? type,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await adminDatasource.getPaginatedDoctorsList(
        specialization: specialization,
        type: type,
        page: page,
        limit: limit,
      );
      if (response != null) {
             return PaginatedMapper.toEntity<UserEntity, GetUserResponse>(
      response: response,
      fromResponse: (r) => UserMapper.toUserEntity(r.user),
    );
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - getPaginatedUserList error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }

    @override
  Future<UserEntity?> updateProfile(
      UpdateProfileRequest updateProfileRequest) async {
    try {
      final response = await adminDatasource.updateProfile(updateProfileRequest);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final updateProfileEntity =
            UserMapper.toUserEntity(response);
        return updateProfileEntity;
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<AdBannerEntity?> createAdBanner(CreateAdBannerRequest request) async {
    try {
      final response = await adminDatasource.createAdBanner(request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final adBannerEntity = AdBannerMapper.toAdBannerEntity(response);
        return adBannerEntity;
      }
    } on BaseErrorResponse catch (error) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - createAdBanner error: ${error.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<PaginatedListEntity<AdBannerEntity>> getAdBannersList({
    int? limit,
    int? page,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      final response = await adminDatasource.getAdBannersList(
        limit: limit,
        page: page,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      if (response != null) {
        return PaginatedMapper.toEntity(
          response: response,
          fromResponse: (r) => AdBannerMapper.toAdBannerEntity(r),
        );
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (error) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - getAdBannersList error: ${error.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<AdBannerEntity?> updateAdBanner(int id, UpdateAdBannerRequest request) async {
    try {
      final response = await adminDatasource.updateAdBanner(id, request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final adBannerEntity = AdBannerMapper.toAdBannerEntity(response);
        return adBannerEntity;
      }
    } on BaseErrorResponse catch (error) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - updateAdBanner error: ${error.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<ProductEntity?> createProduct(CreateProductRequest request) async {
    try {
      final response = await adminDatasource.createProduct(request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final productEntity = ProductMapper.toProductEntity(response);
        return productEntity;
      }
    } on BaseErrorResponse catch (error) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - createProduct error: ${error.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<PaginatedListEntity<ProductEntity>> getProductsList({
    int? limit,
    int? page,
    int? categoryId,
    String? availabilityStatus,
  }) async {
    try {
      final response = await adminDatasource.getProductsList(
        limit: limit,
        page: page,
        categoryId: categoryId,
        availabilityStatus: availabilityStatus,
      );
      if (response != null) {
        return PaginatedMapper.toEntity(
          response: response,
          fromResponse: (r) => ProductMapper.toProductEntity(r),
        );
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (error) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - getProductsList error: ${error.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<ProductEntity?> updateProduct(int id, UpdateProductRequest request) async {
    try {
      final response = await adminDatasource.updateProduct(id, request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final productEntity = ProductMapper.toProductEntity(response);
        return productEntity;
      }
    } on BaseErrorResponse catch (error) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - updateProduct error: ${error.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<bool> deleteProduct(int id) async {
    try {
      final result = await adminDatasource.deleteProduct(id);
      return result;
    } on BaseErrorResponse catch (error) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - deleteProduct error: ${error.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<List<ProductEntity>> getFavorites() async {
    try {
      final response = await adminDatasource.getFavorites();
      if (response == null || response.isEmpty) {
        return [];
      } else {
        return response.map((productResponse) => ProductMapper.toProductEntity(productResponse)).toList();
      }
    } on BaseErrorResponse catch (error) {
      if (kDebugMode) {
        print('AdminRepositoryImpl - getFavorites error: ${error.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

}
