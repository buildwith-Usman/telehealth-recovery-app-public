import 'package:flutter/material.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';

typedef OnChangedOptionStateTextField = Function(String);

class OptionStateTextField extends StatelessWidget {
  const OptionStateTextField({
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
    this.willWarning = false,
    this.warningText = '',
    required this.readOnly,
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
  final String invalidText;
  final bool willWarning;
  final String warningText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: <Widget>[
              Text(titleText,
                  style: const TextStyle(
                      color: Color(0xff333333), fontWeight: FontWeight.w600)),
              if (isRequired) ...[
                const SizedBox(width: 2),
                const Text('*',
                    style: TextStyle(
                        color: Color(0xffE61513), fontWeight: FontWeight.w600)),
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
                style: const TextStyle(color: Color(0xff333333), fontSize: 14),
                decoration: InputDecoration(
                  suffixIconConstraints:
                      BoxConstraints.tightFor(width: height, height: height),
                  contentPadding: const EdgeInsets.all(10),
                  alignLabelWithHint: true,
                  filled: true,
                  isDense: true,
                  fillColor: readOnly ? const Color(0xffEFEFEF) : backgroundColor,
                  border: const OutlineInputBorder(),
                  hintText: readOnly ? null : hintText,
                  labelText: initialValue,
                  labelStyle:
                      const TextStyle(color: Color(0xff333333), fontSize: 14),
                  suffixIcon: readOnly
                      ? const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.grey80,
                          size: 20,
                        )
                      : suffixIcon,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: isInvalid ? AppColors.red513 : const Color(0xffE0E0E0)),
                  ),
                  focusedBorder: const OutlineInputBorder(),
                  hintStyle: const TextStyle(
                    color: Color(0xff777777),
                    fontSize: 14,
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
        ],
        if (willWarning) ...[
          const SizedBox(height: 2),
          AppText.primary(
            warningText,
            fontSize: 11,
            color: AppColors.red513,
          )
        ]
      ],
    );
  }
}
