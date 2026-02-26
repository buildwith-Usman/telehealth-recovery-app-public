import 'dart:io';

import 'package:recovery_consultation_app/domain/entity/file_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import '../../data/api/request/add_questionnaires_request.dart';
import '../../data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/domain/entity/questionnaire_list_entity.dart';
import '../entity/update_profile_entity.dart';

abstract class UserRepository {
  // ==================== PROFILE MANAGEMENT ====================

  /// Get current user information
  Future<UserEntity?> getUser();

  /// Update user profile
  Future<UpdateProfileEntity?> updateProfile(
      UpdateProfileRequest updateProfileRequest);

  /// Submit questionnaire responses
  Future<QuestionnaireListEntity?> addQuestionnaires(
      AddQuestionnairesRequest request);

  /// Upload File
  Future<FileEntity?> uploadFile(
      File file, String directory);
}
