import 'package:recovery_consultation_app/domain/entity/base_entity.dart';
import 'package:recovery_consultation_app/domain/enums/payment_method_type.dart';

/// Payment Method Entity - Represents a saved payment method
/// This entity follows clean architecture principles and extends BaseEntity
class PaymentMethodEntity extends BaseEntity {
  final PaymentMethodType type;
  final String? phoneNumber;     // For Jazz Cash, Easy Paisa
  final String? cardNumber;      // For Credit/Debit Card (last 4 digits)
  final String? cardHolderName;  // For Credit/Debit Card
  final String? expiryDate;      // For Credit/Debit Card
  final String? cardType;        // For Credit/Debit Card (Visa, Mastercard, etc.)
  final bool isDefault;
  final String? nickname;        // Optional friendly name for the payment method

  const PaymentMethodEntity({
    required super.id,
    required this.type,
    this.phoneNumber,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.cardType,
    this.isDefault = false,
    this.nickname,
    super.createdAt,
    super.updatedAt,
  });

  /// Get display title for the payment method
  String get displayTitle {
    if (nickname != null && nickname!.isNotEmpty) {
      return nickname!;
    }
    return type.displayName;
  }

  /// Get display subtitle (masked sensitive info)
  String get displaySubtitle {
    if (type.requiresPhoneNumber && phoneNumber != null) {
      return _maskPhoneNumber(phoneNumber!);
    }
    if (type.requiresCardDetails && cardNumber != null) {
      return '**** **** **** $cardNumber';
    }
    return type.displayName;
  }

  /// Mask phone number for security (show last 4 digits)
  String _maskPhoneNumber(String phone) {
    if (phone.length <= 4) return phone;
    return '****${phone.substring(phone.length - 4)}';
  }

  /// Create copy with updated fields
  PaymentMethodEntity copyWith({
    int? id,
    PaymentMethodType? type,
    String? phoneNumber,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cardType,
    bool? isDefault,
    String? nickname,
    String? createdAt,
    String? updatedAt,
  }) {
    return PaymentMethodEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cardType: cardType ?? this.cardType,
      isDefault: isDefault ?? this.isDefault,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'phoneNumber': phoneNumber,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cardType': cardType,
      'isDefault': isDefault,
      'nickname': nickname,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Create from JSON (from API response)
  factory PaymentMethodEntity.fromJson(Map<String, dynamic> json) {
    return PaymentMethodEntity(
      id: json['id'] as int,
      type: PaymentMethodType.fromString(json['type']) ?? PaymentMethodType.cashOnDelivery,
      phoneNumber: json['phoneNumber'] as String?,
      cardNumber: json['cardNumber'] as String?,
      cardHolderName: json['cardHolderName'] as String?,
      expiryDate: json['expiryDate'] as String?,
      cardType: json['cardType'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      nickname: json['nickname'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
}
