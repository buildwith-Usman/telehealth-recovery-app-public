import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/base_horizontal_profile_card.dart';
import 'package:recovery_consultation_app/presentation/widgets/tabLayout/custom_tab_layout.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/button/custom_navigation_button.dart';
import 'specialist_profile_view_controller.dart';

class SpecialistProfileViewPage
    extends BaseStatefulPage<SpecialistProfileViewController> {
  const SpecialistProfileViewPage({super.key});

  @override
  BaseStatefulPageState<SpecialistProfileViewController> createState() =>
      _SpecialistProfileViewPageState();
}

class _SpecialistProfileViewPageState
    extends BaseStatefulPageState<SpecialistProfileViewController> {
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
                  // Obx(() => _buildHeader()),
                  _buildHeader(),// Fixed header
                  gapH20,
                  Obx(() =>
                      _buildSpecialistCard(widget.controller.specialistDetail)),
                  // _buildSpecialistCard(widget.controller.specialistDetail),
                  gapH6,
                  // Expanded Tab Layout
                  // Obx(
                  //       () =>
                            SizedBox(
                      // You might need to adjust this height
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: CustomTabLayout(
                        tabs: widget.controller.tabPages,
                        pages: widget.controller.tabWidgets,
                        onTabChanged: (index) {
                          debugPrint("Switched to tab $index");
                        },
                      ),
                    ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomActionBar()
        // widget.controller.roleManager.currentRole == UserRole.admin
        //     ? _buildBottomActionBar()
        //     : null,
        );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Left button
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {
            // widget.controller.goBack()
            Navigator.pop(context)
          },
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

  Widget _buildSpecialistCard(ProfileCardItem specialist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: BaseHorizontalProfileCard(
        item: specialist,
      ),
    );
  }

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
