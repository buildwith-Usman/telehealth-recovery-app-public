import '../../app/config/app_constant.dart';
import '../../app/config/app_routes.dart';
import '../../app/config/app_enum.dart';
import '../../app/services/app_storage.dart';
import '../../app/services/role_manager.dart';
import '../../app/utils/flow_tracker.dart';
import '../../app/controllers/base_controller.dart';
import '../../di/client_module.dart';
import '../../domain/entity/appointment_booking_entity.dart';
import 'package:get/get.dart';

class SuccessController extends BaseController with ClientModule {
  final RxString screenOpenedFrom = ''.obs;
  final RxBool isFromPayment = false.obs;
  final RxString userEmail = ''.obs;

  // Payment success data - booking response entity
  AppointmentBookingResponseEntity? bookingResponse;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      // Check if coming from payment (booking response present)
      if (args.containsKey(Arguments.bookingResponse)) {
        isFromPayment.value = true;
        bookingResponse = args[Arguments.bookingResponse] as AppointmentBookingResponseEntity?;
      } else {
        // Existing signup flow
        screenOpenedFrom.value = args[Arguments.openedFrom]?.toString() ?? '';
        // Capture email if provided in arguments
        userEmail.value = args[Arguments.email]?.toString() ?? '';
      }
    }

    // Debug information
    logger.controller("Success screen opened from: ${screenOpenedFrom.value}");
    logger.controller("User email: ${userEmail.value}");
    logger.controller("Is from payment: ${isFromPayment.value}");
    if (isFromPayment.value) {
      logger.controller(
          "Payment data - Appointment ID: ${bookingResponse?.id}, Date: ${bookingResponse?.date}");
    } else {
      logger.controller(
          "Flow description: ${FlowTracker.getFlowDescription(screenOpenedFrom.value)}");
      logger.controller(
          "Is from specialist signup: ${FlowTracker.isFromSpecialistSignup(screenOpenedFrom.value)}");
      logger.controller(
          "Is from regular signup: ${FlowTracker.isFromRegularSignup(screenOpenedFrom.value)}");

      // Save user role on successful signup
      _saveUserRoleOnSignupSuccess();
    }
  }

  void goToSpecialistSelection() {
    if (FlowTracker.isFromRegularSignup(screenOpenedFrom.value)) {
      logger.controller("Navigating to specialist selection (from regular signup)");
      Get.offAllNamed(AppRoutes.specialistSelection);
    } else {
      logger.warning(
          "Unexpected flow - this method should only be called from regular signup");
      Get.offAllNamed(AppRoutes.specialistSelection); // Fallback
    }
  }

  void goToLogin() {
    if (FlowTracker.isFromForgotPassword(screenOpenedFrom.value)) {
      logger.controller("Navigating to login (from forgot password flow)");
      Get.offAllNamed(AppRoutes.logIn);
    } else {
      logger.warning(
          "Unexpected flow - this method should only be called from forgot password");
      Get.offAllNamed(AppRoutes.logIn); // Fallback
    }
  }

  void goToWaitingForApproval() {
    if (FlowTracker.isFromSpecialistSignup(screenOpenedFrom.value)) {
      logger.controller("Navigating to waiting for approval (from specialist signup)");
      Get.offAllNamed(AppRoutes.waitingForApproval,
          arguments: {Arguments.openedFrom: screenOpenedFrom.value});
    } else {
      logger.warning(
          "Unexpected flow - this method should only be called from specialist signup");
      Get.offAllNamed(AppRoutes.waitingForApproval); // Fallback
    }
  }

  // Payment success navigation methods
  void goToMySessions() {
    logger.controller("Navigating to my sessions");
    Get.offAllNamed(
        AppRoutes.navScreen); // Navigate to main app with sessions tab
  }

  void goToHome() {
    logger.controller("Navigating to home");
    Get.offAllNamed(AppRoutes.navScreen); // Navigate to main app home
  }

  // ==================== USER ROLE MANAGEMENT ====================
  
  /// Save user role based on signup flow type
  void _saveUserRoleOnSignupSuccess() async {
    try {
      UserRole userRole = _determineUserRole();

      logger.controller("Saving user role: ${userRole.toString().split('.').last}");

      // Save to app storage
      await AppStorage.instance.setUserRole(userRole);

      // Update role manager for navigation
      await RoleManager.instance.setRole(userRole);

      logger.controller("User role saved successfully!");

    } catch (e) {
      logger.error("Error saving user role", error: e);
    }
  }

  /// Determine user role based on screen flow and email
  UserRole _determineUserRole() {
    if (FlowTracker.isFromSpecialistSignup(screenOpenedFrom.value)) {
      // For specialist signup, we need to determine specialist type
      // Since we don't have specialist type info here, we'll set as general specialist
      // and it will be updated later during approval process
      return UserRole.doctor;
    } else if (FlowTracker.isFromRegularSignup(screenOpenedFrom.value)) {
      // For regular signup, determine role based on email domain or default to patient
      return _getUserRoleFromEmail(userEmail.value) ?? UserRole.patient;
    }
    
    // Default fallback
    return UserRole.patient;
  }

  /// Get user role from email domain (same logic as login controller)
  UserRole? _getUserRoleFromEmail(String email) {
    if (email.isEmpty) return UserRole.patient;
    
    if (email.endsWith('@admin.recovery.com')) {
      return UserRole.admin;
    } else if (email.endsWith('@specialist.recovery.com')) {
      return UserRole.doctor;
    } else {
      return UserRole.patient;
    }
  }

  /// Main navigation method that routes based on the flow
  void navigateToNextScreen() {
    if (isFromPayment.value) {
      goToMySessions(); // Default action for single button (not used when showing two buttons)
    } else if (FlowTracker.isFromSpecialistSignup(screenOpenedFrom.value)) {
      goToWaitingForApproval();
    } else if (FlowTracker.isFromRegularSignup(screenOpenedFrom.value)) {
      goToSpecialistSelection();
    } else if (FlowTracker.isFromForgotPassword(screenOpenedFrom.value)) {
      goToLogin();
    } else {
      logger.warning("Unknown flow, defaulting to specialist selection");
      goToSpecialistSelection();
    }
  }

  /// Get the appropriate success message based on the flow
  String getSuccessMessage() {
    if (isFromPayment.value) {
      return 'Payment Successful!\nYour session is booked';
    } else if (FlowTracker.isFromSpecialistSignup(screenOpenedFrom.value)) {
      return 'Specialist account created successfully!\nYour account is pending approval.';
    } else if (FlowTracker.isFromRegularSignup(screenOpenedFrom.value)) {
      return 'Welcome to your journey to wellness - explore and connect with specialists.';
    } else if (FlowTracker.isFromForgotPassword(screenOpenedFrom.value)) {
      return 'Password reset successful!\nYou can now login with your new password.';
    }
    return 'Reset complete - nurture yourself as you journey on.';
  }

  /// Get the appropriate button text based on the flow
  String getButtonText() {
    if (isFromPayment.value) {
      return 'Go to My Sessions'; // Default for single button (not used with two buttons)
    } else if (FlowTracker.isFromSpecialistSignup(screenOpenedFrom.value)) {
      return 'Wait for Approval';
    } else if (FlowTracker.isFromRegularSignup(screenOpenedFrom.value)) {
      return 'Find Specialists';
    } else if (FlowTracker.isFromForgotPassword(screenOpenedFrom.value)) {
      return 'Go to Login';
    }
    return 'Continue';
  }

  /// Check if we should show two buttons (payment success) or single button (signup flows)
  bool shouldShowTwoButtons() {
    return isFromPayment.value;
  }
}
