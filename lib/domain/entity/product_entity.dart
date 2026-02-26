import 'package:recovery_consultation_app/domain/entity/base_entity.dart';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';

/// Product Entity - Represents product/medicine data from API
class ProductEntity extends BaseEntity {
  final String? medicineName;
  final int? imageId;
  final int? categoryId;
  final double? price;
  final int? stockQuantity;
  final String? ingredients;
  final String? discountType;
  final double? discountValue;
  final String? howToUse;
  final String? description;
  final bool? isVisible;
  final bool? isTemporarilyHidden;
  final String? availabilityStatus;
  final double? finalPrice;
  final int? createdBy;
  final FileEntity? image;
  final String? imageUrl;
  final CategoryEntity? category;
  final UserEntity? creator;

  const ProductEntity({
    required super.id,
    this.medicineName,
    this.imageId,
    this.categoryId,
    this.price,
    this.stockQuantity,
    this.ingredients,
    this.discountType,
    this.discountValue,
    this.howToUse,
    this.description,
    this.isVisible,
    this.isTemporarilyHidden,
    this.availabilityStatus,
    this.finalPrice,
    this.createdBy,
    this.image,
    this.imageUrl,
    this.category,
    this.creator,
    super.createdAt,
    super.updatedAt,
  });
}

/// Category Entity for Product
class CategoryEntity extends BaseEntity {
  final String? name;
  final String? description;
  final String? status;

  const CategoryEntity({
    required super.id,
    this.name,
    this.description,
    this.status,
    super.createdAt,
    super.updatedAt,
  });
}
