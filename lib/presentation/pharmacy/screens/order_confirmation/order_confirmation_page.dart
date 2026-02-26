import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/order_confirmation/order_confirmation_controller.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/config/app_icon.dart'; // Add this import
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/common/recovery_app_bar.dart';

/// Order Confirmation Page - Shows order success and details
class OrderConfirmationPage extends BaseStatefulPage<OrderConfirmationController> {
  const OrderConfirmationPage({super.key});

  @override
  BaseStatefulPageState<OrderConfirmationController> createState() =>
      _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends BaseStatefulPageState<OrderConfirmationController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Order Confirmation',
      showBackButton: false,
      backgroundColor: AppColors.whiteLight,
    );
  }

  @override
  bool get useStandardPadding => true;

  @override
  Widget? buildBottomBar() {
    return _buildBottomButtons();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() {
      // Show loading state
      if (widget.controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            gapH10,
            // Success Icon with App Icon
            _buildSuccessIcon(),
            gapH24,
            // Success Message
            _buildSuccessMessage(),
            gapH32,
            _buildOrderDetailsSection(),
          ],
        ),
      );
    });
  }

  /// Build success icon with app icon only
  Widget _buildSuccessIcon() {
    return Center(
        child: AppImage.orderConfirmation.widget(
          width: 100,
          height: 100,
        ),
      );
  }

  /// Build success message
  Widget _buildSuccessMessage() {
    return AppText.primary(
          'Your Order Has Been Placed!',
          fontSize: 24,
          fontWeight: FontWeightType.bold,
          color: AppColors.textPrimary,
          textAlign: TextAlign.center,
        );
  }

  /// Build order number section with enhanced design
  Widget _buildOrderNumberSection() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Order number with copy functionality
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      AppText.primary(
                        'Order Number',
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.textSecondary,
                      ),
                      gapH8,
                      AppText.primary(
                        widget.controller.orderNumber.value,
                        fontSize: 20,
                        fontWeight: FontWeightType.bold,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  gapW12,
                  GestureDetector(
                    onTap: () {
                      // Copy order number functionality
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.grey95,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.copy,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              gapH16,
              
              // Delivery estimate with enhanced styling
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage.orderConfirmation.widget(
                      width: 20,
                      height: 20,
                      color: AppColors.primary,
                    ),
                    gapW8,
                    AppText.primary(
                      'Estimated Delivery: ${widget.controller.estimatedDelivery.value}',
                      fontSize: 14,
                      fontWeight: FontWeightType.medium,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  /// Build order summary section
  Widget _buildOrderSummarySection() {
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
              Row(
                children: [
                  AppImage.orderConfirmation.widget(
                    width: 20,
                    height: 20,
                    color: AppColors.primary,
                  ),
                  gapW8,
                  AppText.primary(
                    'Order Summary',
                    fontSize: 18,
                    fontWeight: FontWeightType.bold,
                    color: AppColors.textPrimary,
                  ),
                ],
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

  /// Build labeled container with background
  Widget _buildLabeledContainer(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          label,
          fontSize: 16,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH8,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.greyF7,
            borderRadius: BorderRadius.circular(6),
          ),
          child: AppText.primary(
            value,
            fontSize: 12,
            fontWeight: FontWeightType.medium,
            color: AppColors.black.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  /// Build info row
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: AppColors.primary, size: 16),
        ),
        gapW12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(
                label,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
              ),
              gapH4,
              AppText.primary(
                value,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build bottom buttons
  Widget _buildBottomButtons() {
    return Container(
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
        child: Row(
          children: [
            // Back to Home Button - Clean factory method
            Expanded(
              child: PrimaryButton.roundedOutlined(
                title: 'Back to Home',
                height: 45,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                onPressed: widget.controller.goToHome,
              ),
            ),
            gapW12,
            // Track Order Button - Default filled
            Expanded(
              child: PrimaryButton(
                title: 'Track Order',
                height: 45,
                fontSize: 14,
                color: AppColors.primary,
                textColor: AppColors.white,
                radius: 6,
                showIcon: true,
                fontWeight: FontWeightType.medium,
                onPressed: widget.controller.trackOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build combined order details section
  Widget _buildOrderDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Date Section
          Obx(() => Row(
            children: [
              // Order ID
              Expanded(
                child: _buildLabeledContainer(
                  'Order ID:',
                  widget.controller.orderNumber.value,
                ),
              ),
              gapW12,
              // Date
              Expanded(
                child: _buildLabeledContainer(
                  'Date:',
                  widget.controller.orderDate.value,
                ),
              ),
            ],
          )),
          gapH20,
          // Medicine Ordered Section
           AppText.primary(
                'Medicine Ordered',
                fontSize: 16,
                fontWeight: FontWeightType.bold,
                color: AppColors.black,
              ),
          gapH16,
          // Medicine List
          Obx(() => widget.controller.orderItems.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: AppText.primary(
                  'No items in order',
                  fontSize: 14,
                  fontWeight: FontWeightType.regular,
                  color: AppColors.textSecondary,
                ),
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                decoration: BoxDecoration(
                  color: AppColors.greyF7,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.controller.orderItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bullet point
                          Container(
                            margin: const EdgeInsets.only(top: 6, right: 12),
                            width: 6,
                            height: 6,
                            decoration:  BoxDecoration(
                              color: AppColors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Medicine name and quantity
                          Expanded(
                            child: AppText.primary(
                              '${item.medicine.name} (Qty: ${item.quantity})',
                              fontSize: 12,
                              fontWeight: FontWeightType.medium,
                              color: AppColors.black.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ),
          gapH20,
          // Delivery Information Section
          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabeledContainer(
                  'Name',
                  widget.controller.customerName.value,
                ),
                gapH12,
                _buildLabeledContainer(
                  'Phone Number',
                  widget.controller.phoneNumber.value,
                ),
                gapH12,
                _buildLabeledContainer(
                  'Delivery Address',
                  widget.controller.deliveryAddress.value,
                ),
              gapH12,
              _buildLabeledContainer(
                'Payment Method',
                widget.controller.paymentMethod.value,
              ),
            ],
          )),
          gapH24,
          // Delivery Estimate
          Row(
              children: [
                AppIcon.estimatedDeliveryIcon.widget(
                  width: 20,
                  height: 20,
                ),
                gapW8,
                Obx(() => AppText.primary(
                  'Estimated Delivery: ${widget.controller.estimatedDelivery.value}',
                  fontSize: 14,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.black.withOpacity(0.3),
                )),
              ],
            ),
        ],
      ),
    );
  }
}
