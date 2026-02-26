import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/get_match_doctors_list_use_case.dart';
import 'match_therapist_controller.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class MatchTherapistBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<MatchTherapistController>(
      () => MatchTherapistController(
        getMatchDoctorsListUseCase: GetMatchDoctorsListUseCase(repository: specialistRepository),
      ),
    );
  }
}
