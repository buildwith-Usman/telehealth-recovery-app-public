import 'package:get/get.dart';
import 'order_detail_controller.dart';

/// Order Detail Binding - Manages dependencies for Order Detail page
class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderDetailController>(
      () => OrderDetailController(),
    );
  }
}
