import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/di/client_module.dart';

import '../../data/api/request/update_profile_request.dart';
import '../../domain/entity/update_profile_entity.dart';
import '../../domain/usecase/update_profile_use_case.dart';

class FillQuestionnaireOrSkipController extends BaseController
    with ClientModule {
  FillQuestionnaireOrSkipController({
    required this.updateProfileUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final UpdateProfileUseCase updateProfileUseCase;

  // ==================== NAVIGATION METHODS ====================
  void navigateToQuestionnaire() {
    Get.toNamed(AppRoutes.questionnaire);
  }

  Future<void> skipAndBrowse() async {
    clearGeneralError();
    // Execute API call using BaseController
    final result = await executeApiCall<UpdateProfileEntity>(
      () async {
        final request = UpdateProfileRequest(
            lookingFor: SpecialistType.therapist.name, completed: 1);
        return await updateProfileUseCase.execute(request);
      },
      onSuccess: () {
        debugPrint("Update profile successful");
      },
      onError: (errorMessage) {
        debugPrint("Update profile failed: $errorMessage");
      },
    );

    // Handle successful result
    if (result != null) {
      debugPrint(
          "Update profile result received: ${result.user.patientInfo?.isCompleted.toString()}");
      if (result.user.patientInfo?.isCompleted == true) {
        _navigateToDashboard();
      }
    }
  }

  void _navigateToDashboard() {
    Get.offNamed(AppRoutes.navScreen);
  }

  void goBack() {
    Get.back();
  }
}
