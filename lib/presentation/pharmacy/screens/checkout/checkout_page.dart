import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/checkout/checkout_controller.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/config/app_icon.dart';
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/common/recovery_app_bar.dart';
import '../../../widgets/payment_method/dynamic_payment_fields.dart';
import '../../../widgets/payment_method/payment_method_section.dart';
import '../../../widgets/textfield/form_textfield.dart';

/// Checkout Page - Multi-step checkout process
class CheckoutPage extends BaseStatefulPage<CheckoutController> {
  const CheckoutPage({super.key});

  @override
  BaseStatefulPageState<CheckoutController> createState() =>
      _CheckoutPageState();
}

class _CheckoutPageState extends BaseStatefulPageState<CheckoutController> {
  final PageController _pageController = PageController();
  final RxInt _currentStep = 0.obs;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Checkout',
      showBackButton: true,
      onBackPressed: () {
        if (_currentStep.value > 0) {
          _goToPreviousStep();
        } else {
          widget.controller.goBack();
        }
      },
      backgroundColor: AppColors.whiteLight,
    );
  }

  @override
  bool get useStandardPadding => false;

  @override
  Widget? buildBottomBar() {
    return _buildBottomNavigationBar();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      children: [
        // Step Indicator
        _buildStepIndicator(),
        gapH16,
        // Step Content
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swipe
            onPageChanged: (index) {
              _currentStep.value = index;
            },
            children: [
              _buildDeliveryInformationStep(),
              _buildOrderReviewStep(),
              _buildPaymentMethodStep(),
            ],
          ),
        ),
      ],
    );
  }

  /// Build step indicator
  Widget _buildStepIndicator() {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          color: AppColors.white,
          child: Row(
            children: [
              _buildStepCircle(0, 'Delivery'),
              _buildStepLine(0),
              _buildStepCircle(1, 'Review'),
              _buildStepLine(1),
              _buildStepCircle(2, 'Payment'),
            ],
          ),
        ));
  }

  /// Build step circle
  Widget _buildStepCircle(int stepIndex, String label) {
    final isActive = _currentStep.value == stepIndex;
    final isCompleted = _currentStep.value > stepIndex;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted || isActive
                  ? AppColors.primary
                  : AppColors.grey90,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? AppColors.primary : AppColors.grey90,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 20,
                    )
                  : AppText.primary(
                      '${stepIndex + 1}',
                      fontSize: 16,
                      fontWeight: FontWeightType.bold,
                      color: isActive ? AppColors.white : AppColors.textSecondary,
                    ),
            ),
          ),
          gapH8,
          AppText.primary(
            label,
            fontSize: 12,
            fontWeight: isActive ? FontWeightType.semiBold : FontWeightType.regular,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  /// Build step line
  Widget _buildStepLine(int stepIndex) {
    final isCompleted = _currentStep.value > stepIndex;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        color: isCompleted ? AppColors.primary : AppColors.grey90,
      ),
    );
  }

  /// Step 1: Delivery Information
  Widget _buildDeliveryInformationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
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
              'Delivery Information',
              fontSize: 18,
              fontWeight: FontWeightType.bold,
              color: AppColors.textPrimary,
            ),
            gapH8,
            AppText.primary(
              'Please provide your delivery details',
              fontSize: 14,
              fontWeight: FontWeightType.regular,
              color: AppColors.textSecondary,
            ),
            gapH24,
            _buildFullNameField(),
            gapH16,
            _buildPhoneNumberField(),
            gapH16,
            _buildPostalCodeField(),
            gapH16,
            _buildCountryField(),
            gapH16,
            _buildCityField(),
            gapH16,
            _buildDeliveryAddressField(),
          ],
        ),
      ),
    );
  }

  /// Step 2: Order Review
  Widget _buildOrderReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemsSection(),
          gapH16,
          _buildOrderSummarySection(),
        ],
      ),
    );
  }

  /// Step 3: Payment Method
  Widget _buildPaymentMethodStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPaymentMethodSection(),
        ],
      ),
    );
  }

  /// Navigate to next step
  void _goToNextStep() {
    if (_currentStep.value < 2) {
      if (_validateCurrentStep()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // Last step - place order
      widget.controller.placeOrder();
    }
  }

  /// Navigate to previous step
  void _goToPreviousStep() {
    if (_currentStep.value > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Validate current step
  bool _validateCurrentStep() {
    switch (_currentStep.value) {
      case 0: // Delivery Information
        return widget.controller.validateDeliveryInformation();
      case 1: // Order Review
        return true; // No validation needed for review
      case 2: // Payment Method
        return widget.controller.validatePaymentMethod();
      default:
        return true;
    }
  }

  /// Build bottom navigation bar
  Widget _buildBottomNavigationBar() {
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
            child: Row(
              children: [
                // Back Button (show only when not on first step)
                if (_currentStep.value > 0) ...[
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _goToPreviousStep,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: AppText.primary(
                          'Back',
                          fontSize: 16,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  gapW12,
                ],
                // Next/Continue Button
                Expanded(
                  flex: _currentStep.value > 0 ? 1 : 1,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _goToNextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText.primary(
                            _currentStep.value == 2 ? 'Place Order' : 'Continue',
                            fontSize: 16,
                            fontWeight: FontWeightType.semiBold,
                            color: AppColors.white,
                          ),
                          if (_currentStep.value < 2) ...[
                            gapW8,
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /// Build items section
  Widget _buildItemsSection() {
    return Obx(() {
      if (widget.controller.cartItems.isEmpty) {
        return const SizedBox.shrink();
      }

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
                  'Order Items',
                  fontSize: 18,
                  fontWeight: FontWeightType.bold,
                  color: AppColors.textPrimary,
                ),
                AppText.primary(
                  '${widget.controller.cartItems.length} ${widget.controller.cartItems.length == 1 ? 'item' : 'items'}',
                  fontSize: 14,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            gapH16,
            // List of items
            ...widget.controller.cartItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  if (index > 0) gapH12,
                  _buildOrderItem(item),
                ],
              );
            }),
          ],
        ),
      );
    });
  }

  /// Build single order item
  Widget _buildOrderItem(dynamic item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.grey95,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.medicine.imageUrl != null
                  ? Image.network(
                      item.medicine.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => AppImage.dummyMedicineImg.widget(
                        width: 30,
                        height: 30,
                      ),
                    )
                  : AppImage.dummyMedicineImg.widget(
                      width: 30,
                      height: 30,
                    ),
            ),
          ),
          gapW12,
          // Medicine Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.primary(
                  item.medicine.name ?? 'Unknown Medicine',
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                gapH4,
                AppText.primary(
                  item.medicine.category ?? '',
                  fontSize: 12,
                  fontWeight: FontWeightType.regular,
                  color: AppColors.textSecondary,
                ),
                gapH8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.primary(
                      'Rs. ${item.medicine.price?.toStringAsFixed(2) ?? '0.00'}',
                      fontSize: 14,
                      fontWeight: FontWeightType.bold,
                      color: AppColors.primary,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: AppText.primary(
                        'Qty: ${item.quantity}',
                        fontSize: 12,
                        fontWeight: FontWeightType.medium,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Build payment method section using reusable widget
  Widget _buildPaymentMethodSection() {
    return Column(
      children: [
        // Payment method selector
        PaymentMethodSection(
          controller: widget.controller.paymentMethodController,
        ),

        // Dynamic payment fields based on selected payment method
        Obx(() {
          final selectedMethod = widget.controller.paymentMethodController.selectedPaymentMethod.value;

          if (selectedMethod == null) {
            return const SizedBox.shrink(); // No fields when no payment method selected
          }

          return Column(
            children: [
              gapH16,
              Container(
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
                  children: [
                    DynamicPaymentFields(
                      paymentType: selectedMethod.type,
                      // Phone number field controllers
                      phoneNumberController: widget.controller.paymentPhoneNumberController,
                      phoneNumberError: widget.controller.paymentPhoneNumberError.value,
                      onPhoneNumberChanged: widget.controller.clearPaymentPhoneNumberError,
                      // Card field controllers
                      cardNumberController: widget.controller.cardNumberController,
                      cardNumberError: widget.controller.cardNumberError.value,
                      onCardNumberChanged: widget.controller.clearCardNumberError,
                      cardHolderNameController: widget.controller.cardHolderNameController,
                      cardHolderNameError: widget.controller.cardHolderNameError.value,
                      onCardHolderNameChanged: widget.controller.clearCardHolderNameError,
                      expiryDateController: widget.controller.expiryDateController,
                      expiryDateError: widget.controller.expiryDateError.value,
                      onExpiryDateChanged: widget.controller.clearExpiryDateError,
                      cvvController: widget.controller.cvvController,
                      cvvError: widget.controller.cvvError.value,
                      onCvvChanged: widget.controller.clearCvvError,
                    ),
                    // Save payment method checkbox
                    if (selectedMethod.type.requiresPhoneNumber ||
                        selectedMethod.type.requiresCardDetails) ...[
                      gapH16,
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
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
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

  /// Build full name field
  Widget _buildFullNameField() {
    return Obx(() => FormTextField(
          titleText: 'Full Name',
          isRequired: true,
          hintText: 'Enter your full name',
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.fullNameError.value != null,
          invalidText: widget.controller.fullNameError.value ?? '',
          suffixIcon: AppIcon.userIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.fullNameController,
          onChanged: (value) {
            if (widget.controller.fullNameError.value != null) {
              widget.controller.clearFullNameError();
            }
          },
        ));
  }

  /// Build phone number field
  Widget _buildPhoneNumberField() {
    return Obx(() => FormTextField(
          titleText: 'Phone Number',
          isRequired: true,
          hintText: 'Enter your phone number',
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          textInputType: TextInputType.phone,
          isInvalid: widget.controller.phoneNumberError.value != null,
          invalidText: widget.controller.phoneNumberError.value ?? '',
          suffixIcon: AppIcon.phoneIcon.widget(
            height: 20,
            width: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.phoneNumberController,
          onChanged: (value) {
            if (widget.controller.phoneNumberError.value != null) {
              widget.controller.clearPhoneNumberError();
            }
          },
        ));
  }

  /// Build postal code field
  Widget _buildPostalCodeField() {
    return Obx(() => FormTextField(
          titleText: 'Postal Code',
          isRequired: true,
          hintText: 'Enter postal code',
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          textInputType: TextInputType.number,
          isInvalid: widget.controller.postalCodeError.value != null,
          invalidText: widget.controller.postalCodeError.value ?? '',
          suffixIcon: const Icon(
            Icons.pin_drop,
            size: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.postalCodeController,
          onChanged: (value) {
            if (widget.controller.postalCodeError.value != null) {
              widget.controller.clearPostalCodeError();
            }
          },
        ));
  }

  /// Build country field
  Widget _buildCountryField() {
    return Obx(() => FormTextField(
          titleText: 'Country',
          isRequired: true,
          hintText: 'Enter country',
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.countryError.value != null,
          invalidText: widget.controller.countryError.value ?? '',
          suffixIcon: const Icon(
            Icons.flag,
            size: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.countryController,
          onChanged: (value) {
            if (widget.controller.countryError.value != null) {
              widget.controller.clearCountryError();
            }
          },
        ));
  }

  /// Build city field
  Widget _buildCityField() {
    return Obx(() => FormTextField(
          titleText: 'City',
          isRequired: true,
          hintText: 'Enter city',
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 55,
          isInvalid: widget.controller.cityError.value != null,
          invalidText: widget.controller.cityError.value ?? '',
          suffixIcon: const Icon(
            Icons.location_city,
            size: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.cityController,
          onChanged: (value) {
            if (widget.controller.cityError.value != null) {
              widget.controller.clearCityError();
            }
          },
        ));
  }

  /// Build delivery address field
  Widget _buildDeliveryAddressField() {
    return Obx(() => FormTextField(
          titleText: 'Delivery Address',
          isRequired: true,
          hintText: 'Enter complete delivery address',
          backgroundColor: AppColors.whiteLight,
          borderRadius: 8,
          height: 65,
          maxLines: 3,
          isInvalid: widget.controller.deliveryAddressError.value != null,
          invalidText: widget.controller.deliveryAddressError.value ?? '',
          suffixIcon: const Icon(
            Icons.location_on,
            size: 20,
            color: AppColors.accent,
          ),
          controller: widget.controller.deliveryAddressController,
          onChanged: (value) {
            if (widget.controller.deliveryAddressError.value != null) {
              widget.controller.clearDeliveryAddressError();
            }
          },
        ));
  }
}
