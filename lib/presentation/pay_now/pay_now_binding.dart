import 'package:get/get.dart';
import 'pay_now_controller.dart';

class PayNowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayNowController>(
      () => PayNowController(),
    );
  }
}
