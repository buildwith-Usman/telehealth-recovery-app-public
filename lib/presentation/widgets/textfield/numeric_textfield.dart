import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';

typedef OnChangedNumericTextField = Function(String);

class NumericTextField extends StatefulWidget {
  const NumericTextField({
    this.controller,
    this.initialValue,
    this.hintText,
    this.height = 40,
    this.errorText,
    this.backgroundColor = Colors.white,
    this.labelColor = const Color(0xff333333),
    this.autoFocus = false,
    this.textInputType = const TextInputType.numberWithOptions(decimal: true),
    this.inputFormatters,
    this.onChanged,
    this.prefixIcon,
    this.textAlign = TextAlign.right,
    this.isRequired = false,
    this.isInvalid = false,
    this.invalidText = '',
    this.borderColor = const Color(0xffE0E0E0),
    this.isReadOnly = false,
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
  final List<TextInputFormatter>? inputFormatters;
  final OnChangedNumericTextField? onChanged;
  final Widget? prefixIcon;
  final TextAlign textAlign;
  final bool isRequired;
  final bool isInvalid;
  final String invalidText;
  final String? errorText;
  final Color borderColor;
  final bool isReadOnly;

  @override
  State<NumericTextField> createState() => _NumericTextFieldState();
}

class _NumericTextFieldState extends State<NumericTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
            onTap: () {
              if (!widget.isReadOnly) {
                setState(() {
                  widget.controller?.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: widget.controller?.value.text.length ?? 0,
                  );
                });
              }
            },
            keyboardType: widget.textInputType,
            autofocus: widget.autoFocus,
            readOnly: widget.isReadOnly,
            controller: widget.controller,
            initialValue: widget.initialValue,
            textAlignVertical: TextAlignVertical.center,
            textCapitalization: TextCapitalization.sentences,
            textAlign: widget.textAlign,
            style: const TextStyle(color: Color(0xff333333), fontSize: 14),
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              prefixIconConstraints: BoxConstraints.tightFor(
                width: widget.height,
                height: widget.height,
              ),
              contentPadding: const EdgeInsets.only(
                left: 10,
                top: 11,
                right: 10,
                bottom: 10,
              ),
              alignLabelWithHint: true,
              filled: true,
              isDense: true,
              fillColor: widget.isReadOnly
                  ? const Color(0xffEFEFEF)
                  : widget.backgroundColor,
              border: const OutlineInputBorder(),
              hintText: widget.hintText,
              errorText: widget.errorText,
              prefixIcon: widget.prefixIcon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor,
                ),
              ),
              focusedBorder: const OutlineInputBorder(),
              hintStyle: const TextStyle(
                color: Color(0xff777777),
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

class ThousandsFormatter extends TextInputFormatter {
  final int decimalDigits;

  ThousandsFormatter({this.decimalDigits = 2}) : assert(decimalDigits >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText;

    if (decimalDigits == 0) {
      newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    } else {
      newText = newValue.text.replaceAll(RegExp('[^0-9.]'), '');
    }

    if (newText.contains('.')) {
      // In case if user's first input is "."
      if (newText.trim() == '.') {
        return newValue.copyWith(
          text: '0.',
          selection: const TextSelection.collapsed(offset: 2),
        );
      }
      // In case if user tries to input multiple "."s or tries to input
      // more than the decimal place
      else if ((newText.split(".").length > 2) ||
          (newText.split(".")[1].length > decimalDigits)) {
        return oldValue;
      } else
        return newValue;
    }

    // In case if input is empty or zero
    if (newText.trim() == '' ||
        newText.trim() == '0' ||
        ((int.tryParse(newText) ?? 0) < 1)) {
      return newValue;
    }

    double newDouble = double.tryParse(newText) ?? 0.0;
    var selectionIndexFromTheRight =
        newValue.text.length - newValue.selection.end;

    String newString = NumberFormat("#,##0.##").format(newDouble);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(
        offset: newString.length - selectionIndexFromTheRight,
      ),
    );
  }
}
