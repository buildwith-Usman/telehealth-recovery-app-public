import 'package:get/get.dart';
import 'package:recovery_consultation_app/di/client_module.dart';
import 'package:recovery_consultation_app/di/config_module.dart';
import 'package:recovery_consultation_app/di/datasource_module.dart';
import 'package:recovery_consultation_app/di/repository_module.dart';
import 'package:recovery_consultation_app/di/usecase_module.dart';
import 'admin_home_controller.dart';

class AdminHomeBinding extends Bindings with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<AdminHomeController>(
      () => AdminHomeController(
        getPaginatedAdminUserListUseCase: getPaginatedAdminUserListUseCase,
        getUserUseCase: getUserUseCase,
        getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,
      ),
    );
  }
}
