import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_tracking_controller.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/config/app_icon.dart';
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../../domain/entity/cart_item_entity.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/common/recovery_app_bar.dart';
import '../../../widgets/info_item_with_icon.dart';

/// Order Tracking Page - Shows order tracking status and timeline
class OrderTrackingPage extends BaseStatefulPage<OrderTrackingController> {
  const OrderTrackingPage({super.key});

  @override
  BaseStatefulPageState<OrderTrackingController> createState() =>
      _OrderTrackingPageState();
}

class _OrderTrackingPageState
    extends BaseStatefulPageState<OrderTrackingController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Track Order',
      showBackButton: true,
      backgroundColor: AppColors.whiteLight,
      onBackPressed: widget.controller.goBack,
    );
  }

  @override
  bool get useStandardPadding => false;

  @override
  Widget? buildBottomBar() {
    return _buildBottomButton();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Section with Tracking
            _buildOrderSummaryCard(),
            gapH24,

            // Delivery Information
            _buildDeliveryInformation(),
          ],
        ),
      );
    });
  }

  /// Build order summary card
  Widget _buildOrderSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // First Row: Order ID and Date & Time
          Row(
            children: [
              Expanded(
                child: InfoItemWithIcon(
                    icon: AppIcon.orderConfirmation,
                    value: widget.controller.orderNumber.value),
              ),
              gapW12,
              Expanded(
                child: InfoItemWithIcon(
                  icon: AppIcon.datePickerIcon,
                  value: widget.controller.orderDate.value,
                ),
              ),
            ],
          ),
          gapH16,
          // Second Row: Status and Payment Method
          Row(
            children: [
              Expanded(
                child: InfoItemWithIcon(
                  icon: AppIcon.orderStatus,
                  value: _getStatusText(widget.controller.currentStatus.value),
                ),
              ),
              gapW12,
              Expanded(
                child: InfoItemWithIcon(
                  icon: AppIcon.navPayment,
                  value: 'Paid via: ${widget.controller.paymentMethod.value}',
                ),
              ),
            ],
          ),
          gapH24,
          // Divider
          const Divider(
            color: AppColors.grey95,
            thickness: 1,
            height: 1,
          ),
          gapH20,
          // Order Items Section
          AppText.primary(
            'Order Items',
            fontSize: 18,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
          ),
          gapH16,
          // Order Items List
          _buildOrderItemsList(),
          gapH24,
          // Divider
          const Divider(
            color: AppColors.grey95,
            thickness: 1,
            height: 1,
          ),
          gapH20,
          // Order Tracking Section
          AppText.primary(
            'Order Tracking',
            fontSize: 18,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
          ),
          gapH20,
          // Tracking Timeline
          _buildTrackingTimeline(),
        ],
      ),
    );
  }

  /// Get status text from enum
  String _getStatusText(OrderTrackingStatus status) {
    switch (status) {
      case OrderTrackingStatus.placed:
        return 'Status: Order Placed';
      case OrderTrackingStatus.dispatched:
        return 'Status: Dispatched';
      case OrderTrackingStatus.delivered:
        return 'Status: Delivered';
      case OrderTrackingStatus.completed:
        return 'Status: Completed';
    }
  }

  /// Build order items list
  Widget _buildOrderItemsList() {
    return Obx(() {
      if (widget.controller.orderItems.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: List.generate(widget.controller.orderItems.length, (index) {
          final item = widget.controller.orderItems[index];
          final isLast = index == widget.controller.orderItems.length - 1;

          return Column(
            children: [
              _buildOrderItem(item),
              if (!isLast) ...[
                gapH16,
                const Divider(
                  color: AppColors.grey95,
                  thickness: 1,
                  height: 1,
                ),
                gapH16,
              ],
            ],
          );
        }),
      );
    });
  }

  /// Build individual order item
  Widget _buildOrderItem(CartItemEntity item) {
    final medicineName = item.medicine.name ?? 'Unknown Medicine';
    // For now, use a default dosage format - in real app this would come from medicine entity
    final dosage = item.medicine.description ?? '1 tab × 3/day | 5 days';
    final itemTotal = (item.medicine.price ?? 0) * item.quantity;

    return Column(
      children: [
        // First Row: Medicine Name and Dosage
        Row(
          children: [
            Expanded(
              child: InfoItemWithIcon(
                icon: AppIcon.medicineIcon,
                value: medicineName,
              ),
            ),
            gapW12,
            Expanded(
              child: InfoItemWithIcon(
                icon: AppIcon.dosageIcon,
                value: dosage,
              ),
            ),
          ],
        ),
        gapH12,
        // Second Row: Quantity and Amount
        Row(
          children: [
            Expanded(
              child: InfoItemWithIcon(
                icon: AppIcon.cartIcon,
                value: 'Qty: ${item.quantity}',
              ),
            ),
            gapW12,
            Expanded(
              child: InfoItemWithIcon(
                icon: AppIcon.navPayment,
                value: 'PKR ${itemTotal.toStringAsFixed(0)}',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build tracking timeline with connected lines
  Widget _buildTrackingTimeline() {
    return Obx(() {
      final steps = widget.controller.trackingSteps;

      return Column(
        children: List.generate(steps.length, (index) {
          final step = steps[index];
          final isLast = index == steps.length - 1;

          return _buildTrackingStep(
            step: step,
            isLast: isLast,
          );
        }),
      );
    });
  }

  /// Get icon for tracking status
  AppIconBuilder _getStatusIcon(OrderTrackingStatus status) {
    switch (status) {
      case OrderTrackingStatus.placed:
        return AppIcon.orderPlaced;
      case OrderTrackingStatus.dispatched:
        return AppIcon.orderDispatched;
      case OrderTrackingStatus.delivered:
        return AppIcon.orderDelivered;
      case OrderTrackingStatus.completed:
        return AppIcon.orderCompleted;
    }
  }

  /// Build individual tracking step
  Widget _buildTrackingStep({
    required TrackingStep step,
    required bool isLast,
  }) {
    final bool isActive = step.isCompleted || step.isCurrent;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator (circle and line)
        Column(
          children: [
            // Circle indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary : AppColors.white,
                border: Border.all(
                  color: isActive ? AppColors.primary : AppColors.grey80,
                  width: 2,
                ),
              ),
              child: step.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: AppColors.white,
                    )
                  : step.isCurrent
                      ? Container(
                          margin: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                        )
                      : null,
            ),

            // Connecting line
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isActive ? AppColors.primary : AppColors.grey95,
              ),
          ],
        ),
        gapW16,

        // Step icon and content wrapper
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step icon
                SizedBox(
                  width: 32,
                  height: 32,
                  child: _getStatusIcon(step.status).widget(
                    width: double.infinity,
                    height: double.infinity,
                    color: isActive ? AppColors.primary : AppColors.grey80,
                  ),
                ),
                gapW12,
                // Step content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step title
                      AppText.primary(
                        step.title,
                        fontSize: 16,
                        fontWeight: step.isCurrent
                            ? FontWeightType.bold
                            : FontWeightType.semiBold,
                        color: isActive
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                      gapH4,

                      // Step description
                      if (step.description != null)
                        AppText.primary(
                          step.description!,
                          fontSize: 12,
                          fontWeight: FontWeightType.regular,
                          color: AppColors.textSecondary,
                        ),

                      // Timestamp
                      if (step.timestamp != null) ...[
                        gapH4,
                        AppText.primary(
                          widget.controller.formatTimestamp(step.timestamp),
                          fontSize: 11,
                          fontWeight: FontWeightType.regular,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build delivery information
  Widget _buildDeliveryInformation() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Section Title
          AppText.primary(
            'Delivery Information',
            fontSize: 18,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
          ),
          gapH16,

          // Delivery Address
          _buildDeliveryInfoRow(
            Icons.location_on_outlined,
            'Address',
            widget.controller.deliveryAddress.value,
          ),
          gapH12,

          // Phone Number
          _buildDeliveryInfoRow(
            Icons.phone_outlined,
            'Phone',
            widget.controller.phoneNumber.value,
          ),
          gapH12,

          // Estimated Delivery
          _buildDeliveryInfoRow(
            Icons.calendar_today_outlined,
            'Estimated Delivery',
            widget.controller.estimatedDelivery.value,
          ),
        ],
      ),
    );
  }

  /// Build delivery info row
  Widget _buildDeliveryInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.primary,
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
              gapH2,
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

  /// Build bottom button
  Widget _buildBottomButton() {
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
        child: PrimaryButton(
          title: 'Back to Home',
          height: 40,
          fontSize: 14,
          color: AppColors.primary,
          textColor: AppColors.white,
          radius: 6,
          fontWeight: FontWeightType.medium,
          onPressed: widget.controller.goToHome,
        ),
      ),
    );
  }
}
