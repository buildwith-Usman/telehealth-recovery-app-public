import 'package:recovery_consultation_app/presentation/otp/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/config/app_image.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../../generated/locales.g.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/button/custom_navigation_button.dart';

class OtpPage extends BaseStatefulPage<OtpController> {
  const OtpPage({super.key});

  @override
  BaseStatefulPageState<OtpController> createState() => _OtpPageState();
}

class _OtpPageState extends BaseStatefulPageState<OtpController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildOtpPageContent(context),
    );
  }

  Widget _buildOtpPageContent(BuildContext context) {
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
                  gapH40,
                  _buildHeaderText(),
                  gapH60,
                  _buildOtpIllustration(),
                  gapH40,
                  _buildOtpInstructions(),
                  gapH24,
                  _buildOtpInputFields(),
                  gapH24,
                  _buildResendSection(),
                  gapH60,
                  _buildVerifyButton(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

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

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          LocaleKeys.otpScreen_heading.tr,
          fontFamily: FontFamilyType.poppins,
          fontSize: 32,
          fontWeight: FontWeightType.bold,
          color: AppColors.black,
          textAlign: TextAlign.left,
        ),
        gapH8,
        AppText.primary(
          LocaleKeys.otpScreen_subHeading.tr,
          fontFamily: FontFamilyType.inter,
          fontSize: 16,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildOtpIllustration() {
    return Center(
      child: SizedBox(
        height: 200,
        child: AppImage.otpImg.widget(
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildOtpInstructions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            children: [
              TextSpan(
                text: LocaleKeys.otpScreen_enterDigitsInstruction.tr,
              ),
              const TextSpan(text: '\n'),
              TextSpan(
                text: widget.controller.userEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInputFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: PinCodeTextField(
        appContext: context,
        length: 5,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderWidth: 2,
          activeBorderWidth: 2,
          selectedBorderWidth: 2,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          fieldHeight: 60,
          fieldWidth: 50,
          activeFillColor: AppColors.white,
          inactiveFillColor: AppColors.whiteLight,
          selectedFillColor: AppColors.whiteLight,
          activeColor: AppColors.primary,
          selectedColor: AppColors.primary,
          inactiveColor: AppColors.grey90,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: AppColors.background,
        enableActiveFill: true,
        keyboardType: TextInputType.number,
        controller: widget.controller.verificationCodeController,
        onCompleted: (value) {
          // Handle completion if needed
        },
        onChanged: (value) {
          // Handle changes if needed
        },
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.primary(
            LocaleKeys.otpScreen_didntReceiveCode.tr,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
          gapW4,
          InkWell(
            child: AppText.primary(
              LocaleKeys.otpScreen_resendCode.tr,
              color: AppColors.accent,
              fontWeight: FontWeightType.semiBold,
              fontSize: 14,
            ),
            onTap: () {
              widget.controller.resendOTP();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return PrimaryButton(
      color: AppColors.primary,
      textColor: AppColors.white,
      title: LocaleKeys.otpScreen_verify.tr,
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
        widget.controller.otpVerification();
      },
    );
  }

  @override
  void setupAdditionalListeners() {
    // Listen for resend OTP success
    ever(widget.controller.resendOtpSuccess, (bool success) {
      if (success) {
        showSuccessToast('Verification code resent successfully. Please check your email.');
        // Reset the success state after showing the message
        widget.controller.resendOtpSuccess.value = false;
      }
    });

    // Listen for OTP verification success
    ever(widget.controller.otpVerificationSuccess, (bool success) {
      if (success) {
        // OTP verification success is handled in the controller's navigation
        // This listener can be used for additional UI feedback if needed
      }
    });
  }
}
