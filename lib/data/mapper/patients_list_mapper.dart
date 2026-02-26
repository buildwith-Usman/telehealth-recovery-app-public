import 'package:recovery_consultation_app/data/api/response/base_response.dart';
import 'package:recovery_consultation_app/data/api/response/user_response.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_patients_list_entity.dart';
import 'package:recovery_consultation_app/domain/entity/pagination_entity.dart';
import 'package:recovery_consultation_app/data/mapper/user_mapper.dart';

class PatientsListMapper {
  static PaginatedPatientsListEntity toEntity(BasePagingResponse<UserResponse> response) {
    return PaginatedPatientsListEntity(
      patients: response.data?.map((userResponse) => UserMapper.toUserEntity(userResponse)).toList(),
      pagination: response.total != null || response.currentPage != null
          ? PaginationEntity(
              total: response.total,
              currentPage: response.currentPage,
              perPage: response.perPage,
              lastPage: response.lastPage,
              from: response.from,
              to: response.to,
            )
          : null,
    );
  }
}

