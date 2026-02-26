import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/presentation/patient_home/patient_home_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/list_profile_card.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/section_header.dart';
import '../../app/config/app_enum.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/config/app_routes.dart';
import '../../app/utils/sizes.dart';
import '../../app/utils/image_url_utils.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/textfield/search_textfield.dart';
import '../widgets/banner/sliding_banner.dart';

class PatientHomePage extends BaseStatefulPage<PatientHomeController> {
  const PatientHomePage({super.key});

  @override
  BaseStatefulPageState<PatientHomeController> createState() =>
      _PatientHomePageState();
}

class _PatientHomePageState
    extends BaseStatefulPageState<PatientHomeController> {
      
  @override
  void setupAdditionalListeners() {
    // Set up patient-specific listeners
    // You can add listeners for patient home specific observables here
    // Example: listening for session updates, notification counts, etc.

    // Example: Listen for successful profile updates
    // ever(widget.controller.profileUpdateSuccess, (bool success) {
    //   if (success) {
    //     showSuccessToast('Profile updated successfully!');
    //   }
    // });
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await widget.controller.refreshDoctorsData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                      // _buildSectionTitle(),
                      const SectionHeader(
                        title: 'Upcoming Sessions',
                        titleFontSize: 20,
                        titleFontWeight: FontWeightType.semiBold,
                        titleColor: AppColors.primary,
                        showSeeAll: false,
                      ),
                      gapH16,
                    ],
                  ),
                ),
                // Banner without padding (full width)
                _buildUpcomingSessionsBanner(),
                gapH20,
                // Top Therapist Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Top Therapists',
                    titleFontSize: 16,
                    titleFontWeight: FontWeightType.semiBold,
                    titleColor: AppColors.primary,
                    showSeeAll: true,
                    onSeeAll: () {
                      if (kDebugMode) {
                        print('PatientHomePage: See All Therapist clicked!');
                      }
                      widget.controller.navigateToSpecialistList(
                          SpecialistType.therapist.name);
                    },
                  ),
                ),
                gapH16,
                // Horizontal Therapist List
                _buildTopTherapistList(),
                gapH20,
                // Top Psychiatrist Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Top Psychiatrists',
                    titleFontSize: 16,
                    titleFontWeight: FontWeightType.semiBold,
                    titleColor: AppColors.primary,
                    showSeeAll: true,
                    onSeeAll: () {
                      if (kDebugMode) {
                        print('PatientHomePage: See All Psychiatrist clicked!');
                      }
                      widget.controller.navigateToSpecialistList(
                          SpecialistType.psychiatrist.name);
                    },
                  ),
                ),
                gapH16,
                // Horizontal Psychiatrist List
                _buildTopPsychiatristList(),
                gapH20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Profile Avatar and Greeting
        Expanded(
          child: Row(
            children: [
              // Profile Avatar
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.profile);
                },
                child: Obx(() => ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        color: AppColors.grey80.withValues(alpha: 0.3),
                        child: Image.network(
                          ImageUrlUtils()
                              .getFullImageUrl(widget.controller.userImageUrl),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildPlaceholderImage(),
                        ),
                      ),
                    )),
              ),
              gapW12,
              // Greeting Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => AppText.primary(
                          'Hi, ${widget.controller.userName}',
                          fontFamily: FontFamilyType.poppins,
                          fontSize: 18,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.black,
                        )),
                    gapH2,
                    AppText.primary(
                      'How do you feel today?',
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
             // Pharmacy Button
            CustomNavigationButton.withAppIcon(
              onPressed: () {
                widget.controller.navigateToPharmacy();
              },
              appIcon: AppIcon.pharmacyIcon,
              isFilled: true,
              filledColor: AppColors.white,
              iconColor: AppColors.black,
              size: 40,
              iconSize: 22,
              showBorder: false,
            ),
            gapW10,
            // Notification Button
            CustomNavigationButton.withAppIcon(
              onPressed: () {
                widget.controller.navigateToNotifications();
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
  }

  Widget _buildSearchField() {
    return SearchTextField(
      hintText: 'Search here...',
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
        widget.controller.onSearchChanged(value);
      },
      onFieldSubmitted: (value) {
        widget.controller.onSearchSubmitted(value);
      },
    );
  }

  Widget _buildUpcomingSessionsBanner() {
    return Obx(() {
      final bannerItems = widget.controller.upcomingAppointmentsBanner;

      if (bannerItems.isEmpty) {
        // Show empty state or hide banner when no upcoming appointments
        return const SizedBox.shrink();
      }

      return SlidingBanner(
        items: bannerItems,
        height: 180,
        showIndicators: bannerItems.length > 1,
      );
    });
  }

  Widget _buildTopTherapistList() {
    return Obx(() {
      final therapists = widget.controller.topTherapists;

      if (therapists.isEmpty) {
        return Container(
          height: 220,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon.navDoctors.widget(
                  width: 48,
                  height: 48,
                  color: AppColors.grey80,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No therapists available',
                  style: TextStyle(
                    color: AppColors.grey80,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SizedBox(
        height: 220,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: therapists.length,
          itemBuilder: (context, index) {
            final therapist = therapists[index];
            return SizedBox(
              width: 180,
              child: ListProfileCard(
                item: _mapDoctorToSpecialistItem(therapist),
                margin: EdgeInsets.zero,
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 12),
        ),
      );
    });
  }

  Widget _buildTopPsychiatristList() {
    return Obx(() {
      final psychiatrists = widget.controller.topPsychiatrists;

      if (psychiatrists.isEmpty) {
        return Container(
          height: 215,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppIcon.navDoctors.widget(
                  width: 48,
                  height: 48,
                  color: AppColors.grey80,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No psychiatrists available',
                  style: TextStyle(
                    color: AppColors.grey80,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SizedBox(
        height: 215,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: psychiatrists.length,
          itemBuilder: (context, index) {
            final psychiatrist = psychiatrists[index];
            return SizedBox(
              width: 180,
              child: ListProfileCard(
                item: _mapDoctorToSpecialistItem(psychiatrist),
                margin: EdgeInsets.zero,
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(width: 12),
        ),
      );
    });
  }

  Widget _buildPlaceholderImage({double size = 50}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AppImage.dummyDr.widget(width: 50, height: 50),
      ),
    );
  }

  /// Helper method to map DoctorInfoEntity to ProfileCardItem
  ProfileCardItem _mapDoctorToSpecialistItem(UserEntity user) {
    return ProfileCardItem(
      name: widget.controller.getDoctorDisplayName(user.name),
      profession: widget.controller
          .getDoctorSpecialization(user.doctorInfo?.specialization),
      degree: user.doctorInfo?.degree ?? '',
      experience: widget.controller.getDoctorExperience(user.doctorInfo),
      rating: widget.controller.getDoctorRating(user.reviews),
      noOfRatings: widget.controller.getNumberOfRatings(user.reviews),
      imageUrl: ImageUrlUtils().getFullImageUrl(user.fileInfo?.url),
      onTap: () => widget.controller.navigateToDoctorDetail(user.doctorInfo),
    );
  }
}
