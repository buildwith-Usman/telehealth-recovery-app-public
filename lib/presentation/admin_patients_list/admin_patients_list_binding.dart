import 'package:get/get.dart';
import 'admin_patients_list_controller.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class AdminPatientsListBinding extends Bindings with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<AdminPatientsListController>(
      () => AdminPatientsListController(
        getPaginatedAdminUserListUseCase: getPaginatedAdminUserListUseCase,
      ),
    );
  }
}
