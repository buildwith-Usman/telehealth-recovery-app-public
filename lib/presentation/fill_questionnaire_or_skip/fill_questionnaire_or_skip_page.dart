import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/custom_navigation_button.dart';
import 'package:recovery_consultation_app/generated/locales.g.dart';

import 'fill_questionnaire_or_skip_controller.dart';

class FillQuestionnaireOrSkipPage
    extends BaseStatefulPage<FillQuestionnaireOrSkipController> {
  const FillQuestionnaireOrSkipPage({super.key});

  @override
  BaseStatefulPageState<FillQuestionnaireOrSkipController> createState() =>
      _FillQuestionnaireOrSkipPageState();
}

class _FillQuestionnaireOrSkipPageState extends BaseStatefulPageState<FillQuestionnaireOrSkipController> {
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    _buildMainIcon(),
                    gapH32,
                    _buildHeaderText(),
                    gapH12,
                    _buildSubtitleText(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ),
            ),
            _buildFillQuestionnaireButton(),
            gapH8,
            _buildSkipOption(),
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

  Widget _buildMainIcon() {
    return Center(
      child: AppImage.fillQuestionnaire.widget(
        height: 140,
      ),
    );
  }

  Widget _buildHeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AppText.primary(
        LocaleKeys.fillQuestionnaireOrSkipScreen_heading.tr,
        fontFamily: FontFamilyType.poppins,
        fontSize: 24,
        fontWeight: FontWeightType.semiBold,
        color: AppColors.black,
        textAlign: TextAlign.center,
        maxLines: 3,
      ),
    );
  }

  Widget _buildSubtitleText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: AppText.primary(
        LocaleKeys.fillQuestionnaireOrSkipScreen_subtitle.tr,
        fontFamily: FontFamilyType.inter,
        fontSize: 16,
        fontWeight: FontWeightType.regular,
        color: AppColors.textSecondary,
        textAlign: TextAlign.center,
        maxLines: 3,
      ),
    );
  }

  Widget _buildFillQuestionnaireButton() {
    return PrimaryButton(
      color: AppColors.primary,
      textColor: AppColors.white,
      title: LocaleKeys.fillQuestionnaireOrSkipScreen_fillQuestionnaire.tr,
      height: 55,
      radius: 8,
      fontWeight: FontWeightType.semiBold,
      showIcon: true,
      iconWidget: const Icon(
        Icons.arrow_forward,
        color: AppColors.white,
        size: 18,
      ),
      onPressed: () => widget.controller.navigateToQuestionnaire(),
    );
  }

  Widget _buildSkipOption() {
    return Obx(() {
      final isLoading = widget.controller.isLoading.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.primary(
            LocaleKeys.fillQuestionnaireOrSkipScreen_skipBrowseText.tr,
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
          gapW8,
          GestureDetector(
            onTap: isLoading ? () {} : () => widget.controller.skipAndBrowse(),
            child: AppText.primary(
              LocaleKeys.fillQuestionnaireOrSkipScreen_skip.tr,
              fontFamily: FontFamilyType.inter,
              fontSize: 14,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ],
      );
    });
  }
}
