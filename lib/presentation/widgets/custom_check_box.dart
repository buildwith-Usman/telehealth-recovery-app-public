import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isSelected;

  const CustomCheckbox({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0094B8) : Colors.transparent,
        border: Border.all(
          color: isSelected ? const Color(0xFF0094B8) : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 12,
              color: Colors.white,
            )
          : null,
    );
  }
}
