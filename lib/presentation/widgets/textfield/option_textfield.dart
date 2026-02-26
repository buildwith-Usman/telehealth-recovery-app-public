import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../app_text.dart';

typedef OnChangedOptionTextField = Function(String);

class OptionTextField extends StatelessWidget {
  const OptionTextField({
    required this.titleText,
    this.controller,
    this.initialValue,
    this.hintText,
    this.height = 40,
    this.backgroundColor = Colors.white,
    this.labelColor = const Color(0xff333333),
    this.autoFocus = false,
    this.suffixIcon = const Icon(
      Icons.keyboard_arrow_down_rounded,
      size: 20,
    ),
    required this.onPressed,
    this.textAlign = TextAlign.left,
    this.isRequired = false,
    this.isInvalid = false,
    this.invalidText = '',
    this.readOnly = false,
    this.titleFontSize = 14,
    this.isShowVerticalLine = false,
    this.optionTextFontSize = 14,
    this.contentPadding = const EdgeInsets.all(10),
    super.key,
  });

  final TextEditingController? controller;
  final String titleText;
  final String? initialValue;
  final String? hintText;
  final double height;
  final Color backgroundColor;
  final Color labelColor;
  final bool autoFocus;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final VoidCallback onPressed;
  final bool isRequired;
  final bool isInvalid;
  final bool readOnly;
  final String invalidText;
  final double titleFontSize;
  final bool isShowVerticalLine;
  final double optionTextFontSize;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: <Widget>[
              Text(
                titleText,
                style: TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.w600,
                  fontSize: titleFontSize,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 2),
                const Text(
                  '*',
                  style: TextStyle(
                      color: Color(0xffE61513), fontWeight: FontWeight.w600),
                ),
              ]
            ],
          ),
        ),
        SizedBox(
          height: height,
          child: InkWell(
            onTap: readOnly ? null : onPressed,
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                autofocus: autoFocus,
                controller: controller,
                readOnly: readOnly,
                textAlignVertical: TextAlignVertical.center,
                textAlign: textAlign,
                style: TextStyle(
                    color: const Color(0xff333333), fontSize: optionTextFontSize),
                decoration: InputDecoration(
                  suffixIconConstraints:
                      BoxConstraints.tightFor(width: 40, height: height),
                  contentPadding: contentPadding,
                  alignLabelWithHint: true,
                  filled: true,
                  isDense: true,
                  fillColor: readOnly ? const Color(0xffEFEFEF) : backgroundColor,
                  border: const OutlineInputBorder(),
                  hintText: hintText,
                  labelText: initialValue,
                  labelStyle:
                      const TextStyle(color: Color(0xff333333), fontSize: 14),
                  suffixIcon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isShowVerticalLine) ...[
                        Container(
                          width: 1, // Width of the vertical line
                          height: height, // Height of the vertical line
                          color: AppColors.grey80, // Color of the vertical line
                        ),
                        const SizedBox(width: 2),
                      ],
                      suffixIcon!
                    ],
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isInvalid ? AppColors.red513 : const Color(0xffE0E0E0),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: const Color(0xff777777),
                    fontSize: optionTextFontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isRequired && isInvalid) ...[
          const SizedBox(height: 2),
          AppText.primary(
            invalidText,
            fontSize: 11,
            color: AppColors.red513,
          )
        ]
      ],
    );
  }
}
