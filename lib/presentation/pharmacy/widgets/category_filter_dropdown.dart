import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/custom_check_box.dart';

/// Category Filter Dropdown Overlay
/// Shows a dropdown menu below the trigger widget with checkbox options
class CategoryFilterDropdown {
  static void show({
    required BuildContext context,
    required GlobalKey key,
    required List<String> selectedCategories,
    required Function(List<String>) onChanged,
  }) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final List<String> availableCategories = [
      'Supplements',
      'Prescription Drugs',
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    const dropdownWidth = 200.0;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        screenWidth - dropdownWidth - 20, // Align to right with 20px padding
        position.dy + size.height + 4, // 4px gap below trigger
        20, // Right padding from screen edge
        position.dy + size.height + 4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: AppColors.white,
      elevation: 8,
      items: availableCategories.map((category) {
        final isSelected = selectedCategories.contains(category);
        return PopupMenuItem<String>(
          value: category,
          padding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (context, setState) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  final newSelection = List<String>.from(selectedCategories);
                  if (isSelected) {
                    newSelection.remove(category);
                  } else {
                    newSelection.add(category);
                  }
                  onChanged(newSelection);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CustomCheckbox(isSelected: isSelected),
                      gapW12,
                      AppText.primary(
                        category,
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
