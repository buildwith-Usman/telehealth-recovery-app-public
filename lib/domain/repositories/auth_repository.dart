import 'package:recovery_consultation_app/data/api/request/create_password_request.dart';
import 'package:recovery_consultation_app/data/api/request/sign_up_request.dart';
import 'package:recovery_consultation_app/domain/entity/create_password_entity.dart';
import 'package:recovery_consultation_app/domain/entity/forgot_password_entity.dart';
import 'package:recovery_consultation_app/domain/entity/login_entity.dart';
import 'package:recovery_consultation_app/domain/entity/otp_verification_entity.dart';
import 'package:recovery_consultation_app/domain/entity/resend_otp_entity.dart';
import 'package:recovery_consultation_app/domain/entity/reset_password_entity.dart';
import 'package:recovery_consultation_app/domain/entity/sign_up_entity.dart';

import '../../data/api/request/forgot_password_request.dart';
import '../../data/api/request/login_request.dart';
import '../../data/api/request/otp_verification_request.dart';
import '../../data/api/request/resend_otp_request.dart';
import '../../data/api/request/reset_password_request.dart';

abstract class AuthRepository {

  // ==================== REGISTRATION FLOW ====================
  
  /// User registration/signup
  Future<SignUpEntity> signUp(SignUpRequest signUpRequest);

  /// OTP verification for registration
  Future<OtpVerificationEntity?> otpVerification(
      OPTVerificationRequest otpVerificationRequest);

  /// Resend OTP code
  Future<ResendOtpEntity?> resendOtp(ResendOtpRequest resendOtpRequest);

  /// Create password after successful OTP verification
  Future<CreatePasswordEntity?> createPassword(
      CreatePasswordRequest createPasswordRequest);

  // ==================== LOGIN FLOW ====================
  
  /// User login with email and password
  Future<LoginEntity> login(LoginRequest loginRequest);

  /// User login with Google OAuth
  Future<LoginEntity> loginWithGoogle();

  // ==================== PASSWORD RECOVERY FLOW ====================
  
  /// Forgot password request - sends reset code to email
  Future<ForgotPasswordEntity?> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest);

  /// Reset password using reset code
  Future<ResetPasswordEntity?> resetPassword(
      ResetPasswordRequest resetPasswordRequest);

}
