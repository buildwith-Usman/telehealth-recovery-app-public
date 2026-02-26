import 'package:flutter/foundation.dart';

import '../../domain/entity/error_entity.dart';
import '../../domain/entity/paginated_appointments_list_entity.dart';
import '../../domain/repositories/patient_repository.dart';
import '../api/response/error_response.dart';
import '../datasource/patient/patient_datasource.dart';
import '../mapper/appointments_list_mapper.dart';
import '../mapper/exception_mapper.dart';

class PatientRepositoryImpl extends PatientRepository {
  PatientRepositoryImpl({required this.patientDatasource});

  final PatientDatasource patientDatasource;

  @override
  Future<PaginatedAppointmentsListEntity> getPatientsList({
    int? page,
    int? limit,
  }) async {
    try {
      final response = await patientDatasource.getPatientsList(
        page: page,
        limit: limit,
      );
      if (response != null) {
        return AppointmentsListMapper.toEntity(response);
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print('PatientRepositoryImpl - getPatientsList error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }

  @override
  Future<PaginatedAppointmentsListEntity> getPatientHistory({
    required int patientId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await patientDatasource.getPatientHistory(
        patientId: patientId,
        page: page,
        limit: limit,
      );
      if (response != null) {
        return AppointmentsListMapper.toEntity(response);
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print('PatientRepositoryImpl - getPatientHistory error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }
}

