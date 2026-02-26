import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/get_user_use_case.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(getUserUseCase: GetUserUseCase(repository: userRepository)),
    );
  }
}
