import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/generated/locales.g.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/custom_navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/textfield/form_textfield.dart';
import 'login_controller.dart';

class LoginPage extends BaseStatefulPage<LoginController> {
  const LoginPage({super.key});

  @override
  BaseStatefulPageState<LoginController> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends BaseStatefulPageState<LoginController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildLoginPageContent(context),
    );
  }

  @override
  void setupAdditionalListeners() {
    // Listen for login error messages
    ever(widget.controller.loginErrorMessage, (String? errorMessage) {
      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        widget.controller.clearLoginError();
      }
    });

    // Listen for login success
    ever(widget.controller.loginSuccess, (bool success) {
      if (success) {
        final userRole = widget.controller.userRole.value;
        if (userRole != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Welcome! Logged in as ${userRole.toString().split('.').last}'),
              backgroundColor: Colors.green,
            ),
          );
        }
        widget.controller.clearLoginError();
      }
    });
  }

  Widget _buildLoginPageContent(BuildContext context) {
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
                        onPressed: () => Get.back(),
                        isFilled: true,
                        filledColor: AppColors.whiteLight,
                        iconColor: AppColors.accent,
                      ),
                    ],
                  ),
                  gapH20,
                  _buildWelcomeText(),
                  gapH40,
                  _buildLoginImageSection(),
                  gapH24,
                  _buildEmailField(),
                  gapH16,
                  _buildPasswordField(),
                  gapH24,
                  _buildLoginButton(),
                  gapH8,
                  _buildSignUpSection(),
                  gapH16,
                  _buildOrSection(),
                  gapH16,
                  _buildGoogleLoginButton(),
                  gapH8,
                  _buildSpecialistSection(),
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
          LocaleKeys.loginScreen_heading.tr,
          fontFamily: FontFamilyType.poppins,
          fontSize: 24,
          fontWeight: FontWeightType.bold,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        gapH6,
        AppText.primary(
          LocaleKeys.loginScreen_subHeading.tr,
          fontFamily: FontFamilyType.inter,
          fontSize: 16,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildLoginImageSection() {
    return Center(
      child: SizedBox(
        height: 180,
        child: AppImage.loginSignUpImg.widget(
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Obx(() => FormTextField(
          titleText: LocaleKeys.loginScreen_email.tr,
          isRequired: true,
          hintText: LocaleKeys.loginScreen_enterEmail.tr,
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

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => FormTextField(
              titleText: LocaleKeys.loginScreen_password.tr,
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
            )),
        gapH8,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                widget.controller.goToForgetPasswordScreen();
              },
              child: AppText.primary(
                LocaleKeys.loginScreen_forgetPassword.tr,
                color: AppColors.accent,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return PrimaryButton(
      color: AppColors.primary,
      textColor: AppColors.white,
      title: LocaleKeys.loginScreen_login.tr,
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
        widget.controller.login();
      },
    );
  }

  Widget _buildSignUpSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.primary(
          LocaleKeys.loginScreen_doNotHaveAccount.tr,
          fontSize: 14,
          fontWeight: FontWeightType.regular,
          color: AppColors.grey99,
        ),
        gapW4,
        InkWell(
          child: AppText.primary(LocaleKeys.loginScreen_signUp.tr,
              color: AppColors.primary, fontWeight: FontWeightType.semiBold),
          onTap: () {
            // Regular user signup (patient)
            widget.controller.goToSignUpScreen(userRole: UserRole.patient);
          },
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
        widget.controller.loginWithGoogle();
      },
    );
  }

  Widget _buildSpecialistSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText.primary(
          LocaleKeys.loginScreen_mentalHealthSpecialist.tr,
          fontSize: 14,
          fontWeight: FontWeightType.regular,
          color: AppColors.grey99,
        ),
        gapW4,
        InkWell(
          child: AppText.primary(
            LocaleKeys.loginScreen_joinUs.tr,
            color: AppColors.primary,
            fontWeight: FontWeightType.semiBold,
          ),
          onTap: () {
            // Navigate directly to specialist signup
            widget.controller.goToSpecialistSignup();
          },
        ),
      ],
    );
  }
}
