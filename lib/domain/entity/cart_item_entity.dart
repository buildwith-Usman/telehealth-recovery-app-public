import 'package:recovery_consultation_app/domain/entity/base_entity.dart';
import 'package:recovery_consultation_app/domain/entity/medicine_entity.dart';

/// Cart Item Entity - Represents a medicine item in the shopping cart
/// This follows the same pattern as MedicineEntity
class CartItemEntity extends BaseEntity {
  final MedicineEntity medicine;
  final int quantity;
  final double? totalPrice;

  const CartItemEntity({
    required super.id,
    required this.medicine,
    required this.quantity,
    this.totalPrice,
    super.createdAt,
    super.updatedAt,
  });

  /// Calculate total price based on medicine price and quantity
  double get calculatedTotalPrice {
    return (medicine.price ?? 0) * quantity;
  }

  factory CartItemEntity.fromJson(Map<String, dynamic> json) {
    return CartItemEntity(
      id: json['id'] as int? ?? 0,
      medicine: MedicineEntity.fromJson(json['medicine'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine': medicine.toJson(),
      'quantity': quantity,
      'totalPrice': totalPrice ?? calculatedTotalPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create a copy with updated values
  CartItemEntity copyWith({
    int? id,
    MedicineEntity? medicine,
    int? quantity,
    double? totalPrice,
    String? createdAt,
    String? updatedAt,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
