import 'package:json_annotation/json_annotation.dart';

part 'questionnaire_item.g.dart';

@JsonSerializable()
class QuestionnaireItem {
  @JsonKey(name: 'question')
  final String question;

  @JsonKey(name: 'options')
  final List<String> options;

  @JsonKey(name: 'answer')
  final dynamic answer; // Can be String or List<String>

  @JsonKey(name: 'key')
  final String key;

  QuestionnaireItem({
    required this.question,
    required this.options,
    required this.answer,
    required this.key,
  });

  factory QuestionnaireItem.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireItemFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireItemToJson(this);
}