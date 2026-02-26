import '../../data/api/request/appointment_booking_request.dart';
import '../entity/appointment_booking_entity.dart';
import '../repositories/appointment_repository.dart';
import 'base_usecase.dart';

class BookAppointmentUseCase implements ParamUseCase<AppointmentBookingResponseEntity?, AppointmentBookingRequest> {
  final AppointmentRepository repository;

  BookAppointmentUseCase({required this.repository});

  @override
  Future<AppointmentBookingResponseEntity?> execute(AppointmentBookingRequest params) async {
    final appointmentEntity = await repository.bookAppointment(params);
    return appointmentEntity;
  }
  
}