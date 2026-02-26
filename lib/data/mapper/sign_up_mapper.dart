import 'package:recovery_consultation_app/data/api/response/sign_up_response.dart';
import 'package:recovery_consultation_app/domain/entity/sign_up_entity.dart';

class SignUpMapper {
  static SignUpEntity toSignUpEntity(SignUpResponse signUpResponse) {
    return SignUpEntity(
      verificationRequired: signUpResponse.verificationRequired,
      user: SignUpUserEntity(
        id: signUpResponse.user.id,
        name: signUpResponse.user.name,
        email: signUpResponse.user.email,
        type: signUpResponse.user.type,
        phone: signUpResponse.user.phone,
        isVerified: signUpResponse.user.isVerified,
      ),
    );
  }
}
