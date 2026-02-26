import 'package:recovery_consultation_app/presentation/appointments/appointments_controller.dart';
import 'package:get/get.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class AppointmentsBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, UseCaseModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(() => AppointmentsController(
      getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,
    ));
  }
}
