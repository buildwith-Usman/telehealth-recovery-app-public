import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';

typedef OnChangedFormTextField = Function(String);

class FormPassTextField extends StatefulWidget {
  const FormPassTextField({
    this.titleText = '',
    this.controller,
    this.initialValue,
    this.hintText,
    this.height = 60,
    this.errorText,
    this.backgroundColor = Colors.white,
    this.labelColor = const Color(0xff333333),
    this.autoFocus = false,
    this.textInputType,
    this.onChanged,
    this.prefixIcon,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    this.isRequired = false,
    this.readOnly = false,
    this.isInvalid = false,
    this.invalidText = '',
    this.inputFormatters,
    this.enableSuggestions = true,
    this.autocorrect = true,
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
  final TextInputType? textInputType;
  final OnChangedFormTextField? onChanged;
  final Widget? prefixIcon;
  final TextAlign textAlign;
  final int maxLines;
  final bool isRequired;
  final bool readOnly;
  final bool isInvalid;
  final String invalidText;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final bool enableSuggestions;
  final bool autocorrect;

  @override
  State<FormPassTextField> createState() => _FormPassTextFieldState();
}

class _FormPassTextFieldState extends State<FormPassTextField> {
  final FocusNode _textFormFieldFocusNode = FocusNode();
  final RxBool isPasswordVisible = false.obs;

  @override
  void initState() {
    super.initState();

    // Listen to focus changes on the text field
    _textFormFieldFocusNode.addListener(() {
      if (_textFormFieldFocusNode.hasFocus) {
        // When the text field gains focus, do something according to your needs
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              widget.titleText,
              style: const TextStyle(
                color: AppColors.todoTitle,
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.isRequired) ...[
              const SizedBox(width: 2),
              const Text(
                '*',
                style: TextStyle(
                  color: Color(0xffE61513),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        SizedBox(
          height: widget.height,
          child: Obx(
            () => TextFormField(
              onChanged: (String value) {
                setState(() {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                });
              },
              obscureText: isPasswordVisible.value,
              focusNode: _textFormFieldFocusNode,
              keyboardType: widget.textInputType,
              autofocus: widget.autoFocus,
              controller: widget.controller,
              inputFormatters: widget.inputFormatters,
              initialValue: widget.initialValue,
              enableSuggestions: widget.enableSuggestions,
              autocorrect: widget.autocorrect,
              textAlignVertical: TextAlignVertical.center,
              textCapitalization: TextCapitalization.sentences,
              textAlign: widget.textAlign,
              cursorColor: AppColors.blueCA,
              maxLines: widget.maxLines,
              readOnly: widget.readOnly,
              style: const TextStyle(color: AppColors.todoTitle, fontSize: 14),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(
                  15.0,
                ).copyWith(top: 18.0, bottom: 18.0),
                alignLabelWithHint: true,
                filled: true,
                isDense: true,
                fillColor: widget.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: widget.hintText,
                errorText: widget.errorText,
                prefixIcon: widget.prefixIcon,
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    isPasswordVisible.value =
                        !isPasswordVisible.value; // 👈 Toggle value
                  },
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color:
                        widget.isInvalid
                            ? AppColors.red513
                            : const Color(0xffE0E0E0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(
                    color:
                        widget.isInvalid
                            ? AppColors.red513
                            : const Color(0xff428BCA),
                  ),
                ),
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
        ),
        if (widget.isRequired && widget.isInvalid) ...[
          const SizedBox(height: 2),
          AppText.primary(
            widget.invalidText,
            fontSize: 11,
            color: AppColors.red513,
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _textFormFieldFocusNode
        .dispose(); // Clean up the focus node when not needed
    super.dispose();
  }
}
