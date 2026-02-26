import 'package:get/get.dart';
import 'pharmacy_orders_controller.dart';

/// Pharmacy Orders Binding
class PharmacyOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyOrdersController>(() => PharmacyOrdersController());
  }
}