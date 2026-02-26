import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/controllers/payment_method_controller.dart';
import 'package:recovery_consultation_app/data/api/api_client/api_client_type.dart';
import 'package:recovery_consultation_app/data/datasource/payment/payment_datasource.dart';
import 'package:recovery_consultation_app/data/datasource/payment/payment_datasource_impl.dart';
import 'package:recovery_consultation_app/data/repository/payment_repository_impl.dart';
import 'package:recovery_consultation_app/domain/repositories/payment_repository.dart';

/// Payment Method Binding
/// Dependency injection for payment method feature
/// Use this binding when you need payment method functionality in any screen
class PaymentMethodBinding extends Bindings {
  final APIClientType? apiClient;

  PaymentMethodBinding({this.apiClient});

  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<PaymentDatasource>(
      () => PaymentDatasourceImpl(
        apiClient: apiClient ?? Get.find<APIClientType>(),
      ),
      fenix: true,
    );

    // Repository
    Get.lazyPut<PaymentRepository>(
      () => PaymentRepositoryImpl(
        paymentDatasource: Get.find<PaymentDatasource>(),
      ),
      fenix: true,
    );

    // Controller
    Get.lazyPut<PaymentMethodController>(
      () => PaymentMethodController(
        paymentRepository: Get.find<PaymentRepository>(),
      ),
      fenix: true,
    );
  }
}
