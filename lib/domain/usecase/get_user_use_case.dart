import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/user_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';


class GetUserUseCase implements NoParamUseCase<UserEntity?> {
  final UserRepository repository;

  GetUserUseCase({required this.repository});

  @override
  Future<UserEntity?> execute() async {
    final userEntity = await repository.getUser();
    return userEntity;
  }

}
