import 'package:recovery_consultation_app/data/api/response/user_language_response.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_language_entity.dart';


class DoctorLanguageMapper {
  static DoctorLanguageEntity toDoctorLanguageEntity(UserLanguageResponse response) {
    return DoctorLanguageEntity(
      id: response.id ?? 0, // fallback to 0 if null
      userId: response.userId ?? 0,
      language: response.language ?? '',
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }
}

