import '../config/app_enum.dart';

/// Utility class to track user flows and screen navigation
class FlowTracker {
  
  /// Check if the current flow is from specialist signup
  static bool isFromSpecialistSignup(dynamic screenSource) {
    if (screenSource is ScreenName) {
      return screenSource == ScreenName.specialistSignUp;
    }
    if (screenSource is String) {
      return screenSource == ScreenName.specialistSignUp.toString();
    }
    return false;
  }

  /// Check if the current flow is from regular signup
  static bool isFromRegularSignup(dynamic screenSource) {
    if (screenSource is ScreenName) {
      return screenSource == ScreenName.signUp;
    }
    if (screenSource is String) {
      return screenSource == ScreenName.signUp.toString();
    }
    return false;
  }

  /// Check if the current flow is from any signup (regular or specialist)
  static bool isFromAnySignup(dynamic screenSource) {
    return isFromRegularSignup(screenSource) || isFromSpecialistSignup(screenSource);
  }

  /// Check if the current flow is from login
  static bool isFromLogin(dynamic screenSource) {
    if (screenSource is ScreenName) {
      return screenSource == ScreenName.login;
    }
    if (screenSource is String) {
      return screenSource == ScreenName.login.toString();
    }
    return false;
  }

  /// Check if the current flow is from forgot password
  static bool isFromForgotPassword(dynamic screenSource) {
    if (screenSource is ScreenName) {
      return screenSource == ScreenName.forgotPassword;
    }
    if (screenSource is String) {
      return screenSource == ScreenName.forgotPassword.toString();
    }
    return false;
  }

  /// Get a user-friendly description of the screen source
  static String getFlowDescription(dynamic screenSource) {
    if (isFromSpecialistSignup(screenSource)) {
      return 'Specialist Signup';
    } else if (isFromRegularSignup(screenSource)) {
      return 'Patient Signup';
    } else if (isFromLogin(screenSource)) {
      return 'Login';
    } else if (isFromForgotPassword(screenSource)) {
      return 'Forgot Password';
    }
    return 'Unknown';
  }

  /// Get the next screen route after success based on the flow
  static String getNextRouteAfterSuccess(dynamic screenSource) {
    if (isFromSpecialistSignup(screenSource)) {
      // Specialists typically go to approval waiting or dashboard
      return '/specialist-dashboard'; // or waiting for approval
    } else if (isFromRegularSignup(screenSource)) {
      // Patients go to specialist selection
      return '/specialist-selection';
    }
    return '/home'; // default fallback
  }
}
