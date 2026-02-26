import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../../widgets/app_text.dart';

class AdminMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color? cardColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String? trend; // e.g., "+12%", "-5%"
  final bool showTrend;

  const AdminMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.cardColor,
    this.iconColor,
    this.onTap,
    this.trend,
    this.showTrend = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor ?? AppColors.white,
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
            // Header with icon and trend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 24,
                  ),
                ),
                if (showTrend && trend != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTrendColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AppText.primary(
                      trend!,
                      fontSize: 12,
                      fontWeight: FontWeightType.medium,
                      color: _getTrendColor(),
                    ),
                  ),
              ],
            ),
            gapH16,
            // Main value
            AppText.primary(
              value,
              fontSize: 24,
              fontWeight: FontWeightType.bold,
              color: AppColors.black,
            ),
            gapH4,
            // Title
            AppText.primary(
              title,
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.textSecondary,
            ),
            gapH2,
            // Subtitle
            AppText.primary(
              subtitle,
              fontSize: 12,
              fontWeight: FontWeightType.regular,
              color: AppColors.grey60,
            ),
          ],
        ),
      ),
    );
  }

  Color _getTrendColor() {
    if (trend == null) return AppColors.textSecondary;
    
    if (trend!.startsWith('+')) {
      return Colors.green;
    } else if (trend!.startsWith('-')) {
      return Colors.red;
    }
    return AppColors.textSecondary;
  }
}
