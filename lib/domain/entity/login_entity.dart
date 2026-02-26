import 'package:recovery_consultation_app/domain/entity/user_entity.dart';

class LoginEntity {
  const LoginEntity({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  final UserEntity user;
  final String accessToken;
  final String tokenType;
}
