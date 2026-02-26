import 'package:recovery_consultation_app/data/api/response/reset_password_response.dart';
import 'package:recovery_consultation_app/domain/entity/reset_password_entity.dart';

class ResetPasswordMapper {
  static ResetPasswordEntity toResetPasswordEntity(ResetPasswordResponse response) {
    return ResetPasswordEntity(
      message: response.message ?? 'Password has been reset successfully.',
    );
  }
}
