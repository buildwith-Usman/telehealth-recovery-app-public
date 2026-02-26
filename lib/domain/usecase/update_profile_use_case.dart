import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/domain/entity/update_profile_entity.dart';

import '../repositories/user_repository.dart';
import 'base_usecase.dart';

class UpdateProfileUseCase implements ParamUseCase<UpdateProfileEntity?, UpdateProfileRequest> {
  final UserRepository repository;

  UpdateProfileUseCase({required this.repository});

  @override
  Future<UpdateProfileEntity?> execute(UpdateProfileRequest params) async {
    final signUpEntity = await repository.updateProfile(params);
    return signUpEntity;
  }

}
