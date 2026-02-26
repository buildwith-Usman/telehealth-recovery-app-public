import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../app/config/app_routes.dart';

class PayNowController extends GetxController {
  // ==================== OBSERVABLES ====================
  var isLoading = false.obs;
  var isProcessingPayment = false.obs;
  var paymentStatus = PaymentStatus.processing.obs;
  
  // Payment details
  var specialistName = ''.obs;
  var specialistProfession = ''.obs;
  var specialistImageUrl = ''.obs;
  var consultationDate = ''.obs;
  var consultationTime = ''.obs;
  var consultationType = ''.obs;
  var totalAmount = 0.0.obs;
  var paymentMethod = ''.obs;
  var transactionId = ''.obs;
  
  // Progress tracking
  var currentStep = 0.obs;
  var paymentSteps = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadPaymentData();
    _initializePaymentSteps();
    _startPaymentProcess();
  }

  // ==================== METHODS ====================
  void _loadPaymentData() {
    // Get payment data from arguments (passed from payment summary screen)
    final arguments = Get.arguments as Map<String, dynamic>?;
    
    if (arguments != null) {
      specialistName.value = arguments['specialistName'] ?? 'Dr. Sarah Johnson';
      specialistProfession.value = arguments['specialistProfession'] ?? 'Clinical Psychologist';
      specialistImageUrl.value = arguments['specialistImageUrl'] ?? '';
      consultationDate.value = arguments['consultationDate'] ?? 'March 25, 2024';
      consultationTime.value = arguments['consultationTime'] ?? '10:00 AM';
      consultationType.value = arguments['consultationType'] ?? 'Video Consultation';
      totalAmount.value = arguments['totalAmount'] ?? 120.0;
      paymentMethod.value = arguments['paymentMethodTitle'] ?? arguments['paymentMethodType'] ?? 'Credit Card';
    } else {
      // Default data for testing
      _setDefaultData();
    }
  }

  void _setDefaultData() {
    specialistName.value = 'Dr. Sarah Johnson';
    specialistProfession.value = 'Clinical Psychologist';
    specialistImageUrl.value = '';
    consultationDate.value = 'March 25, 2024';
    consultationTime.value = '10:00 AM';
    consultationType.value = 'Video Consultation';
    totalAmount.value = 120.0;
    paymentMethod.value = 'Credit Card';
  }

  void _initializePaymentSteps() {
    paymentSteps.assignAll([
      'Initiating Payment',
      'Verifying Payment Method',
      'Processing Transaction',
      'Confirming Payment',
      'Booking Confirmation',
    ]);
  }

  void _startPaymentProcess() async {
    isProcessingPayment.value = true;
    paymentStatus.value = PaymentStatus.processing;
    
    try {
      // Simulate payment processing steps
      for (int i = 0; i < paymentSteps.length; i++) {
        currentStep.value = i;
        
        if (kDebugMode) {
          print('Payment Step ${i + 1}: ${paymentSteps[i]}');
        }
        
        // Simulate processing time for each step
        await Future.delayed(Duration(milliseconds: 800 + (i * 200)));
        
        // Check if payment was cancelled
        if (paymentStatus.value == PaymentStatus.cancelled) {
          return;
        }
      }
      
      // Generate transaction ID
      transactionId.value = 'TXN${DateTime.now().millisecondsSinceEpoch}';
      
      // Payment successful
      paymentStatus.value = PaymentStatus.success;
      
      if (kDebugMode) {
        print('Payment successful! Transaction ID: ${transactionId.value}');
      }
      
      // Auto-navigate to success screen after a short delay
      await Future.delayed(const Duration(milliseconds: 1500));
      _navigateToSuccess();
      
    } catch (e) {
      // Payment failed
      paymentStatus.value = PaymentStatus.failed;
      
      if (kDebugMode) {
        print('Payment failed: $e');
      }
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void cancelPayment() {
    if (paymentStatus.value == PaymentStatus.processing) {
      paymentStatus.value = PaymentStatus.cancelled;
      
      if (kDebugMode) {
        print('Payment cancelled by user');
      }
      
      Get.snackbar(
        'Payment Cancelled',
        'Your payment has been cancelled',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      // Go back to payment summary
      Get.back();
    }
  }

  void retryPayment() {
    if (paymentStatus.value == PaymentStatus.failed) {
      currentStep.value = 0;
      _startPaymentProcess();
    }
  }

  void _navigateToSuccess() {
    // Navigate to success screen with booking details
    Get.offAllNamed(AppRoutes.navScreen, arguments: {
      'showSuccessMessage': true,
      'transactionId': transactionId.value,
      'specialistName': specialistName.value,
      'consultationDate': consultationDate.value,
      'consultationTime': consultationTime.value,
      'totalAmount': totalAmount.value,
    });
  }

  void goBackToSummary() {
    Get.back();
  }

  String getFormattedAmount() {
    return '\$${totalAmount.value.toStringAsFixed(2)}';
  }

  String getCurrentStepText() {
    if (currentStep.value < paymentSteps.length) {
      return paymentSteps[currentStep.value];
    }
    return 'Completed';
  }

  double getProgressPercentage() {
    if (paymentSteps.isEmpty) return 0.0;
    return (currentStep.value + 1) / paymentSteps.length;
  }
}

enum PaymentStatus {
  processing,
  success,
  failed,
  cancelled,
}
