import 'package:recovery_consultation_app/presentation/create_new_password/create_new_password_controller.dart';
import 'package:get/get.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class CreateNewPasswordBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateNewPasswordController(
        resetPasswordUseCase: resetPasswordUseCase));
  }
}
