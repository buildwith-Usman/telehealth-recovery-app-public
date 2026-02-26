import 'package:recovery_consultation_app/data/api/request/appointment_update_request.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/appointment_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

class UpdateAppointmentUseCase implements ParamUseCase<AppointmentEntity?, UpdateAppointmentParams> {
  final AppointmentRepository repository;

  UpdateAppointmentUseCase({required this.repository});

  @override
  Future<AppointmentEntity?> execute(UpdateAppointmentParams params) async {
    final request = AppointmentUpdateRequest(
      appointmentId: params.appointmentId,
      status: params.status,
    );
    return await repository.updateAppointment(request);
  }
}

class UpdateAppointmentParams {
  final int appointmentId;
  final String status;

  UpdateAppointmentParams({
    required this.appointmentId,
    required this.status,
  });

  @override
  String toString() {
    return 'UpdateAppointmentParams{appointmentId: $appointmentId, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateAppointmentParams &&
          runtimeType == other.runtimeType &&
          appointmentId == other.appointmentId &&
          status == other.status;

  @override
  int get hashCode => appointmentId.hashCode ^ status.hashCode;
}
