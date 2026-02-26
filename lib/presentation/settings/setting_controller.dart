import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import '../../app/config/app_enum.dart';

class SettingController extends BaseController {

  var screenType = ScreenName.setting;

  RxBool reminderEnabled = true.obs;

    // Get role manager instance
  RoleManager get roleManager => RoleManager.instance;

  void clearStorageAndNavigateToOnboardingScreen() {
    logger.userAction('User logged out and navigated to onboarding screen');
  }

  void goToPaymentHistoryScreen() {
    logger.userAction('Navigating to Payment History screen from Settings');
    Get.toNamed(AppRoutes.paymentHistory);
  }

  void goToMyOrders() {
    logger.userAction('Navigating to My Orders screen from Settings');
    Get.toNamed(AppRoutes.pharmacyOrders);
  }

}
