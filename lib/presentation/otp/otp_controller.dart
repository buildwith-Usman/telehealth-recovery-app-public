import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../app/config/app_constant.dart';
import '../../app/config/app_enum.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../app/utils/flow_tracker.dart';
import '../../data/api/request/otp_verification_request.dart';
import '../../data/api/request/resend_otp_request.dart';
import '../../di/client_module.dart';
import '../../domain/entity/otp_verification_entity.dart';
import '../../domain/entity/resend_otp_entity.dart';
import '../../domain/usecase/otp_verification_use_case.dart';
import '../../domain/usecase/resend_otp_use_case.dart';
import '../../domain/usecase/set_access_token_use_case.dart';
import '../../app/services/token_recovery_service.dart';

class OtpController extends BaseController with ClientModule {
  OtpController({
    required this.otpVerificationUseCase,
    required this.resendOtpUseCase,
    required this.setAccessTokenUseCase,
    required this.tokenRecoveryService,
  });

  // ========================================
  // DEPENDENCIES
  // ========================================
  final OtpVerificationUseCase otpVerificationUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final SetAccessTokenUseCase setAccessTokenUseCase;
  final TokenRecoveryService tokenRecoveryService;

  // ========================================
  // UI CONTROLLERS
  // ========================================
  final TextEditingController verificationCodeController =
      TextEditingController();

  // ========================================
  // STATE PROPERTIES
  // ========================================
  String userEmail = '';
  final Rx<ScreenName> sourceScreen = ScreenName.signUp.obs;
  var otpVerificationSuccess = false.obs;
  var resendOtpSuccess = false.obs;

  // ========================================
  // GETTERS
  // ========================================
  String get verificationCode => verificationCodeController.text;

  // ========================================
  // LIFECYCLE METHODS
  // ========================================
  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }

  @override
  void dispose() {
    verificationCodeController.dispose();
    super.dispose();
  }

  // ========================================
  // INITIALIZATION METHODS
  // ========================================
  void _initializeFromArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      sourceScreen.value = args[Arguments.openedFrom] ?? ScreenName.signUp;
      userEmail = args[Arguments.email] ?? '';

      // Log specialist flow information
      final isSpecialistFlow = args[Arguments.isSpecialistFlow] ?? false;
      final returnToStep = args[Arguments.returnToStep];
      final formData = args[Arguments.specialistFormData];

      logger.controller("OTP initialized' Params from arguments params: {sourceScreen - ${sourceScreen.value} === userEmail - $userEmail === isSpecialistFlow - $isSpecialistFlow === returnToStep - $returnToStep === formData - $formData}");
    }
  }

  // ========================================
  // API METHODS
  // ========================================
  Future<void> otpVerification() async {
    logger.method('otpVerification');
    logger.userAction('Starting OTP verification', params: {
      'verificationCode': verificationCode,
      'userEmail': userEmail
    });

    clearGeneralError();

    // Validate inputs
    if (!_validateOtpInput()) return;

    // Execute API call
    final result = await executeApiCall<OtpVerificationEntity>(
      () async {
        final request = OPTVerificationRequest(
          type: _getVerificationType().name,
          email: userEmail,
          verificationCode: verificationCode,
        );
        return await otpVerificationUseCase.execute(request);
      },
      onSuccess: () async {
        otpVerificationSuccess.value = true;
        logger.controller("OTP verification successful");
      },
      onError: (errorMessage) {
        logger.error("OTP verification failed", error: errorMessage);
      },
    );

    // Handle successful result
    if (result != null) {
      logger.controller("User verified successfully, params: 'isVerified': ${result.isVerified}");

      // Save access token using recovery service (non-blocking)
      if (result.accessToken.isNotEmpty) {
        tokenRecoveryService
            .saveTokenSafely(result.accessToken)
            .then((success) {
          if (success) {
            logger.controller("✅ Access token saved successfully");
          } else {
            logger.warning("⚠️ Access token stored for recovery - will retry on next app launch");
          }
        });
      }

      _navigateToNextScreen();
    }
  }

  Future<void> resendOTP() async {
    logger.method('resendOTP');
    logger.userAction("Resending OTP", params: {'email': userEmail});

    clearGeneralError();

    // Validate inputs
    if (!_validateEmail()) return;

    // Execute API call
    final result = await executeApiCall<ResendOtpEntity>(
      () async {
        final request = ResendOtpRequest(email: userEmail, type: _getVerificationType().name);
        return await resendOtpUseCase.execute(request);
      },
      onSuccess: () {
        resendOtpSuccess.value = true;
        logger.controller("OTP resent successfully, params: 'email': $userEmail}");
      },
      onError: (errorMessage) {
        logger.error("Failed to resend OTP", error: errorMessage);
      },
    );

    // Handle successful result
    if (result != null) {
      logger.controller("Resend OTP success, params: {'message': ${result.message}");
    }
  }

  // ========================================
  // VALIDATION METHODS
  // ========================================
  bool _validateOtpInput() {
    if (verificationCode.length != 5) {
      setGeneralError('Please enter a valid 5-digit code');
      return false;
    }
    return _validateEmail();
  }

  bool _validateEmail() {
    if (userEmail.isEmpty) {
      setGeneralError('Email not found. Please try again.');
      return false;
    }
    return true;
  }

  // ========================================
  // HELPER METHODS
  // ========================================
  OtpVerificationType _getVerificationType() {
    if (FlowTracker.isFromForgotPassword(sourceScreen.value)) {
      return OtpVerificationType.forgot;
    } else {
      return OtpVerificationType.signup;
    }
  }

  // ========================================
  // NAVIGATION METHODS
  // ========================================
  void _navigateToNextScreen() {
    logger.navigation('Determining navigation path', arguments: {
      'sourceScreen': sourceScreen.value,
      'flow': FlowTracker.getFlowDescription(sourceScreen.value)
    });

    final arguments = Get.arguments as Map<String, dynamic>?;
    
    // Check if this is a specialist flow returning to signup
    if (arguments != null) {
      final isSpecialistFlow = arguments[Arguments.isSpecialistFlow] ?? false;
      final returnToStep = arguments[Arguments.returnToStep];
      
      if (isSpecialistFlow && returnToStep != null) {
        logger.navigation('Returning to specialist signup flow', arguments: {
          'returnToStep': returnToStep
        });
        _navigateToSpecialistSignupAtStep(returnToStep);
        return;
      }
    }

    // Handle other flows
    if (FlowTracker.isFromForgotPassword(sourceScreen.value)) {
      _navigateToCreateNewPassword();
    } else {
      _navigateToSuccessScreen();
    }
  }

  void _navigateToSpecialistSignupAtStep(int stepNumber) {
    logger.navigation('Navigating back to specialist signup', arguments: {
      'step': stepNumber
    });
    
    // Remove form data handling - no longer needed
    Get.offAllNamed(
      AppRoutes.specialistSignup,
      arguments: {
        Arguments.navigateSpecialistSignUpToStepTwo: stepNumber,
        Arguments.email: userEmail,
      },
    );
  }

  void _navigateToCreateNewPassword() {
    logger.navigation('Navigating to Create New Password (Forgot Password Flow)');
    
    Get.offNamed(
      AppRoutes.createNewPassword,
      arguments: {
        Arguments.openedFrom: sourceScreen.value.toString(),
        Arguments.email: userEmail,
        Arguments.resetCode: verificationCode,
      },
    );
  }

  void _navigateToSuccessScreen() {
    logger.navigation('Navigating to Success Screen (Regular Signup Flow)');
    
    Get.offAllNamed(
      AppRoutes.successPage,
      arguments: {
        Arguments.openedFrom: sourceScreen.value.toString(),
        Arguments.email: userEmail,
      },
    );
  }

  void goToPreviousScreen() {
    logger.navigation("Going back to previous screen");
    Get.back();
  }
}
