import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/domain/entity/medicine_entity.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';

/// Medicine Card Widget - Displays medicine with image, name, and price
/// This follows the same pattern as FeaturedProductCard
class MedicineCard extends StatelessWidget {
  final MedicineEntity medicine;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine image
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Center(
                      child: medicine.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                medicine.imageUrl!,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
                              ),
                            )
                          : _buildPlaceholderIcon(),
                    ),
                    // Stock indicator (low stock warning)
                    if (medicine.stockQuantity != null && medicine.stockQuantity! < 20)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.pendingColor.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: AppText.primary(
                            'Low',
                            fontSize: 8,
                            fontWeight: FontWeightType.medium,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            gapH6,
            // Medicine name
            AppText.primary(
              medicine.name ?? 'Medicine Name',
              fontSize: 13,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            gapH4,
            // Category
            if (medicine.category != null)
              AppText.primary(
                medicine.category!,
                fontSize: 10,
                fontWeight: FontWeightType.regular,
                color: AppColors.grey60,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            gapH4,
            // Price section
            if (medicine.price != null)
              Row(
                children: [
                  AppText.primary(
                    'Rs. ${medicine.price!.toStringAsFixed(2)}',
                    fontSize: 14,
                    fontWeight: FontWeightType.bold,
                    color: AppColors.accent,
                  ),
                  // Stock count indicator
                  const Spacer(),
                  if (medicine.stockQuantity != null)
                    AppText.primary(
                      '${medicine.stockQuantity} left',
                      fontSize: 9,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.grey60,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Build placeholder icon when image is not available
  Widget _buildPlaceholderIcon() {
    return AppImage.dummyMedicineImg.widget(width: 100, height: 100);
  }
}
