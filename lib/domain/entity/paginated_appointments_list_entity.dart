import 'appointment_entity.dart';
import 'paginated_doctors_list_entity.dart';

class PaginatedAppointmentsListEntity {
  final List<AppointmentEntity>? appointments;
  final PaginationEntity? pagination;

  PaginatedAppointmentsListEntity({
    this.appointments,
    this.pagination,
  });

  @override
  String toString() {
    return 'PaginatedAppointmentsListEntity{appointments: ${appointments?.length}, pagination: $pagination}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedAppointmentsListEntity &&
          runtimeType == other.runtimeType &&
          appointments == other.appointments &&
          pagination == other.pagination;

  @override
  int get hashCode => appointments.hashCode ^ pagination.hashCode;
}