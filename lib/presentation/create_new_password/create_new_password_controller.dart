import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../app/config/app_constant.dart';
import '../../app/config/app_enum.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../app/utils/input_validator.dart';
import '../../data/api/request/reset_password_request.dart';
import '../../di/client_module.dart';
import '../../domain/usecase/reset_password_use_case.dart';

class CreateNewPasswordController extends BaseController with ClientModule {
  CreateNewPasswordController({
    required this.resetPasswordUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final ResetPasswordUseCase resetPasswordUseCase;

  // ==================== CONTROLLERS & OBSERVABLES ====================
  final TextEditingController passwordTextEditingController =
      TextEditingController();

  final TextEditingController confirmPasswordTextEditingController =
      TextEditingController();

  var passwordError = RxnString(); // Observable for password error message
  var confirmPasswordError =
      RxnString(); // Observable for confirm password error message

  // State observables for UI reactions
  var resetPasswordSuccess = false.obs;

  // Password visibility observables
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // Screen context observables
  late final String userEmail;
  late final String resetCode;
  final RxString screenOpenedFrom = ''.obs;
  var screenType = ScreenName.password;

  // ==================== GETTERS ====================
  String get password => passwordTextEditingController.text;
  String get confirmPassword => confirmPasswordTextEditingController.text;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() async {
    super.onInit();
    _initializeScreen();
  }

  @override
  void onClose() {
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  // ==================== INITIALIZATION METHODS ====================
  void _initializeScreen() {
    final args = Get.arguments as Map<String, dynamic>;
    
    screenOpenedFrom.value = args[Arguments.openedFrom].toString();
    
    // This controller now only handles reset password flow
    userEmail = args[Arguments.email];
    resetCode = args[Arguments.resetCode];
  }

  // ==================== VALIDATION METHODS ====================
  bool validatePasswordForm([BuildContext? context]) {
    // Clear previous validation errors
    passwordError.value = null;
    confirmPasswordError.value = null;

    bool isValid = true;

    // Get current field values
    final passwordValue = passwordTextEditingController.text.trim();
    final confirmPasswordValue =
        confirmPasswordTextEditingController.text.trim();

    // Validate password field
    if (passwordValue.isEmpty) {
      passwordError.value = "Password is required";
      isValid = false;
    } else {
      final passwordValidation = InputValidator.validatePassword(passwordValue);
      if (passwordValidation != null) {
        passwordError.value = passwordValidation;
        isValid = false;
      }
    }

    // Validate confirm password field
    if (confirmPasswordValue.isEmpty) {
      confirmPasswordError.value = "Confirm password is required";
      isValid = false;
    } else if (passwordValue != confirmPasswordValue) {
      confirmPasswordError.value = "Passwords do not match";
      isValid = false;
    }

    return isValid;
  }

  // ==================== ERROR MANAGEMENT METHODS ====================
  void clearPasswordError() {
    passwordError.value = null;
  }

  void clearConfirmPasswordError() {
    confirmPasswordError.value = null;
  }

  void clearAllErrors() {
    passwordError.value = null;
    confirmPasswordError.value = null;
    clearGeneralError(); // Use BaseController's error clearing
  }

  void clearResetPasswordError() {
    clearGeneralError(); // Use BaseController's error clearing
    resetPasswordSuccess.value = false;
  }

  // ==================== PASSWORD FIELD METHODS ====================
  void onPasswordChanged(String value) {
    clearPasswordError();
  }

  void onConfirmPasswordChanged(String value) {
    clearConfirmPasswordError();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // ==================== AUTHENTICATION METHODS ====================
  Future<void> resetPassword() async {
    // Validate form first
    if (!validatePasswordForm()) {
      return; // Stop if validation fails - errors are shown in UI
    }

    // Reset password flow
    await _handleResetPassword();
  }

  Future<void> _handleResetPassword() async {
    final request = ResetPasswordRequest(
      email: userEmail,
      resetCode: resetCode,
      password: password,
    );
    
    await executeApiCall(
      () async => await resetPasswordUseCase.execute(request),
      onSuccess: () {
        resetPasswordSuccess.value = true;
        goToSuccessScreen();
      },
      onError: (message) {
        if (kDebugMode) {
          print('Reset password error: $message');
        }
      },
    );
  }

  // ==================== UTILITY METHODS ====================
  Future<void> reset() async {
    passwordTextEditingController.clear();
    confirmPasswordTextEditingController.clear();
    clearAllErrors();
  }

  // ==================== NAVIGATION METHODS ====================
  void goToSuccessScreen() {
    Get.toNamed(AppRoutes.successPage, arguments: {
      Arguments.openedFrom: screenOpenedFrom.value,
    });
  }

  void goToPreviousScreen() {
    Get.back();
  }

  // ==================== HELPER METHODS ====================
  // Helper method to get appropriate screen title
  String get screenTitle => "New Password";
}
