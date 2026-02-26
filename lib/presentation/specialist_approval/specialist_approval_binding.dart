import 'package:get/get.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';
import 'specialist_approval_controller.dart';

class SpecialistApprovalBinding extends Bindings with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<SpecialistApprovalController>(
      () => SpecialistApprovalController(
        getPaginatedAdminUserListUseCase: getPaginatedAdminUserListUseCase,
        adminUpdateProfileUseCase: adminUpdateProfileUserCase,
      ),
    );
  }
}