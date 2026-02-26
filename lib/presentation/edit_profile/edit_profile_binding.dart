import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/usecase/admin_update_profile_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_user_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/update_profile_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/upload_file_use_case.dart';
import 'edit_profile_controller.dart';
import '../../di/client_module.dart';
import '../../di/config_module.dart';
import '../../di/datasource_module.dart';
import '../../di/repository_module.dart';

class EditProfileBinding extends Bindings
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController(
          getUserUseCase: GetUserUseCase(repository: userRepository),
          updateProfileUseCase:
              UpdateProfileUseCase(repository: userRepository),
          getSpecialistByIdUseCase:
              GetUserDetailByIdUseCase(repository: specialistRepository),
          uploadFileUseCase: UploadFileUseCase(repository: userRepository),
          adminUpdateProfileUseCase:
              AdminUpdateProfileUseCase(repository: adminRepository),
        ));
  }
}
