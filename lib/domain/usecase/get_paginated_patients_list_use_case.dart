import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

import '../entity/paginated_appointments_list_entity.dart';
import '../repositories/patient_repository.dart';

class GetPaginatedPatientsListUseCase implements ParamUseCase<PaginatedAppointmentsListEntity?, GetPaginatedPatientsListParams> {
  final PatientRepository repository;

  GetPaginatedPatientsListUseCase({required this.repository});

  @override
  Future<PaginatedAppointmentsListEntity?> execute(GetPaginatedPatientsListParams params) async {
    return await repository.getPatientsList(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetPaginatedPatientsListParams {
  final int? page;
  final int? limit;

  GetPaginatedPatientsListParams({
    this.page,
    this.limit,
  });

  // Helper method to create params with defaults
  factory GetPaginatedPatientsListParams.withDefaults({
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedPatientsListParams(
      page: page,
      limit: limit,
    );
  }
}

