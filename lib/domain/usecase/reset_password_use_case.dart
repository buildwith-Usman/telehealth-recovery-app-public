import 'package:recovery_consultation_app/data/api/request/reset_password_request.dart';
import 'package:recovery_consultation_app/domain/entity/reset_password_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/auth_repository.dart';

import 'base_usecase.dart';

class ResetPasswordUseCase implements ParamUseCase<ResetPasswordEntity?, ResetPasswordRequest> {
  final AuthRepository repository;

  ResetPasswordUseCase({required this.repository});

  @override
  Future<ResetPasswordEntity?> execute(ResetPasswordRequest params) async {
    final resetPasswordEntity = await repository.resetPassword(params);
    return resetPasswordEntity;
  }
}
