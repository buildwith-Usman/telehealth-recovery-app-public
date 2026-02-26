import 'package:recovery_consultation_app/domain/entity/base_entity.dart';

/// Featured Product Entity - Represents featured/promoted product data
/// This follows the same pattern as PharmacyBannerEntity
class FeaturedProductEntity extends BaseEntity {
  final String name;
  final String? imageUrl;
  final double price;
  final double? originalPrice;
  final double? discountPercentage;
  final String? description;
  final String? category;
  final bool isInStock;
  final int? stockCount;

  const FeaturedProductEntity({
    required super.id,
    required this.name,
    this.imageUrl,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
    this.description,
    this.category,
    this.isInStock = true,
    this.stockCount,
    super.createdAt,
    super.updatedAt,
  });

  /// Helper method to check if product has discount
  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;

  /// Helper method to format discount text
  String get discountText => hasDiscount ? 'Up to ${discountPercentage!.toInt()}% OFF' : '';

  /// Helper method to calculate savings
  double get savings => originalPrice != null ? originalPrice! - price : 0;

  /// Factory constructor for creating entity from JSON (API response)
  factory FeaturedProductEntity.fromJson(Map<String, dynamic> json) {
    return FeaturedProductEntity(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      description: json['description'] as String?,
      category: json['category'] as String?,
      isInStock: json['isInStock'] as bool? ?? true,
      stockCount: json['stockCount'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  /// Convert entity to JSON (for API requests if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'description': description,
      'category': category,
      'isInStock': isInStock,
      'stockCount': stockCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create a copy of the entity with modified fields
  FeaturedProductEntity copyWith({
    int? id,
    String? name,
    String? imageUrl,
    double? price,
    double? originalPrice,
    double? discountPercentage,
    String? description,
    String? category,
    bool? isInStock,
    int? stockCount,
    String? createdAt,
    String? updatedAt,
  }) {
    return FeaturedProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      description: description ?? this.description,
      category: category ?? this.category,
      isInStock: isInStock ?? this.isInStock,
      stockCount: stockCount ?? this.stockCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
