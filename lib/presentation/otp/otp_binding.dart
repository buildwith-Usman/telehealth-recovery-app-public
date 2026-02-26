import 'package:recovery_consultation_app/domain/usecase/otp_verification_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/set_access_token_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_access_token_use_case.dart';
import 'package:recovery_consultation_app/presentation/otp/otp_controller.dart';
import 'package:recovery_consultation_app/app/services/token_recovery_service.dart';
import 'package:get/get.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../domain/usecase/resend_otp_use_case.dart';

class OtpBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    // Register TokenRecoveryService as a singleton
    Get.put(TokenRecoveryService(
      setAccessTokenUseCase: SetAccessTokenUseCase(repository: preferencesRepository),
      getAccessTokenUseCase: GetAccessTokenUseCase(repository: preferencesRepository),
    ), permanent: true);
    
    Get.lazyPut(() => OtpController(
          otpVerificationUseCase:
              OtpVerificationUseCase(repository: authRepository),
          resendOtpUseCase: ResendOtpUseCase(repository: authRepository),
          setAccessTokenUseCase: SetAccessTokenUseCase(repository: preferencesRepository),
          tokenRecoveryService: Get.find<TokenRecoveryService>(),
        ));
  }
}
