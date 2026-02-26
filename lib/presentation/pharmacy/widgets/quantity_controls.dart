import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../widgets/app_text.dart';

/// Quantity Controls Widget - Reusable quantity selector
/// Used in both Medicine Detail Page and Cart Item Card
class QuantityControls extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantityControls({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Decrease button
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.greyA8, width: 1.5),
          ),
          child: IconButton(
            onPressed: onDecrease,
            icon: const Icon(Icons.remove),
            color: AppColors.primary,
            iconSize: 14,
            padding: EdgeInsets.zero,
          ),
        ),
        // Quantity display
        SizedBox(
          width: 40,
          height: 25,
          child: Center(
            child: AppText.primary(
              quantity.toString(),
              fontSize: 14,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        // Increase button
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            onPressed: onIncrease,
            icon: const Icon(Icons.add),
            color: AppColors.white,
            iconSize: 14,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
