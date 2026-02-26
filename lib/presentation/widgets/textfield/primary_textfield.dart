import 'package:flutter/material.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';

typedef OnChangedPrimaryTextField = Function(String);

class PrimaryTextField extends StatefulWidget {
  const PrimaryTextField({
    this.controller,
    this.initialValue,
    this.hintText,
    this.height = 40,
    this.contentPadding = const EdgeInsets.only(
      left: 10,
      top: 11,
      right: 10,
      bottom: 10,
    ),
    this.errorText,
    this.backgroundColor = Colors.white,
    this.labelColor = const Color(0xff333333),
    this.autoFocus = false,
    this.textInputType,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.textAlign = TextAlign.left,
    this.isRequired = false,
    this.isInvalid = false,
    this.invalidText = '',
    this.radius = 4.0,
    this.showBorder = true,
    this.readOnly = false,
    super.key,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final double height;
  final Color backgroundColor;
  final Color labelColor;
  final bool autoFocus;
  final TextInputType? textInputType;
  final OnChangedPrimaryTextField? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final TextAlign textAlign;
  final bool isRequired;
  final bool isInvalid;
  final String invalidText;
  final String? errorText;
  final EdgeInsets contentPadding;
  final double radius;
  final bool showBorder;
  final bool readOnly;

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: widget.height,
          child: TextFormField(
            key: widget.initialValue != null 
                ? ValueKey('textfield_${widget.initialValue}') 
                : null, // Force rebuild when initialValue changes
            onChanged: (String value) {
              setState(() {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              });
            },
            keyboardType: widget.textInputType,
            autofocus: widget.autoFocus,
            controller: widget.controller,
            initialValue: widget.initialValue,
            readOnly: widget.readOnly,
            textAlignVertical: TextAlignVertical.center,
            textCapitalization: TextCapitalization.sentences,
            textAlign: widget.textAlign,
            style: const TextStyle(color: Color(0xff333333), fontSize: 14),
            decoration: InputDecoration(
              prefixIconConstraints: BoxConstraints.tightFor(
                width: widget.height,
                height: widget.height,
              ),
              contentPadding: widget.contentPadding,
              alignLabelWithHint: true,
              filled: true,
              isDense: true,
              fillColor: widget.backgroundColor,
              border: widget.showBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                    )
                  : InputBorder.none,
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
                  : (widget.controller != null &&
                          widget.controller!.text.isNotEmpty
                      ? InkWell(
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
                            size: 17,
                          ),
                        )
                      : null),
              enabledBorder: widget.showBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: const BorderSide(
                        color: Color(0xffE0E0E0),
                      ),
                    )
                  : InputBorder.none,
              focusedBorder: widget.showBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.radius),
                      borderSide: const BorderSide(
                        color: Color(0xff428BCA),
                      ),
                    )
                  : InputBorder.none,
              hintStyle: const TextStyle(
                color: AppColors.todoTitle,
                fontSize: 14,
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
          )
        ]
      ],
    );
  }
}
