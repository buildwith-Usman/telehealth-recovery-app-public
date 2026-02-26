import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/domain/entity/featured_product_entity.dart';
import '../../../app/config/app_colors.dart';
import '../app_text.dart';

/// Featured Product Card Widget - Displays product image with name and price overlay
class FeaturedProductCard extends StatelessWidget {
  final FeaturedProductEntity product;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const FeaturedProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.width = 120,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
                      )
                    : _buildPlaceholderIcon(),
              ),
            ),
            const SizedBox(height: 6),
            // Medicine name
            AppText.primary(
              product.name,
              fontSize: 12,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Price
            AppText.primary(
              'Rs.${product.price.toStringAsFixed(0)}',
              fontSize: 12,
              fontWeight: FontWeightType.bold,
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }

  /// Build placeholder icon when image is not available
  Widget _buildPlaceholderIcon() {
    return Center(
      child: AppImage.dummyMedicineImg.widget(width: 60, height: 60),
    );
  }
}
