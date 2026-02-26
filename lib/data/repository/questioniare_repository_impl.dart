import 'package:recovery_consultation_app/data/datasource/questioniare/questioniare_datasource.dart';
import 'package:recovery_consultation_app/domain/entity/questionnaire_list_entity.dart';
import '../../domain/entity/error_entity.dart';
import '../../domain/models/questionnaire_models.dart';
import '../../domain/repositories/questioniare_repository.dart';
import '../api/request/add_questionnaires_request.dart';
import '../api/response/error_response.dart';
import '../mapper/questionnaires_list_mapper.dart';
import '../mapper/exception_mapper.dart';

class QuestioniareRepositoryImpl extends QuestioniareRepository {
  QuestioniareRepositoryImpl({required this.questioniareDatasource});

  final QuestioniareDatasource questioniareDatasource;

  @override
  Future<QuestionnaireListEntity?> addQuestionnaires(
      AddQuestionnairesRequest request) async {
    try {
      final response = await questioniareDatasource.addQuestionnaires(request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      } else {
        final addQuestionnairesEntity =
            QuestionnairesListMapper.toAddQuestionnairesEntity(response);
        return addQuestionnairesEntity;
      }
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }

  @override
  Future<Questionnaire> getQuestionnaire() async {
    try {
      final questionnaire = await questioniareDatasource.getQuestionnaire();
      return questionnaire;
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    } catch (error) {
      throw BaseErrorEntity.noData();
    }
  }
}
