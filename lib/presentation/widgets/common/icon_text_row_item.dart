import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';

class IconTextRowItem extends StatelessWidget {
  // --- Icon options ---
  final AppIconBuilder? appIcon; // e.g., AppIcon.experienceIcon
  final Widget? iconWidget; // Any custom widget (e.g., Image, SVG)
  final IconData? iconData; // Native Flutter Icon fallback
  final double iconSize;
  final Color? iconColor;

  // --- Text options ---
  final Widget? textWidget; // e.g., AppText.primary('Doctor Name')
  final String? text; // Fallback text
  final double spacing;

  const IconTextRowItem({
    super.key,
    this.appIcon,
    this.iconWidget,
    this.iconData,
    this.iconSize = 20,
    this.iconColor,
    this.textWidget,
    this.text,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    // ---- ICON HANDLING ----
    Widget? icon;
    if (appIcon != null) {
      icon = appIcon!.widget(
        width: iconSize,
        height: iconSize,
        color: iconColor,
      );
    } else if (iconWidget != null) {
      icon = iconWidget;
    } else if (iconData != null) {
      icon = Icon(iconData, size: iconSize, color: iconColor ?? Colors.black);
    }

    // ---- TEXT HANDLING ----
    Widget textContent = textWidget ??
        AppText.primary(
          text ?? '',
          fontSize: 14,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

    // ---- BUILD ----
    return Row(
      mainAxisSize: MainAxisSize.min, // prevents stretching
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) icon,
        if (icon != null) SizedBox(width: spacing),
        Flexible( // ✅ ensures no overflow
          child: textContent,
        ),
      ],
    );
  }
}
