import 'package:flutter/material.dart';

import '../../app/config/app_colors.dart';

class AppRadio extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final String label;

  const AppRadio({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.activeColor = AppColors.green9A5,
    this.inactiveColor = AppColors.grey80,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? activeColor : inactiveColor,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class AppRadioGroup extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onOptionSelected;

  const AppRadioGroup({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  State<AppRadioGroup> createState() => _AppRadioGroupState();
}

class _AppRadioGroupState extends State<AppRadioGroup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((option) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: AppRadio(
            isSelected: widget.selectedOption == option,
            onTap: () => widget.onOptionSelected(option),
            label: option,
          ),
        );
      }).toList(),
    );
  }
}



