import 'package:recovery_consultation_app/data/api/request/add_questionnaires_request.dart';
import 'package:recovery_consultation_app/domain/entity/questionnaire_list_entity.dart';

import '../repositories/user_repository.dart';
import 'base_usecase.dart';

class AddQuestionnairesUseCase
    implements
        ParamUseCase<QuestionnaireListEntity?, AddQuestionnairesRequest> {
  final UserRepository repository;

  AddQuestionnairesUseCase({required this.repository});

  @override
  Future<QuestionnaireListEntity?> execute(
      AddQuestionnairesRequest params) async {
    final result = await repository.addQuestionnaires(params);
    return result;
  }
}
