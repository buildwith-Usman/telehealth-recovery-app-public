import 'package:get/get.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';
import 'recent_patients_list_controller.dart';

class PatientListBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<RecentPatientsListController>(
      () => RecentPatientsListController(
        getPaginatedPatientsListUseCase: getPaginatedPatientsListUseCase,
      ),
    );
  }
}
