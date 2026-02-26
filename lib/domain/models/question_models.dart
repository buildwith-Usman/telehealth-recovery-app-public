
/// Core question-related models
/// Separated from questionnaire for better organization
library;

import '../enums/question_type.dart';

class QuestionOption {
  final String id;
  final String text;
  final String? description;

  const QuestionOption({
    required this.id,
    required this.text,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        if (description != null) 'description': description,
      };

  factory QuestionOption.fromJson(Map<String, dynamic> json) => QuestionOption(
        id: json['id'] as String,
        text: json['text'] as String,
        description: json['description'] as String?,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Question {
  final String id;
  final String title;
  final String? subtitle;
  final QuestionType type;
  final List<QuestionOption> options;
  final bool isRequired;
  final String? placeholder;
  final String? validationMessage;
  dynamic answer; // Can be String, List<String>, int, DateTime, etc.

  Question({
    required this.id,
    required this.title,
    this.subtitle,
    required this.type,
    this.options = const [],
    this.isRequired = false,
    this.placeholder,
    this.validationMessage,
    this.answer,
  });

  /// Validation logic - core to the Question model
  bool get isAnswered {
    if (answer == null) return false;
    if (answer is String) return (answer as String).isNotEmpty;
    if (answer is List) return (answer as List).isNotEmpty;
    return true;
  }

  bool get isValid {
    if (!isRequired) return true;
    return isAnswered;
  }

  /// Create a copy of this question with updated answer
  Question copyWithAnswer(dynamic newAnswer) {
    return Question(
      id: id,
      title: title,
      subtitle: subtitle,
      type: type,
      options: options,
      isRequired: isRequired,
      placeholder: placeholder,
      validationMessage: validationMessage,
      answer: newAnswer,
    );
  }

  /// Update the answer for this question (returns new instance)
  Question updateAnswer(dynamic newAnswer) {
    return copyWithAnswer(newAnswer);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        if (subtitle != null) 'subtitle': subtitle,
        'type': type.name,
        'options': options.map((o) => o.toJson()).toList(),
        'isRequired': isRequired,
        if (placeholder != null) 'placeholder': placeholder,
        if (validationMessage != null) 'validationMessage': validationMessage,
        if (answer != null) 'answer': answer,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String?,
        type: QuestionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => QuestionType.textInput,
        ),
        options: (json['options'] as List<dynamic>? ?? [])
            .map((o) => QuestionOption.fromJson(o as Map<String, dynamic>))
            .toList(),
        isRequired: json['isRequired'] as bool? ?? false,
        placeholder: json['placeholder'] as String?,
        validationMessage: json['validationMessage'] as String?,
        answer: json['answer'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          answer == other.answer; // ← Include answer in equality check

  @override
  int get hashCode => Object.hash(id, answer); // ← Include answer in hashCode
}