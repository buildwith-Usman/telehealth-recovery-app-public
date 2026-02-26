import 'package:recovery_consultation_app/domain/usecase/get_has_onboarding_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_access_token_use_case.dart';
import 'package:recovery_consultation_app/presentation/splash/splash_controller.dart';
import 'package:get/get.dart';

import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import 'package:recovery_consultation_app/di/client_module.dart';

import '../../domain/usecase/get_user_use_case.dart';

class SplashBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(
        getHasOnboardingUseCase:
            GetHasOnboardingUseCase(repository: preferencesRepository),
        getAccessTokenUseCase:
            GetAccessTokenUseCase(repository: preferencesRepository),
        getUserUseCase: GetUserUseCase(repository: userRepository)));
  }
}
