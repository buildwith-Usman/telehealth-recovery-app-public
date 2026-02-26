import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_icon.dart';
import '../../../app/utils/sizes.dart';
import '../button/custom_navigation_button.dart';

class PharmacyHeaderBar extends StatelessWidget {
  final VoidCallback? onCartPressed;
  final VoidCallback? onPrescriptionPressed;

  const PharmacyHeaderBar({
    super.key,
    this.onCartPressed,
    this.onPrescriptionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: AppColors.white,
      child: Row(
        children: [
          // Pharmacy Icon and Text
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Pharmacy Icon
                AppIcon.pharmacyGroupIcon.widget(
                  width: 104,
                  height: 32,
                  color: AppColors.primary,
                ),
                // gapW12,
                // // Pharmacy Text
                // AppText.primary(
                //   'Pharmacy',
                //   fontSize: 20,
                //   fontWeight: FontWeightType.semiBold,
                //   color: AppColors.textPrimary,
                // ),
              ],
            ),
          ),
          // Right Action Buttons
          Row(
            children: [
              // View Prescription Button
              CustomNavigationButton.withIcon(
                onPressed: onPrescriptionPressed ?? () {},
                iconData: Icons.description_outlined,
                isFilled: true,
                filledColor: AppColors.whiteLight,
                iconColor: AppColors.textPrimary,
                size: 40,
                iconSize: 22,
                showBorder: false,
              ),
              gapW10,
              // Cart Button
              CustomNavigationButton.withIcon(
                onPressed: onCartPressed ?? () {},
                iconData: Icons.shopping_cart_outlined,
                isFilled: true,
                filledColor: AppColors.whiteLight,
                iconColor: AppColors.textPrimary,
                size: 40,
                iconSize: 22,
                showBorder: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
