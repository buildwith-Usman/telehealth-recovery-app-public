import 'package:json_annotation/json_annotation.dart';

part 'create_product_request.g.dart';

@JsonSerializable()
class CreateProductRequest {
  @JsonKey(name: 'medicine_name')
  final String medicineName;

  @JsonKey(name: 'image_id')
  final int imageId;

  @JsonKey(name: 'category_id')
  final int categoryId;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;

  @JsonKey(name: 'ingredients')
  final String ingredients;

  @JsonKey(name: 'discount_type')
  final String discountType;

  @JsonKey(name: 'discount_value')
  final double discountValue;

  @JsonKey(name: 'how_to_use')
  final String howToUse;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'is_visible')
  final bool isVisible;

  @JsonKey(name: 'is_temporarily_hidden')
  final bool isTemporarilyHidden;

  CreateProductRequest({
    required this.medicineName,
    required this.imageId,
    required this.categoryId,
    required this.price,
    required this.stockQuantity,
    required this.ingredients,
    required this.discountType,
    required this.discountValue,
    required this.howToUse,
    required this.description,
    required this.isVisible,
    required this.isTemporarilyHidden,
  });

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProductRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateProductRequestToJson(this);
}
