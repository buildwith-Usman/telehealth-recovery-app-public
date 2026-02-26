
import '../../domain/entity/resend_otp_entity.dart';
import '../api/response/resend_otp_response.dart';

class ResendOtpMapper {
  static ResendOtpEntity toResendOtpEntity(ResendOtpResponse response) {
    return ResendOtpEntity(
      message: response.message,
    );
  }
}

