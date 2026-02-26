import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/entity/payment_method_entity.dart';
import 'package:recovery_consultation_app/domain/enums/payment_method_type.dart';
import 'package:recovery_consultation_app/domain/repositories/payment_repository.dart';

/// Reusable Payment Method Controller
/// This controller manages payment methods across the entire application
/// It follows SOLID principles and can be reused in multiple flows
/// (video consultation, medicine ordering, settings, etc.)
class PaymentMethodController extends GetxController {
  PaymentMethodController({required this.paymentRepository});

  final PaymentRepository paymentRepository;

  // Observable state
  final RxList<PaymentMethodEntity> paymentMethods = <PaymentMethodEntity>[].obs;
  final Rx<PaymentMethodEntity?> selectedPaymentMethod = Rx<PaymentMethodEntity?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPaymentMethods();
  }

  /// Load all saved payment methods
  Future<void> loadPaymentMethods() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Get saved payment methods from repository
      final methods = await paymentRepository.getSavedPaymentMethods();

      // Always include Cash on Delivery as a system payment method
      final List<PaymentMethodEntity> allMethods = [
        // Add Cash on Delivery as the first option (system method)
        PaymentMethodEntity(
          id: -1, // Use negative ID to identify as system method
          type: PaymentMethodType.cashOnDelivery,
          isDefault: false,
          nickname: 'Cash on Delivery',
          createdAt: DateTime.now().toIso8601String(),
        ),
        // Add all saved payment methods
        ...methods,
      ];

      paymentMethods.assignAll(allMethods);

      // ❌ No automatic selection - user must choose payment method manually
      // selectedPaymentMethod remains null until user selects one

      if (kDebugMode) {
        print('Loaded ${allMethods.length} payment methods (including COD)');
      }
    } catch (e) {
      error.value = 'Failed to load payment methods';
      if (kDebugMode) {
        print('Error loading payment methods: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Select a payment method
  void selectPaymentMethod(PaymentMethodEntity method) {
    selectedPaymentMethod.value = method;
    if (kDebugMode) {
      print('Selected payment method: ${method.displayTitle}');
    }
  }

  /// Save a new payment method
  Future<bool> savePaymentMethod(PaymentMethodEntity method) async {
    try {
      isSaving.value = true;
      error.value = '';

      // Validate before saving
      final isValid = await paymentRepository.validatePaymentMethod(method);
      if (!isValid) {
        error.value = 'Invalid payment method details';
        return false;
      }

      // Save the payment method
      final savedMethod = await paymentRepository.savePaymentMethod(method);
      paymentMethods.add(savedMethod);

      // Select the newly added method
      selectedPaymentMethod.value = savedMethod;

      if (kDebugMode) {
        print('Payment method saved successfully: ${savedMethod.displayTitle}');
      }

      return true;
    } catch (e) {
      error.value = 'Failed to save payment method';
      if (kDebugMode) {
        print('Error saving payment method: $e');
      }
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Update an existing payment method
  Future<bool> updatePaymentMethod(PaymentMethodEntity method) async {
    try {
      isSaving.value = true;
      error.value = '';

      final updatedMethod = await paymentRepository.updatePaymentMethod(method);

      final index = paymentMethods.indexWhere((m) => m.id == updatedMethod.id);
      if (index != -1) {
        paymentMethods[index] = updatedMethod;
      }

      if (selectedPaymentMethod.value?.id == updatedMethod.id) {
        selectedPaymentMethod.value = updatedMethod;
      }

      if (kDebugMode) {
        print('Payment method updated successfully');
      }

      return true;
    } catch (e) {
      error.value = 'Failed to update payment method';
      if (kDebugMode) {
        print('Error updating payment method: $e');
      }
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete a payment method
  Future<bool> deletePaymentMethod(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      await paymentRepository.deletePaymentMethod(id);
      paymentMethods.removeWhere((method) => method.id == id);

      // If we deleted the selected method, select another one
      if (selectedPaymentMethod.value?.id == id) {
        selectedPaymentMethod.value = paymentMethods.isNotEmpty ? paymentMethods.first : null;
      }

      if (kDebugMode) {
        print('Payment method deleted successfully');
      }

      return true;
    } catch (e) {
      error.value = 'Failed to delete payment method';
      if (kDebugMode) {
        print('Error deleting payment method: $e');
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Set a payment method as default
  /// ❌ DEPRECATED - Not implementing default payment method functionality
  @Deprecated('Default payment method feature is not implemented')
  Future<bool> setDefaultPaymentMethod(int id) async {
    if (kDebugMode) {
      print('WARNING: setDefaultPaymentMethod called but feature is not implemented');
    }
    return false;
  }

  /// Get the currently selected payment method title
  String getSelectedPaymentMethodTitle() {
    if (selectedPaymentMethod.value == null) {
      return 'Choose Payment Method';
    }
    return selectedPaymentMethod.value!.displayTitle;
  }

  /// Get the currently selected payment method subtitle
  String getSelectedPaymentMethodSubtitle() {
    if (selectedPaymentMethod.value == null) {
      return '';
    }
    return selectedPaymentMethod.value!.displaySubtitle;
  }

  /// Check if a specific payment method is selected
  bool isPaymentMethodSelected(PaymentMethodEntity method) {
    return selectedPaymentMethod.value?.id == method.id;
  }

  /// Get payment methods by type
  List<PaymentMethodEntity> getPaymentMethodsByType(PaymentMethodType type) {
    return paymentMethods.where((method) => method.type == type).toList();
  }

  /// Check if there are any saved payment methods
  bool get hasPaymentMethods => paymentMethods.isNotEmpty;

  /// Get the default payment method
  /// ❌ DEPRECATED - Not implementing default payment method functionality
  @Deprecated('Default payment method feature is not implemented')
  PaymentMethodEntity? get defaultPaymentMethod {
    return null; // Always returns null - no default payment method
  }

  /// Clear error message
  void clearError() {
    error.value = '';
  }

  /// Refresh payment methods (useful for pull-to-refresh)
  @override
  Future<void> refresh() async {
    await loadPaymentMethods();
  }
}
