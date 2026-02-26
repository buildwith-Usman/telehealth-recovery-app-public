import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';

/// Reusable Section Header with Dropdown
/// Displays title on left and dropdown trigger (text + icon) on right
class SectionHeaderWithDropdown extends StatelessWidget {
  final String title;
  final String dropdownText;
  final VoidCallback? onDropdownTap;
  final Color? titleColor;
  final Color? dropdownColor;
  final double titleFontSize;
  final double dropdownFontSize;
  final FontWeightType titleFontWeight;
  final FontWeightType dropdownFontWeight;

  const SectionHeaderWithDropdown({
    super.key,
    required this.title,
    required this.dropdownText,
    this.onDropdownTap,
    this.titleColor,
    this.dropdownColor,
    this.titleFontSize = 16,
    this.dropdownFontSize = 14,
    this.titleFontWeight = FontWeightType.semiBold,
    this.dropdownFontWeight = FontWeightType.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side - Section title
        AppText.primary(
          title,
          fontSize: titleFontSize,
          fontWeight: titleFontWeight,
          color: titleColor ?? AppColors.textPrimary,
        ),

        // Right side - Dropdown trigger
        InkWell(
          onTap: onDropdownTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.primary(
                  dropdownText,
                  fontSize: dropdownFontSize,
                  fontWeight: dropdownFontWeight,
                  color: dropdownColor ?? AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: dropdownColor ?? AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
