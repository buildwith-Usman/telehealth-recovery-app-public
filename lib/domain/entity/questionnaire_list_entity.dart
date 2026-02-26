import 'package:recovery_consultation_app/domain/entity/questionnaire_item_entity.dart';

class QuestionnaireListEntity {
  final List<QuestionnaireItemEntity> items;

  const QuestionnaireListEntity({
    this.items = const [],
  });

  @override
  String toString() => 'QuestionnairesEntity(items: $items)';
}