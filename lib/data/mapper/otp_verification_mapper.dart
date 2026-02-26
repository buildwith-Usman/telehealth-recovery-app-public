import 'package:recovery_consultation_app/data/api/response/otp_verification_response.dart';
import 'package:recovery_consultation_app/domain/entity/otp_verification_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';

class OtpVerificationMapper {
  static OtpVerificationEntity toOtpVerificationMapper(
      OTPVerificationResponse otpVerificationResponse) {
    return OtpVerificationEntity(
      user: _mapToUserEntity(otpVerificationResponse.user ?? UserData()),
      accessToken: otpVerificationResponse.accessToken ?? '',
      tokenType: otpVerificationResponse.tokenType ?? '',
      isVerified: otpVerificationResponse.user?.isVerified ?? false,
    );
  }

  static UserEntity _mapToUserEntity(UserData userData) {
    return UserEntity(
      id: userData.id ?? 0,
      name: userData.name ?? '',
      email: userData.email ?? '',
      type: userData.type ?? '',
      phone: userData.phone ?? '',
      isVerified: userData.isVerified,
    );
  }
}
