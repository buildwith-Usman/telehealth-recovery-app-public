import 'package:recovery_consultation_app/domain/models/questionnaire_models.dart';
import 'package:recovery_consultation_app/domain/repositories/questioniare_repository.dart';
import 'base_usecase.dart';

/// Use Case for loading questionnaire data
/// Follows Clean Architecture: Use Case → Repository → Data Source
class LoadQuestionnaireUseCase implements NoParamUseCase<Questionnaire?> {
  final QuestioniareRepository repository;

  LoadQuestionnaireUseCase({required this.repository});

  @override
  Future<Questionnaire> execute() async {

    // Delegate to repository layer
    final questionnaire = await repository.getQuestionnaire();
    // Business validation: ensure questionnaire has questions
    if (questionnaire.questions.isEmpty) {
      throw StateError('Questionnaire must have at least one question');
    }

    return questionnaire;
  }
}

