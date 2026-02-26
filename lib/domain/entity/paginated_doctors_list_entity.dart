import 'doctors_list_entity.dart';

class PaginatedDoctorsListEntity {
  final List<DoctorEntity>? doctors;
  final PaginationEntity? pagination;

  PaginatedDoctorsListEntity({
    this.doctors,
    this.pagination,
  });

  @override
  String toString() {
    return 'PaginatedDoctorsListEntity{doctors: ${doctors?.length}, pagination: $pagination}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedDoctorsListEntity &&
          runtimeType == other.runtimeType &&
          doctors == other.doctors &&
          pagination == other.pagination;

  @override
  int get hashCode => doctors.hashCode ^ pagination.hashCode;
}

class PaginationEntity {
  final int? total;
  final int? currentPage;
  final int? perPage;
  final int? lastPage;
  final int? from;
  final int? to;

  PaginationEntity({
    this.total,
    this.currentPage,
    this.perPage,
    this.lastPage,
    this.from,
    this.to,
  });

  bool get hasNextPage => currentPage != null && lastPage != null && currentPage! < lastPage!;
  bool get hasPreviousPage => currentPage != null && currentPage! > 1;
  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == lastPage;

  @override
  String toString() {
    return 'PaginationEntity{total: $total, currentPage: $currentPage, perPage: $perPage, lastPage: $lastPage, from: $from, to: $to}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginationEntity &&
          runtimeType == other.runtimeType &&
          total == other.total &&
          currentPage == other.currentPage &&
          perPage == other.perPage &&
          lastPage == other.lastPage &&
          from == other.from &&
          to == other.to;

  @override
  int get hashCode =>
      total.hashCode ^
      currentPage.hashCode ^
      perPage.hashCode ^
      lastPage.hashCode ^
      from.hashCode ^
      to.hashCode;
}


