import 'package:recovery_consultation_app/domain/entity/resend_otp_entity.dart';
import 'package:recovery_consultation_app/data/api/request/resend_otp_request.dart';
import 'package:recovery_consultation_app/domain/repositories/auth_repository.dart';

import 'base_usecase.dart';

class ResendOtpUseCase implements ParamUseCase<ResendOtpEntity?, ResendOtpRequest> {
  final AuthRepository repository;

  ResendOtpUseCase({required this.repository});

  @override
  Future<ResendOtpEntity?> execute(ResendOtpRequest params) async {
    final entity = await repository.resendOtp(params);
    return entity;
  }
}
