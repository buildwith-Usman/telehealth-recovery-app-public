import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

import '../entity/paginated_appointments_list_entity.dart';
import '../repositories/appointment_repository.dart';

class GetPaginatedAppointmentsListUseCase implements ParamUseCase<PaginatedAppointmentsListEntity?, GetPaginatedAppointmentsListParams> {
  final AppointmentRepository repository;

  GetPaginatedAppointmentsListUseCase({required this.repository});

  @override
  Future<PaginatedAppointmentsListEntity?> execute(GetPaginatedAppointmentsListParams params) async {
    return await repository.getAppointmentsList(
      type: params.type,
      status: params.status,
      doctorUserId: params.doctorUserId,
      patientUserId: params.patientUserId,
      dateFrom: params.dateFrom,
      dateTo: params.dateTo,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetPaginatedAppointmentsListParams {
  final String? type;
  final String? status;
  final int? doctorUserId;
  final int? patientUserId;
  final String? dateFrom;
  final String? dateTo;
  final int? page;
  final int? limit;

  GetPaginatedAppointmentsListParams({
    this.type,
    this.status,
    this.doctorUserId,
    this.patientUserId,
    this.dateFrom,
    this.dateTo,
    this.page,
    this.limit,
  });

  // Helper method to create params with defaults
  factory GetPaginatedAppointmentsListParams.withDefaults({
    String? type,
    String? status,
    int? doctorUserId,
    int? patientUserId,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAppointmentsListParams(
      type: type,
      status: status,
      doctorUserId: doctorUserId,
      patientUserId: patientUserId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      page: page,
      limit: limit,
    );
  }

  // Helper factory methods for different appointment statuses
  factory GetPaginatedAppointmentsListParams.pending({
    int? doctorUserId,
    int? patientUserId,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAppointmentsListParams.withDefaults(
      status: 'pending',
      doctorUserId: doctorUserId,
      patientUserId: patientUserId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      page: page,
      limit: limit,
    );
  }

  factory GetPaginatedAppointmentsListParams.confirmed({
    int? doctorUserId,
    int? patientUserId,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAppointmentsListParams.withDefaults(
      status: 'confirmed',
      doctorUserId: doctorUserId,
      patientUserId: patientUserId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      page: page,
      limit: limit,
    );
  }

  factory GetPaginatedAppointmentsListParams.completed({
    int? doctorUserId,
    int? patientUserId,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAppointmentsListParams.withDefaults(
      status: 'completed',
      doctorUserId: doctorUserId,
      patientUserId: patientUserId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      page: page,
      limit: limit,
    );
  }

  factory GetPaginatedAppointmentsListParams.cancelled({
    int? doctorUserId,
    int? patientUserId,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAppointmentsListParams.withDefaults(
      status: 'cancelled',
      doctorUserId: doctorUserId,
      patientUserId: patientUserId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      page: page,
      limit: limit,
    );
  }

  // Helper factory for filtering by doctor
  factory GetPaginatedAppointmentsListParams.byDoctor({
    required int doctorUserId,
    String? status,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAppointmentsListParams.withDefaults(
      doctorUserId: doctorUserId,
      status: status,
      dateFrom: dateFrom,
      dateTo: dateTo,
      page: page,
      limit: limit,
    );
  }

  // Helper factory for filtering by patient
  factory GetPaginatedAppointmentsListParams.byPatient({
    int? patientUserId,
    String? status,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAppointmentsListParams.withDefaults(
      patientUserId: patientUserId,
      status: status,
      dateFrom: dateFrom,
      dateTo: dateTo,
      page: page,
      limit: limit,
    );
  }

  // Helper factory for filtering by date range
  factory GetPaginatedAppointmentsListParams.byDateRange({
    required String dateFrom,
    required String dateTo,
    String? status,
    int? doctorUserId,
    int? patientUserId,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAppointmentsListParams.withDefaults(
      dateFrom: dateFrom,
      dateTo: dateTo,
      status: status,
      doctorUserId: doctorUserId,
      patientUserId: patientUserId,
      page: page,
      limit: limit,
    );
  }

  @override
  String toString() {
    return 'GetPaginatedAppointmentsListParams{type: $type, status: $status, doctorUserId: $doctorUserId, patientUserId: $patientUserId, dateFrom: $dateFrom, dateTo: $dateTo, page: $page, limit: $limit}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetPaginatedAppointmentsListParams &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          status == other.status &&
          doctorUserId == other.doctorUserId &&
          patientUserId == other.patientUserId &&
          dateFrom == other.dateFrom &&
          dateTo == other.dateTo &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode =>
      type.hashCode ^
      status.hashCode ^
      doctorUserId.hashCode ^
      patientUserId.hashCode ^
      dateFrom.hashCode ^
      dateTo.hashCode ^
      page.hashCode ^
      limit.hashCode;
}