import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/create_ad_banner_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/upload_file_use_case.dart';
import 'admin_ad_banner_creation_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class AdminAdBannerCreationBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<AdminAdBannerCreationController>(() => AdminAdBannerCreationController(
          uploadFileUseCase: UploadFileUseCase(repository: userRepository),
          createAdBannerUseCase: createAdBannerUseCase,
          updateAdBannerUseCase: updateAdBannerUseCase,
        ));
  }
}
