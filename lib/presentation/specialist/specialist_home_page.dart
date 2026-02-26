import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/presentation/specialist/specialist_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/item_vertical_card.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_grid_view.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/section_header.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/textfield/search_textfield.dart';
import '../widgets/banner/sliding_banner.dart';

class SpecialistHomePage extends BaseStatefulPage<SpecialistHomeController> {
  const SpecialistHomePage({super.key});

  @override
  BaseStatefulPageState<SpecialistHomeController> createState() =>
      _SpecialistHomePageState();
}

class _SpecialistHomePageState
    extends BaseStatefulPageState<SpecialistHomeController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header and Search with padding
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    gapH20,
                    _buildSearchField(),
                    gapH20,
                    const SectionHeader(
                      title: 'Upcoming Sessions',
                      titleFontSize: 20,
                      titleFontWeight: FontWeightType.semiBold,
                      titleColor: AppColors.black,
                      showSeeAll: false,
                    ),
                    gapH10,
                  ],
                ),
              ),
              // Banner without padding (full width)
          Obx(() => _buildUpcomingAppointmentsBanner()),
              gapH20,
              // Recent Patients Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: 'Recent Patients',
                  titleFontSize: 20,
                  titleFontWeight: FontWeightType.semiBold,
                  titleColor: AppColors.black,
                  onSeeAll: (){
                    widget.controller.navigateToPatientsList();
                  },
                ),
              ),
              gapH10,
              // Horizontal Patients List
          Obx(() => _buildRecentPatientsList()),
              gapH30
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(() {
      final userName = widget.controller.userName;
      final userImageUrl = widget.controller.userImageUrl;
      
      return Row(
        children: [
          // Profile Avatar and Greeting
          Expanded(
            child: Row(
              children: [
                // Profile Avatar
                GestureDetector(
                  onTap: () {
                    widget.controller.navigateToSpecialistProfile();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey80.withOpacity(0.3),
                      image: userImageUrl != null && userImageUrl.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(userImageUrl),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: userImageUrl == null || userImageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            color: AppColors.textSecondary,
                            size: 30,
                          )
                        : null,
                  ),
                ),
                gapW12,
                // Greeting Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.primary(
                        'Hi, $userName',
                        fontFamily: FontFamilyType.poppins,
                        fontSize: 18,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.black,
                      ),
                      gapH2,
                      AppText.primary(
                        'Ready to help your patients today?',
                        fontFamily: FontFamilyType.inter,
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          gapW16,
          // Right Action Buttons
          Row(
            children: [
              // Notification Button
              CustomNavigationButton.withAppIcon(
                onPressed: () {
                  // Handle notification action
                },
                appIcon: AppIcon.notification,
                isFilled: true,
                filledColor: AppColors.white,
                iconColor: AppColors.black,
                size: 40,
                iconSize: 22,
                showBorder: false,
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildSearchField() {
    return SearchTextField(
      hintText: 'Search patients...',
      height: 50,
      borderRadius: 8,
      backgroundColor: AppColors.white,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AppIcon.searchIcon.widget(
          width: 24,
          height: 24,
        ),
      ),
      onChanged: (value) {
        // Handle search input for patients
        print('Patient search query: $value');
      },
      onFieldSubmitted: (value) {
        // Handle patient search submission
        print('Patient search submitted: $value');
      },
    );
  }

  Widget _buildUpcomingAppointmentsBanner() {
    final bannerItems = widget.controller.upcomingAppointmentsBanner;

    if (bannerItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AppText.primary(
          'No upcoming sessions',
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      );
    }

    return SlidingBanner(
      items: bannerItems,
      height: 180,
      showIndicators: true,
    );
  }

  Widget _buildRecentPatientsList() {
    final recentPatients = widget.controller.recentPatients;

    if (recentPatients.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AppText.primary(
          'No recent patients to show',
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      );
    }

    return RecoveryGridView(
      itemCount: recentPatients.length,
      itemBuilder: (context, index) {
        return ItemVerticalCard(
          margin: EdgeInsets.zero,
          item: recentPatients[index],
        );
      },
      mainAxisExtent: 220,
    );
  }
}
