import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/presentation/success_screen/success_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/utils/sizes.dart';
import '../../generated/locales.g.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';

class SuccessPage extends BaseStatefulPage<SuccessController> {
  const SuccessPage({super.key});

  @override
  BaseStatefulPageState<SuccessController> createState() => _SuccessPageState();
}

class _SuccessPageState extends BaseStatefulPageState<SuccessController> {
  @override
  Color get scaffoldBackgroundColor => AppColors.white;

  @override
  bool get useSafeArea => true;

  @override
  bool get useStandardPadding => false;

  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: _buildSuccessPageContent(),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget _buildSuccessPageContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Success Icon
                  _buildSuccessIcon(),
                  gapH20,

                  // Success Heading
                  _buildSuccessHeading(),
                  gapH8,

                  // Success Message
                  _buildSuccessMessage(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Success icon widget using app's icon system
  Widget _buildSuccessIcon() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: AppIcon.successIcon.widget(
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Main success heading text
  Widget _buildSuccessHeading() {
    return SizedBox(
      width: double.infinity,
      child: AppText.primary(
        LocaleKeys.successScreen_heading.tr,
        fontFamily: FontFamilyType.poppins,
        fontSize: 24,
        fontWeight: FontWeightType.semiBold,
        color: AppColors.black,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Success message text
  Widget _buildSuccessMessage() {
    return SizedBox(
      width: double.infinity,
      child: AppText.primary(
        widget.controller.getSuccessMessage(),
        fontFamily: FontFamilyType.inter,
        fontSize: 16,
        fontWeight: FontWeightType.regular,
        color: AppColors.textSecondary,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget? buildBottomBar() {
    return Obx(() {
      if (widget.controller.shouldShowTwoButtons()) {
        return _buildTwoButtons();
      } else {
        return _buildSingleButton();
      }
    });
  }

  /// Single button layout for signup flows
  Widget _buildSingleButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: PrimaryButton(
        color: AppColors.primary,
        textColor: AppColors.white,
        title: widget.controller.getButtonText(),
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
          widget.controller.navigateToNextScreen();
        },
      ),
    );
  }

  /// Two buttons layout for payment success
  Widget _buildTwoButtons() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Go to My Sessions Button
          PrimaryButton(
            color: AppColors.primary,
            textColor: AppColors.white,
            title: 'Go to My Sessions',
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
              widget.controller.goToMySessions();
            },
          ),
          gapH12,
          
          // Back to Home Button - Custom outlined button
          GestureDetector(
            onTap: () {
              widget.controller.goToHome();
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary,
                  width: 1,
                ),
                color: AppColors.white,
              ),
              child: Center(
                child: AppText.primary(
                  'Back to Home',
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
