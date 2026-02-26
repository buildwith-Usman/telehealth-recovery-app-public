import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';
import 'package:recovery_consultation_app/domain/usecase/base_usecase.dart';

class GetPaginatedAdminUserListUseCase implements ParamUseCase<PaginatedListEntity<UserEntity>?, GetPaginatedAdminUserListParams> {
  final AdminRepository repository;

  GetPaginatedAdminUserListUseCase({required this.repository});

  @override
  Future<PaginatedListEntity<UserEntity>?> execute(GetPaginatedAdminUserListParams params) async {
    return await repository.getPaginatedUserList(
      specialization: params.specialization,
      type: params.type,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetPaginatedAdminUserListParams {
  final String? specialization;
  final String? type;
  final int? page;
  final int? limit;

  GetPaginatedAdminUserListParams({
    this.specialization,
    this.type,
    this.page,
    this.limit,
  });

  // Helper method to create params with defaults
  factory GetPaginatedAdminUserListParams.withDefaults({
    String? specialization,
    int page = 1,
    int limit = 20,
  }) {
    return GetPaginatedAdminUserListParams(
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
      other is GetPaginatedAdminUserListParams &&
          runtimeType == other.runtimeType &&
          specialization == other.specialization &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => specialization.hashCode ^ page.hashCode ^ limit.hashCode;
}