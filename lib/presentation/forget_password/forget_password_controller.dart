import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../app/config/app_config.dart';
import '../../app/config/app_constant.dart';
import '../../app/config/app_enum.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../app/utils/input_validator.dart';
import '../../app/utils/util.dart';
import '../../data/api/request/forgot_password_request.dart';
import '../../di/client_module.dart';
import '../../domain/entity/forgot_password_entity.dart';
import '../../domain/usecase/forgot_password_use_case.dart';

class ForgetPasswordController extends BaseController with ClientModule {
  ForgetPasswordController({
    required this.forgotPasswordUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final ForgotPasswordUseCase forgotPasswordUseCase;

  // ==================== CONTROLLERS & OBSERVABLES ====================
  final TextEditingController emailTextEditingController =
      TextEditingController();

  var emailError = RxnString(); // Observable for email error message

  // State observables for UI reactions
  var forgotPasswordSuccess = false.obs;

  // Screen context observables
  final Rx<ScreenName> screenSource = ScreenName.login.obs;

  // ==================== GETTERS ====================
  String get email => emailTextEditingController.text;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() async {
    super.onInit();
    _initializeScreen();
  }

  @override
  void onClose() {
    emailTextEditingController.dispose();
    super.dispose();
  }

  // ==================== INITIALIZATION METHODS ====================
  void _initializeScreen() {
    // Handle null arguments case (when coming from login screen)
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args.containsKey(Arguments.openedFrom)) {
      screenSource.value = args[Arguments.openedFrom];
    } else {
      // Default to login screen when no arguments provided
      screenSource.value = ScreenName.login;
    }

    // Pre-fill email if coming from settings screen
    if (screenSource.value == ScreenName.setting) {
      emailTextEditingController.text =
          AppConfig.shared.userEmail?.toString() ?? '';
    } else {
      emailTextEditingController.text = '';
    }
  }

  // ==================== VALIDATION METHODS ====================
  bool validateEmailForm([BuildContext? context]) {
    // Clear previous validation errors
    emailError.value = null;

    bool isValid = true;

    // Get current field value
    final emailValue = emailTextEditingController.text.trim();

    // Validate email field
    if (emailValue.isEmpty) {
      emailError.value = "Email is required";
      isValid = false;
    } else {
      final emailValidation = InputValidator.validateEmail(emailValue);
      if (emailValidation != null) {
        emailError.value = emailValidation;
        isValid = false;
      }
    }

    // Show toast error if context provided and validation failed
    if (!isValid && context != null && emailError.value != null) {
      Util.showErrorToast(message: emailError.value!, context: context);
    }

    return isValid;
  }

  // ==================== ERROR MANAGEMENT METHODS ====================
  void clearEmailError() {
    emailError.value = null;
  }

  void clearAllErrors() {
    emailError.value = null;
  }

  // ==================== EMAIL FIELD METHODS ====================
  void onEmailChanged(String value) {
    clearEmailError();
  }

  // ==================== AUTHENTICATION METHODS ====================
  Future<void> forgotPassword() async {
    debugPrint("Starting forgot password request...");
    debugPrint("Email: $email");

    clearGeneralError();
    clearAllErrors();

    // Validate form first
    if (!validateEmailForm()) {
      return;
    }

    // Execute API call using BaseController
    final result = await executeApiCall<ForgotPasswordEntity>(
      () async {
        final request = ForgotPasswordRequest(email: email);
        return await forgotPasswordUseCase.execute(request);
      },
      onSuccess: () {
        forgotPasswordSuccess.value = true;
        debugPrint("Forgot password request successful");
      },
      onError: (errorMessage) {
        debugPrint("Forgot password request failed: $errorMessage");
      },
    );

    // Handle successful result
    if (result != null) {
      debugPrint("Forgot password result: ${result.message}");
      
      // Show success message and navigate to OTP screen
      if (kDebugMode) {
        print("Success: ${result.message}");
      }
      
      // Navigate to OTP screen
      goToOtpScreen();
    }
  }

  // ==================== UTILITY METHODS ====================
  Future<void> reset() async {
    emailTextEditingController.clear();
    clearAllErrors();
  }

  // ==================== NAVIGATION METHODS ====================
  void goToOtpScreen() {
    Get.toNamed(AppRoutes.otp, arguments: {
      Arguments.email: email,
      Arguments.openedFrom: ScreenName.forgotPassword, // Always pass forgotPassword as the source
    });
  }

  void goToPreviousScreen() {
    Get.back();
  }

  // ==================== HELPER METHODS ====================
  // Helper method to determine if email is from settings screen
  bool get isFromSettingsScreen => screenSource.value == ScreenName.setting;

  // Helper method to get appropriate screen title
  String get screenTitle =>
      isFromSettingsScreen ? "Change Password" : "Forgot Password";
}
