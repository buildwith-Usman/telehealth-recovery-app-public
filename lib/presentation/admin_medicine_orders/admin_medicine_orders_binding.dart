import 'package:get/get.dart';
import 'admin_medicine_orders_controller.dart';

class AdminMedicineOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminMedicineOrdersController());
  }
}
