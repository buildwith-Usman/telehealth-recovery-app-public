import 'package:flutter/material.dart';
import '../../app/config/app_colors.dart';
import '../../app/utils/sizes.dart';
import '../../data/models/rating_statistics.dart';
import 'app_text.dart';

/// Average Rating Widget similar to Google Play Store
///
/// Displays:
/// - Overall rating score
/// - Total number of reviews
/// - Star rating breakdown with progress bars (5 to 1 stars)
class AverageRatingWidget extends StatelessWidget {
  final RatingStatistics statistics;

  const AverageRatingWidget({
    super.key,
    required this.statistics,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Overall rating and total reviews
          _buildOverallRating(),
          gapW24,
          // Right side: Rating breakdown bars
          Expanded(
            child: _buildRatingBars(),
          ),
        ],
      ),
    );
  }

  /// Builds the left side with overall rating number and total reviews
  Widget _buildOverallRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Overall rating number
        AppText.primary(
          statistics.averageRating.toStringAsFixed(1),
          fontSize: 48,
          fontWeight: FontWeightType.bold,
          color: AppColors.textPrimary,
        ),
        gapH4,
        // Star icons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              index < statistics.averageRating.floor()
                  ? Icons.star
                  : (index < statistics.averageRating
                      ? Icons.star_half
                      : Icons.star_border),
              size: 16,
              color: AppColors.pendingColor,
            );
          }),
        ),
        gapH8,
        // Total reviews text
        AppText.primary(
          '${statistics.totalReviews} ${statistics.totalReviews == 1 ? 'review' : 'reviews'}',
          fontSize: 12,
          fontWeight: FontWeightType.medium,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  /// Builds the right side with rating bars (5 to 1 stars)
  Widget _buildRatingBars() {
    return Column(
      children: [
        _buildRatingBar(5, statistics.fiveStarCount, statistics.getFiveStarPercentage()),
        gapH8,
        _buildRatingBar(4, statistics.fourStarCount, statistics.getFourStarPercentage()),
        gapH8,
        _buildRatingBar(3, statistics.threeStarCount, statistics.getThreeStarPercentage()),
        gapH8,
        _buildRatingBar(2, statistics.twoStarCount, statistics.getTwoStarPercentage()),
        gapH8,
        _buildRatingBar(1, statistics.oneStarCount, statistics.getOneStarPercentage()),
      ],
    );
  }

  /// Builds individual rating bar
  Widget _buildRatingBar(int stars, int count, double percentage) {
    return Row(
      children: [
        // Star number
        AppText.primary(
          '$stars',
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.textPrimary,
        ),
        gapW4,
        // Star icon
        const Icon(
          Icons.star,
          size: 14,
          color: AppColors.pendingColor,
        ),
        gapW8,
        // Progress bar
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.grey90,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.pendingColor),
              minHeight: 8,
            ),
          ),
        ),
        gapW8,
        // Count
        SizedBox(
          width: 30,
          child: AppText.primary(
            '$count',
            fontSize: 12,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
