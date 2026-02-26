import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/medicine_detail/medicine_detail_controller.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/config/app_icon.dart';
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/button/custom_navigation_button.dart';
import '../../../widgets/common/recovery_app_bar.dart';
import '../../widgets/quantity_controls.dart';

/// Medicine Detail Page - Shows detailed information about a medicine
/// This follows the same pattern as PharmacyHomePage
class MedicineDetailPage extends BaseStatefulPage<MedicineDetailController> {
  const MedicineDetailPage({super.key});

  @override
  BaseStatefulPageState<MedicineDetailController> createState() =>
      _MedicineDetailPageState();
}

class _MedicineDetailPageState
    extends BaseStatefulPageState<MedicineDetailController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.custom(
      customWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          CustomNavigationButton(
            type: NavigationButtonType.previous,
            onPressed: () => widget.controller.goBack(),
            isFilled: true,
            filledColor: AppColors.white,
            iconColor: AppColors.accent,
            size: 35,
            borderRadius: 6,
            iconSize: 18,
            showBorder: false,
          ),
          // Cart button
          CustomNavigationButton.withIcon(
            onPressed: widget.controller.navigateToCart,
            customIcon: AppIcon.cartIcon.widget(
              width: 16,
              height: 16,
            ),
            isFilled: true,
            filledColor: AppColors.white,
            size: 35,
            borderRadius: 6,
            showBorder: false,
          ),
        ],
      ),
      horizontalPadding: 20,
      // verticalPadding: 16,
    );
  }

  @override
  bool get useStandardPadding => true;

  @override
  Widget? buildBottomBar() {
    return _buildBottomAddToCartButton();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() {
      // Show loading state
      if (widget.controller.isLoading.value &&
          widget.controller.medicine.value == null) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      }

      // Show error state if medicine is null
      if (widget.controller.medicine.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.grey60,
              ),
              gapH16,
              AppText.primary(
                'Medicine not found',
                fontSize: 16,
                fontWeight: FontWeightType.medium,
                color: AppColors.grey60,
              ),
            ],
          ),
        );
      }

      final medicine = widget.controller.medicine.value!;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Name
            _buildMedicineName(medicine),
            gapH16,
            // Medicine Image Card with Gallery
            _buildImageSection(medicine),
            gapH20,

            // Price
            _buildPriceSection(medicine),
            gapH6,

            // Divider
            const Divider(
              color: AppColors.greyA8,
              thickness: 0.5,
            ),
            gapH6,

            // Dosage Selector (only show if dosages are available)
            Obx(() {
              if (widget.controller.dosageVariants.isNotEmpty) {
                return Column(
                  children: [
                    _buildDosageSelector(),
                    gapH24,
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // Quantity Selector
            _buildQuantitySelector(),
            gapH24,

            // Description Section
            _buildDescriptionSection(medicine),
            gapH24,

            // Ingredients Section
            _buildIngredientsSection(medicine),
            gapH24,

            // How to Use Section
            _buildHowToUseSection(medicine),
            gapH24,

            // Share This Product Section
            _buildShareSection(),
            gapH32,
          ],
        ),
      );
    });
  }

  /// Build medicine name
  Widget _buildMedicineName(dynamic medicine) {
    return AppText.primary(
      medicine.name ?? 'Unknown Medicine',
      fontSize: 20,
      fontWeight: FontWeightType.bold,
      color: AppColors.black,
    );
  }

  /// Build medicine image section with main image and horizontal gallery
  Widget _buildImageSection(dynamic medicine) {
    return Obx(() {
      final images = widget.controller.medicineImages;
      final selectedIndex = widget.controller.selectedImageIndex.value;

      return Column(
        children: [
          // Main Image Preview
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.grey80,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: images.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.network(
                          images[selectedIndex],
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              AppImage.dummyMedicineImg.widget(
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    )
                  : AppImage.dummyMedicineImg.widget(
                      width: 120,
                      height: 120,
                    ),
            ),
          ),
          // Thumbnail Grid
          if (images.length > 1) ...[
            gapH10,
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => gapW8,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => widget.controller.selectImage(index),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey90,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.medical_services,
                            size: 24,
                            color: AppColors.grey60,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      );
    });
  }

  /// Build price section
  Widget _buildPriceSection(dynamic medicine) {
    return Obx(() {
      final product = widget.controller.product.value;
      final hasDiscount = product?.discountValue != null &&
                         (product?.discountValue ?? 0) > 0;
      final originalPrice = product?.price ?? 0.0;
      final currentPrice = widget.controller.displayPrice.value;
      final currentStock = widget.controller.displayStock.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppText.primary(
                'Price: ',
                fontSize: 16,
                fontWeight: FontWeightType.medium,
                color: AppColors.greyA8,
              ),
              gapW6,
              // Show original price with strikethrough if there's a discount
              if (hasDiscount && originalPrice != currentPrice) ...[
                AppText.primary(
                  'Rs. ${originalPrice.toStringAsFixed(2)}',
                  fontSize: 16,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.greyA8,
                  decoration: TextDecoration.lineThrough,
                ),
                gapW8,
              ],
              // Final/current price
              AppText.primary(
                'Rs. ${currentPrice.toStringAsFixed(2)}',
                fontSize: 20,
                fontWeight: FontWeightType.bold,
                color: AppColors.primary,
              ),
              // Discount badge
              if (hasDiscount) ...[
                gapW8,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.checkedColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: AppText.primary(
                    '${product!.discountValue!.toStringAsFixed(0)}% OFF',
                    fontSize: 12,
                    fontWeight: FontWeightType.bold,
                    color: AppColors.checkedColor,
                  ),
                ),
              ],
            ],
          ),
          gapH4,
          AppText.primary(
            'In Stock: $currentStock',
            fontSize: 13,
            fontWeight: FontWeightType.regular,
            color: currentStock > 0 ? AppColors.checkedColor : Colors.red,
          ),
        ],
      );
    });
  }

  /// Build dosage selector
  Widget _buildDosageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Dosage',
          fontSize: 16,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.textPrimary,
        ),
        gapH12,
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.controller.dosageVariants.asMap().entries.map((entry) {
                final index = entry.key;
                final variant = entry.value;
                final isSelected = widget.controller.selectedDosageIndex.value == index;
                return GestureDetector(
                  onTap: () => widget.controller.selectDosage(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.grey90,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        AppText.primary(
                          variant.dosage,
                          fontSize: 14,
                          fontWeight: FontWeightType.semiBold,
                          color: isSelected ? AppColors.white : AppColors.textPrimary,
                        ),
                        gapH4,
                        AppText.primary(
                          'Rs. ${variant.price.toStringAsFixed(2)}',
                          fontSize: 11,
                          fontWeight: FontWeightType.regular,
                          color: isSelected ? AppColors.white.withValues(alpha: 0.8) : AppColors.accent,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  /// Build quantity selector
  Widget _buildQuantitySelector() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.primary(
              'Quantity',
              fontSize: 16,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
            ),
            gapH12,
            QuantityControls(
              quantity: widget.controller.quantity.value,
              onIncrease: widget.controller.increaseQuantity,
              onDecrease: widget.controller.decreaseQuantity,
            ),
          ],
        ));
  }

  /// Build description section
  Widget _buildDescriptionSection(dynamic medicine) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Description',
          fontSize: 18,
          fontWeight: FontWeightType.bold,
          color: AppColors.textPrimary,
        ),
        gapH8,
        AppText.primary(
          medicine.description ?? 'No description available for this medicine.',
          fontSize: 14,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  /// Build ingredients section
  Widget _buildIngredientsSection(dynamic medicine) {
    return Obx(() {
      final product = widget.controller.product.value;
      final ingredients = product?.ingredients ?? 'No ingredients information available';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.primary(
            'Ingredients',
            fontSize: 18,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
          ),
          gapH8,
          AppText.primary(
            ingredients,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
        ],
      );
    });
  }

  /// Build how to use section
  Widget _buildHowToUseSection(dynamic medicine) {
    return Obx(() {
      final product = widget.controller.product.value;
      final howToUse = product?.howToUse ?? 'No usage instructions available';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.primary(
            'How to Use',
            fontSize: 18,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
          ),
          gapH8,
          AppText.primary(
            howToUse,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
        ],
      );
    });
  }

  /// Build static add to cart button at bottom
  Widget _buildBottomAddToCartButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: widget.controller.addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: AppText.primary(
              'Add to Cart',
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// Build share this product section
  Widget _buildShareSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          AppText.primary(
            'Share this product',
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          const Spacer(),
          // Instagram
          _buildSocialButton(
            icon: AppIcon.instagramIcon.widget(),
            onTap: () => widget.controller.shareOnSocialMedia('Instagram'),
          ),
          gapW10,
          // Facebook
          _buildSocialButton(
            icon: AppIcon.facebookIcon.widget(),
            onTap: () => widget.controller.shareOnSocialMedia('Facebook'),
          ),
          gapW10,
          // X (Twitter)
          _buildSocialButton(
            icon: AppIcon.xTwitterIcon.widget(),
            onTap: () => widget.controller.shareOnSocialMedia('X'),
          ),
        ],
      ),
    );
  }

  /// Build individual social media button
  Widget _buildSocialButton({
    required Widget icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: icon,
        ),
      ),
    );
  }
}
