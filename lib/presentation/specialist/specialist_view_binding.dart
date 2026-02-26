import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import 'package:recovery_consultation_app/presentation/earning_history/earning_history_controller.dart';
import 'package:recovery_consultation_app/presentation/session_history/session_history_controller.dart';
import 'package:recovery_consultation_app/presentation/specialist/specialist_view_controller.dart';
import 'package:recovery_consultation_app/presentation/specialist_about/specialist_about_controller.dart';
import 'package:recovery_consultation_app/presentation/specialist_reviews/specialist_review_controller.dart';
import 'package:recovery_consultation_app/presentation/withdrawal_history/withdrawal_history_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';

/// Dependency injection binding for unified specialist view
class SpecialistViewBinding extends Bindings
    with
        ClientModule,
        DatasourceModule,
        RepositoryModule,
        ConfigModule,
        UseCaseModule {
  @override
  void dependencies() {
    // Main controller
    Get.lazyPut<SpecialistViewController>(
      () => SpecialistViewController(
        getSpecialistByIdUseCase:
            GetUserDetailByIdUseCase(repository: specialistRepository),
        getUserUseCase: getUserUseCase,
      ),
    );

    // Tab controllers - these will access data from SpecialistViewController
    Get.lazyPut<SpecialistAboutController>(
      () => SpecialistAboutController(),
    );

    Get.lazyPut<SpecialistReviewController>(
      () => SpecialistReviewController(),
    );

    // Additional tab controllers for specialist/admin views
    Get.lazyPut<SessionHistoryController>(
      () => SessionHistoryController(),
    );

    Get.lazyPut<EarningHistoryController>(
      () => EarningHistoryController(),
    );

    Get.lazyPut<WithdrawalHistoryController>(
      () => WithdrawalHistoryController(),
    );
  }
}
