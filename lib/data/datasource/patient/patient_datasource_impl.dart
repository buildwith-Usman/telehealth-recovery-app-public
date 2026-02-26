import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../api/api_client/api_client_type.dart';
import '../../api/response/appointment_response.dart';
import '../../api/response/base_response.dart';
import '../../api/response/error_response.dart';
import 'patient_datasource.dart';

class PatientDatasourceImpl implements PatientDatasource {
  PatientDatasourceImpl({
    required this.apiClient,
  });

  final APIClientType apiClient;

  @override
  Future<BasePagingResponse<AppointmentResponse>?> getPatientsList({
    int? page,
    int? limit,
  }) async {
    try {
      final response = await apiClient.getPatientsList(
        page: page,
        limit: limit,
      );
      return response;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('PatientDatasourceImpl - getPatientsList error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<BasePagingResponse<AppointmentResponse>?> getPatientHistory({
    required int patientId,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await apiClient.getPatientHistory(
        patientId: patientId,
        page: page,
        limit: limit,
      );
      return response;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('PatientDatasourceImpl - getPatientHistory error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }
}

