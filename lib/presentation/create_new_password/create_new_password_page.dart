import 'package:recovery_consultation_app/presentation/create_new_password/create_new_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../../generated/locales.g.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/textfield/form_textfield.dart';

class CreateNewPasswordPage
    extends BaseStatefulPage<CreateNewPasswordController> {
  const CreateNewPasswordPage({super.key});

  @override
  BaseStatefulPageState<CreateNewPasswordController> createState() {
    return _CreateNewPasswordPageState();
  }
}

class _CreateNewPasswordPageState
    extends BaseStatefulPageState<CreateNewPasswordController> {
  @override
  void setupAdditionalListeners() {
    // Listen for successful password reset
    ever(widget.controller.resetPasswordSuccess, (bool isSuccess) {
      if (isSuccess) {
        showSuccessToast("Password reset successfully!");
      }
    });
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildNewPasswordContent(),
    );
  }

  /// Main content of the New Password screen
  Widget _buildNewPasswordContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNavigationHeader(),
              gapH40,
              _buildHeading(),
              gapH10,
              _buildSubHeading(),
              gapH40,
              _buildPasswordField(),
              gapH20,
              _buildConfirmPasswordField(),
              gapH40,
              _buildResetPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigation header with back button and title
  Widget _buildNavigationHeader() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          onPressed: () {
            widget.controller.goToPreviousScreen();
          },
        ),
        Expanded(
          child: Center(
            child: AppText.h3(
              LocaleKeys.createNewPasswordScreen_heading.tr,
              fontWeight: FontWeightType.semiBold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 45), // Balance the back button
      ],
    );
  }

  /// Main heading text
  Widget _buildHeading() {
    return AppText.h3(
      LocaleKeys.createNewPasswordScreen_heading.tr,
      fontWeight: FontWeightType.bold,
      fontSize: 28,
    );
  }

  /// Subtitle/description text
  Widget _buildSubHeading() {
    return AppText.primary(
      LocaleKeys.createNewPasswordScreen_subHeading.tr,
      color: AppColors.grey60,
      fontSize: 16,
      fontWeight: FontWeightType.regular,
    );
  }

  /// New password input field with validation
  Widget _buildPasswordField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.createNewPasswordScreen_newPassword.tr,
          isRequired: true,
          hintText: "*************",
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isPasswordField: true,
          isInvalid: widget.controller.passwordError.value != null,
          invalidText: widget.controller.passwordError.value ?? '',
          controller: widget.controller.passwordTextEditingController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.passwordError.value != null) {
              widget.controller.clearPasswordError();
            }
          },
        ));
  }

  /// Confirm password input field with validation
  Widget _buildConfirmPasswordField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.createNewPasswordScreen_confirmPassword.tr,
          isRequired: true,
          hintText:
              LocaleKeys.createNewPasswordScreen_confirmPasswordPlaceholder.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isPasswordField: true,
          isInvalid: widget.controller.confirmPasswordError.value != null,
          invalidText: widget.controller.confirmPasswordError.value ?? '',
          controller: widget.controller.confirmPasswordTextEditingController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.confirmPasswordError.value != null) {
              widget.controller.clearConfirmPasswordError();
            }
          },
        ));
  }

  /// Reset Password button for form submission
  Widget _buildResetPasswordButton() {
    return PrimaryButton(
      color: AppColors.primary,
      textColor: AppColors.white,
      title: LocaleKeys.createNewPasswordScreen_submit.tr,
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
        widget.controller.resetPassword();
      },
    );
  }
}
