import 'package:flutter/material.dart';

import '../../app/config/app_colors.dart';

class AppSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.green9A5,
    this.inactiveColor = AppColors.grey80,
  });

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: 40,
        height: 20,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : widget.inactiveColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: widget.value ? 20.0 : 0,
              child: Container(
                width: 16.0,
                height: 16.0,
                margin: const EdgeInsets.only(left: 2.0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
