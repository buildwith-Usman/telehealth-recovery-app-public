import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/domain/models/payment_session_history.dart';

class PaymentHistoryController extends BaseController {
  final RxList<PaymentSessionHistoryData> _paymentHistory =
      <PaymentSessionHistoryData>[].obs;
  final RxBool _isLoading = false.obs;
  final RxDouble _totalSpent = 0.0.obs;

  // Getters
  List<PaymentSessionHistoryData> get paymentHistory =>
      _paymentHistory.toList();
  double get totalSpent => _totalSpent.value;

  @override
  void onInit() {
    super.onInit();
    _loadPaymentData();
  }

  void _loadPaymentData() {
    _isLoading.value = true;

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _paymentHistory.value = _generateSamplePaymentData();
      _isLoading.value = false;
    });
  }


  void onPaymentTap(PaymentSessionHistoryData payment) {
    if (kDebugMode) {
      print('Tapped on payment: ${payment.id}');
    }
    // Navigate to payment detail page
  }

  List<PaymentSessionHistoryData> _generateSamplePaymentData() {
    return [
      PaymentSessionHistoryData(
        id: '1',
        therapistName: 'Dr. Ahmad Tahir',
        sessionDate: DateTime(2025, 6, 2),
        patientName: 'Ahmed Ayyaz',
        sessionDuration: '10:00 - 10:30 PM',
        amount: 3000,
        status: 'completed',
      ),
      PaymentSessionHistoryData(
        id: '2',
        therapistName: 'Dr. Sarah Johnson',
        sessionDate: DateTime(2025, 5, 15),
        sessionDuration: '02:00 - 03:00 PM',
        amount: 2500,
        patientName: 'Farhan Khan',
        status: 'completed',
      ),
      PaymentSessionHistoryData(
        id: '3',
        therapistName: 'Dr. Emily Chen',
        sessionDate: DateTime(2025, 4, 20),
        sessionDuration: '04:30 - 05:15 PM',
        amount: 3500,
        patientName: 'Hamza Khalid',
        status: 'completed',
      ),
      PaymentSessionHistoryData(
        id: '4',
        therapistName: 'Dr. Michael Roberts',
        sessionDate: DateTime(2025, 3, 8),
        sessionDuration: '11:00 - 11:45 AM',
        amount: 2800,
        patientName: 'Ghulam Mustafa',
        status: 'completed',
      ),
    ];
  }

  void viewPaymentDetails(String paymentId) {
    // Navigate to payment details
  }

  void downloadInvoice(String paymentId) {
    // Download invoice logic
  }

  void processPayment(double amount) {
    // Process payment logic
  }

  void setupPaymentMethod() {
    // Navigate to payment method setup
  }
}
