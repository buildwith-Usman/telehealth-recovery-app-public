import 'package:flutter/material.dart';
import '../../../../../app/config/app_colors.dart';
import '../../../../../app/config/app_image.dart';
import '../../../../../app/utils/sizes.dart';
import '../../../../widgets/app_text.dart';
import '../../../widgets/quantity_controls.dart';

/// Cart Item Card Widget - Displays a single cart item
class CartItemCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onRemove;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Image and Info with Delete button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.grey95,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.medicine.imageUrl != null
                      ? Image.network(
                          item.medicine.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              AppImage.dummyMedicineImg.widget(
                            width: 40,
                            height: 40,
                          ),
                        )
                      : AppImage.dummyMedicineImg.widget(
                          width: 40,
                          height: 40,
                        ),
                ),
              ),
              gapW12,

              // Medicine Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Delete Button Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppText.primary(
                            item.medicine.name ?? 'Unknown Medicine',
                            fontSize: 16,
                            fontWeight: FontWeightType.semiBold,
                            color: AppColors.textPrimary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Remove Button
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.delete_outline),
                          color: AppColors.red513,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    gapH4,
                    AppText.primary(
                      item.medicine.category ?? '',
                      fontSize: 12,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                    ),
                    gapH8,
                    // Price and Quantity Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.primary(
                          'Rs. ${item.medicine.price?.toStringAsFixed(2) ?? '0.00'}',
                          fontSize: 16,
                          fontWeight: FontWeightType.bold,
                          color: AppColors.primary,
                        ),
                        QuantityControls(
                          quantity: item.quantity,
                          onIncrease: onIncreaseQuantity,
                          onDecrease: onDecreaseQuantity,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
