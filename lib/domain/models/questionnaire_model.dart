import 'package:collection/collection.dart';
import 'question_models.dart';

/// Simplified Questionnaire model focused on core data structure
/// Business logic moved to QuestionnaireService
class Questionnaire {
  final String id;
  final String title;
  final String? description;
  final List<Question> questions;
  final Map<String, dynamic> metadata;

  const Questionnaire({
    required this.id,
    required this.title,
    this.description,
    required this.questions,
    this.metadata = const {},
  });

  /// Basic progress calculation (kept as it's core to the data structure)
  double get progress {
    if (questions.isEmpty) return 0.0;
    final answeredQuestions = questions.where((q) => q.isAnswered).length;
    return answeredQuestions / questions.length;
  }

  /// Essential validation check (kept as it's fundamental to the model)
  bool get canSubmit {
    final requiredQuestions = questions.where((q) => q.isRequired);
    return requiredQuestions.every((q) => q.isAnswered);
  }

  /// Create a copy with updated questions
  Questionnaire copyWith({
    String? id,
    String? title,
    String? description,
    List<Question>? questions,
    Map<String, dynamic>? metadata,
  }) {
    return Questionnaire(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        if (description != null) 'description': description,
        'questions': questions.map((q) => q.toJson()).toList(),
        'metadata': metadata,
      };

  factory Questionnaire.fromJson(Map<String, dynamic> json) => Questionnaire(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        questions: (json['questions'] as List<dynamic>? ?? [])
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList(),
        metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      );

  @override
  int get hashCode => Object.hash(id, questions.hashCode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Questionnaire &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          const ListEquality().equals(questions, other.questions);
}

