import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_user_use_case.dart';
import 'package:recovery_consultation_app/presentation/admin_patient_profile_view/admin_patient_profile_view_controller.dart';
import 'package:recovery_consultation_app/presentation/payment_history/payment_history_controller.dart';
import 'package:recovery_consultation_app/presentation/session_history/session_history_controller.dart';
import 'admin_patient_details_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

class AdminPatientDetailsBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule, UseCaseModule {
  @override
  void dependencies() {
    Get.lazyPut<AdminPatientDetailsController>(
      () => AdminPatientDetailsController(
        getSpecialistByIdUseCase:
            GetUserDetailByIdUseCase(repository: specialistRepository),
        getUserUseCase: getUserUseCase,
      ),
    );
    Get.lazyPut<AdminPatientProfileViewController>(
      () => AdminPatientProfileViewController(
          getUserUseCase: GetUserUseCase(repository: userRepository)),
    );
    Get.lazyPut<SessionHistoryController>(() => SessionHistoryController());
    Get.lazyPut<PaymentHistoryController>(() => PaymentHistoryController());
  }
}
