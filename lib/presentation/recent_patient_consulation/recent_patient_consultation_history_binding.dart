import 'package:get/get.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';
import 'recent_patient_consultation_history_controller.dart';

class RecentPatientConsultationHistoryBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<RecentPatientConsultationHistoryController>(
      () => RecentPatientConsultationHistoryController(
        getPatientHistoryUseCase: getPatientHistoryUseCase,
      ),
    );
  }
}
