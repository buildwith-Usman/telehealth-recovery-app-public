import 'package:get/get.dart';
import 'admin_medicine_product_listing_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class AdminMedicineProductListingBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<AdminMedicineProductListingController>(
      () => AdminMedicineProductListingController(
        getProductsUseCase: getProductsUseCase,
        updateProductUseCase: updateProductUseCase,
        deleteProductUseCase: deleteProductUseCase,
      ),
    );
  }
}
