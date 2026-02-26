import 'package:json_annotation/json_annotation.dart';

part 'add_questionnaires_response.g.dart';

@JsonSerializable()
class AddQuestionnairesResponse {
  @JsonKey(name: 'questionnaires')
  final List<QuestionnaireItemResponse>? questionnaires;

  AddQuestionnairesResponse({
    this.questionnaires,
  });

  factory AddQuestionnairesResponse.fromJson(Map<String, dynamic> json) =>
      _$AddQuestionnairesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddQuestionnairesResponseToJson(this);

  // Helper methods to work with questionnaires
  QuestionnaireItemResponse? getQuestionnaireByKey(String key) =>
      questionnaires?.firstWhere(
        (q) => q.key == key,
        orElse: () => QuestionnaireItemResponse(),
      );

  List<QuestionnaireItemResponse> get validQuestionnaires =>
      questionnaires?.where((q) => q.key != null).toList() ?? [];

  // Get specific questionnaire responses
  QuestionnaireItemResponse? get genderPreference =>
      getQuestionnaireByKey('gender_prefer');
  QuestionnaireItemResponse? get agePreference =>
      getQuestionnaireByKey('age_prefer');
  QuestionnaireItemResponse? get languagePreference =>
      getQuestionnaireByKey('lang_prefer');
  QuestionnaireItemResponse? get ageGroupPreference =>
      getQuestionnaireByKey('age_group_prefer');
  QuestionnaireItemResponse? get helpSupportPreference =>
      getQuestionnaireByKey('help_support');
  QuestionnaireItemResponse? get preferredDay =>
      getQuestionnaireByKey('preferred_day');
  QuestionnaireItemResponse? get preferredTime =>
      getQuestionnaireByKey('preferred_time');
}

@JsonSerializable()
class QuestionnaireItemResponse {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'user_id')
  final int? userId;

  @JsonKey(name: 'question')
  final String? question;

  @JsonKey(name: 'options')
  final String? options; // Comma-separated string

  @JsonKey(name: 'answer')
  final String? answer; // Can be single value or comma-separated

  @JsonKey(name: 'key')
  final String? key;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  QuestionnaireItemResponse({
    this.id,
    this.userId,
    this.question,
    this.options,
    this.answer,
    this.key,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionnaireItemResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionnaireItemResponseToJson(this);

  // Helper methods to convert comma-separated strings to lists
  List<String> get optionsList =>
      options
          ?.split(',')
          .where((s) => s.trim().isNotEmpty)
          .map((s) => s.trim())
          .toList() ??
      [];

  List<String> get answersList =>
      answer
          ?.split(',')
          .where((s) => s.trim().isNotEmpty)
          .map((s) => s.trim())
          .toList() ??
      [];

  // Helper methods for specific questionnaire types
  bool get isMultipleChoice => answersList.length > 1;

  bool get isSingleChoice => answersList.length == 1;

  String get singleAnswer => answersList.isNotEmpty ? answersList.first : '';

  // Helper methods for specific questionnaire keys
  bool get isGenderPreference => key == 'gender_prefer';

  bool get isAgePreference => key == 'age_prefer';

  bool get isLanguagePreference => key == 'lang_prefer';

  bool get isAgeGroupPreference => key == 'age_group_prefer';

  bool get isHelpSupportPreference => key == 'help_support';

  bool get isPreferredDay => key == 'preferred_day';

  bool get isPreferredTime => key == 'preferred_time';

  // Get formatted display text for answers
  String get formattedAnswers => answersList.join(', ');

  // Check if a specific option is selected
  bool isOptionSelected(String option) =>
      answersList.any((answer) => answer.toLowerCase() == option.toLowerCase());
}
