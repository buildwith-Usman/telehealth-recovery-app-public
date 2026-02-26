import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/app_routes.dart';

class PaymentDetailsController extends GetxController {
  // ==================== OBSERVABLES ====================
  var isLoading = false.obs;
  var isProcessing = false.obs;
  
  // Consultation details from arguments
  var specialistName = ''.obs;
  var consultationDate = ''.obs;
  var consultationTime = ''.obs;
  var consultationType = ''.obs;
  var totalAmount = 0.0.obs;
  var paymentMethodType = ''.obs;
  var paymentMethodTitle = ''.obs;
  
  // Form controllers
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  
  // Form validation
  final formKey = GlobalKey<FormState>();
  var isFormValid = false.obs;
  
  // Card number formatting
  var formattedCardNumber = ''.obs;
  var cardType = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _setupCardNumberListener();
  }
  
  @override
  void onClose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardHolderNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // ==================== METHODS ====================
  void _loadArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      specialistName.value = arguments['specialistName'] ?? '';
      consultationDate.value = arguments['consultationDate'] ?? '';
      consultationTime.value = arguments['consultationTime'] ?? '';
      consultationType.value = arguments['consultationType'] ?? '';
      totalAmount.value = arguments['totalAmount'] ?? 0.0;
      paymentMethodType.value = arguments['paymentMethodType'] ?? '';
      paymentMethodTitle.value = arguments['paymentMethodTitle'] ?? '';
      
      if (kDebugMode) {
        print('PaymentDetails loaded with arguments: $arguments');
      }
    }
  }
  
  void _setupCardNumberListener() {
    cardNumberController.addListener(() {
      String text = cardNumberController.text.replaceAll(' ', '');
      
      // Format card number with spaces
      String formatted = '';
      for (int i = 0; i < text.length; i++) {
        if (i > 0 && i % 4 == 0) {
          formatted += ' ';
        }
        formatted += text[i];
      }
      
      formattedCardNumber.value = formatted;
      
      // Detect card type
      _detectCardType(text);
      
      // Update cursor position if formatting changed
      if (formatted != cardNumberController.text) {
        cardNumberController.value = cardNumberController.value.copyWith(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }
  
  void _detectCardType(String number) {
    if (number.startsWith('4')) {
      cardType.value = 'Visa';
    } else if (number.startsWith('5') || number.startsWith('2')) {
      cardType.value = 'Mastercard';
    } else if (number.startsWith('3')) {
      cardType.value = 'American Express';
    } else if (number.startsWith('6')) {
      cardType.value = 'Discover';
    } else {
      cardType.value = '';
    }
  }
  
  void formatExpiryDate(String value) {
    String text = value.replaceAll('/', '');
    if (text.length >= 2) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    expiryDateController.value = expiryDateController.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
  
  void validateForm() {
    isFormValid.value = formKey.currentState?.validate() ?? false;
  }
  
  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    
    String cleanNumber = value.replaceAll(' ', '');
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return 'Invalid card number';
    }
    
    // Luhn algorithm validation
    if (!_isValidCardNumber(cleanNumber)) {
      return 'Invalid card number';
    }
    
    return null;
  }
  
  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    
    if (value.length != 5 || !value.contains('/')) {
      return 'Invalid format (MM/YY)';
    }
    
    List<String> parts = value.split('/');
    int month = int.tryParse(parts[0]) ?? 0;
    int year = int.tryParse(parts[1]) ?? 0;
    
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }
    
    int currentYear = DateTime.now().year % 100;
    int currentMonth = DateTime.now().month;
    
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card expired';
    }
    
    return null;
  }
  
  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    
    if (cardType.value == 'American Express') {
      if (value.length != 4) {
        return 'CVV must be 4 digits for Amex';
      }
    } else {
      if (value.length != 3) {
        return 'CVV must be 3 digits';
      }
    }
    
    return null;
  }
  
  String? validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cardholder name is required';
    }
    
    if (value.length < 2) {
      return 'Name too short';
    }
    
    return null;
  }
  
  String? validateEmail(String? value) {
    if (paymentMethodType.value.toLowerCase().contains('paypal') || 
        paymentMethodType.value.toLowerCase().contains('google')) {
      if (value == null || value.isEmpty) {
        return 'Email is required';
      }
      
      if (!GetUtils.isEmail(value)) {
        return 'Invalid email format';
      }
    }
    
    return null;
  }
  
  bool _isValidCardNumber(String number) {
    int sum = 0;
    bool alternate = false;
    
    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }
  
  bool isCardPayment() {
    return paymentMethodType.value.toLowerCase().contains('card') ||
           paymentMethodType.value.toLowerCase().contains('credit') ||
           paymentMethodType.value.toLowerCase().contains('debit');
  }
  
  bool isDigitalWallet() {
    return paymentMethodType.value.toLowerCase().contains('paypal') ||
           paymentMethodType.value.toLowerCase().contains('google') ||
           paymentMethodType.value.toLowerCase().contains('apple');
  }
  
  void proceedToPayment() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Invalid Details',
        'Please fill in all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    
    isProcessing.value = true;
    
    try {
      // Simulate validation processing
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Navigate to pay now screen with all details
      Get.toNamed(
        AppRoutes.payNow,
        arguments: {
          'specialistName': specialistName.value,
          'consultationDate': consultationDate.value,
          'consultationTime': consultationTime.value,
          'consultationType': consultationType.value,
          'totalAmount': totalAmount.value,
          'paymentMethodType': paymentMethodType.value,
          'paymentMethodTitle': paymentMethodTitle.value,
          'cardNumber': isCardPayment() ? formattedCardNumber.value.replaceAll(' ', '').replaceAll(RegExp(r'.(?=.{4})'), '*') : null,
          'cardType': cardType.value,
          'cardHolderName': cardHolderNameController.text,
          'email': emailController.text,
        },
      );
      
    } catch (e) {
      if (kDebugMode) {
        print('Payment details validation error: $e');
      }
      
      Get.snackbar(
        'Validation Failed',
        'There was an error validating your payment details. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isProcessing.value = false;
    }
  }
  
  void goBack() {
    Get.back();
  }
  
  String getFormattedAmount() {
    return '\$${totalAmount.value.toStringAsFixed(2)}';
  }
}
