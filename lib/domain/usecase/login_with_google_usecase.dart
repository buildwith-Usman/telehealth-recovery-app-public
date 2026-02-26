import 'package:recovery_consultation_app/domain/entity/login_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/auth_repository.dart';

import 'base_usecase.dart';

class LoginWithGoogleUseCase implements NoParamUseCase<LoginEntity?> {
  final AuthRepository repository;

  LoginWithGoogleUseCase({required this.repository});

  @override
  Future<LoginEntity?> execute() async {
    final loginEntity = await repository.loginWithGoogle();
    // await AppStorage.instance.setAccessToken(loginEntity.token);
    return loginEntity;
  }

}
