import '../../domain/entity/login_entity.dart';
import '../api/response/login_response.dart';
import 'user_mapper.dart';

class LoginMapper {
  static LoginEntity toLoginEntity(LoginResponse loginResponse) {
    return LoginEntity(
      user: UserMapper.toUserEntity(loginResponse.user),
      accessToken: loginResponse.accessToken,
      tokenType: loginResponse.tokenType,
    );
  }
}