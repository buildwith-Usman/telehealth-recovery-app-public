import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/checkout/checkout_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/payment_method/payment_method_binding.dart';
import '../../../../di/client_module.dart';
import '../../../../di/config_module.dart';
import '../../../../di/datasource_module.dart';
import '../../../../di/repository_module.dart';
import '../../../../di/usecase_module.dart';

/// Checkout Binding - Dependency injection for Checkout screen
/// This follows the same pattern as CartBinding
class CheckoutBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    // ✅ Initialize payment method module with apiClient from mixin
    PaymentMethodBinding(apiClient: apiClient).dependencies();

    Get.lazyPut<CheckoutController>(
      () => CheckoutController(),
    );
  }
}
