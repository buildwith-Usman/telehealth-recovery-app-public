import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/base_horizontal_profile_card.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/button/custom_navigation_button.dart';
import 'specialist_detail_controller.dart';

class SpecialistDetailPage
    extends BaseStatefulPage<SpecialistDetailController> {
  const SpecialistDetailPage({super.key});

  @override
  BaseStatefulPageState<SpecialistDetailController> createState() =>
      _SpecialistDetailPageState();
}

class _SpecialistDetailPageState
    extends BaseStatefulPageState<SpecialistDetailController> {
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
              gapH20,
              Expanded(
                child: Obx(() => _buildBody()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          (widget.controller.roleManager.currentRole == UserRole.patient ||
                  widget.controller.roleManager.currentRole == UserRole.admin)
              ? _buildBottomActionBar()
              : null,
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
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
      ],
    );
  }

  Widget _buildBody() {
    if (widget.controller.isLoading.value) {
      return _buildLoadingState();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSpecialistCard(widget.controller.specialistDetail),
          gapH20,
          Obx(() => _buildToggleButtons()),
          gapH20,
          Obx(() => _buildContentSection()),
          gapH24,
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          gapH20,
          AppText.primary(
            'Loading specialist details...',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

  Widget _buildToggleButtons() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              title: 'About',
              type: DetailTabType.about,
              isSelected: widget.controller.selectedTab == DetailTabType.about,
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              title: 'Reviews',
              type: DetailTabType.reviews,
              isSelected:
                  widget.controller.selectedTab == DetailTabType.reviews,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required DetailTabType type,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => widget.controller.selectTab(type),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: AppText.primary(
            title,
            fontFamily: FontFamilyType.poppins,
            fontSize: 14,
            fontWeight: FontWeightType.medium,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    switch (widget.controller.selectedTab) {
      case DetailTabType.about:
        return _buildAboutSection();
      case DetailTabType.reviews:
        return _buildReviewsSection();
    }
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => AppText.primary(
              widget.controller.specialistBio,
              fontSize: 14,
              color: AppColors.textSecondary,
            )),
        gapH6,
        _buildStatsSection(),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildStatItem(
                iconWidget: AppIcon.patientIcon.widget(
                  width: 70,
                  height: 70,
                ),
                value: widget.controller.patientsCount,
                label: 'Patients',
              ),
            ),
            gapW16,
            Expanded(
              child: _buildStatItem(
                iconWidget: AppIcon.experienceIcon.widget(
                  width: 70,
                  height: 70,
                ),
                value: widget.controller.experienceDisplay,
                label: 'Experience',
              ),
            ),
            gapW16,
            Expanded(
              child: _buildStatItem(
                iconWidget: AppIcon.ratingIcon.widget(
                  width: 70,
                  height: 70,
                ),
                value: widget.controller.ratingDisplay,
                label: 'Ratings',
              ),
            ),
          ],
        ));
  }

  Widget _buildStatItem({
    required Widget iconWidget,
    required String value,
    required String label,
  }) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          iconWidget,
          gapH12,
          AppText.primary(
            value,
            fontSize: 16,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH4,
          AppText.primary(
            label,
            fontSize: 12,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Reviews',
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.textPrimary,
        ),
        gapH12,
        _buildReviewCard(
          name: 'Sarah Johnson',
          rating: 5.0,
          date: '2 days ago',
          comment:
              'Dr. Sarah was very professional and helped me a lot with my anxiety issues. Highly recommended!',
        ),
        gapH12,
        _buildReviewCard(
          name: 'Michael Chen',
          rating: 4.5,
          date: '1 week ago',
          comment:
              'Great experience with the therapy sessions. Dr. Sarah is very understanding and supportive.',
        ),
        gapH12,
        _buildReviewCard(
          name: 'Emily Rodriguez',
          rating: 5.0,
          date: '2 weeks ago',
          comment:
              'Excellent therapist! She really helped me work through my depression. Thank you!',
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String name,
    required double rating,
    required String date,
    required String comment,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile Picture
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey80.withValues(alpha: 0.3),
                ),
                child: AppIcon.userIcon.widget(
                  width: 20,
                  height: 20,
                  color: AppColors.textSecondary,
                ),
              ),
              gapW12,
              // Name and Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      name,
                      fontSize: 16,
                      fontWeight: FontWeightType.semiBold,
                      color: AppColors.textPrimary,
                    ),
                    gapH4,
                    Row(
                      children: [
                        // Star Rating
                        Row(
                          children: List.generate(5, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: Icon(
                                index < rating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              ),
                            );
                          }),
                        ),
                        gapW8,
                        AppText.primary(
                          date,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          gapH12,
          AppText.primary(
            comment,
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ],
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
