import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/config/app_colors.dart';
import '../../../generated/locales.g.dart';
import '../app_text.dart';

typedef OnChangedOptionTextField = Function(String);

class SearchSelectTextField extends StatefulWidget {
  const SearchSelectTextField({
    required this.titleText,
    this.controller,
    this.initialValue,
    this.hintText,
    this.height = 40,
    this.backgroundColor = Colors.white,
    this.labelColor = const Color(0xff333333),
    this.autoFocus = false,
    required this.onPressed,
    this.onClear,
    this.textAlign = TextAlign.left,
    this.isRequired = false,
    this.isInvalid = false,
    this.invalidText = '',
    this.readOnly = false,
    this.titleFontSize = 14,
    this.optionTextFontSize = 14,
    this.contentPadding = const EdgeInsets.all(10),
    super.key,
    this.showCircularProgressIndicator = false,
    this.onChanged,
    this.showSuffixIcon = true,
  });

  final TextEditingController? controller;
  final String titleText;
  final String? initialValue;
  final String? hintText;
  final double height;
  final Color backgroundColor;
  final Color labelColor;
  final bool autoFocus;
  final TextAlign textAlign;
  final VoidCallback onPressed;
  final VoidCallback? onClear;
  final bool isRequired;
  final bool isInvalid;
  final bool readOnly;
  final String invalidText;
  final double titleFontSize;
  final double optionTextFontSize;
  final EdgeInsets contentPadding;
  final bool showCircularProgressIndicator;
  final OnChangedOptionTextField? onChanged;
  final bool showSuffixIcon;

  @override
  _SearchSelectTextFieldState createState() => _SearchSelectTextFieldState();
}

class _SearchSelectTextFieldState extends State<SearchSelectTextField> {
  Timer? _debounce;

  _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Perform the search only after the user stops typing for 500ms
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel the timer if it exists
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Field required warning
    var requiredFieldText = LocaleKeys.errorMessage_fieldIsRequired.tr;
    if (widget.invalidText.isNotEmpty) {
      requiredFieldText = widget.invalidText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: <Widget>[
              Text(
                widget.titleText,
                style: TextStyle(
                  color: const Color(0xff333333),
                  fontWeight: FontWeight.w600,
                  fontSize: widget.titleFontSize,
                ),
              ),
              if (widget.isRequired) ...[
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
          height: widget.height,
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isInvalid
                    ? AppColors.red513
                    : const Color(0xffE0E0E0),
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: widget.readOnly
                  ? const Color(0xffEFEFEF)
                  : widget.backgroundColor,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    onChanged: (value){
                      _onSearchChanged(value);
                    },
                    enabled: true,
                    autofocus: widget.autoFocus,
                    controller: widget.controller,
                    onTap: widget.onPressed,
                    readOnly: widget.readOnly,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: widget.textAlign,
                    style: TextStyle(
                        color: const Color(0xff333333),
                        fontSize: widget.optionTextFontSize),
                    decoration: InputDecoration(
                      suffixIconConstraints: BoxConstraints.tightFor(
                          width: 40, height: widget.height),
                      contentPadding: widget.contentPadding,
                      alignLabelWithHint: true,
                      filled: false,
                      isDense: true,
                      fillColor: widget.readOnly
                          ? const Color(0xffEFEFEF)
                          : widget.backgroundColor,
                      hintText: widget.hintText,
                      labelText: widget.initialValue,
                      labelStyle: const TextStyle(
                          color: Color(0xff333333), fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffixIcon: _clearButton,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: widget.optionTextFontSize,
                      ),
                    ),
                  ),
                ),
                if (widget.showCircularProgressIndicator) ...[
                  Container(
                    width: 1.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border(
                        right: BorderSide(
                            color: widget.isInvalid
                                ? AppColors.red513
                                : AppColors.black0E0,
                            width: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 33,
                    height: 40.0,
                    child: Center(
                        child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        color: AppColors.black0E0,
                      ),
                    )),
                  )
                ],
                if (!widget.showCircularProgressIndicator) ...[
                  Container(
                    width: 1.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border(
                        right: BorderSide(
                            color: widget.isInvalid
                                ? AppColors.red513
                                : AppColors.black0E0,
                            width: 1.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onPressed,
                    // Trigger the same action as the text field
                    child: const SizedBox(
                      width: 33,
                      height: 40.0,
                      child: Center(
                        child: Icon(
                          Icons.arrow_drop_down_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border(
                        right: BorderSide(
                            color: widget.isInvalid
                                ? AppColors.red513
                                : AppColors.black0E0,
                            width: 1.0),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
        if (widget.isRequired && widget.isInvalid) ...[
          const SizedBox(height: 2),
          AppText.primary(
            requiredFieldText,
            fontSize: 11,
            color: AppColors.red513,
          )
        ]
      ],
    );
  }

  Widget? get _clearButton {
    if (widget.controller != null &&
        widget.controller!.text.isNotEmpty &&
        widget.onClear != null &&
        widget.showSuffixIcon) {
      return InkWell(
        onTap: widget.onClear,
        child: const Icon(
          Icons.close_rounded,
          size: 17.0,
          color: AppColors.todoTitle,
        ),
      );
    }
    return null;
  }
}
