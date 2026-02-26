import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';

typedef OnChangedFormTextField = Function(String);

class FormTextField extends StatefulWidget {
  const FormTextField({
    this.titleText = '',
    this.titleFontSize,
    this.titleTextColor,
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
    this.borderRadius = 50,
    this.horizontalPadding = 15.0,
    this.verticalPadding = 15.0,
    this.borderWidth = 1,
    this.showBorder = false,
    this.showFocusBorder = true,
    this.isPasswordField = false,
    this.fontSize = 14,
    this.suffixIcon,
    this.onSuffixIconTap,
    super.key,
  });

  final TextEditingController? controller;
  final String titleText;
  final double? titleFontSize;
  final Color? titleTextColor;
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
  final double borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderWidth;
  final bool showBorder;
  final bool showFocusBorder;
  final bool isPasswordField;
  final double fontSize;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconTap;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  final FocusNode _textFormFieldFocusNode = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
    // Listen to focus changes on the text field
    _textFormFieldFocusNode.addListener(() {
      if (_textFormFieldFocusNode.hasFocus) {
        // When the text field gains focus, do something according to your needs
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool obscure = widget.isPasswordField && !_isPasswordVisible;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            gapW4,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.titleText,
                    style: TextStyle(
                      color: widget.titleTextColor ?? AppColors.black,
                      fontSize: widget.titleFontSize ?? widget.fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.isRequired)
                    WidgetSpan(
                      alignment: PlaceholderAlignment.top,
                      child: Transform.translate(
                        offset: const Offset(2, -6),
                        child: const Text(
                          '*',
                          style: TextStyle(
                            color: Color(0xffE61513),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (widget.titleText.isNotEmpty) gapH10,
        SizedBox(
          height: widget.height,
          child: TextFormField(
            onChanged: (String value) {
              setState(() {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              });
            },
            focusNode: _textFormFieldFocusNode,
            keyboardType: widget.textInputType,
            autofocus: widget.autoFocus,
            controller: widget.controller,
            inputFormatters: widget.inputFormatters,
            initialValue:
                widget.controller == null ? widget.initialValue : null,
            enableSuggestions: widget.enableSuggestions,
            autocorrect: widget.autocorrect,
            textAlignVertical: TextAlignVertical.center,
            textCapitalization: TextCapitalization.sentences,
            textAlign: widget.textAlign,
            cursorColor: AppColors.blueCA,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            obscureText: obscure,
            style: TextStyle(
                color: AppColors.todoTitle, fontSize: widget.fontSize),
            decoration: InputDecoration(
              suffixIconConstraints: BoxConstraints.tightFor(
                width: widget.height,
                height: widget.height,
              ),
              contentPadding: const EdgeInsets.all(15.0).copyWith(
                top: widget.verticalPadding,
                bottom: widget.verticalPadding,
                left: widget.horizontalPadding,
                right: widget.horizontalPadding,
              ),
              alignLabelWithHint: true,
              filled: true,
              isDense: true,
              fillColor: widget.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              hintText: widget.hintText,
              errorText: widget.errorText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon != null
                  ? GestureDetector(
                      onTap: widget.onSuffixIconTap,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: widget.suffixIcon,
                      ),
                    )
                  : widget.isPasswordField
                      ? IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        )
                      : null,
              enabledBorder: widget.showBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        width: widget.borderWidth,
                        color: widget.isInvalid
                            ? AppColors.red513
                            : const Color(0xffE0E0E0),
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide.none,
                    ),
              focusedBorder: widget.showFocusBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        width: widget.borderWidth,
                        color: widget.isInvalid
                            ? AppColors.red513
                            : AppColors.accent,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide.none,
                    ),
              hintStyle:
                  TextStyle(color: Colors.grey, fontSize: widget.fontSize),
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

  Widget? get _clearButton {
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      return InkWell(
        onTap: () {
          setState(() {
            widget.controller!.clear();
            if (widget.onChanged != null) {
              widget.onChanged!('');
            }
          });
        },
        child: const Icon(
          Icons.close_rounded,
          size: 17.0,
          color: AppColors.todoTitle,
        ),
      );
    }

    return null;
  }

  @override
  void dispose() {
    _textFormFieldFocusNode
        .dispose(); // Clean up the focus node when not needed
    super.dispose();
  }
}
