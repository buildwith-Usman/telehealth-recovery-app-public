import 'package:recovery_consultation_app/data/api/response/forgot_password_response.dart';
import 'package:recovery_consultation_app/domain/entity/forgot_password_entity.dart';

class ForgotPasswordMapper {
  static ForgotPasswordEntity toForgotPasswordEntity(ForgotPasswordResponse response) {
    return ForgotPasswordEntity(
      message: response.message,
    );
  }
}
