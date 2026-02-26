import 'dart:io';

import 'package:recovery_consultation_app/data/datasource/user/user_datasource.dart';
import 'package:recovery_consultation_app/data/mapper/file_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/user_mapper.dart';
import 'package:recovery_consultation_app/domain/entity/questionnaire_list_entity.dart';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/user_repository.dart';
import '../../domain/entity/error_entity.dart';
import '../../domain/entity/update_profile_entity.dart';
import '../api/request/add_questionnaires_request.dart';
import '../api/request/update_profile_request.dart';
import '../api/response/error_response.dart';
import '../mapper/questionnaires_list_mapper.dart';
import '../mapper/exception_mapper.dart';
import '../mapper/update_profile_mapper.dart';

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl({required this.userDatasource});

  final UserDatasource userDatasource;

  // ==================== PROFILE MANAGEMENT ====================

  @override
  Future<UserEntity?> getUser() async {
    try {
      final response = await userDatasource.getUser();
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        
        final userEntity = UserMapper.toUserEntity(response.user);
        return userEntity;
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<UpdateProfileEntity?> updateProfile(
      UpdateProfileRequest updateProfileRequest) async {
    try {
      final response = await userDatasource.updateProfile(updateProfileRequest);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final updateProfileEntity =
            UpdateProfileMapper.toUpdateProfileEntity(response);
        return updateProfileEntity;
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<QuestionnaireListEntity?> addQuestionnaires(
      AddQuestionnairesRequest request) async {
    try {
      final response = await userDatasource.addQuestionnaires(request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final addQuestionnairesEntity =
            QuestionnairesListMapper.toAddQuestionnairesEntity(response);
        return addQuestionnairesEntity;
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

    @override
  Future<FileEntity?> uploadFile(
      File file, String directory) async {
    try {
      final response = await userDatasource.uploadFile(file, directory);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final uploadFileEntity =
            FileMapper.toFileEntity(response.file!);
        return uploadFileEntity;
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

}
