import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/presentation/specialist/specialist_view_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/base_horizontal_profile_card.dart';
import 'package:recovery_consultation_app/presentation/widgets/tabLayout/custom_tab_layout.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/button/primary_button.dart';

/// Unified specialist view page
/// Adapts UI based on configuration (patient/specialist/admin view)
/// Follows DRY principle - single page for all specialist viewing scenarios
class SpecialistViewPage extends BaseStatefulPage<SpecialistViewController> {
  const SpecialistViewPage({super.key});

  @override
  BaseStatefulPageState<SpecialistViewController> createState() =>
      _SpecialistViewPageState();
}

class _SpecialistViewPageState
    extends BaseStatefulPageState<SpecialistViewController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                gapH20,
                Obx(() => _buildSpecialistCard(widget.controller.specialistDetails.value)),
                gapH6,
                SizedBox(
                  // Adjust height based on screen size
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: CustomTabLayout(
                    tabs: widget.controller.tabPages,
                    pages: widget.controller.tabWidgets,
                    onTabChanged: (index) {
                      debugPrint("Switched to tab $index");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.controller.showBottomButton
          ? _buildBottomActionBar()
          : null,
    );
  }

  /// Build header with back button and title
  Widget _buildHeader() {
    return Row(
      children: [
        // Back button
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => widget.controller.goBack(),
          isFilled: true,
          filledColor: AppColors.white,
          iconColor: AppColors.accent,
          size: 40,
          iconSize: 18,
          showBorder: false,
        ),
        // Title centered
        Expanded(
          child: Center(
            child: AppText.primary(
              widget.controller.screenTitle,
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        // Invisible spacer to balance left button
        const SizedBox(width: 40),
      ],
    );
  }

  /// Build specialist profile card
  Widget _buildSpecialistCard(ProfileCardItem specialist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: BaseHorizontalProfileCard(
        item: specialist,
      ),
    );
  }

  /// Build bottom action button (Book/Edit Profile)
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: PrimaryButton(
          title: widget.controller.bottomButtonText,
          onPressed: () => widget.controller.navigationButtonClick(),
          color: AppColors.primary,
          textColor: AppColors.white,
          height: 48,
          radius: 8,
          showIcon: true,
          iconWidget: AppIcon.rightArrowIcon.widget(
            width: 10,
            height: 10,
            color: AppColors.white,
          ),
          fontWeight: FontWeightType.semiBold,
        ),
      ),
    );
  }
}
