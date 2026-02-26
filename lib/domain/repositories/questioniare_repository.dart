import 'package:recovery_consultation_app/domain/entity/questionnaire_list_entity.dart';

import '../../data/api/request/add_questionnaires_request.dart';
import '../models/questionnaire_models.dart';

abstract class QuestioniareRepository {
  
  /// Submit questionnaire responses
  Future<QuestionnaireListEntity?> addQuestionnaires(
      AddQuestionnairesRequest request);

  /// Load questionnaire
  Future<Questionnaire> getQuestionnaire();

}
