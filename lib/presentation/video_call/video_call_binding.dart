import 'package:get/get.dart';
import '../../app/services/agora_video_service.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';
import '../../domain/usecase/update_appointment_use_case.dart';
import 'video_call_controller.dart';

class VideoCallBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    // Register AgoraVideoService as a singleton
    Get.put<AgoraVideoService>(AgoraVideoService());

    // Register UpdateAppointmentUseCase
    Get.lazyPut(() => UpdateAppointmentUseCase(
      repository: appointmentRepository,
    ));

    Get.lazyPut<VideoCallController>(
      () => VideoCallController(
        updateAppointmentUseCase: Get.find<UpdateAppointmentUseCase>(),
      ),
    );
  }
}