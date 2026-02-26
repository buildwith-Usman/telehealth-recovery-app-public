import 'package:recovery_consultation_app/domain/usecase/set_has_onboarding_use_case.dart';
import 'package:recovery_consultation_app/presentation/onboarding/onboarding_controller.dart';
import 'package:get/get.dart';

import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import 'package:recovery_consultation_app/di/client_module.dart';

class OnboardingBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(
      () => OnboardingController(
          setHasOnboardingUseCase:
              SetHasOnboardingUseCase(repository: preferencesRepository)),
    );
  }
}
