import 'package:json_annotation/json_annotation.dart';
import 'questionnaire_item.dart';

part 'add_questionnaires_request.g.dart';

@JsonSerializable()
class AddQuestionnairesRequest {
  @JsonKey(name: 'questionnaires')
  final List<QuestionnaireItem> questionnaires;

  AddQuestionnairesRequest({
    required this.questionnaires,
  });

  factory AddQuestionnairesRequest.fromJson(Map<String, dynamic> json) =>
      _$AddQuestionnairesRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddQuestionnairesRequestToJson(this);
}
