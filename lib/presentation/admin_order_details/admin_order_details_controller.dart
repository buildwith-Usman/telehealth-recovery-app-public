import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/presentation/admin_medicine_orders/admin_medicine_orders_controller.dart';

class AdminOrderDetailsController extends BaseController {
  final order = Rx<MedicineOrder?>(null);

  final List<String> availableStatuses = [
    'Pending',
    'Confirmed',
    'Dispatched',
    'Delivered',
    'Cancelled',
  ];

  final selectedStatus = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    order.value = Get.arguments as MedicineOrder?;
    if (order.value != null) {
      // Initialize with current order status, mapping from the enum
      selectedStatus.value = _mapOrderStatusToString(order.value!.status);
    }
  }

  void updateStatus(String? newStatus) {
    if (newStatus != null) {
      selectedStatus.value = newStatus;
    }
  }

  // Helper to convert enum status to a display string
  String _mapOrderStatusToString(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.dispatched:
        return 'Dispatched';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Future<void> saveNewStatus() async {
    // Implement logic to save the new status
    Get.snackbar('Success', 'Order status updated to ${selectedStatus.value}');
  }
}
