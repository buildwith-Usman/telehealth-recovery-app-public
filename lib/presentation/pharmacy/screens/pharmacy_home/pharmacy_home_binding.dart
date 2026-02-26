import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/pharmacy_home/pharmacy_home_controller.dart';
import '../../../../di/client_module.dart';
import '../../../../di/config_module.dart';
import '../../../../di/datasource_module.dart';
import '../../../../di/repository_module.dart';
import '../../../../di/usecase_module.dart';

class PharmacyHomeBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyHomeController>(
      () => PharmacyHomeController(
        getAdBannersUseCase: getAdBannersUseCase,
        getFeaturedProductsUseCase: getFeaturedProductsUseCase,
        getMedicinesUseCase: getMedicinesUseCase,
        getPharmacyProductsUseCase: getPharmacyProductsUseCase,
      ),
    );
  }
}
