import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../api/api_client/api_client_type.dart';
import '../../api/request/appointment_booking_request.dart';
import '../../api/request/appointment_update_request.dart';
import '../../api/response/appointment_booking_response.dart';
import '../../api/response/appointment_response.dart';
import '../../api/response/base_response.dart';
import '../../api/response/error_response.dart';
import 'appointment_datasource.dart';

class AppointmentDatasourceImpl implements AppointmentDatasource {
  AppointmentDatasourceImpl({
    required this.apiClient,
  });

  final APIClientType apiClient;

  @override
  Future<AppointmentBookingResponse?> bookAppointment(AppointmentBookingRequest request) async {
    try {
      final response = await apiClient.bookAppointment(request);
      return response.data;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('AppointmentDatasourceImpl - bookAppointment error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<BasePagingResponse<AppointmentResponse>?> getAppointmentsList({
    String? type,
    String? status,
    int? doctorUserId,
    int? patientUserId,
    String? dateFrom,
    String? dateTo,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await apiClient.getAppointmentsList(
        type: type,
        status: status,
        doctorUserId: doctorUserId,
        patientUserId: patientUserId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        page: page,
        limit: limit,
      );
      return response;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('AppointmentDatasourceImpl - getAppointmentsList error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<AppointmentResponse?> getAppointmentDetail({
    required int appointmentId,
  }) async {
    try {
      final response = await apiClient.getAppointmentDetail(
        appointmentId: appointmentId,
      );
      return response.data;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('AppointmentDatasourceImpl - getAppointmentDetail error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<AppointmentResponse?> updateAppointment(AppointmentUpdateRequest request) async {
    try {
      final response = await apiClient.updateAppointment(request);
      return response.data;
    } on DioException catch (error) {
      if (kDebugMode) {
        print('AppointmentDatasourceImpl - updateAppointment error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }
}
