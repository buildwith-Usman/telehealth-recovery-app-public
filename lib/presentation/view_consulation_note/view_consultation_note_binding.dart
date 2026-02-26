import 'package:get/get.dart';
import 'package:recovery_consultation_app/di/client_module.dart';
import 'package:recovery_consultation_app/di/config_module.dart';
import 'package:recovery_consultation_app/di/datasource_module.dart';
import 'package:recovery_consultation_app/di/repository_module.dart';
import 'package:recovery_consultation_app/di/usecase_module.dart';
import 'package:recovery_consultation_app/presentation/view_consulation_note/view_consultation_note_controller.dart';

class ViewConsultationNoteBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, UseCaseModule, ConfigModule {

  @override
  void dependencies() {
    Get.lazyPut<ViewConsultationNoteController>(
      () => ViewConsultationNoteController(
        getPatientHistoryUseCase: getPatientHistoryUseCase,
      ),
    );
  }
}
