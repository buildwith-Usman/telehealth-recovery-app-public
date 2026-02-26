import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/controllers/payment_method_controller.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/payment_method/payment_method_selector_tile.dart';

/// Reusable Payment Method Selection Bottom Sheet
/// Use this to show payment method selection in any flow
class PaymentMethodBottomSheet extends StatelessWidget {
  final PaymentMethodController controller;
  final Function(int paymentMethodId)? onPaymentMethodSelected;

  const PaymentMethodBottomSheet({
    super.key,
    required this.controller,
    this.onPaymentMethodSelected,
  });

  /// Show the bottom sheet
  static Future<int?> show({
    required BuildContext context,
    required PaymentMethodController controller,
    Function(int paymentMethodId)? onPaymentMethodSelected,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodBottomSheet(
        controller: controller,
        onPaymentMethodSelected: onPaymentMethodSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.primary(
                  'Select Payment Method',
                  fontSize: 20,
                  fontWeight: FontWeightType.bold,
                  color: AppColors.textPrimary,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          gapH16,

          // Payment methods list
          Flexible(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                    ),
                  ),
                );
              }

              if (controller.paymentMethods.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.payment,
                        size: 64,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                      gapH16,
                      AppText.primary(
                        'No Payment Methods',
                        fontSize: 16,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.textSecondary,
                      ),
                      gapH8,
                      AppText.primary(
                        'Add a payment method to continue',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: controller.paymentMethods.length,
                separatorBuilder: (context, index) => gapH12,
                itemBuilder: (context, index) {
                  final paymentMethod = controller.paymentMethods[index];
                  final isSelected = controller.isPaymentMethodSelected(paymentMethod);

                  return PaymentMethodSelectorTile(
                    paymentMethod: paymentMethod,
                    isSelected: isSelected,
                    onTap: () {
                      controller.selectPaymentMethod(paymentMethod);
                      if (onPaymentMethodSelected != null) {
                        onPaymentMethodSelected!(paymentMethod.id);
                      }
                      Navigator.pop(context, paymentMethod.id);
                    },
                    showDefaultBadge: true,
                  );
                },
              );
            }),
          ),

          gapH24,
        ],
      ),
    );
  }
}

/// Simple Payment Method Selection Bottom Sheet (without controller dependency)
/// For quick selections without full controller setup
class SimplePaymentMethodBottomSheet extends StatefulWidget {
  final List<String> paymentMethodTypes;
  final String? selectedType;
  final Function(String type)? onSelected;

  const SimplePaymentMethodBottomSheet({
    super.key,
    required this.paymentMethodTypes,
    this.selectedType,
    this.onSelected,
  });

  static Future<String?> show({
    required BuildContext context,
    required List<String> paymentMethodTypes,
    String? selectedType,
    Function(String type)? onSelected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SimplePaymentMethodBottomSheet(
        paymentMethodTypes: paymentMethodTypes,
        selectedType: selectedType,
        onSelected: onSelected,
      ),
    );
  }

  @override
  State<SimplePaymentMethodBottomSheet> createState() => _SimplePaymentMethodBottomSheetState();
}

class _SimplePaymentMethodBottomSheetState extends State<SimplePaymentMethodBottomSheet> {
  late String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.primary(
                  'Select Payment Method',
                  fontSize: 20,
                  fontWeight: FontWeightType.bold,
                  color: AppColors.textPrimary,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          gapH16,

          // Payment types list
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            itemCount: widget.paymentMethodTypes.length,
            separatorBuilder: (context, index) => gapH12,
            itemBuilder: (context, index) {
              final type = widget.paymentMethodTypes[index];
              final isSelected = _selectedType == type;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedType = type;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent.withValues(alpha: 0.1)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.textSecondary.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText.primary(
                          type,
                          fontSize: 16,
                          fontWeight: FontWeightType.medium,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (isSelected)
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
                  ),
                ),
              );
            },
          ),

          gapH24,

          // Confirm button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PrimaryButton(
              title: 'Confirm',
              height: 50,
              onPressed: _selectedType != null
                  ? () {
                      if (widget.onSelected != null) {
                        widget.onSelected!(_selectedType!);
                      }
                      Navigator.pop(context, _selectedType);
                    }
                  : () {},
            ),
          ),

          gapH24,
        ],
      ),
    );
  }
}
