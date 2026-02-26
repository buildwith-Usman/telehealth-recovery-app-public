import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/data/api/response/user_response.dart';
import 'package:recovery_consultation_app/data/mapper/match_doctors_list_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/paginated_mapper.dart';
import 'package:recovery_consultation_app/data/mapper/user_mapper.dart';
import 'package:recovery_consultation_app/domain/entity/match_doctors_list_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import '../../data/api/response/error_response.dart';
import '../../data/mapper/exception_mapper.dart';
import '../../domain/entity/error_entity.dart';
import '../../domain/repositories/specialist_repository.dart';
import '../datasource/specialist/specialist_datasource.dart';

class SpecialistRepositoryImpl extends SpecialistRepository {
  SpecialistRepositoryImpl({required this.specialistDatasource});

  final SpecialistDatasource specialistDatasource;

  @override
  Future<MatchDoctorsListEntity> getMatchDoctorsList() async {
    try {
      final response = await specialistDatasource.getMatchDoctorsList();
      if (response != null) {
        return MatchDoctorsListMapper.toEntity(response);
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print(
            'SpecialistRepositoryImpl - getMatchDoctorsList error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }

  @override
  Future<PaginatedListEntity<UserEntity>> getPaginatedDoctorsList({
    String? specialization,
    int? page,
    int? limit,
  }) async {
    try {
      final response = await specialistDatasource.getPaginatedDoctorsList(
        specialization: specialization,
        page: page,
        limit: limit,
      );
      if (response != null) {
        return PaginatedMapper.toEntity<UserEntity, UserResponse>(
          response: response,
          fromResponse: (r) => UserMapper.toUserEntity(r),
        );
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print(
            'SpecialistRepositoryImpl - getPaginatedDoctorsList error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }

  @override
  Future<UserEntity> getUserDetailById(int userId) async {
    try {
      final response =
          await specialistDatasource.getUserDetailById(userId);
      if (response != null) {
        return UserMapper.toUserEntity(response);
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print(
            'SpecialistRepositoryImpl - getUserDetailById error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }

  @override
  Future<bool> createPrescription({
    required int appointmentId,
    required String prescriptionDate,
    required String notes,
  }) async {
    try {
      final response = await specialistDatasource.createPrescription(
        appointmentId: appointmentId,
        prescriptionDate: prescriptionDate,
        notes: notes,
      );
      // Return true if prescription was created successfully
      return response != null;
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print(
            'SpecialistRepositoryImpl - createPrescription error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }
}
