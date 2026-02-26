import 'package:flutter/material.dart';
import 'app_text.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.title,
    this.height = 40,
    this.padding,
    this.color = const Color(0xff0099a5),
    this.textColor = Colors.white,
    this.radius = 5,
    this.fontSize = 14,
    this.fontWeight = FontWeightType.semiBold,
    required this.onPressed,
    this.borderColor,
    this.icon, // NEW: optional icon
    super.key,
  });

  final String title;
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color textColor;
  final FontWeightType? fontWeight;
  final double radius;
  final VoidCallback onPressed;
  final Color? borderColor;
  final Widget? icon; // NEW

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: color,
            border: Border.all(
              color: borderColor ?? const Color(0xffCCCCCC),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.primaryButton(
                title,
                color: textColor,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
              if (icon != null) icon!,
            ],
          ),
        ),
      ),
    );
  }
}
