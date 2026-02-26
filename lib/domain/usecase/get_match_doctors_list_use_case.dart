import 'package:recovery_consultation_app/domain/entity/match_doctors_list_entity.dart';
import 'package:recovery_consultation_app/domain/repositories/specialist_repository.dart';

import 'base_usecase.dart';

class GetMatchDoctorsListUseCase implements NoParamUseCase<MatchDoctorsListEntity?> {
  final SpecialistRepository repository;

  GetMatchDoctorsListUseCase({required this.repository});

  @override
  Future<MatchDoctorsListEntity?> execute() async {
    final result = await repository.getMatchDoctorsList();
    return result;
  }
}
