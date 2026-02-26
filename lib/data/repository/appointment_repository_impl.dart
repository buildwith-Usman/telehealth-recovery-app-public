import 'package:recovery_consultation_app/data/api/request/appointment_booking_request.dart';
import 'package:recovery_consultation_app/data/api/request/appointment_update_request.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entity/appointment_booking_entity.dart';
import '../../domain/entity/appointment_entity.dart';
import '../../domain/entity/paginated_appointments_list_entity.dart';
import '../../domain/entity/error_entity.dart';
import '../../domain/repositories/appointment_repository.dart';
import '../api/response/error_response.dart';
import '../datasource/appointment/appointment_datasource.dart';
import '../mapper/appointment_booking_mapper.dart';
import '../mapper/appointments_list_mapper.dart';
import '../mapper/exception_mapper.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  AppointmentRepositoryImpl({required this.appointmentDatasource});

  final AppointmentDatasource appointmentDatasource;

  @override
  Future<AppointmentBookingResponseEntity?> bookAppointment(
      AppointmentBookingRequest request) async {
    try {
      final response = await appointmentDatasource.bookAppointment(request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final appointmentBookingEntity = AppointmentBookingMapper.toAppointmentBookingResponseEntity(response);
        return appointmentBookingEntity;
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<PaginatedAppointmentsListEntity> getAppointmentsList({
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
      final response = await appointmentDatasource.getAppointmentsList(
        type: type,
        status: status,
        doctorUserId: doctorUserId,
        patientUserId: patientUserId,
        dateFrom: dateFrom,
        dateTo: dateTo,
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
        print('AppointmentRepositoryImpl - getAppointmentsList error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }

  @override
  Future<AppointmentEntity?> getAppointmentDetail({
    required int appointmentId,
  }) async {
    try {
      final response = await appointmentDatasource.getAppointmentDetail(
        appointmentId: appointmentId,
      );
      if (response != null) {
        return AppointmentsListMapper.toAppointmentEntity(response);
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print('AppointmentRepositoryImpl - getAppointmentDetail error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }

  @override
  Future<AppointmentEntity?> updateAppointment(AppointmentUpdateRequest request) async {
    try {
      final response = await appointmentDatasource.updateAppointment(request);
      if (response != null) {
        return AppointmentsListMapper.toAppointmentEntity(response);
      } else {
        throw BaseErrorEntity.noData();
      }
    } on BaseErrorResponse catch (e) {
      if (kDebugMode) {
        print('AppointmentRepositoryImpl - updateAppointment error: ${e.statusMessage}');
      }
      throw ExceptionMapper.toBaseErrorEntity(e);
    }
  }
}
