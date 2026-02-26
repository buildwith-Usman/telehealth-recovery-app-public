import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';

enum DiscountApplyOn { session, pharmacy }
enum DiscountStatus { active, inactive, scheduled }

class AdminGlobalSessionDiscountController extends BaseController {
  final formKey = GlobalKey<FormState>();

  // Controllers
  final discountTitleController = TextEditingController();
  final discountValueController = TextEditingController();

  // State
  final discountApplyOn = DiscountApplyOn.session.obs;
  final discountTypes = ['Percentage', 'Fixed'];
  final selectedDiscountType = 'Percentage'.obs;
  final fromDate = Rx<DateTime?>(null);
  final toDate = Rx<DateTime?>(null);
  final status = DiscountStatus.scheduled.obs;

  @override
  void onClose() {
    discountTitleController.dispose();
    discountValueController.dispose();
    super.onClose();
  }

  // Methods to update state
  void setDiscountApplyOn(DiscountApplyOn value) {
    discountApplyOn.value = value;
  }

  void setDiscountType(String value) {
    selectedDiscountType.value = value;
  }

  void setFromDate(DateTime date) {
    fromDate.value = date;
  }

  void setToDate(DateTime date) {
    toDate.value = date;
  }

  void setStatus(DiscountStatus newStatus) {
    status.value = newStatus;
  }

  Future<void> saveDiscount() async {
    if (formKey.currentState!.validate()) {
      // Implement save logic
    }
  }
}
