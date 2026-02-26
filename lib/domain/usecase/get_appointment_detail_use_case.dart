import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/appointment_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

class GetAppointmentDetailUseCase implements ParamUseCase<AppointmentEntity?, GetAppointmentDetailParams> {
  final AppointmentRepository repository;

  GetAppointmentDetailUseCase({required this.repository});

  @override
  Future<AppointmentEntity?> execute(GetAppointmentDetailParams params) async {
    return await repository.getAppointmentDetail(
      appointmentId: params.appointmentId,
    );
  }
}

class GetAppointmentDetailParams {
  final int appointmentId;

  GetAppointmentDetailParams({
    required this.appointmentId,
  });

  @override
  String toString() {
    return 'GetAppointmentDetailParams{appointmentId: $appointmentId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetAppointmentDetailParams &&
          runtimeType == other.runtimeType &&
          appointmentId == other.appointmentId;

  @override
  int get hashCode => appointmentId.hashCode;
}
