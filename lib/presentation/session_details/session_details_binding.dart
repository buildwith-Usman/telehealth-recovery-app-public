import 'package:get/get.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../domain/usecase/get_appointment_detail_use_case.dart';
import 'session_details_controller.dart';

class SessionDetailsBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(() => GetAppointmentDetailUseCase(
      repository: appointmentRepository,
    ));

    Get.lazyPut(() => SessionDetailsController(
      getAppointmentDetailUseCase: Get.find<GetAppointmentDetailUseCase>(),
    ));
  }
}
