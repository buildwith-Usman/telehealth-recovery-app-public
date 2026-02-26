import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'order_detail_controller.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/config/app_icon.dart';
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../../domain/entity/pharmacy_order_entity.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/common/recovery_app_bar.dart';
import '../../../widgets/info_item_with_icon.dart';

/// Order Detail Page - Shows detailed information about a pharmacy order
class OrderDetailPage extends BaseStatefulPage<OrderDetailController> {
  const OrderDetailPage({super.key});

  @override
  BaseStatefulPageState<OrderDetailController> createState() =>
      _OrderDetailPageState();
}

class _OrderDetailPageState
    extends BaseStatefulPageState<OrderDetailController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Order Details',
      showBackButton: true,
      backgroundColor: AppColors.whiteLight,
      onBackPressed: widget.controller.goBack,
    );
  }

  @override
  bool get useStandardPadding => false;

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() {
      final order = widget.controller.order.value;

      return Container(
        color: AppColors.whiteLight,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Status Card
                _buildOrderStatusCard(order),
                gapH20,

                // Order Information Card
                _buildOrderInfoCard(order),
                gapH20,

                // Delivery Address Card
                _buildDeliveryAddressCard(order),
                gapH20,

                // Order Items Card
                _buildOrderItemsCard(order),
                gapH20,

                // Payment Summary Card
                _buildPaymentSummaryCard(order),
                gapH20,

                // Action Buttons
                _buildActionButtons(order),
                gapH20,
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Build order status card
  Widget _buildOrderStatusCard(PharmacyOrderEntity order) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.primary(
                'Order Status',
                fontSize: 16,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.textPrimary,
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          gapH12,
          const Divider(height: 1, color: AppColors.lightDivider),
          gapH12,
          _buildInfoRow('Order Number', order.orderNumber, AppIcon.orderConfirmation),
          if (order.trackingNumber != null) ...[
            gapH12,
            _buildInfoRow('Tracking Number', order.trackingNumber!, AppIcon.myOrderInProgress),
          ],
        ],
      ),
    );
  }

  /// Build status badge
  Widget _buildStatusBadge(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.primary(
            _getStatusText(status),
            fontSize: 12,
            fontWeight: FontWeightType.medium,
            color: _getStatusColor(status),
          ),
          gapW4,
          Icon(
            _getStatusIcon(status),
            size: 14,
            color: _getStatusColor(status),
          ),
        ],
      ),
    );
  }

  /// Build order information card
  Widget _buildOrderInfoCard(PharmacyOrderEntity order) {
    return Container(
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
            'Order Information',
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          gapH12,
          const Divider(height: 1, color: AppColors.lightDivider),
          gapH12,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      'Order Date',
                      fontSize: 10,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                    ),
                    gapH4,
                    InfoItemWithIcon(
                      icon: AppIcon.datePickerIcon,
                      value: DateFormat('MMM dd, yyyy').format(order.orderDate),
                    ),
                  ],
                ),
              ),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      'Expected Delivery',
                      fontSize: 10,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                    ),
                    gapH4,
                    InfoItemWithIcon(
                      icon: AppIcon.orderDelivered,
                      value: DateFormat('MMM dd, yyyy')
                          .format(order.estimatedDeliveryDate),
                    ),
                  ],
                ),
              ),
            ],
          ),
          gapH12,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      'Payment Method',
                      fontSize: 10,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                    ),
                    gapH4,
                    InfoItemWithIcon(
                      icon: AppIcon.navPayment,
                      value: order.paymentMethod,
                    ),
                  ],
                ),
              ),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      'Payment Status',
                      fontSize: 10,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                    ),
                    gapH4,
                    InfoItemWithIcon(
                      icon: AppIcon.navPayment,
                      value: _getPaymentStatusText(order.paymentStatus),
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

  /// Build delivery address card
  Widget _buildDeliveryAddressCard(PharmacyOrderEntity order) {
    return Container(
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
            'Delivery Address',
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          gapH12,
          const Divider(height: 1, color: AppColors.lightDivider),
          gapH12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: AppColors.accent,
              ),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      order.customerName,
                      fontSize: 14,
                      fontWeight: FontWeightType.semiBold,
                      color: AppColors.textPrimary,
                    ),
                    gapH4,
                    AppText.primary(
                      order.customerPhone,
                      fontSize: 14,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                    ),
                    gapH4,
                    AppText.primary(
                      order.deliveryAddress,
                      fontSize: 14,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
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

  /// Build order items card
  Widget _buildOrderItemsCard(PharmacyOrderEntity order) {
    return Container(
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
            'Order Items (${order.items.length})',
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          gapH12,
          const Divider(height: 1, color: AppColors.lightDivider),
          gapH12,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => gapH12,
            itemBuilder: (context, index) {
              final item = order.items[index];
              return _buildOrderItem(item);
            },
          ),
        ],
      ),
    );
  }

  /// Build single order item
  Widget _buildOrderItem(OrderItemEntity item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Medicine icon
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: AppIcon.medicineIcon.widget(width: 24, height: 24),
          ),
        ),
        gapW12,
        // Item details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(
                item.medicineName,
                fontSize: 14,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.textPrimary,
              ),
              if (item.manufacturer != null) ...[
                gapH4,
                AppText.primary(
                  item.manufacturer!,
                  fontSize: 12,
                  fontWeight: FontWeightType.regular,
                  color: AppColors.textSecondary,
                ),
              ],
              gapH4,
              AppText.primary(
                'Qty: ${item.quantity} × Rs. ${item.unitPrice.toStringAsFixed(2)}',
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        // Price
        AppText.primary(
          'Rs. ${item.totalPrice.toStringAsFixed(2)}',
          fontSize: 14,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }

  /// Build payment summary card
  Widget _buildPaymentSummaryCard(PharmacyOrderEntity order) {
    return Container(
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
            'Payment Summary',
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          gapH12,
          const Divider(height: 1, color: AppColors.lightDivider),
          gapH12,
          _buildPriceRow('Subtotal', order.subtotal),
          gapH8,
          _buildPriceRow('Delivery Fee', order.deliveryFee),
          gapH8,
          _buildPriceRow('Tax', order.tax),
          gapH12,
          const Divider(height: 1, color: AppColors.lightDivider),
          gapH12,
          _buildPriceRow('Total', order.totalAmount, isTotal: true),
        ],
      ),
    );
  }

  /// Build price row
  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.primary(
          label,
          fontSize: isTotal ? 16 : 14,
          fontWeight: isTotal ? FontWeightType.bold : FontWeightType.regular,
          color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
        ),
        AppText.primary(
          'Rs. ${amount.toStringAsFixed(2)}',
          fontSize: isTotal ? 16 : 14,
          fontWeight: isTotal ? FontWeightType.bold : FontWeightType.semiBold,
          color: isTotal ? AppColors.primary : AppColors.textPrimary,
        ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons(PharmacyOrderEntity order) {
    final canTrack = order.status == OrderStatus.dispatched ||
        order.status == OrderStatus.confirmed;

    return Column(
      children: [
        // Track Order Button (if applicable)
        if (canTrack) ...[
          PrimaryButton(
            title: 'Track Order',
            height: 48,
            fontSize: 16,
            showIcon: true,
            icon: Icons.location_on_outlined,
            iconPosition: IconPosition.left,
            onPressed: widget.controller.trackOrder,
          ),
          gapH12,
        ],

        // Secondary Actions Row
        Row(
          children: [
            // Cancel Order Button (if allowed)
            if (order.canBeCancelled)
              Expanded(
                child: PrimaryButton.outlined(
                  title: 'Cancel Order',
                  height: 48,
                  fontSize: 14,
                  borderColor: AppColors.red513,
                  textColor: AppColors.red513,
                  onPressed: widget.controller.cancelOrder,
                ),
              ),

            // Reorder Button (if delivered)
            if (order.status == OrderStatus.delivered) ...[
              if (order.canBeCancelled) gapW12,
              Expanded(
                child: PrimaryButton.outlined(
                  title: 'Reorder',
                  height: 48,
                  fontSize: 14,
                  onPressed: widget.controller.reorderItems,
                ),
              ),
            ],

            // Contact Support
            if (!order.canBeCancelled &&
                order.status != OrderStatus.delivered) ...[
              Expanded(
                child: PrimaryButton.outlined(
                  title: 'Contact Support',
                  height: 48,
                  fontSize: 14,
                  onPressed: widget.controller.contactSupport,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Get status color
  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.pendingColor;
      case OrderStatus.confirmed:
        return AppColors.primary;
      case OrderStatus.dispatched:
        return AppColors.accent;
      case OrderStatus.delivered:
        return AppColors.checkedColor;
      case OrderStatus.cancelled:
        return AppColors.red513;
    }
  }

  /// Get status text
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.dispatched:
        return 'Dispatched';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  /// Get status icon
  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.dispatched:
        return Icons.local_shipping_outlined;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  /// Get payment status text
  String _getPaymentStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.paid:
        return 'Paid';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  /// Build info row with label and value
  Widget _buildInfoRow(String label, String value, AppIconBuilder icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          label,
          fontSize: 10,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
        ),
        gapH4,
        InfoItemWithIcon(
          icon: icon,
          value: value,
        ),
      ],
    );
  }
}
