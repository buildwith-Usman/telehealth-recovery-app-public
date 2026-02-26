import 'package:get/get.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../domain/usecase/book_appointment_use_case.dart';
import '../../domain/usecase/get_specialist_by_id_use_case.dart';
import 'payment_summary_controller.dart';

class PaymentSummaryBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<PaymentSummaryController>(() => PaymentSummaryController(
          getSpecialistByIdUseCase:
              GetUserDetailByIdUseCase(repository: specialistRepository),
          bookAppointmentUseCase: BookAppointmentUseCase(
            repository: appointmentRepository,
          ),
        ));
  }
}
