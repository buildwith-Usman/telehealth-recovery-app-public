import 'package:recovery_consultation_app/domain/entity/base_entity.dart';

/// Category Entity - Represents medicine category data from API
/// This follows the same pattern as UserEntity, AppointmentEntity
class CategoryEntity extends BaseEntity {
  final String? name;
  final String? description;
  final String? iconUrl;
  final int? productCount;

  const CategoryEntity({
    required super.id,
    this.name,
    this.description,
    this.iconUrl,
    this.productCount,
    super.createdAt,
    super.updatedAt,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      productCount: json['productCount'] as int?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'productCount': productCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
