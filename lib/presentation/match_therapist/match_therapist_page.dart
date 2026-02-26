import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/entity/match_doctors_list_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/domain/models/specialist_item.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/base_horizontal_profile_card.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/cards/specialist_card.dart';
import 'match_therapist_controller.dart';

class MatchTherapistPage extends BaseStatefulPage<MatchTherapistController> {
  const MatchTherapistPage({super.key});

  @override
  BaseStatefulPageState<MatchTherapistController> createState() =>
      _MatchTherapistPageState();
}

class _MatchTherapistPageState
    extends BaseStatefulPageState<MatchTherapistController> {
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
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomNavigationButton.withAppIcon(
          onPressed: () => widget.controller.goToDashboard(),
          appIcon: AppIcon.navHome,
          iconColor: AppColors.accent,
          isFilled: true,
          filledColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              'Matched Therapists',
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

  Widget _buildBody() {
    if (widget.controller.isLoading.value) {
      return _buildLoadingState();
    }

    if (widget.controller.errorMessage != null &&
        widget.controller.errorMessage!.isNotEmpty) {
      return _buildErrorState();
    }

    if (!widget.controller.hasMatches) {
      return _buildNoMatchesState();
    }

    return _buildMatchesList();
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
            'Finding your perfect therapy match...',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.medium,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH8,
          AppText.primary(
            'We\'re analyzing your preferences to find the best therapists for you.',
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          gapH20,
          AppText.primary(
            'Oops! Something went wrong',
            fontFamily: FontFamilyType.inter,
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH8,
          AppText.primary(
            widget.controller.errorMessage ??
                'Unable to load matched therapists',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH30,
          PrimaryButton(
            title: 'Try Again',
            onPressed: () => widget.controller.retryMatching(),
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 55,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildNoMatchesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary,
          ),
          gapH20,
          AppText.primary(
            'No Matches Found',
            fontFamily: FontFamilyType.inter,
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH8,
          AppText.primary(
            widget.controller.noDocsMessage,
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH30,
          PrimaryButton(
            title: 'Browse All Therapists',
            onPressed: () => widget.controller.skipMatching(),
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 55,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesList() {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.controller.refreshDoctors();
      },
      child: ListView.builder(
        itemCount: widget.controller.matchedDoctors.length,
        itemBuilder: (context, index) {
          final doctor = widget.controller.matchedDoctors[index];
          return _buildSpecialistCard(doctor);
        },
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

  Widget _buildDoctorCard(DoctorUserEntity doctor, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: SpecialistCard(
        specialist: SpecialistItem(
          name: doctor.name ?? 'Unknown Doctor',
          profession: doctor.doctorInfo?.specialization ?? 'Specialist',
          credentials: doctor.doctorInfo?.degree ?? '',
          experience: doctor.doctorInfo?.experience ?? '0 Years',
          rating: 4.5, // Default rating since not in API
          imageUrl: doctor.profileImage,
          onTap: () => widget.controller.onDoctorTap(doctor),
        ),
      ),
    );
  }

  @override
  void setupAdditionalListeners() {
    // Could add additional page-specific listeners here if needed
  }
}
