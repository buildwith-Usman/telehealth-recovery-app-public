import 'package:recovery_consultation_app/data/api/response/match_doctors_list_response.dart';
import 'package:recovery_consultation_app/data/api/response/base_response.dart';
import 'package:recovery_consultation_app/data/api/response/user_response.dart';
import 'package:recovery_consultation_app/data/api/response/prescription_response.dart';

abstract class SpecialistDatasource {
  /// Get matched doctors list based on user preferences and questionnaire
  Future<MatchDoctorsListResponse?> getMatchDoctorsList();

  /// Get paginated doctors list with optional specialization filter
  Future<BasePagingResponse<UserResponse>?> getPaginatedDoctorsList({
    String? specialization,
    int? page,
    int? limit,
  });

  /// Get specialist by ID
  Future<UserResponse?> getUserDetailById(int userId);

  /// Create prescription for an appointment
  Future<PrescriptionResponse?> createPrescription({
    required int appointmentId,
    required String prescriptionDate,
    required String notes,
  });
}
