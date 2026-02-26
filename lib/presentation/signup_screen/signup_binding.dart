import 'package:recovery_consultation_app/domain/usecase/sign_up_use_case.dart';
import 'package:recovery_consultation_app/presentation/signup_screen/signup_controller.dart';
import 'package:get/get.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class SignupBinding extends Bindings with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(() => SignupController(
        signUpUseCase: SignUpUseCase(repository: authRepository)
    ));
  }
}
