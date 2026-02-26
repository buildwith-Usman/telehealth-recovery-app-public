import '../../api/response/appointment_response.dart';
import '../../api/response/base_response.dart';

abstract class PatientDatasource {
  Future<BasePagingResponse<AppointmentResponse>?> getPatientsList({
    int? page,
    int? limit,
  });

  Future<BasePagingResponse<AppointmentResponse>?> getPatientHistory({
    required int patientId,
    int? page,
    int? limit,
  });
}

