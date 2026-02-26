import 'pagination_entity.dart';

/// A generic paginated list entity that can hold any type of data.
/// Example usage:
///   PaginatedListEntity<UserEntity>
///   PaginatedListEntity<DoctorEntity>
class PaginatedListEntity<T> {
  final List<T> data;
  final PaginationEntity? pagination;

  const PaginatedListEntity({
    this.data = const [],
    this.pagination,
  });

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
}
