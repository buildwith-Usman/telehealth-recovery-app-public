import '../../app/config/app_constant.dart';
import '../../app/config/app_routes.dart';
import '../../app/utils/flow_tracker.dart';
import '../../di/client_module.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class WaitingForApprovalController extends GetxController with ClientModule {

  final RxString screenOpenedFrom = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      screenOpenedFrom.value = args[Arguments.openedFrom]?.toString() ?? '';
    }
    
    // Debug information
    debugPrint("Waiting for approval screen opened from: ${screenOpenedFrom.value}");
    debugPrint("Flow description: ${FlowTracker.getFlowDescription(screenOpenedFrom.value)}");
    debugPrint("Is from specialist signup: ${FlowTracker.isFromSpecialistSignup(screenOpenedFrom.value)}");
  }

  void goToLogin() {
    Get.offAllNamed(AppRoutes.logIn);
  }

  void checkApplicationStatus() {
    // TODO: Implement check application status functionality
    // This could call an API to check the current approval status
    Get.snackbar(
      'Status Check',
      'Checking your application status...',
      snackPosition: SnackPosition.TOP,
    );
  }
}
