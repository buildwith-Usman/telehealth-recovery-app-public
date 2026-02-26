import 'package:get/get.dart';
import 'admin_manage_ad_banner_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class AdminManageAdBannerBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<AdminManageAdBannerController>(
      () => AdminManageAdBannerController(
        getAdBannersUseCase: getAdBannersUseCase,
        updateAdBannerUseCase: updateAdBannerUseCase,
      ),
    );
  }
}
