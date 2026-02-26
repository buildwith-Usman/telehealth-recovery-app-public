import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/generated/locales.g.dart';

import '../../app/config/app_enum.dart';
import 'specialist_selection_controller.dart';

class SpecialistSelectionPage
    extends BaseStatefulPage<SpecialistSelectionController> {
  const SpecialistSelectionPage({super.key});

  @override
  BaseStatefulPageState<SpecialistSelectionController> createState() =>
      _SpecialistSelectionPageState();
}

class _SpecialistSelectionPageState extends BaseStatefulPageState<SpecialistSelectionController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildSpecialistSelectionContent(context),
      bottomNavigationBar: _buildContinueButton(),
    );
  }

  Widget _buildSpecialistSelectionContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeaderText(),
                    gapH40,
                    _buildTherapistCard(),
                    gapH20,
                    _buildPsychiatristCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Center(
      child: AppText.primary(
        LocaleKeys.therapistSelectionScreen_heading.tr,
        fontFamily: FontFamilyType.poppins,
        fontSize: 28,
        fontWeight: FontWeightType.semiBold,
        color: AppColors.black,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTherapistCard() {
    return Obx(() {
      final isSelected =
          widget.controller.selectedType == SpecialistType.therapist;

      return GestureDetector(
        onTap: () =>
            widget.controller.selectSpecialistType(SpecialistType.therapist),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.grey80.withValues(alpha: 0.3),
              ),
              child: Row(
                children: [
                  // Content Section (50% width)
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText.primary(
                            'For',
                            fontFamily: FontFamilyType.inter,
                            fontSize: 14,
                            fontWeight: FontWeightType.regular,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                          AppText.primary(
                            'Therapists',
                            fontFamily: FontFamilyType.poppins,
                            fontSize: 24,
                            fontWeight: FontWeightType.medium,
                            color:
                                isSelected ? AppColors.white : AppColors.black,
                          ),
                          gapH8,
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.white.withValues(alpha: 0.2)
                                  : AppColors.grey80.withValues(alpha: 0.3),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Image Section (50% width)
                  Expanded(
                    flex: 5,
                    child: AppImage.lookingForTherapist.widget(
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPsychiatristCard() {
    return Obx(() {
      final isSelected =
          widget.controller.selectedType == SpecialistType.psychiatrist;

      return GestureDetector(
        onTap: () =>
            widget.controller.selectSpecialistType(SpecialistType.psychiatrist),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.grey80.withValues(alpha: 0.3),
              ),
              child: Row(
                children: [
                  // Content Section (50% width)
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText.primary(
                            'For',
                            fontFamily: FontFamilyType.inter,
                            fontSize: 14,
                            fontWeight: FontWeightType.regular,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                          AppText.primary(
                            'Psychiatrist',
                            fontFamily: FontFamilyType.poppins,
                            fontSize: 24,
                            fontWeight: FontWeightType.medium,
                            color:
                                isSelected ? AppColors.white : AppColors.black,
                          ),
                          gapH8,
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.white.withValues(alpha: 0.2)
                                  : AppColors.grey80.withValues(alpha: 0.3),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Image Section (50% width)
                  Expanded(
                    flex: 5,
                    child: AppImage.lookingForPsychiatrist.widget(
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContinueButton() {
    return Obx(() {
      final canProceed = widget.controller.canProceed;
      final isLoading = widget.controller.isLoading.value;

      return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: PrimaryButton(
          color: canProceed ? AppColors.primary : AppColors.grey80,
          textColor: canProceed ? AppColors.white : AppColors.textSecondary,
          title: 'Continue',
          height: 55,
          radius: 8,
          fontWeight: FontWeightType.semiBold,
          showIcon: true,
          iconWidget: AppIcon.rightArrowIcon.widget(
            width: 10,
            height: 10,
            color: canProceed ? AppColors.white : AppColors.textSecondary,
          ),
          onPressed: canProceed && !isLoading
              ? () => widget.controller.proceedToNext()
              : () {},
        ),
      );
    });
  }
}
