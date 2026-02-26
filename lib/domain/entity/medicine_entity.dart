import 'package:recovery_consultation_app/domain/entity/base_entity.dart';

/// Medicine Entity - Represents medicine data from API
/// This follows the same pattern as UserEntity, AppointmentEntity
class MedicineEntity extends BaseEntity {
  final String? name;
  final String? description;
  final String? category;
  final double? price;
  final String? imageUrl;
  final int? stockQuantity;
  final String? manufacturer;
  final bool? requiresPrescription;
  final List<String>? tags;

  const MedicineEntity({
    required super.id,
    this.name,
    this.description,
    this.category,
    this.price,
    this.imageUrl,
    this.stockQuantity,
    this.manufacturer,
    this.requiresPrescription,
    this.tags,
    super.createdAt,
    super.updatedAt,
  });

  factory MedicineEntity.fromJson(Map<String, dynamic> json) {
    return MedicineEntity(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      stockQuantity: json['stockQuantity'] as int?,
      manufacturer: json['manufacturer'] as String?,
      requiresPrescription: json['requiresPrescription'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'stockQuantity': stockQuantity,
      'manufacturer': manufacturer,
      'requiresPrescription': requiresPrescription,
      'tags': tags,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
