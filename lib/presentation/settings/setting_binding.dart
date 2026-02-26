import 'package:recovery_consultation_app/presentation/settings/setting_controller.dart';
import 'package:get/get.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class SettingBinding extends Bindings with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {

  @override
  void dependencies() {
   Get.lazyPut(() => SettingController());
  }

}