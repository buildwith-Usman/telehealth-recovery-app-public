import 'package:get/get.dart';
import 'admin_global_session_discount_controller.dart';

class AdminGlobalSessionDiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminGlobalSessionDiscountController());
  }
}
