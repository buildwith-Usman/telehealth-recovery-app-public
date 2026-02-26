import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/app/utils/input_validator.dart';
import 'package:recovery_consultation_app/data/api/request/sign_up_request.dart';
import 'package:recovery_consultation_app/domain/entity/sign_up_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/sign_up_use_case.dart';

import 'package:flutter/cupertino.dart';

import '../../app/config/app_routes.dart';
import '../../di/client_module.dart';
import 'package:get/get.dart';

class SignupController extends BaseController with ClientModule {
  SignupController({
    required this.signUpUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final SignUpUseCase signUpUseCase;

  // ==================== CONTROLLERS & OBSERVABLES ====================
  final TextEditingController nameTextEditingController =
      TextEditingController();

  final TextEditingController emailTextEditingController =
      TextEditingController();

  final TextEditingController mobileTextEditingController =
      TextEditingController();

  final TextEditingController passwordTextEditingController =
      TextEditingController();

  final TextEditingController confirmPasswordTextEditingController =
      TextEditingController();

  // Observable error states for reactive UI
  var nameError = RxnString();
  var emailError = RxnString();
  var mobileError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();

  // State observables for UI reactions
  var signupSuccess = false.obs;

  // ==================== GETTERS ====================
  String get name => nameTextEditingController.text;
  String get email => emailTextEditingController.text;
  String get mobile => mobileTextEditingController.text;
  String get password => passwordTextEditingController.text;
  String get confirmPassword => confirmPasswordTextEditingController.text;

  var screenType = ScreenName.signUp;

  // ==================== LIFECYCLE METHODS ====================
  @override
  Future<void> onInit() async {
    super.onInit();
    nameTextEditingController.text = '';
    emailTextEditingController.text = '';
    mobileTextEditingController.text = '';
    passwordTextEditingController.text = '';
    confirmPasswordTextEditingController.text = '';
  }

  @override
  void onClose() {
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    mobileTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    super.dispose();
  }

  // ==================== VALIDATION METHODS ====================
  bool validateSignUpForm([BuildContext? context]) {
    // Clear previous validation errors
    clearAllErrors();

    bool isValid = true;

    // Get current field values
    final nameValue = nameTextEditingController.text.trim();
    final emailValue = emailTextEditingController.text.trim();
    final mobileValue = mobileTextEditingController.text.trim();
    final passwordValue = passwordTextEditingController.text.trim();
    final confirmPasswordValue =
        confirmPasswordTextEditingController.text.trim();

    // Validate name field
    if (nameValue.isEmpty) {
      nameError.value = "Full name is required";
      isValid = false;
    } else {
      final nameValidation = InputValidator.validateName(nameValue);
      if (nameValidation != null) {
        nameError.value = nameValidation;
        isValid = false;
      }
    }

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

    // Validate mobile field
    if (mobileValue.isEmpty) {
      mobileError.value = "Phone number is required";
      isValid = false;
    } else {
      final mobileValidation = InputValidator.validatePhone(mobileValue);
      if (mobileValidation != null) {
        mobileError.value = mobileValidation;
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
  void clearNameError() {
    nameError.value = null;
  }

  void clearEmailError() {
    emailError.value = null;
  }

  void clearMobileError() {
    mobileError.value = null;
  }

  void clearPasswordError() {
    passwordError.value = null;
  }

  void clearConfirmPasswordError() {
    confirmPasswordError.value = null;
  }

  void clearAllErrors() {
    nameError.value = null;
    emailError.value = null;
    mobileError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    clearGeneralError();
  }

  // ==================== AUTHENTICATION METHODS ====================
  Future<void> signUp() async {
    // Validate form first
    if (!validateSignUpForm()) {
      return; // Stop if validation fails - errors are shown in UI
    }

    // Execute API call with simplified error handling
    final result = await executeApiCall<SignUpEntity>(
      () async {
        final params = SignUpRequest(
          name: name,
          email: email,
          phone: mobile,
          password: password,
          passwordConfirmation: confirmPassword,
          type: UserRole.patient.name,
        );
        return await signUpUseCase.execute(params);
      },
      onSuccess: () {
        signupSuccess.value = true;
        debugPrint("SignUp success");
      },
      onError: (errorMessage) {
        debugPrint("Signup error: $errorMessage");
      },
    );

    // Handle successful result
    if (result != null) {
      debugPrint("SignUp success: ${result.verificationRequired}");
      goToOtpScreen(result.user.email);
    }
  }

  // ==================== UTILITY METHODS ====================
  Future<void> reset() async {
    nameTextEditingController.clear();
    emailTextEditingController.clear();
    mobileTextEditingController.clear();
    passwordTextEditingController.clear();
    confirmPasswordTextEditingController.clear();
    clearAllErrors(); // Clear validation errors when resetting
  }

  // ==================== NAVIGATION METHODS ====================
  void goToOtpScreen(String email) {
    Get.toNamed(AppRoutes.otp, arguments: {
      Arguments.openedFrom: screenType,
      Arguments.email: email, // Pass email to OTP screen
    });
  }

  void goToPreviousScreen() {
    Get.back();
  }
}
