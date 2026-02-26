import 'package:get/get.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';
import 'admin_sessions_controller.dart';

class AdminSessionsBinding extends Bindings with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut(() => AdminSessionsController(
          getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,
        ));
  }
}