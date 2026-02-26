import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import 'specialist_detail_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class SpecialistDetailBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<SpecialistDetailController>(
      () => SpecialistDetailController(
        getSpecialistByIdUseCase: GetUserDetailByIdUseCase(repository: specialistRepository),
      ),
    );
  }
}
