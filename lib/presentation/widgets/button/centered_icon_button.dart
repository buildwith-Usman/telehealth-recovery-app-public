import 'package:flutter/material.dart';
import '../app_text.dart';

class CenteredIconButton extends StatelessWidget {
  const CenteredIconButton({
    required this.title,
    this.width,
    this.height = 40,
    this.padding,
    this.color = const Color(0xffFFFFFF),
    this.textColor = const Color(0xff0099a5),
    this.iconColor = const Color(0xff0099a5),
    this.radius = 4,
    this.fontSize = 13,
    this.fontWeightType = FontWeightType.semiBold,
    this.borderColor = const Color(0xff0099a5),
    required this.onPressed,
    required this.icon,
    super.key,
  });

  final String title;
  final double? width;
  final double height;
  final double fontSize;
  final FontWeightType fontWeightType;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color textColor;
  final Color? iconColor;
  final double radius;
  final VoidCallback onPressed;
  final Color borderColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: borderColor,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          padding: padding,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              AppText.regular(
                title,
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeightType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
