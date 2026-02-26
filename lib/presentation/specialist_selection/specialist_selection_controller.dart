import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/di/client_module.dart';
import 'package:recovery_consultation_app/domain/entity/update_profile_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/update_profile_use_case.dart';
import 'package:recovery_consultation_app/generated/locales.g.dart';

import '../../app/config/app_enum.dart';

class SpecialistSelectionController extends BaseController with ClientModule {
  SpecialistSelectionController({
    required this.updateProfileUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final UpdateProfileUseCase updateProfileUseCase;

  // ==================== OBSERVABLES ====================
  final _selectedType = Rx<SpecialistType?>(SpecialistType.therapist);

  // ==================== GETTERS ====================
  SpecialistType? get selectedType => _selectedType.value;
  bool get canProceed => _selectedType.value != null;

  // ==================== LIFECYCLE METHODS ====================
  @override
  Future<void> onInit() async {
    super.onInit();
    // Initialize with therapist as default selection
    _selectedType.value = SpecialistType.therapist;
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }

  // ==================== SELECTION METHODS ====================
  void selectSpecialistType(SpecialistType type) {
    _selectedType.value = type;
    _clearError(); // Clear any previous errors
  }

  // ==================== ERROR MANAGEMENT METHODS ====================
  void _clearError() {
    clearGeneralError();
  }

  void _setError(String message) {
    setGeneralError(message);
  }

  // ==================== NAVIGATION METHODS ====================
  Future<void> proceedToNext() async {
    if (!canProceed) {
      _setError(LocaleKeys.therapistSelectionScreen_errorSelectType.tr);
      return;
    }

    _clearError();

    // Execute API call using BaseController
    final result = await executeApiCall<UpdateProfileEntity>(
      () async {
        final request = UpdateProfileRequest(
          lookingFor: _selectedType.value!.name,
          completed: getCompletionStatus(),
        );
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
      debugPrint("Update profile result received: ${result.user.patientInfo?.isCompleted.toString()}");
      _navigateBasedOnSelection();
    }
  }

  int getCompletionStatus() {
    return _selectedType.value == SpecialistType.therapist ? 0 : 1;
  }

  /// Navigate to appropriate screen based on specialist selection
  void _navigateBasedOnSelection() {
    switch (_selectedType.value) {
      case SpecialistType.therapist:
        // Navigate to questionnaire for better matching with therapists
        Get.toNamed(AppRoutes.fillQuestionnaireOrSkip);
        break;
      case SpecialistType.psychiatrist:
        // Navigate directly to main navigation for psychiatrist
        Get.offNamed(AppRoutes.navScreen);
        break;
      case null:
        _setError(LocaleKeys.therapistSelectionScreen_errorSelectType.tr);
        break;
    }
  }


  void goBack() {
    Get.back();
  }
}
