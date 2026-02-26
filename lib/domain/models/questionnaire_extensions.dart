import 'questionnaire_model.dart';
import 'question_models.dart';

/// Extension methods for Questionnaire domain model
/// These are domain-level utilities that belong with the model
extension QuestionnaireExtensions on Questionnaire {
  
  /// Get all required questions from this questionnaire
  List<Question> get requiredQuestions {
    return questions.where((q) => q.isRequired).toList();
  }

  /// Get all unanswered required questions
  List<Question> get unansweredRequiredQuestions {
    return requiredQuestions.where((q) => !q.isAnswered).toList();
  }

  /// Check if questionnaire is complete (all questions answered)
  bool get isComplete {
    return questions.every((q) => q.isValid);
  }

  /// Get validation errors for the questionnaire
  List<String> get validationErrors {
    final errors = <String>[];
    
    if (unansweredRequiredQuestions.isNotEmpty) {
      errors.add('Please answer ${unansweredRequiredQuestions.length} required questions');
    }
    
    return errors;
  }

  /// Get question by ID
  Question? getQuestionById(String questionId) {
    try {
      return questions.firstWhere((q) => q.id == questionId);
    } catch (e) {
      return null;
    }
  }

  /// Extract answers as a map
  Map<String, dynamic> get answersMap {
    final answers = <String, dynamic>{};
    
    for (final question in questions) {
      if (question.answer != null) {
        answers[question.id] = question.answer;
      }
    }
    
    return answers;
  }

  /// Update answer for a specific question (returns new instance)
  Questionnaire updateQuestionAnswer(String questionId, dynamic answer) {
    print('📋 EXTENSIONS: updateQuestionAnswer called - questionId: $questionId, answer: $answer');
    print('📋 EXTENSIONS: Current questionnaire has ${questions.length} questions');
    
    final updatedQuestions = questions.map((question) {
      if (question.id == questionId) {
        print('📋 EXTENSIONS: Found matching question: "${question.title}"');
        print('📋 EXTENSIONS: Original answer: ${question.answer}');
        
        final updatedQuestion = question.copyWithAnswer(answer);
        print('📋 EXTENSIONS: Updated answer: ${updatedQuestion.answer}');
        return updatedQuestion;
      }
      return question;
    }).toList();

    final newQuestionnaire = copyWith(questions: updatedQuestions);
    print('📋 EXTENSIONS: Created new questionnaire with ${newQuestionnaire.questions.length} questions');
    
    // Verify the update worked
    final verifyQuestion = newQuestionnaire.questions.firstWhere((q) => q.id == questionId, orElse: () => questions.first);
    print('📋 EXTENSIONS: Verification - question $questionId answer is now: ${verifyQuestion.answer}');
    
    return newQuestionnaire;
  }

  /// Clear answer for a specific question (returns new instance)
  Questionnaire clearAnswer(String questionId) {
    return updateQuestionAnswer(questionId, null);
  }
}

/// Extension methods for Question domain model
extension QuestionExtensions on Question {
  
  /// Validate this question and return errors
  List<String> get validationErrors {
    final errors = <String>[];
    
    if (isRequired && !isAnswered) {
      errors.add(validationMessage ?? '$title is required');
    }
    
    return errors;
  }
}

/// Utility methods for questionnaire navigation/flow
/// These are controller helper methods, not domain logic
class QuestionnaireFlowHelper {
  
  /// Check if can proceed to next question (UI flow logic)
  static bool canProceedToNext(
    Questionnaire questionnaire, 
    int currentIndex, 
    {bool requireAnswerToAdvance = false}
  ) {
    if (currentIndex >= questionnaire.questions.length - 1) return false;
    
    if (!requireAnswerToAdvance) return true;
    
    final currentQuestion = questionnaire.questions[currentIndex];
    return currentQuestion.isValid;
  }

  /// Get current question by index (UI helper)
  static Question? getCurrentQuestion(Questionnaire questionnaire, int index) {
    if (index < 0 || index >= questionnaire.questions.length) {
      return null;
    }
    return questionnaire.questions[index];
  }

  /// Calculate progress percentage (UI helper)
  static double calculateProgress(Questionnaire questionnaire, int currentIndex) {
    if (questionnaire.questions.isEmpty) return 0.0;
    return (currentIndex + 1) / questionnaire.questions.length;
  }
}
