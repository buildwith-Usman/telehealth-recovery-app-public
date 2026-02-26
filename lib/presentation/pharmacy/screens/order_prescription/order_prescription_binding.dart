import 'package:get/get.dart';
import 'order_prescription_controller.dart';

/// Order Prescription Binding - Manages dependencies for Order Prescription page
class OrderPrescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderPrescriptionController>(
      () => OrderPrescriptionController(),
    );
  }
}
