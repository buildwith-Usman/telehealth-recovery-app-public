import 'package:recovery_consultation_app/data/api/request/create_password_request.dart';
import 'package:recovery_consultation_app/data/api/request/login_request.dart';
import 'package:recovery_consultation_app/data/api/request/reset_password_request.dart';
import 'package:recovery_consultation_app/data/api/request/sign_up_request.dart';
import 'package:recovery_consultation_app/data/api/response/create_password_response.dart';
import 'package:recovery_consultation_app/data/api/response/login_response.dart';
import 'package:recovery_consultation_app/data/api/response/otp_verification_response.dart';
import 'package:recovery_consultation_app/data/api/response/resend_otp_response.dart';
import 'package:recovery_consultation_app/data/api/response/reset_password_response.dart';
import 'package:recovery_consultation_app/data/api/response/sign_up_response.dart';

import '../../api/request/forgot_password_request.dart';
import '../../api/request/otp_verification_request.dart';
import '../../api/request/resend_otp_request.dart';
import '../../api/response/forgot_password_response.dart';

abstract class AuthDatasource {

  // ==================== REGISTRATION FLOW ====================
  
  /// User registration/signup
  Future<SignUpResponse?> signUp(SignUpRequest signUpRequest);

  /// OTP verification for registration
  Future<OTPVerificationResponse?> otpVerification(
      OPTVerificationRequest otpVerificationRequest);

  /// Resend OTP code
  Future<ResendOtpResponse?> resendOtp(ResendOtpRequest resendOtpRequest);

  /// Create password after successful OTP verification
  Future<CreatePasswordResponse?> createPassword(
      CreatePasswordRequest createPasswordRequest);

  // ==================== LOGIN FLOW ====================
  
  /// User login with email and password
  Future<LoginResponse?> login(LoginRequest loginRequest);

  /// User login with Google OAuth
  Future<LoginResponse?> loginWithGoogle();

  // ==================== PASSWORD RECOVERY FLOW ====================
  
  /// Forgot password request - sends reset code to email
  Future<ForgotPasswordResponse?> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest);

  /// Reset password using reset code
  Future<ResetPasswordResponse?> resetPassword(
      ResetPasswordRequest resetPasswordRequest);
  
}
