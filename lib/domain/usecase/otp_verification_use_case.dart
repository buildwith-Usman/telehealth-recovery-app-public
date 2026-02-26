import 'package:recovery_consultation_app/domain/entity/otp_verification_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/auth_repository.dart';

import '../../data/api/request/otp_verification_request.dart';
import 'base_usecase.dart';

class OtpVerificationUseCase implements ParamUseCase<OtpVerificationEntity?, OPTVerificationRequest> {
  final AuthRepository repository;

  OtpVerificationUseCase({required this.repository});

  @override
  Future<OtpVerificationEntity?> execute(OPTVerificationRequest params) async {
    final otpVerificationEntity = await repository.otpVerification(params);
    return otpVerificationEntity;
  }
}
