import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/data/api/request/add_questionnaires_request.dart';
import 'package:recovery_consultation_app/domain/entity/questionnaire_list_entity.dart';
import 'package:recovery_consultation_app/domain/models/questionnaire_models.dart';
import 'package:recovery_consultation_app/domain/models/questionnaire_extensions.dart';
import 'package:recovery_consultation_app/domain/usecase/add_questionnaires_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/load_questionnaire_use_case.dart';

import '../../data/api/request/questionnaire_item.dart';

class QuestionnaireController extends BaseController {
  QuestionnaireController({
    required this.addQuestionnairesUseCase,
    required this.loadQuestionnaireUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final AddQuestionnairesUseCase addQuestionnairesUseCase;
  final LoadQuestionnaireUseCase loadQuestionnaireUseCase;

  // ==================== OBSERVABLES ====================
  final _currentQuestionIndex = 0.obs;
  final _questionnaire = Rx<Questionnaire?>(null);
  final _canSwipe = true.obs;
  final _requireAnswerToAdvance = false.obs;
  final PageController pageController = PageController();

  // ==================== GETTERS ====================
  int get currentQuestionIndex => _currentQuestionIndex.value;
  RxInt get currentQuestionIndexRx => _currentQuestionIndex;
  Questionnaire? get questionnaire => _questionnaire.value;
  Rx<Questionnaire?> get questionnaireRx => _questionnaire;
  bool get canSwipe => _canSwipe.value;
  bool get requireAnswerToAdvance => _requireAnswerToAdvance.value;

  Question? get currentQuestion {
    if (questionnaire == null) return null;
    return QuestionnaireFlowHelper.getCurrentQuestion(
        questionnaire!, currentQuestionIndex);
  }

  bool get canGoToPrevious => currentQuestionIndex > 0;

  bool get canGoToNext {
    if (questionnaire == null) return false;
    return QuestionnaireFlowHelper.canProceedToNext(
      questionnaire!,
      currentQuestionIndex,
      requireAnswerToAdvance: requireAnswerToAdvance,
    );
  }

  bool get isLastQuestion =>
      currentQuestionIndex >= (questionnaire?.questions.length ?? 0) - 1;

  double get progress {
    if (questionnaire == null) return 0.0;
    return QuestionnaireFlowHelper.calculateProgress(
        questionnaire!, currentQuestionIndex);
  }

  // ==================== LIFECYCLE METHODS ====================
  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadQuestionnaire();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // ==================== DATA LOADING ====================
  Future<void> _loadQuestionnaire() async {
    logger.method('_loadQuestionnaire');
    
    final result = await executeApiCall<Questionnaire>(
      () async => loadQuestionnaireUseCase.execute(),
      onSuccess: () {
        logger.controller('Questionnaire loaded with ${questionnaire?.questions.length ?? 0} questions');
      },
    );
    
    if (result != null) {
      final oldValue = _questionnaire.value;
      _questionnaire.value = result;
      logger.stateChange('questionnaire', oldValue, result);
    }
  }

  // ==================== NAVIGATION METHODS ====================
  void goToQuestion(int index) {
    if (index < 0 ||
        questionnaire == null ||
        index >= questionnaire!.questions.length) {
      logger.warning('Invalid question index: $index');
      return;
    }

    logger.navigation('Navigate to question', arguments: {
      'index': index, 
      'questionId': questionnaire!.questions[index].id
    });

    final oldValue = _currentQuestionIndex.value;
    _currentQuestionIndex.value = index;
    logger.stateChange('currentQuestionIndex', oldValue, index);
    
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goToPrevious() {
    if (canGoToPrevious) {
      logger.userAction('Navigate to previous question');
      goToQuestion(currentQuestionIndex - 1);
    } else {
      logger.warning('Cannot go to previous question - already at first question');
    }
  }

  void goToNext() {
    if (canGoToNext) {
      logger.userAction('Navigate to next question');
      goToQuestion(currentQuestionIndex + 1);
    } else if (isLastQuestion && canSubmit()) {
      logger.userAction('Submit questionnaire from last question');
      _submitQuestionnaire();
    } else {
      logger.warning('Cannot proceed to next question - validation failed');
    }
  }

  void onPageChanged(int index) {
    final oldValue = _currentQuestionIndex.value;
    _currentQuestionIndex.value = index;
    logger.stateChange('currentQuestionIndex', oldValue, index);
  }

  // ==================== ANSWER METHODS ====================
  void updateAnswer(String questionId, dynamic answer) {
    if (questionnaire == null) {
      logger.warning('Attempted to update answer but questionnaire is null');
      return;
    }

    logger.userAction('Update answer', params: {
      'questionId': questionId, 
      'answer': answer
    });

    final updatedQuestions = questionnaire!.questions.map((question) {
      if (question.id == questionId) {
        return question.updateAnswer(answer);
      }
      return question;
    }).toList();

    final updatedQuestionnaire = Questionnaire(
      id: questionnaire!.id,
      title: questionnaire!.title,
      description: questionnaire!.description,
      questions: updatedQuestions,
      metadata: questionnaire!.metadata,
    );
    
    final oldValue = _questionnaire.value;
    _questionnaire.value = updatedQuestionnaire;
    logger.stateChange('questionnaire', oldValue, updatedQuestionnaire);
  }

  void clearAnswer(String questionId) {
    if (questionnaire == null) {
      logger.warning('Attempted to clear answer but questionnaire is null');
      return;
    }
    
    logger.userAction('Clear answer', params: {'questionId': questionId});
    
    final updatedQuestions = questionnaire!.questions.map((question) {
      if (question.id == questionId) {
        return question.updateAnswer(null);
      }
      return question;
    }).toList();

    final updatedQuestionnaire = questionnaire!.copyWith(questions: updatedQuestions);
    final oldValue = _questionnaire.value;
    _questionnaire.value = updatedQuestionnaire;
    logger.stateChange('questionnaire', oldValue, updatedQuestionnaire);
  }

  // ==================== VALIDATION METHODS ====================
  bool canSubmit() {
    final canSubmit = questionnaire?.canSubmit ?? false;
    logger.method('canSubmit', params: 'result: $canSubmit');
    return canSubmit;
  }

  List<Question> getInvalidRequiredQuestions() {
    if (questionnaire == null) return [];
    final invalid = questionnaire!.unansweredRequiredQuestions;
    logger.method('getInvalidRequiredQuestions', params: 'count: ${invalid.length}');
    return invalid;
  }

  // ==================== SUBMISSION METHODS ====================
  Future<void> _submitQuestionnaire() async {
    logger.method('_submitQuestionnaire');
    
    if (!canSubmit()) {
      final invalidQuestions = getInvalidRequiredQuestions();
      final errorMessage = 'Please answer all required questions (${invalidQuestions.length} remaining)';
      logger.warning('Submission blocked: $errorMessage');
      setGeneralError(errorMessage);
      return;
    }

    final request = _createAddQuestionnairesRequest();
    logger.controller('Submitting questionnaire with ${request.questionnaires.length} answered questions');

    await executeApiCall<QuestionnaireListEntity?>(
      () => addQuestionnairesUseCase.execute(request),
      onSuccess: () {
        logger.navigation('Redirect to therapist matching', route: AppRoutes.matchTherapist);
        Get.offAllNamed(AppRoutes.matchTherapist);
      },
    );
  }

  AddQuestionnairesRequest _createAddQuestionnairesRequest() {
    if (questionnaire == null) {
      throw Exception('No questionnaire data available');
    }

    final questionnaires = <QuestionnaireItem>[];

    for (final question in questionnaire!.questions) {
      if (question.answer != null) {
        dynamic answer;
        if (question.type == QuestionType.multipleSelection) {
          answer = (question.answer is List) 
            ? (question.answer as List).join(',')
            : question.answer.toString();
        } else {
          answer = (question.answer is List && (question.answer as List).isNotEmpty)
            ? (question.answer as List).first.toString()
            : question.answer.toString();
        }

        String key = _mapQuestionIdToKey(question.id);

        questionnaires.add(QuestionnaireItem(
          question: question.title,
          options: question.options.map((opt) => opt.text).toList(),
          answer: answer,
          key: key,
        ));
      }
    }

    return AddQuestionnairesRequest(questionnaires: questionnaires);
  }

  String _mapQuestionIdToKey(String questionId) {
    switch (questionId) {
      case 'therapist_gender_preference':
        return 'gender_prefer';
      case 'therapist_age_preference':
        return 'age_prefer';
      case 'language_preference':
        return 'lang_prefer';
      case 'user_age_group':
        return 'age_group_prefer';
      case 'therapy_support_needs':
        return 'help_support';
      case 'preferred_day':
        return 'preferred_day';
      case 'preferred_time':
        return 'preferred_time';
      default:
        return questionId;
    }
  }

  // ==================== CONFIGURATION METHODS ====================
  void setCanSwipe(bool value) {
    final oldValue = _canSwipe.value;
    _canSwipe.value = value;
    logger.stateChange('canSwipe', oldValue, value);
  }

  void setRequireAnswerToAdvance(bool value) {
    final oldValue = _requireAnswerToAdvance.value;
    _requireAnswerToAdvance.value = value;
    logger.stateChange('requireAnswerToAdvance', oldValue, value);
  }

  void goBack() {
    logger.navigation('Navigate back');
    Get.back();
  }
}
