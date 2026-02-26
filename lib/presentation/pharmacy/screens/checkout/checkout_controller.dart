import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/controllers/payment_method_controller.dart';
import 'package:recovery_consultation_app/domain/entity/payment_method_entity.dart';
import 'package:recovery_consultation_app/domain/entity/cart_item_entity.dart';
import '../../../../app/controllers/base_controller.dart';

/// Checkout Controller - Manages checkout screen state and business logic
class CheckoutController extends BaseController {
  // ✅ Get the reusable payment method controller
  final PaymentMethodController paymentMethodController = Get.find();

  // Text Editing Controllers for Delivery Form
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final postalCodeController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final deliveryAddressController = TextEditingController();

  // Payment Field Controllers
  final paymentPhoneNumberController = TextEditingController();
  final cardNumberController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();

  // Save payment method option
  final RxBool savePaymentMethod = false.obs;

  // Validation Errors
  final Rx<String?> fullNameError = Rx<String?>(null);
  final Rx<String?> phoneNumberError = Rx<String?>(null);
  final Rx<String?> postalCodeError = Rx<String?>(null);
  final Rx<String?> countryError = Rx<String?>(null);
  final Rx<String?> cityError = Rx<String?>(null);
  final Rx<String?> deliveryAddressError = Rx<String?>(null);

  // Payment Field Validation Errors
  final Rx<String?> paymentPhoneNumberError = Rx<String?>(null);
  final Rx<String?> cardNumberError = Rx<String?>(null);
  final Rx<String?> cardHolderNameError = Rx<String?>(null);
  final Rx<String?> expiryDateError = Rx<String?>(null);
  final Rx<String?> cvvError = Rx<String?>(null);

  // Cart Items (passed from cart)
  final RxList<CartItemEntity> cartItems = <CartItemEntity>[].obs;

  // Order Summary (passed from cart)
  final RxDouble subtotal = 0.0.obs;
  final RxDouble deliveryFee = 50.0.obs;
  final RxDouble total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCheckoutData();
  }

  @override
  void onClose() {
    // Dispose delivery form controllers
    fullNameController.dispose();
    phoneNumberController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    cityController.dispose();
    deliveryAddressController.dispose();

    // Dispose payment field controllers
    paymentPhoneNumberController.dispose();
    cardNumberController.dispose();
    cardHolderNameController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();

    super.onClose();
  }

  // Clear error methods - Delivery Form
  void clearFullNameError() => fullNameError.value = null;
  void clearPhoneNumberError() => phoneNumberError.value = null;
  void clearPostalCodeError() => postalCodeError.value = null;
  void clearCountryError() => countryError.value = null;
  void clearCityError() => cityError.value = null;
  void clearDeliveryAddressError() => deliveryAddressError.value = null;

  // Clear error methods - Payment Fields
  void clearPaymentPhoneNumberError() => paymentPhoneNumberError.value = null;
  void clearCardNumberError() => cardNumberError.value = null;
  void clearCardHolderNameError() => cardHolderNameError.value = null;
  void clearExpiryDateError() => expiryDateError.value = null;
  void clearCvvError() => cvvError.value = null;

  /// Load checkout data (passed from cart)
  Future<void> _loadCheckoutData() async {
    try {
      setLoading(true);

      // Get order summary and cart items from cart (passed as arguments)
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        subtotal.value = args['subtotal'] ?? 0.0;
        deliveryFee.value = args['deliveryFee'] ?? 50.0;
        total.value = args['total'] ?? 0.0;

        // Load cart items if provided
        final items = args['cartItems'] as List<dynamic>?;
        if (items != null) {
          cartItems.value = items.cast<CartItemEntity>();
        }
      }

      setLoading(false);
    } catch (e) {
      logger.error('Error loading checkout data: $e');
      setLoading(false);
    }
  }


  /// Place order
  Future<void> placeOrder() async {
    try {
      if (!_validateOrder()) {
        return;
      }

      setLoading(true);

      // Save payment method if user opted to save it
      if (savePaymentMethod.value) {
        await _savePaymentMethodDetails();
      }

      // TODO: Implement API call to place order
      await Future.delayed(const Duration(seconds: 2));

      setLoading(false);

      // Navigate to order confirmation with order data
      Get.offNamed(AppRoutes.orderConfirmation, arguments: {
        'orderNumber': _generateOrderNumber(),
        'subtotal': subtotal.value,
        'deliveryFee': deliveryFee.value,
        'total': total.value,
        'paymentMethod': _getPaymentMethodLabel(),
        'fullName': fullNameController.text.trim(),
        'phoneNumber': phoneNumberController.text.trim(),
        'deliveryAddress': '${deliveryAddressController.text.trim()}, ${cityController.text.trim()}, ${countryController.text.trim()}, ${postalCodeController.text.trim()}',
      });
    } catch (e) {
      logger.error('Error placing order: $e');
      setLoading(false);
      // TODO: Show error message
    }
  }

  /// Generate order number (temporary - should come from backend)
  String _generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD${timestamp.toString().substring(timestamp.toString().length - 8)}';
  }

  /// Get payment method label for order confirmation
  String _getPaymentMethodLabel() {
    final selectedMethod = paymentMethodController.selectedPaymentMethod.value;
    if (selectedMethod != null) {
      return selectedMethod.displayTitle;
    }
    return 'N/A';
  }

  /// Validate order before placing
  bool _validateOrder() {
    bool isValid = true;

    // Validate Full Name
    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
      isValid = false;
    } else if (fullNameController.text.trim().length < 2) {
      fullNameError.value = 'Name too short';
      isValid = false;
    }

    // Validate Phone Number
    if (phoneNumberController.text.trim().isEmpty) {
      phoneNumberError.value = 'Phone number is required';
      isValid = false;
    } else if (phoneNumberController.text.trim().length < 10) {
      phoneNumberError.value = 'Invalid phone number';
      isValid = false;
    }

    // Validate Postal Code
    if (postalCodeController.text.trim().isEmpty) {
      postalCodeError.value = 'Postal code is required';
      isValid = false;
    }

    // Validate Country
    if (countryController.text.trim().isEmpty) {
      countryError.value = 'Country is required';
      isValid = false;
    }

    // Validate City
    if (cityController.text.trim().isEmpty) {
      cityError.value = 'City is required';
      isValid = false;
    }

    // Validate Delivery Address
    if (deliveryAddressController.text.trim().isEmpty) {
      deliveryAddressError.value = 'Delivery address is required';
      isValid = false;
    } else if (deliveryAddressController.text.trim().length < 10) {
      deliveryAddressError.value = 'Address too short';
      isValid = false;
    }

    // Validate Payment Method
    if (paymentMethodController.selectedPaymentMethod.value == null) {
      isValid = false;
      // TODO: Show error message for missing payment method
    } else {
      // Validate payment fields based on payment type
      if (!_validatePaymentFields()) {
        isValid = false;
      }
    }

    return isValid;
  }

  /// Validate payment fields based on selected payment method type
  bool _validatePaymentFields() {
    final selectedMethod = paymentMethodController.selectedPaymentMethod.value;
    if (selectedMethod == null) return false;

    bool isValid = true;

    // Validate phone number for Jazz Cash / Easy Paisa
    if (selectedMethod.type.requiresPhoneNumber) {
      if (paymentPhoneNumberController.text.trim().isEmpty) {
        paymentPhoneNumberError.value = 'Phone number is required';
        isValid = false;
      } else if (paymentPhoneNumberController.text.trim().length < 11) {
        paymentPhoneNumberError.value = 'Invalid phone number (11 digits required)';
        isValid = false;
      }
    }

    // Validate card details for Credit/Debit Card
    if (selectedMethod.type.requiresCardDetails) {
      // Card Number
      final cardNumber = cardNumberController.text.replaceAll(' ', '');
      if (cardNumber.isEmpty) {
        cardNumberError.value = 'Card number is required';
        isValid = false;
      } else if (cardNumber.length != 16) {
        cardNumberError.value = 'Invalid card number (16 digits required)';
        isValid = false;
      }

      // Card Holder Name
      if (cardHolderNameController.text.trim().isEmpty) {
        cardHolderNameError.value = 'Card holder name is required';
        isValid = false;
      } else if (cardHolderNameController.text.trim().length < 3) {
        cardHolderNameError.value = 'Name too short';
        isValid = false;
      }

      // Expiry Date
      final expiry = expiryDateController.text.replaceAll('/', '');
      if (expiry.isEmpty) {
        expiryDateError.value = 'Expiry date is required';
        isValid = false;
      } else if (expiry.length != 4) {
        expiryDateError.value = 'Invalid expiry date (MM/YY)';
        isValid = false;
      } else {
        // Validate expiry date is not in the past
        final month = int.tryParse(expiry.substring(0, 2)) ?? 0;
        final year = int.tryParse(expiry.substring(2, 4)) ?? 0;
        final now = DateTime.now();
        final currentYear = now.year % 100; // Get last 2 digits
        final currentMonth = now.month;

        if (month < 1 || month > 12) {
          expiryDateError.value = 'Invalid month';
          isValid = false;
        } else if (year < currentYear || (year == currentYear && month < currentMonth)) {
          expiryDateError.value = 'Card has expired';
          isValid = false;
        }
      }

      // CVV
      if (cvvController.text.trim().isEmpty) {
        cvvError.value = 'CVV is required';
        isValid = false;
      } else if (cvvController.text.trim().length != 3) {
        cvvError.value = 'Invalid CVV (3 digits required)';
        isValid = false;
      }
    }

    return isValid;
  }

  /// Save payment method details
  Future<void> _savePaymentMethodDetails() async {
    try {
      final selectedMethod = paymentMethodController.selectedPaymentMethod.value;
      if (selectedMethod == null) return;

      // Create new payment method entity from entered details
      final newPaymentMethod = PaymentMethodEntity(
        id: 0, // Will be assigned by repository
        type: selectedMethod.type,
        phoneNumber: selectedMethod.type.requiresPhoneNumber
            ? paymentPhoneNumberController.text.trim()
            : null,
        cardNumber: selectedMethod.type.requiresCardDetails
            ? cardNumberController.text.replaceAll(' ', '').substring(12) // Last 4 digits only
            : null,
        cardHolderName: selectedMethod.type.requiresCardDetails
            ? cardHolderNameController.text.trim()
            : null,
        expiryDate: selectedMethod.type.requiresCardDetails
            ? expiryDateController.text.trim()
            : null,
        cardType: selectedMethod.type.requiresCardDetails
            ? _detectCardType(cardNumberController.text.replaceAll(' ', ''))
            : null,
        isDefault: false,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Save the payment method
      await paymentMethodController.savePaymentMethod(newPaymentMethod);
    } catch (e) {
      logger.error('Error saving payment method: $e');
    }
  }

  /// Detect card type from card number
  String _detectCardType(String cardNumber) {
    if (cardNumber.isEmpty) return 'Unknown';

    // Visa: starts with 4
    if (cardNumber.startsWith('4')) {
      return 'Visa';
    }
    // Mastercard: starts with 51-55 or 2221-2720
    else if (cardNumber.startsWith(RegExp(r'^5[1-5]')) ||
        cardNumber.startsWith(RegExp(r'^2[2-7]'))) {
      return 'Mastercard';
    }
    // American Express: starts with 34 or 37
    else if (cardNumber.startsWith('34') || cardNumber.startsWith('37')) {
      return 'American Express';
    }
    // Discover: starts with 6011, 622126-622925, 644-649, 65
    else if (cardNumber.startsWith('6011') ||
        cardNumber.startsWith(RegExp(r'^62212[6-9]')) ||
        cardNumber.startsWith(RegExp(r'^6229[01][0-9]')) ||
        cardNumber.startsWith(RegExp(r'^622[2-9]')) ||
        cardNumber.startsWith(RegExp(r'^64[4-9]')) ||
        cardNumber.startsWith('65')) {
      return 'Discover';
    }

    return 'Unknown';
  }

  /// Validate delivery information (Step 1)
  bool validateDeliveryInformation() {
    bool isValid = true;

    // Validate Full Name
    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
      isValid = false;
    } else if (fullNameController.text.trim().length < 2) {
      fullNameError.value = 'Name too short';
      isValid = false;
    }

    // Validate Phone Number
    if (phoneNumberController.text.trim().isEmpty) {
      phoneNumberError.value = 'Phone number is required';
      isValid = false;
    } else if (phoneNumberController.text.trim().length < 10) {
      phoneNumberError.value = 'Invalid phone number';
      isValid = false;
    }

    // Validate Postal Code
    if (postalCodeController.text.trim().isEmpty) {
      postalCodeError.value = 'Postal code is required';
      isValid = false;
    }

    // Validate Country
    if (countryController.text.trim().isEmpty) {
      countryError.value = 'Country is required';
      isValid = false;
    }

    // Validate City
    if (cityController.text.trim().isEmpty) {
      cityError.value = 'City is required';
      isValid = false;
    }

    // Validate Delivery Address
    if (deliveryAddressController.text.trim().isEmpty) {
      deliveryAddressError.value = 'Delivery address is required';
      isValid = false;
    } else if (deliveryAddressController.text.trim().length < 10) {
      deliveryAddressError.value = 'Address too short';
      isValid = false;
    }

    return isValid;
  }

  /// Validate payment method (Step 3)
  bool validatePaymentMethod() {
    // Validate Payment Method Selection
    if (paymentMethodController.selectedPaymentMethod.value == null) {
      // TODO: Show error message for missing payment method
      return false;
    }

    // Validate payment fields based on payment type
    return _validatePaymentFields();
  }

  /// Go back to cart
  void goBack() {
    logger.navigation('Going back to cart');
    Get.back();
  }
}
