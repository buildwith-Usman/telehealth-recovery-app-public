import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';

import 'base_usecase.dart';

class AdminUpdateProfileUseCase implements ParamUseCase<UserEntity?, UpdateProfileRequest> {
  final AdminRepository repository;

  AdminUpdateProfileUseCase({required this.repository});

  @override
  Future<UserEntity?> execute(UpdateProfileRequest params) async {
    final userEntity = await repository.updateProfile(params);
    return userEntity;
  }

}
