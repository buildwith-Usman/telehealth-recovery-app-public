import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onSeeAll;
  final bool showSeeAll;
  final Color? titleColor;
  final Color? actionColor;
  final double titleFontSize;
  final double actionFontSize;
  final FontWeightType titleFontWeight;
  final FontWeightType actionFontWeight;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.actionText = 'See all',
    this.showSeeAll = true,
    this.titleColor,
    this.actionColor,
    this.titleFontSize = 18,
    this.actionFontSize = 14,
    this.titleFontWeight = FontWeightType.semiBold,
    this.actionFontWeight = FontWeightType.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side — section title
        AppText.primary(
          title,
          fontFamily: FontFamilyType.poppins,
          fontSize: titleFontSize,
          fontWeight: titleFontWeight,
          color: titleColor ?? AppColors.primary,
        ),
        // Right side — "See all"
        if (showSeeAll) ...[
          InkWell(
            borderRadius: BorderRadius.circular(4),
            splashColor: (actionColor ?? AppColors.accent).withOpacity(0.1),
            onTap: onSeeAll,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: AppText.primary(
                actionText,
                fontFamily: FontFamilyType.inter,
                fontSize: actionFontSize,
                fontWeight: actionFontWeight,
                color: actionColor ?? AppColors.accent,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
