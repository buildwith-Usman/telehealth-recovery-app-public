import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/data/api/response/error_response.dart';
import 'package:recovery_consultation_app/data/api/response/match_doctors_list_response.dart';
import 'package:recovery_consultation_app/data/api/response/base_response.dart';
import 'package:recovery_consultation_app/data/api/response/user_response.dart';
import 'package:recovery_consultation_app/data/api/response/prescription_response.dart';
import 'package:recovery_consultation_app/data/api/request/create_prescription_request.dart';
import 'package:recovery_consultation_app/data/datasource/specialist/specialist_datasource.dart';
import '../../api/api_client/api_client_type.dart';

class SpecialistDatasourceImpl implements SpecialistDatasource {
  SpecialistDatasourceImpl({
    required this.apiClient,
  });

  final APIClientType apiClient;

  @override
  Future<MatchDoctorsListResponse?> getMatchDoctorsList() async {
    try {
      final response = await apiClient.getMatchDoctorsList();
      return response.data;
    } on DioException catch (error) {
      if (kDebugMode) {
        print(
            'SpecialistDatasourceImpl - getMatchDoctorsList error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<BasePagingResponse<UserResponse>?> getPaginatedDoctorsList({
    String? specialization,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await apiClient.getDoctorsList(
        specialization: specialization,
        page: page,
        limit: limit,
      );
      return response;
    } on DioException catch (error) {
      if (kDebugMode) {
        print(
            'SpecialistDatasourceImpl - getPaginatedDoctorsList error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<UserResponse?> getUserDetailById(int userId) async {
    try {
      final response =
          await apiClient.getUserDetailById(userId: userId);
      return response.data;
    } on DioException catch (error) {
      if (kDebugMode) {
        print(
            'SpecialistDatasourceImpl - getUserDetailById error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<PrescriptionResponse?> createPrescription({
    required int appointmentId,
    required String prescriptionDate,
    required String notes,
  }) async {
    try {
      final request = CreatePrescriptionRequest(
        appointmentId: appointmentId,
        prescriptionDate: prescriptionDate,
        notes: notes,
      );
      final response = await apiClient.createPrescription(request);
      return response.data;
    } on DioException catch (error) {
      if (kDebugMode) {
        print(
            'SpecialistDatasourceImpl - createPrescription error: ${error.message}');
      }
      throw BaseErrorResponse.fromDioException(error);
    }
  }
}
