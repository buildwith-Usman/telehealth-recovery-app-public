import 'package:recovery_consultation_app/data/api/response/product_response.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';
import 'package:recovery_consultation_app/app/config/app_config.dart';
import 'user_mapper.dart';

class ProductMapper {
  static ProductEntity toProductEntity(ProductResponse response) {
    // Get full image URL if available
    String? imageUrl;
    if (response.image != null) {
      imageUrl = response.image!.getFullUrl(baseUrl: AppConfig.shared.baseUrl);
    }

    return ProductEntity(
      id: response.id ?? 0,
      medicineName: response.medicineName,
      imageId: response.imageId,
      categoryId: response.categoryId,
      price: response.price != null ? double.tryParse(response.price!) : null,
      stockQuantity: response.stockQuantity,
      ingredients: response.ingredients,
      discountType: response.discountType,
      discountValue: response.discountValue != null
          ? double.tryParse(response.discountValue!)
          : null,
      howToUse: response.howToUse,
      description: response.description,
      isVisible: response.isVisible,
      isTemporarilyHidden: response.isTemporarilyHidden,
      availabilityStatus: response.availabilityStatus,
      finalPrice: response.finalPrice,
      createdBy: response.createdBy,
      image: response.image != null
          ? FileEntity(
              id: response.image!.id ?? 0,
              fileName: response.image!.fileName,
              fileExtension: response.image!.fileExtension,
              mimeType: response.image!.mimeType,
              size: response.image!.size?.toString(),
              path: response.image!.path,
              url: response.image!.url,
              temp: response.image!.temp,
              createdAt: response.image!.createdAt,
              updatedAt: response.image!.updatedAt,
            )
          : null,
      imageUrl: imageUrl,
      category: response.category != null
          ? CategoryEntity(
              id: response.category!.id ?? 0,
              name: response.category!.name,
              description: response.category!.description,
              status: response.category!.status,
              createdAt: response.category!.createdAt,
              updatedAt: response.category!.updatedAt,
            )
          : null,
      creator: response.creator != null
          ? UserMapper.toUserEntity(response.creator!)
          : null,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }
}
