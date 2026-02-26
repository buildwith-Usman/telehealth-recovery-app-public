import '../../../domain/models/questionnaire_models.dart';
import '../../api/request/add_questionnaires_request.dart';
import '../../api/response/add_questionnaires_response.dart';

abstract class QuestioniareDatasource {

  /// Submit questionnaire responses
  Future<AddQuestionnairesResponse?> addQuestionnaires(
      AddQuestionnairesRequest request);

  /// Load questionnaire data
  Future<Questionnaire> getQuestionnaire();

}
