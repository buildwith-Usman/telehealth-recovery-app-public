import 'package:get/get.dart';
import 'specialist_about_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class SpecialistAboutBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<SpecialistAboutController>(
      () => SpecialistAboutController(),
    );
  }
}
