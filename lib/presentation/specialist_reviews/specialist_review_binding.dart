import 'package:get/get.dart';
import 'specialist_review_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class SpecialistReviewBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<SpecialistReviewController>(
      () => SpecialistReviewController(),
    );
  }
}
