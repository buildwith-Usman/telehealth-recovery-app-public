import '../entity/paginated_appointments_list_entity.dart';

abstract class PatientRepository {
  Future<PaginatedAppointmentsListEntity> getPatientsList({
    int? page,
    int? limit,
  });

  Future<PaginatedAppointmentsListEntity> getPatientHistory({
    required int patientId,
    int? page,
    int? limit,
  });
}

