import 'package:recovery_consultation_app/domain/entity/base_entity.dart';

/// Pharmacy Banner Entity - Represents promotional banner data from API
/// This follows the same pattern as UserEntity, AppointmentEntity
class PharmacyBannerEntity extends BaseEntity {
  final String title;
  final String description;
  final String? imageUrl;
  final String? productName;
  final double? discountPercentage;
  final String? buttonText;
  final PharmacyBannerType bannerType;

  const PharmacyBannerEntity({
    required super.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.productName,
    this.discountPercentage,
    this.buttonText,
    this.bannerType = PharmacyBannerType.promotion,
    super.createdAt,
    super.updatedAt,
  });

  /// Helper method to get display button text
  String get displayButtonText => buttonText ?? 'Shop Now';

  /// Helper method to check if banner has discount
  bool get hasDiscount => discountPercentage != null && discountPercentage! > 0;

  /// Helper method to format discount text
  String get discountText => hasDiscount ? '${discountPercentage!.toInt()}% OFF' : '';

  /// Factory constructor for creating entity from JSON (API response)
  factory PharmacyBannerEntity.fromJson(Map<String, dynamic> json) {
    return PharmacyBannerEntity(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      productName: json['productName'] as String?,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      buttonText: json['buttonText'] as String?,
      bannerType: _bannerTypeFromString(json['bannerType'] as String?),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  /// Convert entity to JSON (for API requests if needed)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'productName': productName,
      'discountPercentage': discountPercentage,
      'buttonText': buttonText,
      'bannerType': bannerType.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create a copy of the entity with modified fields
  PharmacyBannerEntity copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    String? productName,
    double? discountPercentage,
    String? buttonText,
    PharmacyBannerType? bannerType,
    String? createdAt,
    String? updatedAt,
  }) {
    return PharmacyBannerEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      productName: productName ?? this.productName,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      buttonText: buttonText ?? this.buttonText,
      bannerType: bannerType ?? this.bannerType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Helper method to convert string to banner type
  static PharmacyBannerType _bannerTypeFromString(String? type) {
    switch (type?.toLowerCase()) {
      case 'promotion':
        return PharmacyBannerType.promotion;
      case 'newarrival':
      case 'new_arrival':
        return PharmacyBannerType.newArrival;
      case 'flashsale':
      case 'flash_sale':
        return PharmacyBannerType.flashSale;
      case 'featured':
        return PharmacyBannerType.featured;
      case 'announcement':
        return PharmacyBannerType.announcement;
      default:
        return PharmacyBannerType.promotion;
    }
  }
}

/// Banner types for pharmacy module
enum PharmacyBannerType {
  promotion,      // Product promotions
  newArrival,     // New products
  flashSale,      // Time-limited sales
  featured,       // Featured products
  announcement,   // General announcements
}
