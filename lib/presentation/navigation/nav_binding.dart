import 'package:recovery_consultation_app/presentation/admin_patients_list/admin_patients_list_controller.dart';
import 'package:recovery_consultation_app/presentation/admin_sessions/admin_sessions_controller.dart';
import 'package:recovery_consultation_app/presentation/patient_list/recent_patients_list_controller.dart';
import 'package:recovery_consultation_app/presentation/settings/setting_controller.dart';
import 'package:recovery_consultation_app/presentation/patient_home/patient_home_controller.dart';
import 'package:recovery_consultation_app/presentation/appointments/appointments_controller.dart';
import 'package:recovery_consultation_app/presentation/payments/payments_controller.dart';
import 'package:recovery_consultation_app/presentation/navigation/nav_controller.dart';
import 'package:recovery_consultation_app/presentation/admin/admin_home_controller.dart';
import 'package:recovery_consultation_app/presentation/specialist/specialist_home_controller.dart';
import 'package:get/get.dart';

import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../di/usecase_module.dart';
import '../specialist_list/specialist_list_controller.dart';

class NavBinding extends Bindings
    with
        ClientModule,
        DatasourceModule,
        RepositoryModule,
        ConfigModule,
        UseCaseModule {
  @override
  void dependencies() {
    // Navigation controller
    Get.lazyPut(() => NavController());

    // Page controllers for each navigation item
    Get.lazyPut(() => PatientHomeController(
          getUserUseCase: getUserUseCase,
          getPaginatedDoctorsListUseCase: getPaginatedDoctorsListUseCase,
          getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,
          addReviewUseCase: addReviewUseCase,
        ));
    Get.lazyPut(() => AppointmentsController(
          getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,
        ));
    Get.lazyPut(() => AdminSessionsController( getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,));
    Get.lazyPut(() => SpecialistListController(
          getPaginatedDoctorsListUseCase: getPaginatedDoctorsListUseCase,
        ));
    Get.lazyPut(() => AdminPatientsListController(getPaginatedAdminUserListUseCase: getPaginatedAdminUserListUseCase));
    Get.lazyPut(() => PaymentsController());
    Get.lazyPut(() => SettingController());

    // Admin controller
    Get.lazyPut(() => AdminHomeController(
      getPaginatedAdminUserListUseCase: getPaginatedAdminUserListUseCase,
      getUserUseCase: getUserUseCase,
      getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase
    ));

    // Specialist controller
    Get.lazyPut(() => SpecialistHomeController(
      getUserUseCase: getUserUseCase,
      getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,
      getPaginatedPatientsListUseCase: getPaginatedPatientsListUseCase,
      createPrescriptionUseCase: createPrescriptionUseCase
    ));
    Get.lazyPut(() => RecentPatientsListController(
      getPaginatedPatientsListUseCase: getPaginatedPatientsListUseCase,
    ));
  }
}
