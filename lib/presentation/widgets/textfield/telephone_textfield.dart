import 'package:flutter/material.dart';

typedef OnChangedFormTextField = Function(String);

class TelephoneTextField extends StatelessWidget {
  const TelephoneTextField({
    required this.titleText,
    this.controller,
    this.initialValue,
    this.hintText,
    this.height = 40,
    this.backgroundColor = Colors.white,
    this.labelColor = Colors.black,
    this.autoFocus = false,
    this.textInputType = TextInputType.phone,
    required this.onChanged,
    this.textAlign = TextAlign.left,
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
  final OnChangedFormTextField onChanged;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Text(titleText,
              style:
                  const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          height: height,
          child: TextFormField(
            onChanged: onChanged,
            keyboardType: textInputType,
            autofocus: autoFocus,
            controller: controller,
            initialValue: initialValue,
            textAlignVertical: TextAlignVertical.center,
            textAlign: textAlign,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  left: 0, top: 11, right: 10, bottom: 10),
              alignLabelWithHint: true,
              filled: true,
              isDense: true,
              fillColor: backgroundColor,
              border: const OutlineInputBorder(),
              hintText: hintText,
              prefixIcon: const Icon(Icons.search_rounded),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: const OutlineInputBorder(),
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}
