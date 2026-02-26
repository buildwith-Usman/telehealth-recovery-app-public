import 'package:recovery_consultation_app/app/config/app_config.dart';
import 'package:recovery_consultation_app/data/api/request/login_request.dart';
import 'package:recovery_consultation_app/domain/usecase/login_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/login_with_google_usecase.dart';
import 'package:recovery_consultation_app/domain/entity/login_entity.dart';
import 'package:recovery_consultation_app/app/services/token_recovery_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../app/config/app_enum.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../app/services/app_storage.dart';
import '../../app/services/role_manager.dart';
import '../../app/utils/input_validator.dart';
import '../../di/client_module.dart';

class LoginController extends BaseController with ClientModule {
  LoginController({
    required this.loginUseCase,
    required this.loginWithGoogleUseCase,
    required this.tokenRecoveryService,
  });

  // ==================== DEPENDENCIES ====================
  final LoginUseCase loginUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final TokenRecoveryService tokenRecoveryService;

  // ==================== CONTROLLERS & OBSERVABLES ====================
  final TextEditingController emailTextEditingController =
      TextEditingController();

  final TextEditingController passwordTextEditingController =
      TextEditingController();

  var emailError = RxnString(); // Observable for email error message
  var passwordError = RxnString(); // Observable for password error message

  // State observables for UI reactions
  var loginSuccess = false.obs;
  var loginErrorMessage = RxnString();
  var userRole = Rxn<UserRole>();

  // ==================== GETTERS ====================
  String get email => emailTextEditingController.text;

  String get password => passwordTextEditingController.text;

  // ==================== LIFECYCLE METHODS ====================
  @override
  Future<void> onInit() async {
    super.onInit();
    emailTextEditingController.text = '';
    passwordTextEditingController.text = '';
  }

  @override
  void onClose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  // ==================== VALIDATION METHODS ====================
  bool validateLoginForm([BuildContext? context]) {
    // Clear previous validation errors
    emailError.value = null;
    passwordError.value = null;

    bool isValid = true;

    // Get current field values
    final emailValue = emailTextEditingController.text.trim();
    final passwordValue = passwordTextEditingController.text.trim();

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

    return isValid;
  }

  // ==================== ERROR MANAGEMENT METHODS ====================
  void clearEmailError() {
    emailError.value = null;
  }

  void clearPasswordError() {
    passwordError.value = null;
  }

  void clearAllErrors() {
    emailError.value = null;
    passwordError.value = null;
    loginErrorMessage.value = null;
  }

  void clearLoginError() {
    loginErrorMessage.value = null;
    loginSuccess.value = false;
  }

  // ==================== AUTHENTICATION METHODS ====================
  Future<void> login() async {
    debugPrint("Starting login...");
    debugPrint("Email: $email");

    clearGeneralError();
    clearAllErrors();

    // Validate inputs
    if (!validateLoginForm()) {
      return;
    }

    // Execute API call using BaseController
    final result = await executeApiCall<LoginEntity>(
      () async {
        final request = LoginRequest(
          email: email,
          password: password,
        );
        return await loginUseCase.execute(request);
      },
      onSuccess: () {
        loginSuccess.value = true;
        debugPrint("Login successful");
      },
      onError: (errorMessage) {
        debugPrint("Login failed: $errorMessage");
      },
    );

    // Handle successful result
    if (result != null) {
      debugPrint("Login result received: ${result.user.email}");

      // Save access token using recovery service (non-blocking)
      if (result.accessToken.isNotEmpty) {
        tokenRecoveryService
            .saveTokenSafely(result.accessToken)
            .then((success) {
          if (success) {
            debugPrint("✅ Access token saved successfully");
          } else {
            debugPrint(
                "⚠️ Access token stored for recovery - will retry on next app launch");
          }
        });
      }

      // Determine and save user role
      final userRoleResult = _mapTypeToUserRole(result.user.type);
      if (userRoleResult != null) {
        await AppStorage.instance.setUserRole(userRoleResult);
        await RoleManager.instance.setRole(userRoleResult);
        userRole.value = userRoleResult;

        debugPrint("User role set: $userRoleResult");

           // Setup app config with baseUrl and userId
        await AppStorage.instance.setupAppConfig(
          baseUrl: AppConfig.shared.baseUrl,
          userId: result.user.id,
        );
        logger.controller("✅ App config setup completed with userId: ${result.user.id}");

        // Navigate to dashboard
        goToDashboardScreen();
      } else {
        setGeneralError('Unknown user role: ${result.user.type}');
      }
    }
  }

  Future<void> loginWithGoogle() async {
    debugPrint("Starting Google login...");

    clearGeneralError();
    clearAllErrors();

    // Execute API call using BaseController
    final result = await executeApiCall<LoginEntity>(
      () async {
        return await loginWithGoogleUseCase.execute();
      },
      onSuccess: () {
        loginSuccess.value = true;
        debugPrint("Google login successful");
      },
      onError: (errorMessage) {
        debugPrint("Google login failed: $errorMessage");
        loginErrorMessage.value = errorMessage;
      },
    );

    // Handle successful result
    if (result != null) {
      debugPrint("Google login result received: ${result.user.email}");

      // Save access token using recovery service (non-blocking)
      if (result.accessToken.isNotEmpty) {
        tokenRecoveryService
            .saveTokenSafely(result.accessToken)
            .then((success) {
          if (success) {
            debugPrint("✅ Access token saved successfully");
          } else {
            debugPrint(
                "⚠️ Access token stored for recovery - will retry on next app launch");
          }
        });
      }

      // Determine and save user role
      final userRoleResult = _mapTypeToUserRole(result.user.type);
      if (userRoleResult != null) {
        await AppStorage.instance.setUserRole(userRoleResult);
        await RoleManager.instance.setRole(userRoleResult);
        userRole.value = userRoleResult;

        debugPrint("User role set: $userRoleResult");

        // Navigate to dashboard
        goToDashboardScreen();
      } else {
        setGeneralError('Unknown user role: ${result.user.type}');
      }
    }
  }

  // ==================== UTILITY METHODS ====================
  Future<void> reset() async {
    emailTextEditingController.clear();
    passwordTextEditingController.clear();
    clearAllErrors(); // Clear validation errors when resetting
  }

  // ==================== NAVIGATION METHODS ====================
  void goToSignUpScreen({UserRole? userRole}) {
    // Pass user role parameter to SignUp screen
    // If no role specified, default to patient signup
    Get.toNamed(
      AppRoutes.signup,
      arguments: {
        'userRole': userRole ?? UserRole.patient,
      },
    );
  }

  void goToSpecialistSignup() {
    Get.toNamed(AppRoutes.specialistSignup);
  }

  void goToDashboardScreen() {
    Get.offAllNamed(AppRoutes.navScreen);
  }

  void goToForgetPasswordScreen() {
    Get.toNamed(AppRoutes.forgetPassword);
  }

  // ==================== HELPER METHODS ====================
  // Helper method to map API type to UserRole
  UserRole? _mapTypeToUserRole(String? type) {
    if (type == null || type.isEmpty) {
      debugPrint("User type is null or empty");
      return null;
    }

    final normalizedType = type.toLowerCase().trim();

    const roleMap = {
      'admin': UserRole.admin,
      'receptionist': UserRole.admin,
      'doctor': UserRole.doctor,
      'specialist': UserRole.doctor,
      'patient': UserRole.patient,
    };

    final role = roleMap[normalizedType];
    if (role == null) debugPrint("Unknown user type: $type");

    return role;
  }
}
