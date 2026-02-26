import 'package:get/get.dart';
import 'admin_order_details_controller.dart';

class AdminOrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminOrderDetailsController());
  }
}
