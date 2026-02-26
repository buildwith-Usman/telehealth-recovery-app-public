import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/cart/cart_controller.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/config/app_image.dart';
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/common/recovery_app_bar.dart';
import 'widgets/cart_item_card.dart';

/// Cart Page - Shows shopping cart with items and checkout options
/// This follows the same pattern as MedicineDetailPage
class CartPage extends BaseStatefulPage<CartController> {
  const CartPage({super.key});

  @override
  BaseStatefulPageState<CartController> createState() => _CartPageState();
}

class _CartPageState extends BaseStatefulPageState<CartController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Shopping Cart',
      showBackButton: true,
      backButtonIcon: AppIcon.navHome.widget(
        width: 16,
        height: 16,
        color: AppColors.accent,
      ),
      onBackPressed: () => widget.controller.goBack(),
      backgroundColor: AppColors.whiteLight,
    );
  }

  @override
  bool get useStandardPadding => true;

  @override
  Widget? buildBottomBar() {
    return _buildBottomCheckoutSection();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() {
      // Show loading state
      if (widget.controller.isLoading.value &&
          widget.controller.cartItems.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      }

      // Show empty cart state
      if (widget.controller.cartItems.isEmpty) {
        return _buildEmptyCartState();
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items List
            ...widget.controller.cartItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCartItemCard(item),
              );
            }),
            gapH16,

            // Order Summary
            _buildOrderSummary(),
            gapH32,
          ],
        ),
      );
    });
  }

  /// Build empty cart state
  Widget _buildEmptyCartState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage.dummyMedicineImg.widget(
            width: 120,
            height: 120,
          ),
          gapH24,
          AppText.primary(
            'Your cart is empty',
            fontSize: 20,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
          ),
          gapH8,
          AppText.primary(
            'Add medicines to get started',
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  /// Build cart item card
  Widget _buildCartItemCard(dynamic item) {
    return CartItemCard(
      item: item,
      onRemove: () => widget.controller.removeItem(item.id),
      onIncreaseQuantity: () => widget.controller.increaseQuantity(item.id),
      onDecreaseQuantity: () => widget.controller.decreaseQuantity(item.id),
    );
  }

  /// Build order summary
  Widget _buildOrderSummary() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(
                'Order Summary',
                fontSize: 18,
                fontWeight: FontWeightType.bold,
                color: AppColors.textPrimary,
              ),
              gapH16,
              // Subtotal
              _buildSummaryRow(
                'Subtotal',
                'Rs. ${widget.controller.subtotal.value.toStringAsFixed(2)}',
              ),
              gapH12,
              // Delivery Fee
              _buildSummaryRow(
                'Delivery Fee',
                'Rs. ${widget.controller.deliveryFee.value.toStringAsFixed(2)}',
              ),
              gapH12,
              const Divider(
                color: AppColors.grey90,
                thickness: 1,
              ),
              gapH12,
              // Total
              _buildSummaryRow(
                'Total',
                'Rs. ${widget.controller.total.value.toStringAsFixed(2)}',
                isBold: true,
              ),
            ],
          ),
        ));
  }

  /// Build summary row
  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.primary(
          label,
          fontSize: 14,
          fontWeight: isBold ? FontWeightType.bold : FontWeightType.regular,
          color: AppColors.textSecondary,
        ),
        AppText.primary(
          value,
          fontSize: isBold ? 18 : 14,
          fontWeight: isBold ? FontWeightType.bold : FontWeightType.semiBold,
          color: isBold ? AppColors.primary : AppColors.textPrimary,
        ),
      ],
    );
  }

  /// Build bottom checkout section
  Widget _buildBottomCheckoutSection() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.primary(
                      'Total Amount',
                      fontSize: 14,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                    ),
                    AppText.primary(
                      'Rs. ${widget.controller.total.value.toStringAsFixed(2)}',
                      fontSize: 20,
                      fontWeight: FontWeightType.bold,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                gapH12,
                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: widget.controller.cartItems.isNotEmpty
                        ? widget.controller.proceedToCheckout
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.grey90,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    child: AppText.primary(
                      'Proceed to Checkout',
                      fontSize: 14,
                      fontWeight: FontWeightType.medium,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
