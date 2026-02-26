import 'package:recovery_consultation_app/presentation/success_screen/success_controller.dart';
import 'package:get/get.dart';

class SuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SuccessController());
  }
}
