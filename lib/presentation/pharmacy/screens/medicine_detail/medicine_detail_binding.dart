import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/medicine_detail/medicine_detail_controller.dart';
import '../../../../di/client_module.dart';
import '../../../../di/config_module.dart';
import '../../../../di/datasource_module.dart';
import '../../../../di/repository_module.dart';
import '../../../../di/usecase_module.dart';

/// Medicine Detail Binding - Dependency injection for Medicine Detail screen
/// This follows the same pattern as PharmacyHomeBinding
class MedicineDetailBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<MedicineDetailController>(
      () => MedicineDetailController(
        getProductByIdUseCase: getProductByIdUseCase,
      ),
    );
  }
}
