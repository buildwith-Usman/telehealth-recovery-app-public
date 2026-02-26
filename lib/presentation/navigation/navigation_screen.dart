import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'nav_controller.dart';

class NavigationScreen extends GetView<NavController> {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex,
            children: controller.pages,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            child: controller.fabWidget,
            onPressed: () {
              // Handle FAB tap (e.g., open modal or switch tab)
              controller.changeTab(2); // Example: switch to middle tab
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked, // Use centerDocked for center FAB
          bottomNavigationBar: controller.shouldShowNavBar
              ? SafeArea(
                  top: false, // only respect bottom safe area
                  child: StylishBottomBar(
                    items: controller.navigationItems,
                    currentIndex: controller.currentIndex,
                    onTap: controller.changeTab,
                    fabLocation: StylishBarFabLocation.center,
                    hasNotch: true,
                    notchStyle: NotchStyle.circle,
                    option: AnimatedBarOptions(
                      iconStyle: IconStyle.animated,
                      barAnimation: BarAnimation.fade,
                    ),
                  ),
                )
              : null,
        ));
  }
}
