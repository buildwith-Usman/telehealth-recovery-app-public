import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String titleText;
  final String hintText;
  final bool isRequired;
  final T? value;
  final List<T> items;
  final String Function(T) getDisplayText;
  final void Function(T?) onChanged;
  final Widget? suffixIcon;
  final bool isInvalid;
  final String invalidText;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final AlignmentGeometry? alignment;

  const CustomDropdownField({
    super.key,
    required this.titleText,
    required this.hintText,
    required this.items,
    required this.getDisplayText,
    required this.onChanged,
    this.isRequired = false,
    this.value,
    this.suffixIcon,
    this.isInvalid = false,
    this.invalidText = '',
    this.height = 55,
    this.borderRadius = 8,
    this.backgroundColor = AppColors.whiteLight,
    this.dropdownColor,
    this.menuMaxHeight = 200,
    this.alignment = AlignmentDirectional.centerEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with optional required indicator
        Row(
          children: [
            AppText.primary(
              titleText,
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.black,
            ),
            if (isRequired)
              AppText.primary(
                " *",
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: AppColors.red513,
              ),
          ],
        ),
        gapH8,

        // Dropdown Container
        Container(
          height: height,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isInvalid ? AppColors.red513 : AppColors.lightGrey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Dropdown Button
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    hint: AppText.primary(
                      hintText,
                      fontSize: 16,
                      color: AppColors.grey99,
                    ),
                    value: value,
                    isExpanded: true,
                    alignment: alignment ?? AlignmentDirectional.centerStart,
                    items: items.map((T item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          child: AppText.primary(
                            getDisplayText(item),
                            fontSize: 16,
                            fontWeight: FontWeightType.medium,
                            color: AppColors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.grey99,
                      size: 20,
                    ),
                    dropdownColor: dropdownColor ?? backgroundColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    menuMaxHeight: menuMaxHeight,
                  ),
                ),
              ),

              // Suffix Icon
              if (suffixIcon != null) suffixIcon!,
            ],
          ),
        ),

        // Error Message
        if (isInvalid && invalidText.isNotEmpty) ...[
          gapH4,
          AppText.primary(
            invalidText,
            fontSize: 12,
            fontWeight: FontWeightType.regular,
            color: AppColors.red513,
          ),
        ],
      ],
    );
  }
}
