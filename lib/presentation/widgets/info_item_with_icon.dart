import 'package:flutter/material.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/utils/sizes.dart';
import 'app_text.dart';

/// Reusable widget to display an icon with text value
/// Used across multiple screens for consistent info display
class InfoItemWithIcon extends StatelessWidget {
  final AppIconBuilder icon;
  final String value;
  final double iconSize;
  final double fontSize;
  final Color? iconColor;
  final Color? textColor;
  final FontWeightType? fontWeight;

  const InfoItemWithIcon({
    super.key,
    required this.icon,
    required this.value,
    this.iconSize = 18,
    this.fontSize = 12,
    this.iconColor,
    this.textColor,
    this.fontWeight = FontWeightType.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon container with fixed size for consistency
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: icon.widget(
            width: iconSize,
            height: iconSize,
            color: iconColor ?? AppColors.accent,
          ),
        ),
        gapW12,
        // Value text
        Expanded(
          child: AppText.primary(
            value,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor ?? AppColors.black,
          ),
        ),
      ],
    );
  }
}
