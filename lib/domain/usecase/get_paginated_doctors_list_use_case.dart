import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/specialist_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

class GetPaginatedDoctorsListUseCase implements ParamUseCase<PaginatedListEntity<UserEntity>?, GetPaginatedDoctorsListParams> {
  final SpecialistRepository repository;

  GetPaginatedDoctorsListUseCase({required this.repository});

  @override
  Future<PaginatedListEntity<UserEntity>?> execute(GetPaginatedDoctorsListParams params) async {
    return await repository.getPaginatedDoctorsList(
      specialization: params.specialization,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetPaginatedDoctorsListParams {
  final String? specialization;
  final int? page;
  final int? limit;

  GetPaginatedDoctorsListParams({
    this.specialization,
    this.page,
    this.limit,
  });

  // Helper method to create params with defaults
  factory GetPaginatedDoctorsListParams.withDefaults({
    String? specialization,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedDoctorsListParams(
      specialization: specialization,
      page: page,
      limit: limit,
    );
  }

  @override
  String toString() {
    return 'GetPaginatedDoctorsListParams{specialization: $specialization, page: $page, limit: $limit}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetPaginatedDoctorsListParams &&
          runtimeType == other.runtimeType &&
          specialization == other.specialization &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => specialization.hashCode ^ page.hashCode ^ limit.hashCode;
}