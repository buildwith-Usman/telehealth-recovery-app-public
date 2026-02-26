import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/presentation/onboarding/onboarding_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/custom_navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/config/app_colors.dart';
import '../../app/utils/sizes.dart';
import '../../generated/locales.g.dart';
import '../widgets/app_text.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildOnboardingContent(context),
    );
  }

  Widget _buildOnboardingContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Main onboarding content
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: [
                _buildOnboardingSlide(
                  context,
                  image: AppImage.onBoardingFlowOne,
                  title: LocaleKeys.onboarding_pageOne_title.tr,
                  subtitle: LocaleKeys.onboarding_pageOne_subtitle.tr,
                ),
                _buildOnboardingSlide(
                  context,
                  image: AppImage.onBoardingFlowTwo,
                  title: LocaleKeys.onboarding_pageTwo_title.tr,
                  subtitle: LocaleKeys.onboarding_pageTwo_subtitle.tr,
                ),
                _buildOnboardingSlide(
                  context,
                  image: AppImage.onBoardingFlowThree,
                  title: LocaleKeys.onboarding_pageThree_title.tr,
                  subtitle: LocaleKeys.onboarding_pageThree_subtitle.tr,
                ),
              ],
            ),
          ),

          // Bottom section with dots, navigation and buttons
          _buildBottomSection(context),
        ],
      ),
    );
  }

  Widget _buildOnboardingSlide(
    BuildContext context, {
    required AppImageBuilder image,
    required String title,
    required String subtitle,
  }) {
    // Different configurations for different images
    double imageHeight;
    BoxFit imageFit;

    // Configure based on image type
    if (image == AppImage.onBoardingFlowOne) {
      // First image configuration (adjust based on your image)
      imageHeight = 160;
      imageFit = BoxFit.cover;
    } else if (image == AppImage.onBoardingFlowTwo) {
      // Second image configuration (adjust based on your image)
      imageHeight = 210;
      imageFit = BoxFit.contain;
    } else if (image == AppImage.onBoardingFlowThree) {
      // Third image configuration (adjust based on your image)
      imageHeight = 210;
      imageFit = BoxFit.contain;
    } else {
      // Default configuration
      imageHeight = 180;
      imageFit = BoxFit.contain;
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 50), // Changed from 20 to 50
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the content vertically
        children: [
          // Image section with dynamic sizing
          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: ClipRRect(
              child: image.widget(fit: imageFit),
            ),
          ),
          gapH40, // Reduced from gapH40
          // Title
          AppText.primary(
            title,
            fontFamily: FontFamilyType.poppins,
            fontSize: 20,
            fontWeight: FontWeightType.bold,
            color: AppColors.black,
            textAlign: TextAlign.center,
          ),

          gapH10, // Reduced from gapH12

          // Subtitle
          AppText.primary(
            subtitle,
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page dots indicator
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: controller.currentPageIndex.value == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: controller.currentPageIndex.value == index
                          ? AppColors.accent
                          : AppColors.whiteLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              )),

          gapH30,

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous button (only show from page 1 onwards)
              Obx(() => controller.currentPageIndex.value == 0
                  ? const SizedBox(width: 45) // Empty space on first page
                  : CustomNavigationButton(
                      type: NavigationButtonType.previous,
                      onPressed: () => controller.previousPage(),
                    )),

              // Next button for all pages
              CustomNavigationButton(
                type: NavigationButtonType.next,
                onPressed: () => controller.currentPageIndex.value == 2
                    ? controller.completeOnboarding()
                    : controller.nextPage(),
              ),
            ],
          ),

          gapH20,
        ],
      ),
    );
  }
}
