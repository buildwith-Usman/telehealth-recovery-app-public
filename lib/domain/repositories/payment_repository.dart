import 'package:recovery_consultation_app/domain/entity/payment_method_entity.dart';

/// Payment Repository Interface
/// Defines contract for payment-related operations following Repository Pattern
/// This interface allows for multiple implementations (API, Local Storage, Mock)
abstract class PaymentRepository {
  /// Get all saved payment methods for the current user
  Future<List<PaymentMethodEntity>> getSavedPaymentMethods();

  /// Get a specific payment method by ID
  Future<PaymentMethodEntity?> getPaymentMethodById(int id);

  /// Save a new payment method
  Future<PaymentMethodEntity> savePaymentMethod(PaymentMethodEntity paymentMethod);

  /// Update an existing payment method
  Future<PaymentMethodEntity> updatePaymentMethod(PaymentMethodEntity paymentMethod);

  /// Delete a payment method
  Future<void> deletePaymentMethod(int id);

  /// Set a payment method as default
  Future<void> setDefaultPaymentMethod(int id);

  /// Get the default payment method
  Future<PaymentMethodEntity?> getDefaultPaymentMethod();

  /// Validate payment method details before saving
  Future<bool> validatePaymentMethod(PaymentMethodEntity paymentMethod);

  /// Process a payment (for actual payment processing)
  Future<Map<String, dynamic>> processPayment({
    required int paymentMethodId,
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  });
}
