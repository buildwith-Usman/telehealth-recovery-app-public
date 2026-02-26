import 'package:dio/dio.dart';
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
import 'package:recovery_consultation_app/data/datasource/auth/auth_datasource.dart';

import '../../api/api_client/api_client_type.dart';
import '../../api/request/forgot_password_request.dart';
import '../../api/request/otp_verification_request.dart';
import '../../api/request/resend_otp_request.dart';
import '../../api/response/error_response.dart';
import '../../api/response/forgot_password_response.dart';

class AuthDatasourceImpl implements AuthDatasource {
  AuthDatasourceImpl({
    required this.unauthenticatedClient,
    required this.apiClient,
  });

  final APIClientType unauthenticatedClient;
  final APIClientType apiClient;

  // ==================== REGISTRATION FLOW ====================

  @override
  Future<SignUpResponse?> signUp(SignUpRequest signUpRequest) async {
    try {
      final response = await unauthenticatedClient.signUp(signUpRequest);
      return response.data;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<OTPVerificationResponse?> otpVerification(
      OPTVerificationRequest otpVerificationRequest) async {
    try {
      final response =
          await unauthenticatedClient.verifyEmail(otpVerificationRequest);
      return response.data;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<ResendOtpResponse?> resendOtp(
      ResendOtpRequest resendOtpRequest) async {
    try {
      final response = await unauthenticatedClient.resendOtp(resendOtpRequest);
      return response;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<CreatePasswordResponse?> createPassword(
      CreatePasswordRequest createPasswordRequest) async {
    try {
      // TODO: Implement API call when endpoint is available
      throw UnimplementedError('createPassword method not yet implemented');
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  // ==================== LOGIN FLOW ====================

  @override
  Future<LoginResponse?> login(LoginRequest loginRequest) async {
    try {
      final response = await unauthenticatedClient.login(loginRequest);
      return response.data;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<LoginResponse?> loginWithGoogle() async {
    try {
      // TODO: Implement API call when endpoint is available
      throw UnimplementedError('loginWithGoogle method not yet implemented');
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  // ==================== PASSWORD RECOVERY FLOW ====================

  @override
  Future<ForgotPasswordResponse?> forgotPassword(
      ForgotPasswordRequest forgotPasswordRequest) async {
    try {
      final response =
          await unauthenticatedClient.forgotPassword(forgotPasswordRequest);
      return response;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<ResetPasswordResponse?> resetPassword(
      ResetPasswordRequest resetPasswordRequest) async {
    try {
      final response = await unauthenticatedClient.resetPassword(resetPasswordRequest);
      return response;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }

}
