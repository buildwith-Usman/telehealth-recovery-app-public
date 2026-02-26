import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/questionnaire/questionnaire_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class QuestionnaireBinding extends Bindings 
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<QuestionnaireController>(
      () => QuestionnaireController(
        addQuestionnairesUseCase: addQuestionnairesUseCase,
        loadQuestionnaireUseCase: loadQuestionnaireUseCase,
      ),
    );
  }
}
