
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';
import 'forget_password_controller.dart';
import 'package:get/get.dart';


class ForgetPasswordBinding extends Bindings with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule  {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPasswordController(
      forgotPasswordUseCase: forgotPasswordUseCase,
    ));
  }


}
