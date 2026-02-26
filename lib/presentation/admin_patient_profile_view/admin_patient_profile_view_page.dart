import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/textfield/primary_textfield.dart';
import 'admin_patient_profile_view_controller.dart';
import '../admin_patient_details/admin_patient_details_controller.dart';

class AdminPatientProfileViewPage
    extends BaseStatefulPage<AdminPatientProfileViewController> {
  const AdminPatientProfileViewPage({super.key});

  @override
  BaseStatefulPageState<AdminPatientProfileViewController> createState() =>
      _AdminPatientProfileViewPageState();
}

class _AdminPatientProfileViewPageState
    extends BaseStatefulPageState<AdminPatientProfileViewController> {
  @override
  void setupAdditionalListeners() {
    super.setupAdditionalListeners();
    if (kDebugMode) {
      print('ProfilePage - Additional listeners setup');
    }
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _UserNameSection(userName: widget.controller.userName),
          const SizedBox(height: 24),
          _UserInformationSection(controller: widget.controller),
          const SizedBox(height: 24),
          // _AccountSettingsSection(controller: widget.controller),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// -----------------
/// Reusable Section Widgets
/// -----------------

class _UserNameSection extends StatelessWidget {
  final RxString userName;
  const _UserNameSection({required this.userName});

  @override
  Widget build(BuildContext context) {
    // Get the parent AdminPatientDetailsController to access patient name
    final patientDetailsController = Get.find<AdminPatientDetailsController>();
    
    return Center(
      child: Obx(
        () => AppText.primary(
          patientDetailsController.patientName.isNotEmpty 
              ? patientDetailsController.patientName 
              : 'Loading...',
          fontFamily: FontFamilyType.poppins,
          fontSize: 24,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _UserInformationSection extends StatelessWidget {
  final AdminPatientProfileViewController controller;
  const _UserInformationSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Get the parent AdminPatientDetailsController to access patient data
    final patientDetailsController = Get.find<AdminPatientDetailsController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Patient Information',
          fontFamily: FontFamilyType.poppins,
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH16,
        Obx(
          () => ProfileField(
            label: 'Email',
            value: patientDetailsController.specialist.value?.email ?? 'N/A',
            icon: AppIcon.emailIcon.widget(width: 16, color: AppColors.accent),
          ),
        ),
        gapH12,
        Obx(
          () => ProfileField(
            label: 'Phone Number',
            value: patientDetailsController.specialist.value?.phone ?? 'N/A',
            icon: AppIcon.phoneIcon.widget(width: 16, color: AppColors.accent),
          ),
        ),
        gapH12,
        Obx(
          () => ProfileField(
            label: 'Gender',
            value: patientDetailsController.specialist.value?.patientInfo?.gender ?? 'N/A',
            icon: AppIcon.genderIcon(size: 16, color: AppColors.accent),
          ),
        ),
        gapH12,
        Obx(
          () => ProfileField(
            label: 'Date of Birth',
            value: patientDetailsController.specialist.value?.patientInfo?.dob ?? 'N/A',
            icon:
                AppIcon.datePickerIcon.widget(width: 16, color: AppColors.accent),
          ),
        ),
        gapH12,
        Obx(
          () => ProfileField(
            label: 'Age',
            value: patientDetailsController.specialist.value?.patientInfo?.age?.toString() ?? 'N/A',
            icon: AppIcon.ageIcon(size: 16, color: AppColors.accent),
          ),
        ),
      ],
    );
  }
}

class _AccountSettingsSection extends StatelessWidget {
  final AdminPatientProfileViewController controller;
  const _AccountSettingsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Account Settings',
          fontFamily: FontFamilyType.poppins,
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH16,
        SettingsItem(
          title: 'Change Password',
          icon: AppIcon.lockFlutterIcon(size: 18, color: AppColors.primary),
          onTap: controller.onChangePassword,
        ),
        gapH12,
        SettingsItem(
          title: 'Account Settings',
          icon: AppIcon.navSetting
              .widget(width: 18, height: 18, color: AppColors.primary),
          onTap: controller.onAccountSettings,
        ),
      ],
    );
  }
}

/// -----------------
/// Reusable Field & Settings Widgets
/// -----------------

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final Widget? icon;

  const ProfileField({super.key, 
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          label,
          fontFamily: FontFamilyType.poppins,
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.primary,
        ),
        gapH8,
        PrimaryTextField(
          initialValue: value,
          height: 50,
          radius: 6,
          readOnly: true,
          showBorder: true,
          suffixIcon: icon,
          backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  const SettingsItem({super.key, 
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            icon,
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
                .widget(width: 12, height: 12, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
