import 'package:recovery_consultation_app/domain/entity/paginated_appointments_list_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/appointment_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

class GetAppointmentsListUseCase implements ParamUseCase<PaginatedAppointmentsListEntity?, GetAppointmentsListParams> {
  final AppointmentRepository repository;

  GetAppointmentsListUseCase({required this.repository});

  @override
  Future<PaginatedAppointmentsListEntity?> execute(GetAppointmentsListParams params) async {
    return await repository.getAppointmentsList(
      type: params.type,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetAppointmentsListParams {
  final String? type;
  final int? page;
  final int? limit;

  GetAppointmentsListParams({
    this.type,
    this.page,
    this.limit,
  });

  // Helper method to create params with defaults
  factory GetAppointmentsListParams.withDefaults({
    String? type,
    int page = 1,
    int limit = 20,
  }) {
    return GetAppointmentsListParams(
      type: type,
      page: page,
      limit: limit,
    );
  }

  @override
  String toString() {
    return 'GetAppointmentsListParams{type: $type, page: $page, limit: $limit}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetAppointmentsListParams &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => type.hashCode ^ page.hashCode ^ limit.hashCode;
}