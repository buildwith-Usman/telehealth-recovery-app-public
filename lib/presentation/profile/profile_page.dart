import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/textfield/primary_textfield.dart';
import 'profile_controller.dart';

class ProfilePage extends BaseStatefulPage<ProfileController> {
  const ProfilePage({super.key});

  @override
  BaseStatefulPageState<ProfileController> createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseStatefulPageState<ProfileController> {
  @override
  void setupAdditionalListeners() {
    super.setupAdditionalListeners();

    // Add any profile-specific listeners here if needed
    // For example, listen for profile updates
    if (kDebugMode) {
      print('ProfilePage - Additional listeners setup');
    }
  }

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
              gapH16,
              Expanded(
                child: Obx(() => _buildProfileContent()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => Get.back(),
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              'Profile',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        // Empty container to balance the layout (no action button)
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildProfileContent() {
    // BaseStatefulPage handles loading automatically, so we don't need manual loading check
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileImageSection(),
          gapH24,
          _buildUserNameSection(),
          gapH24,
          _buildUserInformationSection(),
          gapH24,
          // _buildAccountSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: GestureDetector(
        onTap: () => widget.controller.onChangeProfileImage(),
        child: Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteLight,
          ),
          child: ClipOval(
            child: widget.controller.profileImageUrl.isNotEmpty
                ? Image.network(
                    widget.controller.profileImageUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  )
                : _buildPlaceholderImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.whiteLight,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          color: AppColors.textSecondary,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildUserNameSection() {
    return Center(
      child: Column(
        children: [
          Obx(() => AppText.primary(
                widget.controller.userName.isNotEmpty
                    ? widget.controller.userName
                    : 'Loading...',
                fontFamily: FontFamilyType.poppins,
                fontSize: 24,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.black,
                textAlign: TextAlign.center,
              )),
          gapH16,
          // Edit Profile Button
          PrimaryButton(
            title: 'Edit Profile',
            onPressed: () => widget.controller.onEditProfile(),
            width: 150,
            height: 40,
            showIcon: true,
            iconWidget: const Icon(
              Icons.edit,
              size: 14,
              color: AppColors.white,
            ),
            color: AppColors.primary,
            textColor: AppColors.white,
            fontWeight: FontWeightType.medium,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInformationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          AppText.primary(
            'User Information',
            fontFamily: FontFamilyType.poppins,
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.black,
          ),
          gapH16,
          // User Information Items
          Obx(() => _buildInfoItem('Email', widget.controller.userEmail,
              AppIcon.emailIcon.widget(width: 16, color: AppColors.accent))),
          gapH12,
          Obx(() => _buildInfoItem(
              'Phone Number',
              widget.controller.phoneNumber,
              AppIcon.phoneIcon.widget(width: 16, color: AppColors.accent))),
          gapH12,
          Obx(() => _buildInfoItem('Gender', widget.controller.gender,
              AppIcon.genderIcon(size: 16, color: AppColors.accent))),
          gapH12,
          Obx(() => _buildInfoItem(
              'Date of Birth',
              widget.controller.dateOfBirth,
              AppIcon.datePickerIcon
                  .widget(width: 16, color: AppColors.accent))),
          gapH12,
          Obx(() => _buildInfoItem('Age', widget.controller.age,
              AppIcon.ageIcon(size: 16, color: AppColors.accent))),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, [Widget? suffixIcon]) {
    if (kDebugMode) {
      print(
          '_buildInfoItem - Label: $label, Value: "$value", IsEmpty: ${value.isEmpty}');
    }

    // Hide the field if value is empty (would show "Not provided")
    if (value.isEmpty) {
      return const SizedBox.shrink(); // Return empty widget
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        AppText.primary(
          label,
          fontFamily: FontFamilyType.poppins,
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.primary,
        ),
        gapH8,
        // PrimaryTextField - read-only display
        PrimaryTextField(
          initialValue: value,
          height: 50,
          radius: 6,
          showBorder: true,
          readOnly: true,
          suffixIcon: suffixIcon,
          backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
        // gapH12, // Add some spacing after the field
      ],
    );
  }

  Widget _buildAccountSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          AppText.primary(
            'Account Settings',
            fontFamily: FontFamilyType.poppins,
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.black,
          ),
          gapH16,
          // Account Settings Items
          _buildSettingsItem(
            'Change Password',
            AppIcon.lockFlutterIcon(
              size: 18,
              color: AppColors.primary,
            ),
            () => widget.controller.onChangePassword(),
          ),
          gapH12,
          _buildSettingsItem(
            'Account Settings',
            AppIcon.navSetting.widget(
              width: 18,
              height: 18,
              color: AppColors.primary,
            ),
            () => widget.controller.onAccountSettings(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
      String title, Widget iconWidget, VoidCallback onTap) {
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
                color: AppColors.textPrimary,
              ),
            ),
            AppIcon.forwardIcon
                .widget(width: 12, height: 12, color: AppColors.accent)
          ],
        ),
      ),
    );
  }
}
