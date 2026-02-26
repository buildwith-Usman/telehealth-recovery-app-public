import 'package:json_annotation/json_annotation.dart';
import 'file_response.dart';
import 'user_response.dart';

part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'medicine_name')
  final String? medicineName;

  @JsonKey(name: 'image_id')
  final int? imageId;

  @JsonKey(name: 'category_id')
  final int? categoryId;

  @JsonKey(name: 'price')
  final String? price;

  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;

  @JsonKey(name: 'ingredients')
  final String? ingredients;

  @JsonKey(name: 'discount_type')
  final String? discountType;

  @JsonKey(name: 'discount_value')
  final String? discountValue;

  @JsonKey(name: 'how_to_use')
  final String? howToUse;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'is_visible')
  final bool? isVisible;

  @JsonKey(name: 'is_temporarily_hidden')
  final bool? isTemporarilyHidden;

  @JsonKey(name: 'availability_status')
  final String? availabilityStatus;

  @JsonKey(name: 'final_price')
  final double? finalPrice;

  @JsonKey(name: 'created_by')
  final int? createdBy;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'image')
  final FileData? image;

  @JsonKey(name: 'category')
  final CategoryResponse? category;

  @JsonKey(name: 'creator')
  final UserResponse? creator;

  ProductResponse({
    this.id,
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
    this.createdAt,
    this.updatedAt,
    this.image,
    this.category,
    this.creator,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

@JsonSerializable()
class CategoryResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  CategoryResponse({
    this.id,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
