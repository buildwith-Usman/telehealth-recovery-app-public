import 'package:recovery_consultation_app/presentation/signup_screen/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/config/app_image.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../../generated/locales.g.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/textfield/form_textfield.dart';

class SignupPage extends BaseStatefulPage<SignupController> {
  const SignupPage({super.key});

  @override
  BaseStatefulPageState<SignupController> createState() => _SignupPageState();
}

class _SignupPageState extends BaseStatefulPageState<SignupController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildSignupPageContent(context),
    );
  }

  Widget _buildSignupPageContent(BuildContext context) {
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
                  Row(
                    children: [
                      CustomNavigationButton(
                        type: NavigationButtonType.previous,
                        onPressed: () => widget.controller.goToPreviousScreen(),
                        isFilled: true,
                        filledColor: AppColors.whiteLight,
                        iconColor: AppColors.accent,
                      ),
                    ],
                  ),
                  gapH20,
                  _buildWelcomeText(),
                  gapH40,
                  _buildSignupImageSection(),
                  gapH24,
                  _buildNameField(),
                  gapH16,
                  _buildEmailField(),
                  gapH16,
                  _buildPhoneField(),
                  gapH16,
                  _buildPasswordField(),
                  gapH16,
                  _buildConfirmPasswordField(),
                  gapH24,
                  _buildSignupButton(),
                  gapH8,
                  _buildLoginSection(),
                  gapH16,
                  _buildOrSection(),
                  gapH16,
                  _buildGoogleLoginButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          LocaleKeys.signupScreen_heading.tr,
          fontFamily: FontFamilyType.poppins,
          fontSize: 24,
          fontWeight: FontWeightType.bold,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        gapH6,
        AppText.primary(
          LocaleKeys.signupScreen_subHeading.tr,
          fontFamily: FontFamilyType.inter,
          fontSize: 16,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildSignupImageSection() {
    return Center(
      child: SizedBox(
        height: 180,
        child: AppImage.loginSignUpImg.widget(
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.signupScreen_fullName.tr,
          isRequired: true,
          hintText: "Enter your full name",
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.nameError.value != null,
          invalidText: widget.controller.nameError.value ?? '',
          suffixIcon: AppIcon.userIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.nameTextEditingController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.nameError.value != null) {
              widget.controller.clearNameError();
            }
          },
        ));
  }

  Widget _buildEmailField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.signupScreen_email.tr,
          isRequired: true,
          hintText: LocaleKeys.signupScreen_emailHint.tr,
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
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.emailError.value != null) {
              widget.controller.clearEmailError();
            }
          },
        ));
  }

  Widget _buildPhoneField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.signupScreen_phoneNumber.tr,
          isRequired: true,
          hintText: LocaleKeys.signupScreen_phoneHint.tr,
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          textInputType: TextInputType.phone,
          isInvalid: widget.controller.mobileError.value != null,
          invalidText: widget.controller.mobileError.value ?? '',
          suffixIcon: AppIcon.phoneIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.mobileTextEditingController,
          onChanged: (value) {
            // Clear error when user starts typing
            if (widget.controller.mobileError.value != null) {
              widget.controller.clearMobileError();
            }
          },
        ));
  }

  Widget _buildPasswordField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.signupScreen_password.tr,
          isRequired: true,
          hintText: "*************",
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 60,
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

  Widget _buildConfirmPasswordField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.signupScreen_confirmPassword.tr,
          isRequired: true,
          hintText: "*************",
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 60,
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

  Widget _buildSignupButton() {
    return PrimaryButton(
      color: AppColors.primary,
      textColor: AppColors.white,
      title: LocaleKeys.signupScreen_createAccount.tr,
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
        widget.controller.signUp();
      },
    );
  }

  Widget _buildLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.primary(
          LocaleKeys.signupScreen_alreadyHaveAccount.tr,
          fontSize: 14,
          fontWeight: FontWeightType.regular,
          color: AppColors.grey99,
        ),
        gapW4,
        InkWell(
          child: AppText.primary(
            LocaleKeys.signupScreen_login.tr,
            color: AppColors.primary,
            fontWeight: FontWeightType.semiBold,
          ),
          onTap: () => Get.back(),
        ),
      ],
    );
  }

  Widget _buildOrSection() {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.black0E0,
            thickness: 1.5,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AppText.primary(
            "Or",
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.grey99,
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.black0E0,
            thickness: 1.5,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton() {
    return PrimaryButton(
      title: LocaleKeys.loginScreen_continueWithGoogle.tr,
      height: 55,
      color: AppColors.whiteLight,
      radius: 8,
      fontWeight: FontWeightType.semiBold,
      textColor: AppColors.black,
      showIcon: true,
      iconPosition: IconPosition.left,
      iconWidget: AppIcon.googleIcon.widget(
        width: 20,
        height: 20,
      ),
      onPressed: () {
        // Handle Google login logic here
      },
    );
  }
}
