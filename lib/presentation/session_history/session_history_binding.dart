
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/session_history/session_history_controller.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class SessionHistoryBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(() => SessionHistoryController());
  }
}
