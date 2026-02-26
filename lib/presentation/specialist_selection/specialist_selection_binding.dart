import 'package:get/get.dart';
import 'package:recovery_consultation_app/di/client_module.dart';
import 'package:recovery_consultation_app/di/config_module.dart';
import 'package:recovery_consultation_app/di/datasource_module.dart';
import 'package:recovery_consultation_app/di/repository_module.dart';
import 'package:recovery_consultation_app/domain/usecase/update_profile_use_case.dart';

import 'specialist_selection_controller.dart';

class SpecialistSelectionBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(() => SpecialistSelectionController(updateProfileUseCase: UpdateProfileUseCase(repository: userRepository)));
  }
}
