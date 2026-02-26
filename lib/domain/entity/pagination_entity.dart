/// Pagination info for paginated lists
class PaginationEntity {
  final int? total;
  final int? currentPage;
  final int? perPage;
  final int? lastPage;
  final int? from;
  final int? to;

  const PaginationEntity({
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
}
