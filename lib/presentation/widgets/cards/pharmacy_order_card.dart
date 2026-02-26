import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/info_item_with_icon.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/utils/sizes.dart';
import '../../../../domain/entity/pharmacy_order_entity.dart';
import '../app_text.dart';
import '../button/primary_button.dart';

/// Pharmacy Order Card - Displays order information in a card format
class PharmacyOrderCard extends StatelessWidget {
  final PharmacyOrderEntity order;
  final VoidCallback? onTap;
  final VoidCallback? onTrackOrder;
  final VoidCallback? onCancelOrder;
  final VoidCallback? onReorder;
  final VoidCallback? onRateOrder;
  final bool showTrackingInfo;

  const PharmacyOrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onTrackOrder,
    this.onCancelOrder,
    this.onReorder,
    this.onRateOrder,
    this.showTrackingInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
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
            //Order Status
            _buildOrderStatus(),
            gapH12,
            const Divider(
              height: 1,
              color: AppColors.lightDivider,
            ),
            gapH12,
            // Order Items Preview
            _buildItemsPreview(),
            gapH12,
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Build order header with order number and status
  Widget _buildOrderStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppText.primary(
          order.statusDisplayText,
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: _getStatusColor(order.status),
        ),
        gapW8,
        _buildOrderStatusIcon(),
      ],
    );
  }

  Widget _buildOrderStatusIcon() {
    AppIconBuilder statusIcon;

    switch (order.status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
      case OrderStatus.dispatched:
        statusIcon = AppIcon.myOrderInProgress;
        break;
      case OrderStatus.delivered:
        statusIcon = AppIcon.myOrderDelivered;
        break;
      case OrderStatus.cancelled:
        statusIcon = AppIcon.myOrderInProgress;
        break;
    }

    return statusIcon.widget(
      width: 16,
      height: 16,
    );
  }

  /// Get status color based on order status
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

  /// Build items preview 
  Widget _buildItemsPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Number and Date Row
        Row(
          children: [
            Expanded(
              child: InfoItemWithIcon(
                icon: AppIcon.orderConfirmation,
                value: order.orderNumber,
              ),
            ),
            gapW12,
            Expanded(
              child: InfoItemWithIcon(
                icon: AppIcon.datePickerIcon,
                value: DateFormat('MMM dd, yyyy').format(order.orderDate),
              ),
            ),
          ],
        ),
        gapH12,
        Row(
          children: [
            Expanded(
              child: InfoItemWithIcon(
                icon: AppIcon.medicineIcon,
                value: '2 Items',
              ),
            ),
            gapW12,
            Expanded(
              child: InfoItemWithIcon(
                icon: AppIcon.navPayment,
                value: order.totalAmount.toString(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build action buttons based on order status
  Widget _buildActionButtons() {
    return Row(
      children: [
        // View Details Button (always available)
        Expanded(
          child: PrimaryButton(
            title: 'Details',
            height: 36,
            fontSize: 12,
            color: AppColors.greyF7,
            textColor: AppColors.black,
            showIcon: true,
            fontWeight: FontWeightType.medium,
            onPressed: onTap ?? () {},
          ),
        ),
        gapW12,
        //action button
        Expanded(
          child: _buildPrimaryActionButton(),
        ),
      ],
    );
  }

  /// Build primary action button based on order status
  Widget _buildPrimaryActionButton() {
    return PrimaryButton(
            title: 'Track',
            height: 36,
            fontSize: 12,
            showIcon: true,
            color: AppColors.primary,
            fontWeight: FontWeightType.medium,
            onPressed: onTrackOrder ?? () {},
          );
  }
}
