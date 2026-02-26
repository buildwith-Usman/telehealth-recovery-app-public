import 'package:recovery_consultation_app/presentation/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/config/app_colors.dart';
import '../../app/config/app_image.dart';
import '../../app/utils/sizes.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildSplashContent(),
    );
  }


  Widget _buildSplashContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Splash Logo/Icon
          AppImage.splashIcon.widget(
            width: 130,
            height: 135,
          ),
          gapH40,
          // Progress Indicator
          Obx(() => CircularProgressIndicator(
            value: controller.progressValue.value,
            color: AppColors.primary,
            backgroundColor: AppColors.primary.withValues(alpha: 0.3),
            strokeWidth: 3,
          )),
        ],
      ),
    );
  }
}
