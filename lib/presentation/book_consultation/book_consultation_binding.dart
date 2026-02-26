import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import 'book_consultation_controller.dart';

class BookConsultationBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<BookConsultationController>(
      () => BookConsultationController(
        getSpecialistByIdUseCase:
            GetUserDetailByIdUseCase(repository: specialistRepository),
      ),
    );
  }
}
