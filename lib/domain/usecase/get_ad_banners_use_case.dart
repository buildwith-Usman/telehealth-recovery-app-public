import 'package:recovery_consultation_app/domain/entity/ad_banner_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/repositories/admin_repository.dart';

class GetAdBannersParams {
  final int? limit;
  final int? page;
  final String? dateFrom;
  final String? dateTo;

  GetAdBannersParams({
    this.limit,
    this.page,
    this.dateFrom,
    this.dateTo,
  });
}

class GetAdBannersUseCase {
  final AdminRepository repository;

  GetAdBannersUseCase({required this.repository});

  Future<PaginatedListEntity<AdBannerEntity>> execute(GetAdBannersParams params) async {
    return await repository.getAdBannersList(
      limit: params.limit,
      page: params.page,
      dateFrom: params.dateFrom,
      dateTo: params.dateTo,
    );
  }
}
