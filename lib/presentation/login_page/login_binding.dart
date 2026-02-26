import 'package:recovery_consultation_app/di/client_module.dart';
import 'package:recovery_consultation_app/domain/usecase/login_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/login_with_google_usecase.dart';
import 'package:recovery_consultation_app/domain/usecase/set_access_token_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_access_token_use_case.dart';
import 'package:recovery_consultation_app/app/services/token_recovery_service.dart';
import 'package:recovery_consultation_app/presentation/login_page/login_controller.dart';
import 'package:get/get.dart';

import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class LoginBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    // Register TokenRecoveryService as a singleton if not already registered
    if (!Get.isRegistered<TokenRecoveryService>()) {
      Get.put(TokenRecoveryService(
        setAccessTokenUseCase: SetAccessTokenUseCase(repository: preferencesRepository),
        getAccessTokenUseCase: GetAccessTokenUseCase(repository: preferencesRepository),
      ), permanent: true);
    }
    
    Get.lazyPut(() => LoginController(
          loginUseCase: LoginUseCase(repository: authRepository),
          loginWithGoogleUseCase:
              LoginWithGoogleUseCase(repository: authRepository),
          tokenRecoveryService: Get.find<TokenRecoveryService>(),
        ));
  }
}
