import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/update_profile_use_case.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import 'fill_questionnaire_or_skip_controller.dart';

class FillQuestionnaireOrSkipBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<FillQuestionnaireOrSkipController>(() =>
        FillQuestionnaireOrSkipController(
            updateProfileUseCase:
                UpdateProfileUseCase(repository: userRepository)));
  }
}
