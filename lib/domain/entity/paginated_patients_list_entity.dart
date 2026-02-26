import 'pagination_entity.dart';
import 'user_entity.dart';

class PaginatedPatientsListEntity {
  final List<UserEntity>? patients;
  final PaginationEntity? pagination;

  PaginatedPatientsListEntity({
    this.patients,
    this.pagination,
  });

  @override
  String toString() {
    return 'PaginatedPatientsListEntity{patients: ${patients?.length}, pagination: $pagination}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedPatientsListEntity &&
          runtimeType == other.runtimeType &&
          patients == other.patients &&
          pagination == other.pagination;

  @override
  int get hashCode => patients.hashCode ^ pagination.hashCode;
}

