import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/app_constant.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../data/api/request/appointment_booking_request.dart';
import '../../domain/entity/appointment_booking_entity.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/usecase/book_appointment_use_case.dart';
import '../../domain/usecase/get_specialist_by_id_use_case.dart';

class PaymentSummaryController extends BaseController {
  // ==================== DEPENDENCIES ====================
  final GetUserDetailByIdUseCase getSpecialistByIdUseCase;
  final BookAppointmentUseCase bookAppointmentUseCase;

  PaymentSummaryController({
    required this.getSpecialistByIdUseCase,
    required this.bookAppointmentUseCase,
  });

  // ==================== OBSERVABLES ====================
  var isProcessingPayment = false.obs;
  
  // Consultation details
  var specialistName = ''.obs;
  var specialistProfession = ''.obs;
  var specialistImageUrl = ''.obs;
  var consultationDate = ''.obs;
  var consultationTime = ''.obs;
  var consultationType = ''.obs;

  // Booking details (for API call)
  int? specialistId;
  int? timeSlotId;

  // Payment details
  var consultationFee = 0.0.obs;
  var platformFee = 0.0.obs;
  var taxAmount = 0.0.obs;
  var totalAmount = 0.0.obs;
  
  // Coupon details (MVP)
  var couponCode = ''.obs;
  var appliedCouponCode = ''.obs;
  var discountPercentage = 0.0.obs;
  var discountAmount = 0.0.obs;
  var couponError = ''.obs;
  var isCouponApplied = false.obs;
  
  // Payment method
  var selectedPaymentMethod = 'Jazz Cash'.obs;
  var selectedPaymentMethodIndex = 0.obs;
  var paymentMethods = <String>[].obs;
  var savedPaymentMethods = <Map<String, dynamic>>[].obs;
  var savePaymentMethod = false.obs;

  // Form controls for payment details
  final formKey = GlobalKey<FormState>();
  final couponController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // Form validation
  var isFormValid = false.obs;
  var formattedCardNumber = ''.obs;
  var cardType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPaymentDetails();
    _setupCardNumberListener();
  }

  @override
  void onClose() {
    couponController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardHolderNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // ==================== METHODS ====================
  void _loadPaymentDetails() async {
    // Extract arguments using constants
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    // Extract consultation details from arguments
    consultationDate.value = args[Arguments.consultationDate] ?? '';
    consultationTime.value = args[Arguments.consultationTime] ?? '';
    consultationType.value = args[Arguments.consultationType] ?? '';
    consultationFee.value = args[Arguments.consultationFee] ?? 0.0;

    // Extract booking details for API call
    specialistId = args[Arguments.doctorId];
    timeSlotId = args[Arguments.timeSlotId];

    if (specialistId != null) {
      // Fetch specialist data from API
      final result = await executeApiCall<UserEntity>(
        () => getSpecialistByIdUseCase.execute(specialistId!),
        onSuccess: () {
          logger.controller('Successfully loaded specialist data for payment summary');
        },
      );

      if (result != null) {
        specialistName.value = result.name;
        specialistProfession.value = result.doctorInfo?.specialization ?? '';
        specialistImageUrl.value = result.imageUrl ?? '';
      }
    }

    // Calculate fees
    _calculateFees();

    // Load payment methods
    _loadPaymentMethods();
  }

  // ==================== FORM VALIDATION METHODS ====================
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
    } else if (number.startsWith(RegExp(r'5[1-5]')) || number.startsWith(RegExp(r'2[2-7]'))) {
      cardType.value = 'Mastercard';
    } else if (number.startsWith('3[47]')) {
      cardType.value = 'American Express';
    } else if (number.startsWith('6')) {
      cardType.value = 'Discover';
    } else {
      cardType.value = '';
    }
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    
    String cleanValue = value.replaceAll(' ', '');
    if (cleanValue.length < 13 || cleanValue.length > 19) {
      return 'Invalid card number';
    }
    
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Invalid format (MM/YY)';
    }
    
    List<String> parts = value.split('/');
    int month = int.tryParse(parts[0]) ?? 0;
    int year = int.tryParse(parts[1]) ?? 0;
    
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }
    
    DateTime now = DateTime.now();
    DateTime expiry = DateTime(2000 + year, month);
    
    if (expiry.isBefore(DateTime(now.year, now.month))) {
      return 'Card expired';
    }
    
    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    
    if (value.length < 3 || value.length > 4) {
      return 'Invalid CVV';
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
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (!GetUtils.isEmail(value)) {
      return 'Invalid email address';
    }
    
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    if (value.length < 10) {
      return 'Invalid phone number';
    }
    
    return null;
  }

  bool get isCardPayment {
    return selectedPaymentMethod.value == 'Card Payment';
  }

  void processPaymentWithForm() async {
    if (isCardPayment && !formKey.currentState!.validate()) {
      return;
    }

    // Validate required booking data
    if (specialistId == null || timeSlotId == null) {
      Get.snackbar(
        'Error',
        'Missing booking information. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
      return;
    }

    isProcessingPayment.value = true;

    try {
      // Create booking request
      final bookingRequest = AppointmentBookingRequest(
        docUserId: specialistId!,
        date: consultationDate.value,
        timeSlotId: timeSlotId!,
      );

      // Book appointment via API
      logger.controller('Booking appointment...');
      final result = await bookAppointmentUseCase.execute(bookingRequest);

      isProcessingPayment.value = false;

      if (result != null) {
        logger.controller('Appointment booked successfully with ID: ${result.id}');

        // Navigate to payment success screen with booking response
        Get.offNamed(
          AppRoutes.successPage,
          arguments: {
            Arguments.bookingResponse: result,
            Arguments.showBackToHome: true,
          },
        );
      } else {
        logger.error('Appointment booking returned null');
        Get.snackbar(
          'Error',
          'Failed to book appointment. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isProcessingPayment.value = false;
      logger.error('Error booking appointment: $e');
      Get.snackbar(
        'Error',
        'Failed to book appointment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  }

  void _calculateFees() {
    // Calculate platform fee (5% of consultation fee)
    platformFee.value = consultationFee.value * 0.05;
    
    // Calculate tax (10% of subtotal)
    double subtotal = consultationFee.value + platformFee.value;
    taxAmount.value = subtotal * 0.10;
    
    // Calculate discount if coupon is applied
    if (isCouponApplied.value) {
      discountAmount.value = (consultationFee.value + platformFee.value + taxAmount.value) * (discountPercentage.value / 100);
    } else {
      discountAmount.value = 0.0;
    }
    
    // Calculate total with discount
    totalAmount.value = consultationFee.value + platformFee.value + taxAmount.value - discountAmount.value;
  }

  void _loadPaymentMethods() {
    // Load saved payment methods (simulate from local storage/API)
    savedPaymentMethods.assignAll([
      {
        'type': 'Jazz Cash',
        'phoneNumber': '03123456789',
        'accountName': 'John Doe',
        'isDefault': true,
      },
      {
        'type': 'Easy Paisa',
        'phoneNumber': '03009876543',
        'accountName': 'John Doe',
        'isDefault': false,
      },
      {
        'type': 'Card Payment',
        'brand': 'Visa',
        'lastFour': '4242',
        'expiryDate': '12/25',
        'isDefault': false,
        'cardholderName': 'John Doe',
      },
    ]);
    
    // Available payment method types
    paymentMethods.assignAll([
      'Jazz Cash',
      'Easy Paisa',
      'Card Payment',
    ]);
    
    // Set default payment method if available
    if (savedPaymentMethods.isNotEmpty) {
      var defaultMethod = savedPaymentMethods.firstWhere(
        (method) => method['isDefault'] == true,
        orElse: () => savedPaymentMethods.first,
      );
      selectedPaymentMethod.value = defaultMethod['type'];
      selectedPaymentMethodIndex.value = savedPaymentMethods.indexOf(defaultMethod);
    }
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    
    if (kDebugMode) {
      print('Selected payment method: $method');
    }
  }

  void selectSavedPaymentMethod(int index) {
    if (index < savedPaymentMethods.length) {
      selectedPaymentMethodIndex.value = index;
      selectedPaymentMethod.value = savedPaymentMethods[index]['type'];
      
      if (kDebugMode) {
        print('Selected saved payment method at index $index');
      }
    }
  }

  void addNewPaymentMethod() {
    if (kDebugMode) {
      print('Add new payment method tapped');
    }
    
    // TODO: Navigate to add payment method screen
    Get.snackbar(
      'Add Payment Method',
      'This feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String getPaymentMethodTitle(Map<String, dynamic> method) {
    switch (method['type']) {
      case 'Jazz Cash':
        return 'Jazz Cash';
      case 'Easy Paisa':
        return 'Easy Paisa';
      case 'Card Payment':
        return '${method['brand']} •••• ${method['lastFour']}';
      default:
        return method['type'] ?? 'Unknown';
    }
  }

  String getPaymentMethodSubtitle(Map<String, dynamic> method) {
    switch (method['type']) {
      case 'Jazz Cash':
      case 'Easy Paisa':
        return method['phoneNumber'] ?? '';
      case 'Card Payment':
        return 'Expires ${method['expiryDate']}';
      default:
        return '';
    }
  }

  void openPaymentMethodBottomSheet() {
    if (kDebugMode) {
      print('Opening payment method bottom sheet');
    }
    // This will be called from the page to show the bottom sheet
  }

  String getCurrentPaymentMethodDisplay() {
    if (savedPaymentMethods.isEmpty) {
      return 'Choose Payment Method';
    }
    
    if (selectedPaymentMethodIndex.value < savedPaymentMethods.length) {
      var method = savedPaymentMethods[selectedPaymentMethodIndex.value];
      return getPaymentMethodTitle(method);
    }
    
    return 'Choose Payment Method';
  }

  void saveNewPaymentMethod(Map<String, dynamic> newMethod) {
    // Set as default if it's the first payment method
    if (savedPaymentMethods.isEmpty) {
      newMethod['isDefault'] = true;
    } else {
      newMethod['isDefault'] = false;
    }
    
    savedPaymentMethods.add(newMethod);
    
    // Select the newly added method
    selectedPaymentMethodIndex.value = savedPaymentMethods.length - 1;
    selectedPaymentMethod.value = newMethod['type'];
    
    if (kDebugMode) {
      print('New payment method saved: ${getPaymentMethodTitle(newMethod)}');
    }
    
    Get.snackbar(
      'Payment Method Added',
      'Your payment method has been saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void setAsDefaultPaymentMethod(int index) {
    if (index < savedPaymentMethods.length) {
      // Remove default from all methods
      for (var method in savedPaymentMethods) {
        method['isDefault'] = false;
      }
      
      // Set the selected method as default
      savedPaymentMethods[index]['isDefault'] = true;
      savedPaymentMethods.refresh(); // Notify observers
      
      if (kDebugMode) {
        print('Payment method at index $index set as default');
      }
      
      Get.snackbar(
        'Default Payment Method Updated',
        'Your default payment method has been updated',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void removePaymentMethod(int index) {
    if (index < savedPaymentMethods.length) {
      bool wasDefault = savedPaymentMethods[index]['isDefault'] == true;
      String methodTitle = getPaymentMethodTitle(savedPaymentMethods[index]);
      
      savedPaymentMethods.removeAt(index);
      
      // If we removed the default method and there are other methods, set the first one as default
      if (wasDefault && savedPaymentMethods.isNotEmpty) {
        savedPaymentMethods[0]['isDefault'] = true;
        selectedPaymentMethodIndex.value = 0;
        selectedPaymentMethod.value = savedPaymentMethods[0]['type'];
      } else if (selectedPaymentMethodIndex.value >= savedPaymentMethods.length) {
        // Adjust selected index if it's out of bounds
        selectedPaymentMethodIndex.value = savedPaymentMethods.isNotEmpty ? 0 : -1;
      }
      
      if (kDebugMode) {
        print('Payment method removed: $methodTitle');
      }
      
      Get.snackbar(
        'Payment Method Removed',
        '$methodTitle has been removed',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void processPayment() {
    if (kDebugMode) {
      print('Navigating to payment details...');
      print('Specialist: ${specialistName.value}');
      print('Date: ${consultationDate.value}');
      print('Time: ${consultationTime.value}');
      print('Type: ${consultationType.value}');
      print('Payment Method: ${selectedPaymentMethod.value}');
      print('Total Amount: \$${totalAmount.value.toStringAsFixed(2)}');
    }
    
    // Get selected payment method details
    String? selectedPaymentMethodTitle;
    if (selectedPaymentMethodIndex.value >= 0 && 
        selectedPaymentMethodIndex.value < savedPaymentMethods.length) {
      selectedPaymentMethodTitle = getPaymentMethodTitle(savedPaymentMethods[selectedPaymentMethodIndex.value]);
    }
    
    // Navigate to payment details screen with all necessary data
    Get.toNamed(
      AppRoutes.paymentDetails,
      arguments: {
        'specialistName': specialistName.value,
        'consultationDate': consultationDate.value,
        'consultationTime': consultationTime.value,
        'consultationType': consultationType.value,
        'totalAmount': totalAmount.value,
        'paymentMethodType': selectedPaymentMethod.value,
        'paymentMethodTitle': selectedPaymentMethodTitle ?? selectedPaymentMethod.value,
      },
    );
  }

  void goBack() {
    Get.back();
  }

  void editBookingDetails() {
    // Navigate back to booking screen
    Get.back();
  }

  // ==================== COUPON METHODS (MVP) ====================
  
  /// MVP: Hardcoded valid coupons for demonstration
  final Map<String, double> _validCoupons = {
    'SAVE10': 10.0,   // 10% discount
    'SAVE20': 20.0,   // 20% discount
    'FIRST15': 15.0,  // 15% discount for first-time users
    'HEALTH25': 25.0, // 25% discount
  };

  /// Validate and apply coupon
  void applyCoupon() {
    final code = couponController.text.trim().toUpperCase();
    
    if (code.isEmpty) {
      couponError.value = 'Please enter a coupon code';
      return;
    }

    // Check if coupon is valid
    if (_validCoupons.containsKey(code)) {
      appliedCouponCode.value = code;
      discountPercentage.value = _validCoupons[code]!;
      isCouponApplied.value = true;
      couponError.value = '';
      
      // Recalculate fees with discount
      _calculateFees();
      
      Get.snackbar(
        'Coupon Applied!',
        'You saved ${discountPercentage.value.toInt()}% on your consultation',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      couponError.value = 'Invalid coupon code';
      Get.snackbar(
        'Invalid Coupon',
        'The coupon code you entered is not valid',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  /// Remove applied coupon
  void removeCoupon() {
    appliedCouponCode.value = '';
    discountPercentage.value = 0.0;
    isCouponApplied.value = false;
    couponError.value = '';
    couponController.clear();
    
    // Recalculate fees without discount
    _calculateFees();
    
    Get.snackbar(
      'Coupon Removed',
      'The discount has been removed from your booking',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Clear coupon error when user types
  void clearCouponError() {
    if (couponError.value.isNotEmpty) {
      couponError.value = '';
    }
  }
}
