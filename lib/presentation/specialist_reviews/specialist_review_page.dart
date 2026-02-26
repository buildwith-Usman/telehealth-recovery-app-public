import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/review_card.dart';
import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../../data/models/rating_statistics.dart';
import '../widgets/app_text.dart';
import '../widgets/average_rating_widget.dart';
import 'specialist_review_controller.dart';

class SpecialistReviewPage
    extends BaseStatefulPage<SpecialistReviewController> {
  const SpecialistReviewPage({super.key});

  @override
  BaseStatefulPageState<SpecialistReviewController> createState() =>
      _SpecialistReviewPageState();
}

class _SpecialistReviewPageState
    extends BaseStatefulPageState<SpecialistReviewController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: 0, vertical: 10), // optional padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildReviewsSection(),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    // Example rating statistics (replace with actual data from controller/API)
    const ratingStats = RatingStatistics(
      averageRating: 4.5,
      totalReviews: 128,
      fiveStarCount: 85,
      fourStarCount: 30,
      threeStarCount: 8,
      twoStarCount: 3,
      oneStarCount: 2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Average Rating Widget (Google Play Store style)
        const AverageRatingWidget(statistics: ratingStats),
        gapH16,
        AppText.primary(
          'Reviews',
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.textPrimary,
        ),
        gapH16,
        const ReviewCard(
          name: "Dr. Sarah Khan",
          rating: 5.0,
          date: "25 Oct, 2025",
          comment: "Extremely professional and kind. Highly recommend!",
        ),
        gapH12,
        const ReviewCard(
          name: "Dr. Ali Raza",
          rating: 4.0,
          date: "22 Oct, 2025",
          comment: "Good consultation, explained everything clearly.",
        ),
        gapH12,
        const ReviewCard(
          name: "Dr. Fatima Noor",
          rating: 4.8,
          date: "20 Oct, 2025",
          comment:
              "Very attentive and understanding. Made me feel comfortable.",
        ),
        gapH12,
        const ReviewCard(
          name: "Dr. Hassan Malik",
          rating: 3.9,
          date: "18 Oct, 2025",
          comment: "Helpful session but took longer than expected.",
        ),
        gapH12,
        const ReviewCard(
          name: "Dr. Ayesha Siddiqui",
          rating: 5.0,
          date: "15 Oct, 2025",
          comment: "Excellent doctor! Friendly and knowledgeable.",
        ),
        gapH12,
      ],
    );
  }
}
