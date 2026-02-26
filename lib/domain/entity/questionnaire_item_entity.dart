import 'package:recovery_consultation_app/domain/entity/base_entity.dart';

class QuestionnaireItemEntity extends BaseEntity {
  final int? userId;
  final String? question;
  final List<String> options; // available options for multiple choice
  final List<String> answers; // selected answers
  final String? key;

  const QuestionnaireItemEntity({
    required super.id,
    this.userId,
    this.question,
    this.options = const [],
    this.answers = const [],
    this.key,
    super.createdAt,
    super.updatedAt,
  });

  /// Create a copy with modified fields (useful for state updates)
  QuestionnaireItemEntity copyWith({
    int? id,
    int? userId,
    String? question,
    List<String>? options,
    List<String>? answers,
    String? key,
    String? createdAt,
    String? updatedAt,
  }) {
    return QuestionnaireItemEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      question: question ?? this.question,
      options: options ?? this.options,
      answers: answers ?? this.answers,
      key: key ?? this.key,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts a comma-separated answer string into a list
  factory QuestionnaireItemEntity.fromAnswerString({
    required int id,
    required int userId,
    required String key,
    required String answer,
    String? createdAt,
    String? updatedAt,
  }) {
    return QuestionnaireItemEntity(
      id: id,
      userId: userId,
      key: key,
      answers: answer.split(',').where((s) => s.isNotEmpty).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  String toString() {
    return 'QuestioniareItemEntityEntity(id: $id, userId: $userId, question: $question, options: $options, answers: $answers, key: $key, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}