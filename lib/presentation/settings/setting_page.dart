import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/presentation/navigation/nav_controller.dart';
import 'package:recovery_consultation_app/presentation/settings/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_switch.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/config/app_routes.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';

class SettingPage extends BaseStatefulPage<SettingController> {
  const SettingPage({super.key});

  @override
  BaseStatefulPageState<SettingController> createState() => _SettingPageState();
}

class _SettingPageState extends BaseStatefulPageState<SettingController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              gapH14,
              Expanded(
                child: _buildProfileContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final NavController navController = Get.find();
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {
            if (navController.currentIndex == 4)
              {navController.changeTab(0)}
            else
              Get.back()
          },
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              'Settings',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        // Empty container to balance the layout
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildProfileContent() {
    // BaseStatefulPage handles loading automatically, so we don't need manual loading check
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() => _buildSettingsItem(
                'Appointment Reminders',
                AppIcon.appintmentReminderSetting.widget(
                  width: 18,
                  height: 18,
                  color: AppColors.accent,
                ),
                () {},
                showArrow: false,
                switchValue: widget.controller.reminderEnabled.value,
                onSwitchChanged: (val) =>
                    widget.controller.reminderEnabled.value = val,
              )),
          // gapH24,
          // _buildSettingsItem(
          //   'Help & FAQ\'s',
          //   AppIcon.helpSetting.widget(
          //     width: 18,
          //     height: 18,
          //     color: AppColors.accent,
          //   ),
          //   () => (),
          // ),
          if (widget.controller.roleManager.isPatient) ...[
             gapH14,
            _buildSettingsItem(
              'Payment History',
              AppIcon.navPayment.widget(
                width: 18,
                height: 18,
                color: AppColors.accent,
              ),
              () => (),
            ),
            gapH14,
            _buildSettingsItem(
              'My Orders',
              AppIcon.orderConfirmation.widget(
                width: 18,
                height: 18,
                color: AppColors.accent,
              ),
              () => widget.controller.goToMyOrders()),
          ],
          if (widget.controller.roleManager.isAdmin) ...[
            gapH14,
            _buildSettingsItem(
              'Manage Ad Banner',
              AppIcon.navPayment.widget(
                width: 18,
                height: 18,
                color: AppColors.accent,
              ),
              () => (Get.toNamed(AppRoutes.adminManageAdBannerPage)),
            ),
            gapH14,
            _buildSettingsItem(
              'Manage Feature Product',
              AppIcon.navPayment.widget(
                width: 18,
                height: 18,
                color: AppColors.accent,
              ),
              () => (Get.toNamed(AppRoutes.adminManageFeatureProductPage)),
            ),
            gapH14,
            _buildSettingsItem(
              'Medicine Product Listing',
              AppIcon.navPayment.widget(
                width: 18,
                height: 18,
                color: AppColors.accent,
              ),
              () => (Get.toNamed(AppRoutes.adminMedicineProductListingPage)),
            ),
            gapH14,
             _buildSettingsItem(
              'Medicine Orders',
              AppIcon.navPayment.widget(
                width: 18,
                height: 18,
                color: AppColors.accent,
              ),
              () => (Get.toNamed(AppRoutes.adminMedicineOrdersPage)),
            ),
            gapH14,
                        _buildSettingsItem(
              'Global Session Discount',
              AppIcon.navPayment.widget(
                width: 18,
                height: 18,
                color: AppColors.accent,
              ),
              () => (Get.toNamed(AppRoutes.adminGlobalSessionDiscountPage)),
            ),
            gapH14,
            _buildSettingsItem(
              'Pharmacy View',
              AppIcon.pharmacyIcon.widget(
                width: 18,
                height: 18,
                color: AppColors.accent,
              ),
              () => (Get.toNamed(AppRoutes.pharmacy)),
            ),
            gapH14,
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    Widget iconWidget,
    VoidCallback onTap, {
    bool showArrow = true,
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            iconWidget,
            gapW12,
            Expanded(
              child: AppText.primary(
                title,
                fontFamily: FontFamilyType.inter,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: AppColors.black,
              ),
            ),
            if (showArrow)
              AppIcon.forwardIcon
                  .widget(width: 12, height: 12, color: AppColors.accent)
            else
              AppSwitch(
                value: switchValue,
                onChanged: onSwitchChanged ??
                    (_) {
                      switchValue;
                    },
              ),
          ],
        ),
      ),
    );
  }
}
