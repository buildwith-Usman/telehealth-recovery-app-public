import 'package:recovery_consultation_app/presentation/forget_password/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../../generated/locales.g.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/textfield/form_textfield.dart';

class ForgetPasswordPage extends BaseStatefulPage<ForgetPasswordController> {
  const ForgetPasswordPage({super.key});

  @override
  BaseStatefulPageState<ForgetPasswordController> createState() {
    return _ForgetPasswordPageState();
  }
}

class _ForgetPasswordPageState extends BaseStatefulPageState<ForgetPasswordController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildForgotPasswordContent(),
    );
  }

  Widget _buildForgotPasswordContent() {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildNavigationHeader(),
                  gapH20,
                  _buildHeadingSection(),
                  gapH24,
                  _buildEmailField(),
                  gapH20,
                  _buildNextButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Navigation header with back button
  Widget _buildNavigationHeader() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => widget.controller.goToPreviousScreen(),
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
        ),
      ],
    );
  }

  /// Heading section with title
  Widget _buildHeadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          LocaleKeys.forgetPasswordScreen_heading.tr,
          fontFamily: FontFamilyType.poppins,
          fontSize: 24,
          fontWeight: FontWeightType.bold,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  /// Email input field with validation
  Widget _buildEmailField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.forgetPasswordScreen_emailLabel.tr,
          isRequired: true,
          hintText: LocaleKeys.forgetPasswordScreen_emailPlaceholder.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.emailError.value != null,
          invalidText: widget.controller.emailError.value ?? '',
          suffixIcon: AppIcon.emailIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.emailTextEditingController,
          onChanged: widget.controller.onEmailChanged,
        ));
  }

  /// Next button for form submission
  Widget _buildNextButton() {
    return PrimaryButton(
      color: AppColors.primary,
      textColor: AppColors.white,
      title: LocaleKeys.forgetPasswordScreen_next.tr,
      height: 55,
      radius: 8,
      fontWeight: FontWeightType.semiBold,
      showIcon: true,
      iconWidget: AppIcon.rightArrowIcon.widget(
        width: 10,
        height: 10,
        color: AppColors.white,
      ),
      onPressed: () {
        widget.controller.forgotPassword();
      },
    );
  }
}
