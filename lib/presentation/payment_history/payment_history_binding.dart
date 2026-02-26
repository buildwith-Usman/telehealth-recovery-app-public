
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/payment_history/payment_history_controller.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class PaymentHistoryBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentHistoryController());
  }
}
