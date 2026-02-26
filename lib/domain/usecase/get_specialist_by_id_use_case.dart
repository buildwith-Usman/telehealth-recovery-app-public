import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/specialist_repository.dart';

import 'base_usecase.dart';

class GetUserDetailByIdUseCase implements ParamUseCase<UserEntity?, int> {
  final SpecialistRepository repository;

  GetUserDetailByIdUseCase({required this.repository});

  @override
  Future<UserEntity?> execute(int specialistId) async {
    final result = await repository.getUserDetailById(specialistId);
    return result;
  }
}
