import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/domain/entity/payment_method_entity.dart';
import 'package:recovery_consultation_app/domain/enums/payment_method_type.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';

/// Reusable Payment Method Selector Tile
/// A clean, tappable card that displays payment method information
/// Follows DRY principle - use this widget across all payment flows
class PaymentMethodSelectorTile extends StatelessWidget {
  final PaymentMethodEntity? paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool showDefaultBadge;
  final bool showActionButton;
  final VoidCallback? onActionButtonTap;
  final IconData? actionButtonIcon;

  const PaymentMethodSelectorTile({
    super.key,
    this.paymentMethod,
    this.isSelected = false,
    required this.onTap,
    this.onLongPress,
    this.showDefaultBadge = true,
    this.showActionButton = false,
    this.onActionButtonTap,
    this.actionButtonIcon,
  });

  @override
  Widget build(BuildContext context) {
    // If no payment method, show "Add Payment Method" tile
    if (paymentMethod == null) {
      return _buildAddPaymentMethodTile();
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.textSecondary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
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
            // Payment method icon
            _buildPaymentMethodIcon(),
            gapW12,

            // Payment method details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppText.primary(
                          paymentMethod!.displayTitle,
                          fontSize: 16,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (showDefaultBadge && paymentMethod!.isDefault) ...[
                        gapW8,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: AppText.primary(
                            'Default',
                            fontSize: 10,
                            fontWeight: FontWeightType.medium,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                  gapH4,
                  AppText.primary(
                    paymentMethod!.displaySubtitle,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            // Selection indicator or action button
            if (showActionButton && onActionButtonTap != null) ...[
              gapW12,
              IconButton(
                icon: Icon(
                  actionButtonIcon ?? Icons.more_vert,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                onPressed: onActionButtonTap,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ] else if (isSelected) ...[
              gapW12,
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build payment method icon based on type
  Widget _buildPaymentMethodIcon() {
    Widget icon;

    switch (paymentMethod!.type) {
      case PaymentMethodType.jazzCash:
        icon = AppIcon.jazzCashIcon.widget(height: 40, width: 40);
        break;
      case PaymentMethodType.easyPaisa:
        icon = AppIcon.easyPaisaIcon.widget(height: 40, width: 40);
        break;
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        icon = AppIcon.cardPaymentIcon.widget(height: 40, width: 40);
        break;
      case PaymentMethodType.cashOnDelivery:
        icon = AppIcon.defaultPaymentIcon(size: 40, color: AppColors.accent);
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: icon),
    );
  }

  /// Build "Add Payment Method" tile
  Widget _buildAddPaymentMethodTile() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.3),
            width: 1.5,
            style: BorderStyle.solid,
          ),
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.accent,
                size: 24,
              ),
            ),
            gapW12,
            Expanded(
              child: AppText.primary(
                'Add New Payment Method',
                fontSize: 16,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.accent,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.accent,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact version of payment method tile (for summary views)
class PaymentMethodSummaryTile extends StatelessWidget {
  final PaymentMethodEntity? paymentMethod;
  final VoidCallback onTap;
  final bool showChangeButton;

  const PaymentMethodSummaryTile({
    super.key,
    required this.paymentMethod,
    required this.onTap,
    this.showChangeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (paymentMethod != null) ...[
              _buildPaymentMethodIcon(),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.primary(
                      paymentMethod!.displayTitle,
                      fontSize: 14,
                      fontWeight: FontWeightType.semiBold,
                      color: AppColors.textPrimary,
                    ),
                    gapH4,
                    AppText.primary(
                      paymentMethod!.displaySubtitle,
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ] else ...[
              const Icon(
                Icons.payment,
                color: AppColors.accent,
                size: 24,
              ),
              gapW12,
              Expanded(
                child: AppText.primary(
                  'Choose Payment Method',
                  fontSize: 14,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.textSecondary,
                ),
              ),
              // ✅ Show arrow icon when no payment method selected
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accent,
                size: 14,
              ),
            ],
            // ✅ Only show "Change" button when payment method is selected
            if (showChangeButton && paymentMethod != null) ...[
              gapW8,
              AppText.primary(
                'Change',
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: AppColors.accent,
              ),
              gapW4,
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.accent,
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodIcon() {
    if (paymentMethod == null) return const SizedBox();

    Widget icon;

    switch (paymentMethod!.type) {
      case PaymentMethodType.jazzCash:
        icon = AppIcon.jazzCashIcon.widget(height: 32, width: 32);
        break;
      case PaymentMethodType.easyPaisa:
        icon = AppIcon.easyPaisaIcon.widget(height: 32, width: 32);
        break;
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        icon = AppIcon.cardPaymentIcon.widget(height: 32, width: 32);
        break;
      case PaymentMethodType.cashOnDelivery:
        icon = AppIcon.defaultPaymentIcon(size: 32, color: AppColors.accent);
        break;
    }

    return icon;
  }
}
