import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/controllers/payment_method_controller.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/payment_method/payment_method_bottom_sheet.dart';
import 'package:recovery_consultation_app/presentation/widgets/payment_method/payment_method_selector_tile.dart';

/// Reusable Payment Method Section Widget
///
/// Displays a complete payment method section with:
/// - Title
/// - Selected payment method summary
/// - Change button that opens payment method picker
///
/// Usage:
/// ```dart
/// PaymentMethodSection(
///   controller: widget.controller.paymentMethodController,
///   title: 'Payment Method', // Optional, defaults to 'Payment Method'
///   showShadow: true,        // Optional, defaults to true
/// )
/// ```
class PaymentMethodSection extends StatelessWidget {
  /// The payment method controller to use
  final PaymentMethodController controller;

  /// Title to display (defaults to 'Payment Method')
  final String? title;

  /// Whether to show shadow around the container (defaults to true)
  final bool showShadow;

  /// Custom padding (defaults to EdgeInsets.all(16))
  final EdgeInsetsGeometry? padding;

  /// Custom border radius (defaults to BorderRadius.circular(12))
  final BorderRadiusGeometry? borderRadius;

  /// Whether to show background container (defaults to true)
  final bool showBackground;

  const PaymentMethodSection({
    super.key,
    required this.controller,
    this.title,
    this.showShadow = true,
    this.padding,
    this.borderRadius,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null || showBackground) ...[
          AppText.primary(
            title ?? 'Payment Method',
            fontSize: 18,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
          ),
          gapH16,
        ],
        // ✅ Use the reusable summary tile
        Obx(() => PaymentMethodSummaryTile(
          paymentMethod: controller.selectedPaymentMethod.value,
          onTap: () => _showPaymentMethodPicker(context),
          showChangeButton: true,
        )),
      ],
    );

    // If no background, return content directly
    if (!showBackground) {
      return content;
    }

    // Return with background container
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: content,
    );
  }

  /// Show payment method picker bottom sheet
  void _showPaymentMethodPicker(BuildContext context) {
    PaymentMethodBottomSheet.show(
      context: context,
      controller: controller,
    );
  }
}
