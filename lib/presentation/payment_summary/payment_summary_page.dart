import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/app/utils/string_extension.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/common/recovery_app_bar.dart';
import '../widgets/textfield/form_textfield.dart';
import 'payment_summary_controller.dart';

class PaymentSummaryPage extends BaseStatefulPage<PaymentSummaryController> {
  const PaymentSummaryPage({super.key});

  @override
  BaseStatefulPageState<PaymentSummaryController> createState() =>
      _PaymentSummaryPageState();
}

class _PaymentSummaryPageState
    extends BaseStatefulPageState<PaymentSummaryController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Payment Summary',
      showBackButton: true,
      onBackPressed: () => _handleBackPressed(),
    );
  }

  void _handleBackPressed() {
    if (widget.controller.isProcessingPayment.value) {
      // Show warning if processing
      Get.snackbar(
        'Processing Payment',
        'Please wait while we process your payment',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      widget.controller.goBack();
    }
  }

  @override
  Widget? buildBottomBar() {
    return _buildBottomActionBar();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return PopScope(
      canPop: false, // Disable system back button
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Only allow back navigation if not processing payment
        if (!widget.controller.isProcessingPayment.value) {
          widget.controller.goBack();
        } else {
          // Show warning if user tries to go back during processing
          Get.snackbar(
            'Processing Payment',
            'Please wait while we process your payment',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Obx(() {
        final isProcessing = widget.controller.isProcessingPayment.value;

        return AbsorbPointer(
          absorbing: isProcessing, // Block all touches during processing
          child: Opacity(
            opacity: isProcessing ? 0.6 : 1.0, // Visual feedback
            child: _buildPageBody(),
          ),
        );
      }),
    );
  }

  Widget _buildPageBody() {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return _buildLoadingState();
      }

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: widget.controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildConsultationDetails(),
              gapH24,
              _buildPaymentBreakdown(),
              gapH24,
              _buildCouponSection(),
              gapH24,
              _buildPaymentMethods(),
              gapH24,
              // Payment Form Section
              Obx(() => widget.controller.selectedPaymentMethod.value ==
                      'Card Payment'
                  ? _buildCardPaymentForm()
                  : _buildDigitalWalletForm()),
              gapH24,
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          gapH20,
          AppText.primary(
            'Loading payment details...',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
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
        child: Obx(() => PrimaryButton(
              title: widget.controller.isProcessingPayment.value
                  ? 'Processing...'
                  : 'Pay Now',
              height: 55,
              radius: 8,
              color: AppColors.primary,
              textColor: AppColors.white,
              fontWeight: FontWeightType.semiBold,
              showIcon: !widget.controller.isProcessingPayment.value,
              iconWidget: widget.controller.isProcessingPayment.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : AppIcon.rightArrowIcon.widget(
                      width: 10,
                      height: 10,
                      color: AppColors.white,
                    ),
              onPressed: () {
                if (!widget.controller.isProcessingPayment.value) {
                  widget.controller.processPaymentWithForm();
                }
              },
            )),
      ),
    );
  }

  Widget _buildConsultationDetails() {
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
          Row(
            children: [
              AppText.primary(
                'Consultation Details',
                fontSize: 16,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.textPrimary,
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.controller.editBookingDetails,
                child: AppText.primary(
                  'Edit',
                  fontSize: 14,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          gapH16,
          Row(
            children: [
              // Specialist Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.grey80.withValues(alpha: 0.3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.controller.specialistImageUrl.value.isNotEmpty
                      ? Image.network(
                          widget.controller.specialistImageUrl.value,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: AppColors.lightGrey,
                              child: const Icon(Icons.person,
                                  color: AppColors.white),
                            );
                          },
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: AppColors.lightGrey,
                          child:
                              const Icon(Icons.person, color: AppColors.white),
                        ),
                ),
              ),
              gapW16,
              // Specialist Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => AppText.primary(
                          widget.controller.specialistName.value,
                          fontSize: 16,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.textPrimary,
                        )),
                    gapH4,
                    Obx(() => AppText.primary(
                          widget.controller.specialistProfession.value
                              .capitalizeFirstLetter(),
                          fontSize: 14,
                          fontWeight: FontWeightType.medium,
                          color: AppColors.textSecondary,
                        )),
                  ],
                ),
              ),
            ],
          ),
          gapH16,
          // Consultation Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Session Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon.datePickerIcon.widget(
                          height: 14,
                          width: 14,
                        ),
                        gapW8,
                        Flexible(
                          child: AppText.primary(
                            'Session Date',
                            fontSize: 14,
                            fontWeight: FontWeightType.medium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    gapH8,
                    Obx(() => AppText.primary(
                          widget.controller.consultationDate.value,
                          fontSize: 16,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.textPrimary,
                        )),
                  ],
                ),
              ),
              gapW20,
              // Session Duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppIcon.durationIcon.widget(
                          height: 14,
                          width: 14,
                        ),
                        gapW8,
                        Flexible(
                          child: AppText.primary(
                            'Session Duration',
                            fontSize: 14,
                            fontWeight: FontWeightType.medium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    gapH8,
                    Obx(() => AppText.primary(
                          widget.controller.consultationTime.value,
                          fontSize: 16,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.textPrimary,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBreakdown() {
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
          Row(
            children: [
              AppIcon.navPayment
                  .widget(height: 20, width: 20, color: AppColors.accent),
              gapW8,
              AppText.primary(
                'Payment',
                fontSize: 18,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.black,
              ),
            ],
          ),
          gapH20,
          // Payment Details Grid
          Column(
            children: [
              Obx(() => _buildTotalAmountRow(
                    'Consultation Fee',
                    'PKR ${widget.controller.consultationFee.value.toStringAsFixed(2)}',
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmountRow(String label, String amount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.payments,
              size: 16,
              color: AppColors.white,
            ),
          ),
          gapW12,
          Expanded(
            child: AppText.primary(
              label,
              fontSize: 16,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
          AppText.primary(
            amount,
            fontSize: 18,
            fontWeight: FontWeightType.bold,
            color: AppColors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection() {
    return Obx(() => Container(
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.local_offer,
                      size: 18,
                      color: AppColors.accent,
                    ),
                  ),
                  gapW10,
                  AppText.primary(
                    'Have a Coupon?',
                    fontSize: 16,
                    fontWeight: FontWeightType.semiBold,
                    color: AppColors.black,
                  ),
                ],
              ),
              // Show input field if no coupon applied
              if (!widget.controller.isCouponApplied.value) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FormTextField(
                            controller: widget.controller.couponController,
                            hintText: 'Enter coupon code',
                            backgroundColor: AppColors.whiteLight,
                            borderRadius: 8,
                            height: 40,
                            isInvalid:
                                widget.controller.couponError.value.isNotEmpty,
                            invalidText: widget.controller.couponError.value,
                            onChanged: (value) {
                              widget.controller.clearCouponError();
                            },
                            suffixIcon: const Icon(
                              Icons.discount,
                              color: AppColors.grey60,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    gapW12,
                    PrimaryButton(
                        width: 80,
                        height: 40,
                        title: 'Apply',
                        onPressed: widget.controller.applyCoupon),
                  ],
                ),
              ] else ...[
                // Applied coupon display
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green.shade300,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      gapW12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.primary(
                              widget.controller.appliedCouponCode.value,
                              fontSize: 14,
                              fontWeight: FontWeightType.bold,
                              color: Colors.green.shade800,
                            ),
                            gapH4,
                            AppText.primary(
                              'You saved ${widget.controller.discountPercentage.value.toInt()}% (PKR ${widget.controller.discountAmount.value.toStringAsFixed(2)})',
                              fontSize: 12,
                              fontWeight: FontWeightType.medium,
                              color: Colors.green.shade700,
                            ),
                          ],
                        ),
                      ),
                      gapW12,
                      GestureDetector(
                        onTap: widget.controller.removeCoupon,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.red.shade700,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ));
  }

  Widget _buildPaymentMethods() {
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
          AppText.primary(
            'Payment Method',
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.black,
          ),
          gapH16,
          Obx(() => GestureDetector(
                onTap: () => _showPaymentMethodBottomSheet(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.whiteLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.lightGrey,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // AppIcon.jazzCashIcon.widget(),
                      widget.controller.savedPaymentMethods.isNotEmpty
                          ? _getPaymentMethodIcon(
                              widget.controller.savedPaymentMethods[widget
                                  .controller
                                  .selectedPaymentMethodIndex
                                  .value]['type'])
                          : AppIcon.defaultPaymentIcon(),
                      gapW12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.primary(
                              widget.controller
                                  .getCurrentPaymentMethodDisplay(),
                              fontSize: 14,
                              fontWeight: FontWeightType.medium,
                              color: AppColors.black,
                            ),
                            if (widget
                                .controller.savedPaymentMethods.isNotEmpty) ...[
                              gapH4,
                              AppText.primary(
                                widget.controller.getPaymentMethodSubtitle(
                                    widget.controller.savedPaymentMethods[widget
                                        .controller
                                        .selectedPaymentMethodIndex
                                        .value]),
                                fontSize: 12,
                                fontWeight: FontWeightType.regular,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ],
                        ),
                      ),
                      AppIcon.forwardIcon.widget(width: 14, height: 14),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _getPaymentMethodIcon(String method, {Color? color}) {
    switch (method) {
      case 'Jazz Cash':
        return AppIcon.jazzCashIcon.widget(
            width: 28, height: 28); // Using phone icon for mobile wallet
      case 'Easy Paisa':
        return AppIcon.easyPaisaIcon
            .widget(width: 28, height: 28); // Using wallet icon
      case 'Card Payment':
        return AppIcon.cardPaymentIcon
            .widget(width: 28, height: 28); // Using card icon
      default:
        return AppIcon.defaultPaymentIcon();
    }
  }

  void _showPaymentMethodBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            gapH16,
            // Title
            Row(
              children: [
                AppText.primary(
                  'Choose Payment Method',
                  fontSize: 18,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
            gapH20,
            // Payment methods list
            Obx(() => Column(
                  children: widget.controller.savedPaymentMethods
                      .asMap()
                      .entries
                      .map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> method = entry.value;
                    return _buildBottomSheetPaymentMethodItem(method, index);
                  }).toList(),
                )),

            // If no payment methods, show message
            Obx(() {
              if (widget.controller.savedPaymentMethods.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.payment,
                        size: 48,
                        color: AppColors.lightGrey,
                      ),
                      gapH12,
                      AppText.primary(
                        'No Payment Methods',
                        fontSize: 16,
                        fontWeight: FontWeightType.medium,
                        color: AppColors.textSecondary,
                      ),
                      gapH8,
                      AppText.primary(
                        'Add a payment method to continue',
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            gapH20,
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildBottomSheetPaymentMethodItem(
      Map<String, dynamic> method, int index) {
    return Obx(() {
      bool isSelected =
          widget.controller.selectedPaymentMethodIndex.value == index;

      return GestureDetector(
        onTap: () {
          widget.controller.selectSavedPaymentMethod(index);
          Get.back(); // Close bottom sheet
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.whiteLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.lightGrey,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              _getPaymentMethodIcon(method['type'],
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText.primary(
                          widget.controller.getPaymentMethodTitle(method),
                          fontSize: 14,
                          fontWeight: FontWeightType.medium,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                        if (method['isDefault'] == true) ...[
                          gapW8,
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AppText.primary(
                              'Default',
                              fontSize: 10,
                              fontWeight: FontWeightType.medium,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.accent,
                      size: 20,
                    )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // ==================== PAYMENT FORM METHODS ====================
  Widget _buildCardPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          AppText.primary(
            'Card Information',
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          gapH20,

          // Card Number Field
          FormTextField(
            titleText: 'Card Number',
            hintText: '1234 5678 9012 3456',
            controller: widget.controller.cardNumberController,
            textInputType: TextInputType.number,
            backgroundColor: AppColors.whiteLight,
            borderRadius: 8,
            height: 55,
            isRequired: true,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(19),
            ],
          ),
          gapH16,

          Row(
            children: [
              // Expiry Date
              Expanded(
                child: FormTextField(
                  titleText: 'Expiry Date',
                  hintText: 'MM/YY',
                  controller: widget.controller.expiryDateController,
                  textInputType: TextInputType.number,
                  backgroundColor: AppColors.whiteLight,
                  borderRadius: 8,
                  height: 55,
                  isRequired: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    _ExpiryDateInputFormatter(),
                  ],
                ),
              ),
              gapW16,
              // CVV
              Expanded(
                child: FormTextField(
                  titleText: 'CVV',
                  hintText: '123',
                  controller: widget.controller.cvvController,
                  textInputType: TextInputType.number,
                  backgroundColor: AppColors.whiteLight,
                  borderRadius: 8,
                  height: 55,
                  isRequired: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                ),
              ),
            ],
          ),
          gapH16,

          // Cardholder Name
          FormTextField(
            titleText: 'Cardholder Name',
            hintText: 'Enter Card Holder Name',
            controller: widget.controller.cardHolderNameController,
            textInputType: TextInputType.name,
            backgroundColor: AppColors.whiteLight,
            borderRadius: 8,
            isRequired: true,
            height: 55,
          ),
          gapH20,

          // Save Payment Method Checkbox
          Obx(() => GestureDetector(
                onTap: () {
                  widget.controller.savePaymentMethod.value =
                      !widget.controller.savePaymentMethod.value;
                },
                child: Row(
                  children: [
                    Icon(
                      widget.controller.savePaymentMethod.value
                          ? Icons.check_circle
                          : Icons.circle,
                      color: widget.controller.savePaymentMethod.value
                          ? AppColors.accent
                          : AppColors.whiteLight,
                      size: 24,
                    ),
                    gapW8,
                    Expanded(
                      child: AppText.primary(
                        'Save this payment method for future payments',
                        fontSize: 14,
                        fontWeight: FontWeightType.medium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDigitalWalletForm() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          AppText.primary(
            'Mobile Wallet Information',
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          gapH20,

          // Phone Field for Jazz Cash / Easy Paisa
          FormTextField(
            titleText: 'Mobile Number',
            hintText: '03XX XXXXXXX',
            controller: widget.controller.phoneController,
            textInputType: TextInputType.phone,
            backgroundColor: AppColors.whiteLight,
            borderRadius: 8,
            height: 55,
            isRequired: true,
          ),
          gapH16,

          // Account Name Field
          FormTextField(
            titleText: 'Account Holder Name',
            hintText: 'Enter your full name',
            controller: widget.controller
                .emailController, // Reusing email controller for account name
            textInputType: TextInputType.name,
            backgroundColor: AppColors.whiteLight,
            borderRadius: 8,
            height: 55,
            isRequired: true,
          ),
          gapH20,

          // Save Payment Method Checkbox
          Obx(() => GestureDetector(
                onTap: () {
                  widget.controller.savePaymentMethod.value =
                      !widget.controller.savePaymentMethod.value;
                },
                child: Row(
                  children: [
                    Icon(
                      widget.controller.savePaymentMethod.value
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: widget.controller.savePaymentMethod.value
                          ? AppColors.accent
                          : AppColors.lightGrey,
                      size: 20,
                    ),
                    gapW8,
                    Expanded(
                      child: AppText.primary(
                        'Save this payment method for future payments',
                        fontSize: 14,
                        fontWeight: FontWeightType.medium,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// Custom input formatter for expiry date
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (text.length == 2 && oldValue.text.length == 1) {
      text = '$text/';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
