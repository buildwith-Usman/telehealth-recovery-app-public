import 'package:recovery_consultation_app/domain/entity/questionnaire_item_entity.dart';
import 'package:recovery_consultation_app/domain/entity/questionnaire_list_entity.dart';

import '../../data/api/response/add_questionnaires_response.dart';

class QuestionnairesListMapper {
  static QuestionnaireListEntity toAddQuestionnairesEntity(
    AddQuestionnairesResponse response,
  ) {
    return QuestionnaireListEntity(
      items: response.questionnaires
              ?.map((item) => toQuestionnaireItemEntity(item))
              .toList() ??
          [],
    );
  }

  static QuestionnaireItemEntity toQuestionnaireItemEntity(
    QuestionnaireItemResponse response,
  ) {
    return QuestionnaireItemEntity(
      id: response.id ?? 0,
      userId: response.userId,
      question: response.question,
      options: response.optionsList,
      answers: response.answersList,
      key: response.key,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  /// Utility function to split comma-separated strings safely
  static List<String> splitCommaSeparated(String? value) {
    if (value == null || value.isEmpty) return [];
    return value
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
