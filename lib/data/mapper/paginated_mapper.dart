// paginated_mapper.dart
import 'package:recovery_consultation_app/data/api/response/base_response.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/pagination_entity.dart';


class PaginatedMapper {
  static PaginatedListEntity<T> toEntity<T, R>({
    required BasePagingResponse<R> response,
    required T Function(R) fromResponse,
  }) {
    final items = response.data?.map(fromResponse).toList() ?? const [];

    final pagination = PaginationEntity(
      total: response.total,
      currentPage: response.currentPage,
      perPage: response.perPage,
      lastPage: response.lastPage,
      from: response.from,
      to: response.to,
    );

    return PaginatedListEntity<T>(
      data: items,
      pagination: pagination,
    );
  }
}
