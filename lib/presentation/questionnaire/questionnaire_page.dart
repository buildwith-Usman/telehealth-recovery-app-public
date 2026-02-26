import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/custom_navigation_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/domain/models/questionnaire_models.dart';

import 'questionnaire_controller.dart';

class QuestionnairePage extends BaseStatefulPage<QuestionnaireController> {
  const QuestionnairePage({super.key});

  @override
  BaseStatefulPageState<QuestionnaireController> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends BaseStatefulPageState<QuestionnaireController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildQuestionnaireContent(context),
    );
  }

  Widget _buildQuestionnaireContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            _buildBackButton(),
            gapH20,
            _buildHeaderText(),
            gapH24,
            Expanded(
              child: Obx(() {
                if (widget.controller.questionnaire == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  );
                }

                final questionnaire = widget.controller.questionnaire!;

                return Column(
                  children: [
                    _buildProgressIndicator(questionnaire),
                    gapH24,
                    Expanded(
                      child: PageView.builder(
                        controller: widget.controller.pageController,
                        onPageChanged: widget.controller.onPageChanged,
                        physics: widget.controller.canSwipe
                            ? const PageScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        itemCount: questionnaire.questions.length,
                        itemBuilder: (context, index) {
                          final question = questionnaire.questions[index];
                          return SingleChildScrollView(
                            child: _buildQuestionContent(question),
                          );
                        },
                      ),
                    ),
                    _buildNavigationButtons(questionnaire),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () {
            widget.controller.goBack();
          },
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
        ),
      ],
    );
  }

  Widget _buildHeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: AppText.primary(
        'Help us match you to\nthe right therapist',
        fontFamily: FontFamilyType.poppins,
        fontSize: 24,
        fontWeight: FontWeightType.semiBold,
        color: AppColors.black,
        textAlign: TextAlign.center,
        maxLines: 3,
      ),
    );
  }

  Widget _buildProgressIndicator(Questionnaire questionnaire) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Column(
        children: [
          gapH16,
          // Numbered circles with connecting lines - centered and scrollable
          Center(
            child: SizedBox(
              height: 46,
              child: Obx(() {
                // Access reactive variables to ensure GetX detects changes
                final currentIndex =
                    widget.controller.currentQuestionIndexRx.value;
                final currentQuestionnaire = widget.controller.questionnaireRx.value; // This will trigger updates when answers change

                if (currentQuestionnaire == null) {
                  return const SizedBox.shrink();
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: currentQuestionnaire.questions.length,
                  itemBuilder: (context, index) {
                    final question = currentQuestionnaire.questions[index];
                    final isActive = index == currentIndex;
                    final isCompleted = question
                        .isAnswered; // Check if question is actually answered
                    final isLast =
                        index == currentQuestionnaire.questions.length - 1;
                    return Row(
                      children: [
                        // Question circle - tappable
                        InkWell(
                          onTap: () {
                            // Navigate to the tapped question
                            widget.controller.goToQuestion(index);
                          },
                          borderRadius: BorderRadius.circular(23),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? AppColors.primary
                                  : isActive
                                      ? AppColors.primary
                                      : AppColors.whiteLight,
                              border: Border.all(
                                color: isActive
                                    ? AppColors.primary
                                    : isCompleted
                                        ? AppColors.primary
                                        : AppColors.grey99,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: AppColors.white,
                                    )
                                  : AppText.body_2(
                                      '${index + 1}',
                                      fontWeight: FontWeightType.semiBold,
                                      fontSize: 16,
                                      color: isActive
                                          ? AppColors.white
                                          : AppColors.textSecondary,
                                    ),
                            ),
                          ),
                        ),
                        // Connecting line (except for last item)
                        if (!isLast)
                          Container(
                            width: 24,
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: CustomPaint(
                              painter: DottedLinePainter(
                                color: isCompleted
                                    ? AppColors.primary
                                    : AppColors.grey99,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(Question question) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionTitle(question),
          gapH24,
          _buildQuestionInput(question),
        ],
      ),
    );
  }

  Widget _buildQuestionTitle(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AppText.primary(
                question.title,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.black,
                fontSize: 18,
              ),
            ),
            if (question.isRequired)
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: AppText.h4(
                  '*',
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.red513,
                ),
              ),
          ],
        ),
        if (question.subtitle != null) ...[
          gapH8,
          AppText.body_2(
            question.subtitle!,
            color: AppColors.textSecondary,
          ),
        ],
      ],
    );
  }

  Widget _buildQuestionInput(Question question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.singleSelection:
        return _buildRadioOptions(question);
      case QuestionType.multipleSelection:
        return _buildCheckboxOptions(question);
      case QuestionType.dropdown:
        return _buildDropdown(question);
      case QuestionType.textInput:
        return _buildTextInput(question);
      case QuestionType.numberInput:
        return _buildNumberInput(question);
      case QuestionType.dateInput:
        return _buildDateInput(question);
    }
  }

  Widget _buildRadioOptions(Question question) {
    return Column(
      children: question.options.map((option) {
        final isSelected = question.answer == option.id;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => widget.controller.updateAnswer(question.id, option.id),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? AppColors.accent : AppColors.whiteLight,
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : AppColors.grey80,
                        width: 2,
                      ),
                      color: isSelected ? AppColors.primary : AppColors.white,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.circle,
                            size: 10,
                            color: AppColors.white,
                          )
                        : null,
                  ),
                  gapW12,
                  Expanded(
                    child: AppText.body(
                      option.text,
                      fontWeight: isSelected
                          ? FontWeightType.medium
                          : FontWeightType.regular,
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxOptions(Question question) {
    final List<String> selectedAnswers =
        question.answer is List ? List<String>.from(question.answer ?? []) : [];

    // Check if this is question 5 (therapy_support_needs) - use single column
    if (question.id == 'therapy_support_needs') {
      return _buildSingleColumnCheckboxes(question, selectedAnswers);
    }

    // For other questions (like language_preference) - use two-column layout
    return _buildTwoColumnCheckboxes(question, selectedAnswers);
  }

  Widget _buildSingleColumnCheckboxes(
      Question question, List<String> selectedAnswers) {
    return Column(
      children: question.options.map((option) {
        final isSelected = selectedAnswers.contains(option.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              List<String> newAnswers = List<String>.from(selectedAnswers);
              if (isSelected) {
                newAnswers.remove(option.id);
              } else {
                newAnswers.add(option.id);
              }
              widget.controller.updateAnswer(question.id, newAnswers);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey80,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? AppColors.primary.withOpacity(0.05)
                    : AppColors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : AppColors.grey80,
                        width: 2,
                      ),
                      color: isSelected ? AppColors.primary : AppColors.white,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.white,
                          )
                        : null,
                  ),
                  gapW12,
                  Expanded(
                    child: AppText.body(
                      option.text,
                      fontWeight: isSelected
                          ? FontWeightType.medium
                          : FontWeightType.regular,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTwoColumnCheckboxes(
      Question question, List<String> selectedAnswers) {
    // Group options into pairs for two-column layout
    List<List<QuestionOption>> pairedOptions = [];
    for (int i = 0; i < question.options.length; i += 2) {
      if (i + 1 < question.options.length) {
        pairedOptions.add([question.options[i], question.options[i + 1]]);
      } else {
        pairedOptions.add([question.options[i]]);
      }
    }

    return Column(
      children: pairedOptions.map((optionPair) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: optionPair.map((option) {
              final isSelected = selectedAnswers.contains(option.id);

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right:
                        optionPair.indexOf(option) == 0 && optionPair.length > 1
                            ? 8
                            : 0,
                    left: optionPair.indexOf(option) == 1 ? 8 : 0,
                  ),
                  child: InkWell(
                    onTap: () {
                      List<String> newAnswers =
                          List<String>.from(selectedAnswers);
                      if (isSelected) {
                        newAnswers.remove(option.id);
                      } else {
                        newAnswers.add(option.id);
                      }
                      widget.controller.updateAnswer(question.id, newAnswers);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isSelected ? AppColors.primary : AppColors.grey80,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.05)
                            : AppColors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grey80,
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.white,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.white,
                                  )
                                : null,
                          ),
                          gapW8,
                          Expanded(
                            child: AppText.body(
                              option.text,
                              fontWeight: isSelected
                                  ? FontWeightType.medium
                                  : FontWeightType.regular,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown(Question question) {
    return Column(
      children: [
        // Main dropdown trigger
        InkWell(
          onTap: () {
            _showDropdownOptions(question);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.whiteLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.grey99,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppText.body(
                    question.answer != null
                        ? question.options
                            .firstWhere((opt) => opt.id == question.answer)
                            .text
                        : 'Select an option',
                    color: question.answer != null
                        ? AppColors.black
                        : AppColors.textSecondary,
                    fontWeight: FontWeightType.regular,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownOptions(Question question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey80,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Options list
              ...question.options.map((option) {
                final isSelected = question.answer == option.id;
                return InkWell(
                  onTap: () {
                    widget.controller.updateAnswer(question.id, option.id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary : AppColors.whiteLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppText.body(
                      option.text,
                      color:
                          isSelected ? AppColors.white : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeightType.medium
                          : FontWeightType.regular,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 40), // Bottom padding
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextInput(Question question) {
    return TextFormField(
      initialValue: question.answer?.toString() ?? '',
      onChanged: (value) => widget.controller.updateAnswer(question.id, value),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey80),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey80),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: 'Enter your answer',
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      maxLines: question.subtitle?.contains('detailed') == true ? 4 : 1,
    );
  }

  Widget _buildNumberInput(Question question) {
    return TextFormField(
      initialValue: question.answer?.toString() ?? '',
      onChanged: (value) {
        final number = int.tryParse(value);
        widget.controller.updateAnswer(question.id, number);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey80),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey80),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintText: 'Enter a number',
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDateInput(Question question) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          widget.controller
              .updateAnswer(question.id, date.toIso8601String().split('T')[0]);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey80),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText.body(
                question.answer?.toString() ?? 'Select a date',
                color: question.answer != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(Questionnaire questionnaire) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Obx(() {
        final canPrevious = widget.controller.canGoToPrevious;
        final canNext = widget.controller.canGoToNext;
        final isLast = widget.controller.isLastQuestion;
        final canSubmit = widget.controller.canSubmit();

        // Debug information
        print(
            'Navigation Debug - Current Index: ${widget.controller.currentQuestionIndex}');
        print(
            'Navigation Debug - Total Questions: ${questionnaire.questions.length}');
        print('Navigation Debug - isLast: $isLast');
        print('Navigation Debug - canSubmit: $canSubmit');

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous button (only show when can go previous)
            canPrevious
                ? CustomNavigationButton(
                    type: NavigationButtonType.previous,
                    onPressed: () => widget.controller.goToPrevious(),
                  )
                : const SizedBox(width: 45), // Empty space on first page

            // For last question: show Submit button, for others: show Next button
            isLast
                ? _buildSubmitButton(canSubmit)
                : CustomNavigationButton(
                    type: NavigationButtonType.next,
                    onPressed: canNext
                        ? widget.controller.goToNext
                        : () {}, // Empty function for disabled state
                    backgroundColor: canNext
                        ? null // Use default colors
                        : AppColors.grey80, // Disabled appearance
                    iconColor: canNext
                        ? null // Use default colors
                        : AppColors.textSecondary, // Disabled appearance
                  ),
          ],
        );
      }),
    );
  }

  Widget _buildSubmitButton(bool canSubmit) {
    return PrimaryButton(
      title: 'Submit',
      width: 120,
      onPressed: canSubmit ? widget.controller.goToNext : () {},
      color: canSubmit ? AppColors.primary : AppColors.grey80,
      textColor: canSubmit ? AppColors.white : AppColors.black,
      height: 45,
      radius: 8,
      fontSize: 16,
      fontWeight: FontWeightType.medium,
      showIcon: true,
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    const double dotWidth = 3;
    const double dotSpacing = 2;
    double currentX = 0;

    while (currentX < size.width) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(currentX, 0, dotWidth, size.height),
          const Radius.circular(1),
        ),
        paint,
      );
      currentX += dotWidth + dotSpacing;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
