import 'package:json_annotation/json_annotation.dart';

part 'update_product_request.g.dart';

@JsonSerializable()
class UpdateProductRequest {
  @JsonKey(name: 'medicine_name')
  final String? medicineName;

  @JsonKey(name: 'image_id')
  final int? imageId;

  @JsonKey(name: 'category_id')
  final int? categoryId;

  @JsonKey(name: 'price')
  final double? price;

  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;

  @JsonKey(name: 'ingredients')
  final String? ingredients;

  @JsonKey(name: 'discount_type')
  final String? discountType;

  @JsonKey(name: 'discount_value')
  final double? discountValue;

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

  UpdateProductRequest({
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
  });

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProductRequestToJson(this);
}
