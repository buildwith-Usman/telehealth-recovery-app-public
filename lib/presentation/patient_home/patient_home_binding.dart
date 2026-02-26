import 'package:get/get.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';
import 'patient_home_controller.dart';

class PatientHomeBinding extends Bindings with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<PatientHomeController>(
      () => PatientHomeController(
        getUserUseCase: getUserUseCase,
        getPaginatedDoctorsListUseCase: getPaginatedDoctorsListUseCase,
        getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,
        addReviewUseCase: addReviewUseCase,
      ),
    );
  }
}