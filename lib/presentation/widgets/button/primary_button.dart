import 'package:flutter/material.dart';

import '../../../app/utils/sizes.dart';
import '../app_text.dart';
import '../../../app/config/app_colors.dart';

enum IconPosition { left, right }

class PrimaryButton extends StatelessWidget {
  final String title;
  final double height;
  final double? width;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color textColor;
  final FontWeightType? fontWeight;
  final double radius;
  final bool showIcon;
  final IconData? icon;
  final Widget? iconWidget;
  final double iconSize;
  final Color? iconColor;
  final IconPosition iconPosition;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback onPressed;

  // ✅ Keep the original constructor PUBLIC (no changes to existing functionality)
  const PrimaryButton({
    required this.title,
    this.width,
    this.height = 40,
    this.padding,
    this.color = const Color(0xff0099a5),
    this.textColor = Colors.white,
    this.radius = 5,
    this.fontSize = 14,
    this.fontWeight = FontWeightType.semiBold,
    this.showIcon = false,
    this.icon,
    this.iconWidget,
    this.iconSize = 20,
    this.iconColor,
    this.iconPosition = IconPosition.right,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 1.0,
    required this.onPressed,
    super.key,
  });

  // ✅ Private constructor for internal use by factory methods
  const PrimaryButton._({
    required this.title,
    this.width,
    this.height = 40,
    this.padding,
    this.color = const Color(0xff0099a5),
    this.textColor = Colors.white,
    this.radius = 5,
    this.fontSize = 14,
    this.fontWeight = FontWeightType.semiBold,
    this.showIcon = false,
    this.icon,
    this.iconWidget,
    this.iconSize = 20,
    this.iconColor,
    this.iconPosition = IconPosition.right,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 1.0,
    required this.onPressed,
  });

  /// Outlined button with border
  factory PrimaryButton.outlined({
    required String title,
    double? width,
    double height = 45,
    EdgeInsetsGeometry? padding,
    Color backgroundColor = Colors.transparent,
    Color borderColor = AppColors.primary,
    Color textColor = AppColors.primary,
    double borderWidth = 1.5,
    double radius = 8,
    double fontSize = 16,
    FontWeightType fontWeight = FontWeightType.semiBold,
    bool showIcon = false,
    IconData? icon,
    Widget? iconWidget,
    double iconSize = 20,
    Color? iconColor,
    IconPosition iconPosition = IconPosition.right,
    required VoidCallback onPressed,
  }) {
    return PrimaryButton._(
      title: title,
      width: width,
      height: height,
      padding: padding,
      color: backgroundColor,
      textColor: textColor,
      radius: radius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      showIcon: showIcon,
      icon: icon,
      iconWidget: iconWidget,
      iconSize: iconSize,
      iconColor: iconColor ?? textColor,
      iconPosition: iconPosition,
      showBorder: true,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onPressed: onPressed,
    );
  }

  /// Rounded button (pill shaped)
  factory PrimaryButton.rounded({
    required String title,
    double? width,
    double height = 45,
    EdgeInsetsGeometry? padding,
    Color color = AppColors.primary,
    Color textColor = AppColors.white,
    double fontSize = 16,
    FontWeightType fontWeight = FontWeightType.semiBold,
    bool showIcon = false,
    IconData? icon,
    Widget? iconWidget,
    double iconSize = 20,
    Color? iconColor,
    IconPosition iconPosition = IconPosition.right,
    required VoidCallback onPressed,
  }) {
    return PrimaryButton._(
      title: title,
      width: width,
      height: height,
      padding: padding,
      color: color,
      textColor: textColor,
      radius: height / 2, // Fully rounded
      fontSize: fontSize,
      fontWeight: fontWeight,
      showIcon: showIcon,
      icon: icon,
      iconWidget: iconWidget,
      iconSize: iconSize,
      iconColor: iconColor ?? textColor,
      iconPosition: iconPosition,
      showBorder: false,
      onPressed: onPressed,
    );
  }

  /// Rounded outlined button
  factory PrimaryButton.roundedOutlined({
    required String title,
    double? width,
    double height = 45,
    EdgeInsetsGeometry? padding,
    Color backgroundColor = Colors.transparent,
    Color borderColor = AppColors.primary,
    Color textColor = AppColors.primary,
    double borderWidth = 1.5,
    double fontSize = 16,
    FontWeightType fontWeight = FontWeightType.semiBold,
    bool showIcon = false,
    IconData? icon,
    Widget? iconWidget,
    double iconSize = 20,
    Color? iconColor,
    IconPosition iconPosition = IconPosition.right,
    required VoidCallback onPressed,
  }) {
    return PrimaryButton._(
      title: title,
      width: width,
      height: height,
      padding: padding,
      color: backgroundColor,
      textColor: textColor,
      radius: 6, 
      fontSize: fontSize,
      fontWeight: fontWeight,
      showIcon: showIcon,
      icon: icon,
      iconWidget: iconWidget,
      iconSize: iconSize,
      iconColor: iconColor ?? textColor,
      iconPosition: iconPosition,
      showBorder: true,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onPressed: onPressed,
    );
  }

  /// Small button variant
  factory PrimaryButton.small({
    required String title,
    double? width,
    double height = 35,
    EdgeInsetsGeometry? padding,
    Color color = AppColors.primary,
    Color textColor = AppColors.white,
    double radius = 6,
    double fontSize = 14,
    FontWeightType fontWeight = FontWeightType.medium,
    bool showIcon = false,
    IconData? icon,
    Widget? iconWidget,
    double iconSize = 16,
    Color? iconColor,
    IconPosition iconPosition = IconPosition.right,
    required VoidCallback onPressed,
  }) {
    return PrimaryButton._(
      title: title,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
      color: color,
      textColor: textColor,
      radius: radius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      showIcon: showIcon,
      icon: icon,
      iconWidget: iconWidget,
      iconSize: iconSize,
      iconColor: iconColor ?? textColor,
      iconPosition: iconPosition,
      showBorder: false,
      onPressed: onPressed,
    );
  }

  /// Large button variant
  factory PrimaryButton.large({
    required String title,
    double? width,
    double height = 55,
    EdgeInsetsGeometry? padding,
    Color color = AppColors.primary,
    Color textColor = AppColors.white,
    double radius = 12,
    double fontSize = 18,
    FontWeightType fontWeight = FontWeightType.semiBold,
    bool showIcon = false,
    IconData? icon,
    Widget? iconWidget,
    double iconSize = 24,
    Color? iconColor,
    IconPosition iconPosition = IconPosition.right,
    required VoidCallback onPressed,
  }) {
    return PrimaryButton._(
      title: title,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
      color: color,
      textColor: textColor,
      radius: radius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      showIcon: showIcon,
      icon: icon,
      iconWidget: iconWidget,
      iconSize: iconSize,
      iconColor: iconColor ?? textColor,
      iconPosition: iconPosition,
      showBorder: false,
      onPressed: onPressed,
    );
  }

  /// Secondary button variant (light background)
  factory PrimaryButton.secondary({
    required String title,
    double? width,
    double height = 45,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color textColor = AppColors.primary,
    double radius = 8,
    double fontSize = 16,
    FontWeightType fontWeight = FontWeightType.semiBold,
    bool showIcon = false,
    IconData? icon,
    Widget? iconWidget,
    double iconSize = 20,
    Color? iconColor,
    IconPosition iconPosition = IconPosition.right,
    required VoidCallback onPressed,
  }) {
    return PrimaryButton._(
      title: title,
      width: width,
      height: height,
      padding: padding,
      color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
      textColor: textColor,
      radius: radius,
      fontSize: fontSize,
      fontWeight: fontWeight,
      showIcon: showIcon,
      icon: icon,
      iconWidget: iconWidget,
      iconSize: iconSize,
      iconColor: iconColor ?? textColor,
      iconPosition: iconPosition,
      showBorder: false,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = Material(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: width ?? double.infinity,
          height: height,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: showIcon
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: iconPosition == IconPosition.left
                      ? [
                          iconWidget ??
                              Icon(
                                icon ?? Icons.arrow_forward,
                                color: iconColor ?? textColor,
                                size: iconSize,
                              ),
                          gapW8,
                          AppText.primaryButton(
                            title,
                            color: textColor,
                            fontWeight: fontWeight,
                            fontSize: fontSize,
                          ),
                        ]
                      : [
                          AppText.primaryButton(
                            title,
                            color: textColor,
                            fontWeight: fontWeight,
                            fontSize: fontSize,
                          ),
                          gapW8,
                          iconWidget ??
                              Icon(
                                icon ?? Icons.arrow_forward,
                                color: iconColor ?? textColor,
                                size: iconSize,
                              ),
                        ],
                )
              : AppText.primaryButton(
                  title,
                  color: textColor,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                ),
        ),
      ),
    );

    // Wrap with border if needed
    if (showBorder) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: borderColor ?? textColor,
            width: borderWidth,
          ),
        ),
        child: buttonContent,
      );
    }

    return buttonContent;
  }
}
