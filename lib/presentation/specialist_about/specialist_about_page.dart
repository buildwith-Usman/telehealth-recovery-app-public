import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/review_card.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import 'specialist_about_controller.dart';

class SpecialistAboutPage extends BaseStatefulPage<SpecialistAboutController> {
  const SpecialistAboutPage({super.key});

  @override
  BaseStatefulPageState<SpecialistAboutController> createState() =>
      _SpecialistAboutPageState();
}

class _SpecialistAboutPageState
    extends BaseStatefulPageState<SpecialistAboutController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAboutSection(),
          gapH16,
          _buildReviewsSection(),
        ],
      ),
    );
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
        gapH12,
        _buildStatsSection(),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildStatItem(
                  iconWidget: AppIcon.patientIcon.widget(width: 70, height: 70),
                  value: widget.controller.patientsCount,
                  label: 'Patients'),
            ),
            gapW16,
            Expanded(
              child: _buildStatItem(
                  iconWidget:
                      AppIcon.experienceIcon.widget(width: 70, height: 70),
                  value: '${widget.controller.experienceDisplay} Years',
                  label: 'Experience'),
            ),
            gapW16,
            Expanded(
              child: _buildStatItem(
                  iconWidget: AppIcon.ratingIcon.widget(width: 70, height: 70),
                  value: widget.controller.ratingDisplay,
                  label: 'Ratings'),
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
          gapH8,
          AppText.primary(value,
              fontSize: 16,
              fontWeight: FontWeightType.bold,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center),
          gapH4,
          AppText.primary(label,
              fontSize: 12,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Obx(() {
      final hasReviews = widget.controller.hasReviews;
      final reviews = widget.controller.reviews;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.primary(
            "Patient Reviews",
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          gapH12,
          hasReviews
              ? SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: reviews.length,
                    separatorBuilder: (_, __) => gapW12,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return SizedBox(
                        width: 280,
                        child: ReviewCard(
                          name: "Patient", // TODO: Get patient name from API
                          rating: review.rating?.toDouble() ?? 0.0,
                          date: _formatDate(review.createdAt),
                          comment: review.review ?? "No comment provided",
                        ),
                      );
                    },
                  ),
                )
              : _buildEmptyReviewsState(),
        ],
      );
    });
  }

  Widget _buildEmptyReviewsState() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.rate_review_outlined,
              size: 48,
              color: AppColors.accent,
            ),
            gapH8,
            AppText.primary(
              "No reviews yet",
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "Unknown date";
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return "${date.day} ${months[date.month - 1]}, ${date.year}";
    } catch (e) {
      return "Unknown date";
    }
  }
}
