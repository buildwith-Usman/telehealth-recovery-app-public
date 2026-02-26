import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import 'package:recovery_consultation_app/presentation/earning_history/earning_history_controller.dart';
import 'package:recovery_consultation_app/presentation/payment_history/payment_history_controller.dart';
import 'package:recovery_consultation_app/presentation/session_history/session_history_controller.dart';
import 'package:recovery_consultation_app/presentation/specialist_about/specialist_about_controller.dart';
import 'package:recovery_consultation_app/presentation/specialist_reviews/specialist_review_controller.dart';
import 'package:recovery_consultation_app/presentation/withdrawal_history/withdrawal_history_controller.dart';
import 'specialist_profile_view_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class SpecialistProfileViewBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
      
  @override
  void dependencies() {
    Get.lazyPut<SpecialistProfileViewController>(
      () => SpecialistProfileViewController(
        getSpecialistByIdUseCase:
            GetUserDetailByIdUseCase(repository: specialistRepository),
      ),
    );
    Get.lazyPut(() => SpecialistAboutController());
     Get.lazyPut(() => SpecialistReviewController());
    Get.lazyPut<SessionHistoryController>(() => SessionHistoryController());
    Get.lazyPut<EarningHistoryController>(() => EarningHistoryController());
    Get.lazyPut<WithdrawalHistoryController>(() => WithdrawalHistoryController());
    Get.lazyPut<PaymentHistoryController>(() => PaymentHistoryController());
  }
}
