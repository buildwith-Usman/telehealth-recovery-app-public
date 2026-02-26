/// Payment Method Type Enum
/// Defines all available payment methods in the application
enum PaymentMethodType {
  jazzCash('Jazz Cash'),
  easyPaisa('Easy Paisa'),
  creditCard('Card Payment'),
  debitCard('Card Payment'),
  cashOnDelivery('Cash on Delivery');

  final String displayName;

  const PaymentMethodType(this.displayName);

  /// Check if payment method requires phone number
  bool get requiresPhoneNumber {
    return this == PaymentMethodType.jazzCash ||
           this == PaymentMethodType.easyPaisa;
  }

  /// Check if payment method requires card details
  bool get requiresCardDetails {
    return this == PaymentMethodType.creditCard ||
           this == PaymentMethodType.debitCard;
  }

  /// Check if payment method requires no additional details
  bool get requiresNoDetails {
    return this == PaymentMethodType.cashOnDelivery;
  }

  /// Get payment method type from string
  static PaymentMethodType? fromString(String? value) {
    if (value == null) return null;
    try {
      return PaymentMethodType.values.firstWhere(
        (type) => type.displayName.toLowerCase() == value.toLowerCase() ||
                  type.name.toLowerCase() == value.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}
