import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

import '../entity/paginated_appointments_list_entity.dart';
import '../repositories/patient_repository.dart';

class GetPatientHistoryUseCase implements ParamUseCase<PaginatedAppointmentsListEntity?, GetPatientHistoryParams> {
  final PatientRepository repository;

  GetPatientHistoryUseCase({required this.repository});

  @override
  Future<PaginatedAppointmentsListEntity?> execute(GetPatientHistoryParams params) async {
    return await repository.getPatientHistory(
      patientId: params.patientId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetPatientHistoryParams {
  final int patientId;
  final int? page;
  final int? limit;

  GetPatientHistoryParams({
    required this.patientId,
    this.page,
    this.limit,
  });

  // Helper method to create params with defaults
  factory GetPatientHistoryParams.withDefaults({
    required int patientId,
    int page = 1,
    int limit = 20,
  }) {
    return GetPatientHistoryParams(
      patientId: patientId,
      page: page,
      limit: limit,
    );
  }
}

