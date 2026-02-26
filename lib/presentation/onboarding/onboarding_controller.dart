import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/config/app_routes.dart';
import '../../domain/usecase/set_has_onboarding_use_case.dart';
import '../../di/client_module.dart';

class OnboardingController extends GetxController with ClientModule {
  OnboardingController({
    required this.setHasOnboardingUseCase,
  });

  // =========== Usecases ====================
  final SetHasOnboardingUseCase setHasOnboardingUseCase;

  late PageController pageController;
  RxInt currentPageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  void nextPage() {
    if (currentPageIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPageIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> completeOnboarding() async {
    try {
      print("Save Complete OnBoarding");
      // Save onboarding completion using clean architecture
      await setHasOnboardingUseCase.execute(true);
      goToLoginScreen();
    } catch (e) {
      print("Error completing onboarding: $e");
      // Even if saving fails, continue to login screen
      goToLoginScreen();
    }
  }

  void goToLoginScreen() {
    Get.offNamed(AppRoutes.logIn);
  }
}
