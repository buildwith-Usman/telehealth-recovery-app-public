import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../../app/utils/image_url_utils.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../specialist_detail/widgets/specialist_listing_profile_card.dart';
import 'specialist_approval_controller.dart';

class SpecialistApprovalPage
    extends BaseStatefulPage<SpecialistApprovalController> {
  const SpecialistApprovalPage({super.key});

  @override
  BaseStatefulPageState<SpecialistApprovalController> createState() =>
      _SpecialistApprovalPageState();
}

class _SpecialistApprovalPageState
    extends BaseStatefulPageState<SpecialistApprovalController> {
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
              _buildSpecialistTypeTabs(),
              gapH16,
              Expanded(
                child: Obx(() => _buildSpecialistList()),
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
              'Specialist Approval',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.refreshDoctors();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.refresh,
              color: AppColors.primary,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialistTypeTabs() {
    return Obx(() => Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.whiteLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey90.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildSpecialistTypeTab(
                  title: 'Therapists',
                  type: SpecialistType.therapist,
                  count: 0,
                  isSelected: widget.controller.selectedSpecialistType ==
                      SpecialistType.therapist,
                ),
              ),
              Expanded(
                child: _buildSpecialistTypeTab(
                  title: 'Psychiatrists',
                  type: SpecialistType.psychiatrist,
                  count: 0,
                  isSelected: widget.controller.selectedSpecialistType ==
                      SpecialistType.psychiatrist,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildSpecialistTypeTab({
    required String title,
    required SpecialistType type,
    required int count,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => widget.controller.selectSpecialistType(type),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.primary(
                title,
                fontFamily: FontFamilyType.poppins,
                fontSize: 12,
                fontWeight: FontWeightType.medium,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
              /// hide count for now
              // AppText.primary(
              //   '($count)',
              //   fontFamily: FontFamilyType.poppins,
              //   fontSize: 9,
              //   fontWeight: FontWeightType.regular,
              //   color: isSelected ? AppColors.accent : AppColors.grey60,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialistList() {
    final doctors = widget.controller.doctors;
    if (doctors.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await widget.controller.refreshDoctors();
      },
      child: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final user = doctors[index];
          return _buildSpecialistApprovalCard(user);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.approval_outlined,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          gapH16,
          AppText.primary(
            'No specialists found',
            fontFamily: FontFamilyType.poppins,
            fontSize: 18,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
          ),
          gapH8,
          AppText.primary(
            'Switch between therapist and psychiatrist tabs to see different specialist types',
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialistApprovalCard(UserEntity user) {
    final doctorInfo = user.doctorInfo;
    final bool isApproved = doctorInfo?.isApproved ?? false;
    final isApproving = widget.controller.isApprovingSpecialist(user.id);
    final isRejecting = widget.controller.isRejectingSpecialist(user.id);

    final name = user.name;
    final profession = doctorInfo?.specialization;
    // Convert relative image URL to full URL using ImageUrlUtils
    final imageUrl = ImageUrlUtils().getFullImageUrl(user.imageUrl);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Stack(
            children: [
              SpecialistListingProfileCard(
                name: name,
                profession: profession,
                imageUrl: imageUrl,
                onTap: () {
                  widget.controller
                      .navigateToEditProfile(user.id);
                },
              ),
            ],
          ),

          // show action buttons when NOT approved (pending)
          if (!isApproved) ...[
            gapH12,
            _buildActionButtons(user, isApproving, isRejecting),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      UserEntity user, bool isApproving, bool isRejecting) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey90.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              title: 'Reject',
              color: AppColors.red513,
              textColor: AppColors.white,
              isLoading: isRejecting,
              onPressed: isRejecting || isApproving
                  ? null
                  : () {
                      widget.controller.onStatusUpdate(user.id, 'rejected');
                    },
            ),
          ),
          gapW12,
          Expanded(
            child: _buildActionButton(
              title: 'Approve',
              color: AppColors.primary,
              textColor: AppColors.white,
              isLoading: isApproving,
              onPressed: isApproving || isRejecting
                  ? null
                  : () {
                      widget.controller.onStatusUpdate(user.id, 'approved');
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required Color color,
    required Color textColor,
    required bool isLoading,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : AppText.primary(
                title,
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.medium,
                color: textColor,
              ),
      ),
    );
  }
}
