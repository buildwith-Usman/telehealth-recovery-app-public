import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../../widgets/app_text.dart';

class RecentActivityFeed extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivityFeed({
    super.key,
    required this.activities,
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
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.primary(
                'Recent Activity',
                fontSize: 18,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.black,
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to full activity log
                },
                child: AppText.primary(
                  'View All',
                  fontSize: 14,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          gapH16,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 5 ? 5 : activities.length,
            separatorBuilder: (context, index) => gapH12,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(activity);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Row(
      children: [
        // Activity Type Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: activity.iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            activity.icon,
            color: activity.iconColor,
            size: 20,
          ),
        ),
        gapW12,
        // Activity Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(
                activity.title,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: AppColors.black,
                maxLines: 2,
              ),
              gapH2,
              AppText.primary(
                activity.subtitle,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
                maxLines: 1,
              ),
            ],
          ),
        ),
        gapW8,
        // Timestamp
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText.primary(
              activity.timestamp,
              fontSize: 12,
              fontWeight: FontWeightType.regular,
              color: AppColors.grey60,
            ),
            if (activity.isUrgent) ...[
              gapH2,
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String timestamp;
  final IconData icon;
  final Color iconColor;
  final bool isUrgent;
  final VoidCallback? onTap;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
    this.isUrgent = false,
    this.onTap,
  });
}
