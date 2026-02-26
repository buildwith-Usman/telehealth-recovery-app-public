import 'package:get/get.dart';
import 'order_tracking_controller.dart';

/// Order Tracking Binding - Dependency injection for order tracking screen
class OrderTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderTrackingController>(
      () => OrderTrackingController(),
    );
  }
}
