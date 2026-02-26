import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../app_text.dart';

typedef OnChangedSearchTextField = Function(String);

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    this.controller,
    this.initialValue,
    this.hintText,
    this.height,
    this.borderRadius,
    this.backgroundColor = AppColors.greyFEF,
    this.labelColor = Colors.black,
    this.autoFocus = false,
    this.textInputType,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize = 14,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.left,
    this.fontWeight = FontWeightType.regular,
    super.key,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final double? height;
  final double? borderRadius;
  final Color backgroundColor;
  final Color labelColor;
  final bool autoFocus;
  final TextInputType? textInputType;
  final OnChangedSearchTextField? onChanged;
  final OnChangedSearchTextField? onFieldSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeightType? fontWeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 40,
      child: TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: textInputType,
        autofocus: autoFocus,
        controller: controller,
        initialValue: initialValue,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        textCapitalization: TextCapitalization.sentences,
        textAlign: textAlign,
        style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
            fontWeight: fontWeight?.type()),
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4),
            borderSide: const BorderSide(color: AppColors.grey90, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 4),
              borderSide: const BorderSide(color: AppColors.accent, width: 1)),
          suffixIconConstraints:
              BoxConstraints.tightFor(width: height, height: height),
          filled: true,
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: (height! - 20) / 2),
          fillColor: backgroundColor,
          hintStyle: AppText.primary(
            '',
            color: AppColors.grey60,
            fontSize: fontSize,
          ).textStyle,
        ),
      ),
    );
  }
}
