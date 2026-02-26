import 'dart:io';

import 'package:recovery_consultation_app/data/api/response/file_response.dart';

import '../../api/request/add_questionnaires_request.dart';
import '../../api/request/update_profile_request.dart';
import '../../api/response/add_questionnaires_response.dart';
import '../../api/response/get_user_response.dart';
import '../../api/response/update_profile_response.dart';

abstract class UserDatasource {

  // ==================== PROFILE MANAGEMENT ====================

  /// Get current user information
  Future<GetUserResponse?> getUser();

  /// Update user profile with form data
  Future<UpdateProfileResponse?> updateProfile(
      UpdateProfileRequest updateProfileRequest);

  /// Submit questionnaire responses
  Future<AddQuestionnairesResponse?> addQuestionnaires(
      AddQuestionnairesRequest request);

  /// Upload file to server
  Future<FileResponse?> uploadFile(
      File file, String directory);    

}
