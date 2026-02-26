import 'package:flutter/material.dart';

import '../../../app/config/app_colors.dart';

typedef OnChangedDateTimeTextField = Function(String);

class DateTimeTextField extends StatefulWidget {
  const DateTimeTextField({
    required this.titleText,
    this.controller,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.height = 40,
    this.backgroundColor = Colors.white,
    this.labelColor = Colors.black,
    this.autoFocus = false,
    this.suffixIcon = const Icon(
      Icons.calendar_today_outlined,
      size: 16,
      color: AppColors.blackE8E,
    ),
    required this.onSelectPressed,
    this.onClearDateTime,
    this.textAlign = TextAlign.left,
    this.isRequired = false,
    this.isCanClear = true,
    super.key,
  });

  final TextEditingController? controller;
  final String titleText;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final double height;
  final Color backgroundColor;
  final Color labelColor;
  final bool autoFocus;
  final Widget? suffixIcon;
  final TextAlign textAlign;
  final VoidCallback onSelectPressed;
  final VoidCallback? onClearDateTime;
  final bool isRequired;
  final bool isCanClear;

  @override
  State<DateTimeTextField> createState() => _DateTimeTextFieldState();
}

class _DateTimeTextFieldState extends State<DateTimeTextField> {
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editingController = widget.controller!;
  }

  void _onReset() {
    if (widget.onClearDateTime != null) {
      widget.onClearDateTime!();
    }

    setState(() {
      _editingController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.titleText.isNotEmpty
            ? Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  children: <Widget>[
                    Text(widget.titleText,
                        style: const TextStyle(
                            color: Color(0xff333333),
                            fontWeight: FontWeight.w600)),
                    if (widget.isRequired) ...[
                      const SizedBox(width: 2),
                      const Text('*',
                          style: TextStyle(
                              color: Color(0xffE61513),
                              fontWeight: FontWeight.w600)),
                    ]
                  ],
                ),
              )
            : Container(),
        SizedBox(
          height: widget.height,
          child: TextFormField(
            autofocus: widget.autoFocus,
            controller: widget.controller,
            readOnly: true,
            onTap: widget.onSelectPressed,
            textAlignVertical: TextAlignVertical.center,
            textAlign: widget.textAlign,
            style: const TextStyle(color: Color(0xff333333), fontSize: 14),
            decoration: InputDecoration(
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 32,
                height: 40,
              ),
              contentPadding: const EdgeInsets.only(
                  left: 10, top: 15, right: 20, bottom: 10),
              alignLabelWithHint: true,
              filled: true,
              isDense: true,
              fillColor: widget.backgroundColor,
              border: const OutlineInputBorder(),
              hintText: widget.hintText,
              errorText: widget.errorText,
              labelText: widget.initialValue,
              labelStyle:
                  const TextStyle(color: Color(0xff333333), fontSize: 14),
              prefixIcon: widget.suffixIcon,
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Visibility(
                      visible: _editingController.text.isNotEmpty &&
                          widget.isCanClear,
                      child: InkWell(
                        onTap: () {
                          _onReset();
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.blackE8E,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffE0E0E0))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffE0E0E0))),
              hintStyle: const TextStyle(
                color: Color(0xff777777),
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}
