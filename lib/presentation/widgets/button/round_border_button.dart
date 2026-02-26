import 'package:flutter/material.dart';

import '../app_text.dart';

class RoundBorderButton extends StatelessWidget {
  const RoundBorderButton({
    required this.title,
    this.width = double.infinity,
    this.height = 55,
    this.padding,
    this.color = const Color(0xff0099a5),
    this.textColor = Colors.white,
    this.radius = 50,
    this.fontWeight = FontWeightType.semiBold,
    this.fontSize = 14,
    required this.onPressed,
    this.borderWidth,
    this.borderWidthColor,
    super.key,
  });

  final String title;
  final double width;
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color textColor;
  final double radius;
  final VoidCallback onPressed;
  final FontWeightType? fontWeight;
  final double? borderWidth;
  final Color? borderWidthColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: borderWidthColor ?? color ?? const Color(0xffCCCCCC),
          width: borderWidth ?? 0,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          alignment: Alignment.center,
          child: AppText.primaryButton(
            title,
            color: textColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
