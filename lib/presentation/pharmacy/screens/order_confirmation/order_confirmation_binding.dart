import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/order_confirmation/order_confirmation_controller.dart';
import '../../../../di/client_module.dart';
import '../../../../di/config_module.dart';
import '../../../../di/datasource_module.dart';
import '../../../../di/repository_module.dart';
import '../../../../di/usecase_module.dart';

/// Order Confirmation Binding - Dependency injection for Order Confirmation screen
class OrderConfirmationBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<OrderConfirmationController>(
      () => OrderConfirmationController(),
    );
  }
}
