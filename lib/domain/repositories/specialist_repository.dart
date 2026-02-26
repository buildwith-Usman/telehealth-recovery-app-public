import 'package:recovery_consultation_app/domain/entity/match_doctors_list_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';

abstract class SpecialistRepository {
  /// Get matched doctors list based on user preferences and questionnaire
  Future<MatchDoctorsListEntity> getMatchDoctorsList();

  /// Get paginated doctors list with optional specialization filter
  Future<PaginatedListEntity<UserEntity>> getPaginatedDoctorsList({
    String? specialization,
    int? page,
    int? limit,
  });

  /// Get specialist by ID
  Future<UserEntity> getUserDetailById(int userId);

  /// Create prescription for an appointment
  Future<bool> createPrescription({
    required int appointmentId,
    required String prescriptionDate,
    required String notes,
  });
}
