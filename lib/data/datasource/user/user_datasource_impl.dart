import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:recovery_consultation_app/data/api/response/file_response.dart';
import 'package:recovery_consultation_app/data/datasource/user/user_datasource.dart';

import '../../api/api_client/api_client_type.dart';
import '../../api/request/add_questionnaires_request.dart';
import '../../api/request/update_profile_request.dart';
import '../../api/response/add_questionnaires_response.dart';
import '../../api/response/error_response.dart';
import '../../api/response/get_user_response.dart';
import '../../api/response/update_profile_response.dart';

class UserDatasourceImpl implements UserDatasource {
  UserDatasourceImpl({
    required this.apiClient,
  });

  final APIClientType apiClient;

  // ==================== PROFILE MANAGEMENT ====================

  @override
  Future<GetUserResponse?> getUser() async {
    try {
      debugPrint("🔍 DATASOURCE DEBUG: About to call get user API");

      final response = await apiClient.getUser();

      debugPrint("🔍 DATASOURCE DEBUG: Get user API call completed successfully");
      debugPrint("🔍 DATASOURCE DEBUG: Response data: ${response.data != null}");
      return response.data;
    } on DioException catch (error) {
      debugPrint("❌ DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse");
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<UpdateProfileResponse?> updateProfile(UpdateProfileRequest updateProfileRequest) async {
    try {
      debugPrint("🔍 DATASOURCE DEBUG: About to call update profile API");
      debugPrint("🔍 DATASOURCE DEBUG: Request - name: ${updateProfileRequest.name}");
      debugPrint("🔍 DATASOURCE DEBUG: Request - phone: ${updateProfileRequest.phone}");
      debugPrint("🔍 DATASOURCE DEBUG: Request - completed: ${updateProfileRequest.completed}");

      final response = await apiClient.updateProfile(updateProfileRequest);

      debugPrint("🔍 DATASOURCE DEBUG: Update profile API call completed successfully");
      debugPrint("🔍 DATASOURCE DEBUG: Response data: ${response.data != null}");
      return response.data;
    } on DioException catch (error) {
      debugPrint("❌ DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse");
      throw BaseErrorResponse.fromDioException(error);
    }
  }

  @override
  Future<AddQuestionnairesResponse?> addQuestionnaires(
      AddQuestionnairesRequest request) async {
    try {
      debugPrint("🔍 DATASOURCE DEBUG: About to call add questionnaires API");
      debugPrint("🔍 DATASOURCE DEBUG: Request - questionnaires count: ${request.questionnaires.length}");

      final response = await apiClient.addQuestionnaires(request);

      debugPrint("🔍 DATASOURCE DEBUG: Add questionnaires API call completed successfully");
      debugPrint("🔍 DATASOURCE DEBUG: Response data: ${response.data != null}");
      return response.data;
    } on DioException catch (error) {
      debugPrint("❌ DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse");
      throw BaseErrorResponse.fromDioException(error);
    }
  }

    @override
  Future<FileResponse?> uploadFile(
      File file, String directory) async {
    try {
      debugPrint("🔍 DATASOURCE DEBUG: About to call upload file API");

      final response = await apiClient.uploadFile(file, directory);

      debugPrint("🔍 DATASOURCE DEBUG: Upload File API call completed successfully");
      debugPrint("🔍 DATASOURCE DEBUG: Response data: ${response.data != null}");
      return response.data;
    } on DioException catch (error) {
      debugPrint("❌ DATASOURCE DEBUG: DioException caught - will be handled by BaseErrorResponse");
      throw BaseErrorResponse.fromDioException(error);
    }
  }

}
