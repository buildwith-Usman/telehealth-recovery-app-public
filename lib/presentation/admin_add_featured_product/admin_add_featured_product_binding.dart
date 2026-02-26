import 'package:get/get.dart';
import 'admin_add_featured_product_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class AdminAddFeaturedProductBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<AdminAddFeaturedProductController>(
      () => AdminAddFeaturedProductController(
        getProductsUseCase: getProductsUseCase,
        addToFeaturesUseCase: addToFeaturesUseCase,
      ),
    );
  }
}
