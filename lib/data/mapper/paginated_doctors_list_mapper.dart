import 'package:recovery_consultation_app/data/api/response/base_response.dart';
import 'package:recovery_consultation_app/data/api/response/doctor_user_response.dart';
import 'package:recovery_consultation_app/data/mapper/doctors_list_mapper.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_doctors_list_entity.dart';

class PaginatedDoctorsListMapper {
  static PaginatedDoctorsListEntity toEntity(BasePagingResponse<DoctorUserResponse> response) {
    return PaginatedDoctorsListEntity(
      doctors: response.data?.map((doctorResponse) => DoctorsListMapper.toDoctorEntity(doctorResponse)).toList(),
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