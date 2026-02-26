import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/update_profile_use_case.dart';
import '../../domain/usecase/sign_up_use_case.dart';
import 'specialist_signup_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class SpecialistSignupBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<SpecialistSignupController>(
      () => SpecialistSignupController(
        signUpUseCase: SignUpUseCase(repository: authRepository),
        updateProfileUseCase: UpdateProfileUseCase(repository: userRepository)
      ),
    );
  }
}
