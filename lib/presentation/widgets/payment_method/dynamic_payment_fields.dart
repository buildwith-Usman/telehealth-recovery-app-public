import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/domain/enums/payment_method_type.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/textfield/form_textfield.dart';

/// Dynamic Payment Fields Widget
/// Renders appropriate input fields based on payment method type
/// Follows Single Responsibility Principle - each payment type has its own field set
class DynamicPaymentFields extends StatelessWidget {
  final PaymentMethodType paymentType;
  final TextEditingController? phoneNumberController;
  final TextEditingController? cardNumberController;
  final TextEditingController? cardHolderNameController;
  final TextEditingController? expiryDateController;
  final TextEditingController? cvvController;
  final String? phoneNumberError;
  final String? cardNumberError;
  final String? cardHolderNameError;
  final String? expiryDateError;
  final String? cvvError;
  final Function()? onPhoneNumberChanged;
  final Function()? onCardNumberChanged;
  final Function()? onCardHolderNameChanged;
  final Function()? onExpiryDateChanged;
  final Function()? onCvvChanged;

  const DynamicPaymentFields({
    super.key,
    required this.paymentType,
    this.phoneNumberController,
    this.cardNumberController,
    this.cardHolderNameController,
    this.expiryDateController,
    this.cvvController,
    this.phoneNumberError,
    this.cardNumberError,
    this.cardHolderNameError,
    this.expiryDateError,
    this.cvvError,
    this.onPhoneNumberChanged,
    this.onCardNumberChanged,
    this.onCardHolderNameChanged,
    this.onExpiryDateChanged,
    this.onCvvChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Payment type header
        _buildPaymentTypeHeader(),
        gapH16,

        // Dynamic fields based on payment type
        if (paymentType.requiresPhoneNumber) ..._buildPhoneNumberFields(),
        if (paymentType.requiresCardDetails) ..._buildCardFields(),
        if (paymentType.requiresNoDetails) ..._buildNoDetailsRequired(),
      ],
    );
  }

  /// Build payment type header with icon
  Widget _buildPaymentTypeHeader() {
    return Row(
      children: [
        _buildPaymentIcon(),
        gapW12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(
                paymentType.displayName,
                fontSize: 18,
                fontWeight: FontWeightType.bold,
                color: AppColors.textPrimary,
              ),
              gapH4,
              AppText.primary(
                _getPaymentTypeDescription(),
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build payment icon based on type
  Widget _buildPaymentIcon() {
    Widget icon;

    switch (paymentType) {
      case PaymentMethodType.jazzCash:
        icon = AppIcon.jazzCashIcon.widget(height: 48, width: 48);
        break;
      case PaymentMethodType.easyPaisa:
        icon = AppIcon.easyPaisaIcon.widget(height: 48, width: 48);
        break;
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        icon = AppIcon.cardPaymentIcon.widget(height: 48, width: 48);
        break;
      case PaymentMethodType.cashOnDelivery:
        icon = AppIcon.defaultPaymentIcon(size: 48, color: AppColors.accent);
        break;
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: icon),
    );
  }

  /// Get description text for payment type
  String _getPaymentTypeDescription() {
    if (paymentType.requiresPhoneNumber) {
      return 'Enter your ${paymentType.displayName} mobile account number';
    } else if (paymentType.requiresCardDetails) {
      return 'Enter your card details';
    } else if (paymentType.requiresNoDetails) {
      return 'Pay when your order is delivered';
    }
    return 'Enter payment details';
  }

  /// Build phone number fields (for JazzCash, Easypaisa)
  List<Widget> _buildPhoneNumberFields() {
    return [
      FormTextField(
        titleText: 'Phone Number',
        isRequired: true,
        hintText: 'Enter your phone number',
        backgroundColor: AppColors.whiteLight,
        borderRadius: 8,
        height: 55,
        textInputType: TextInputType.phone,
        isInvalid: phoneNumberError != null,
        invalidText: phoneNumberError ?? '',
        suffixIcon: AppIcon.phoneIcon.widget(
          height: 20,
          width: 20,
          color: AppColors.accent,
        ),
        controller: phoneNumberController,
        onChanged: (value) {
          if (onPhoneNumberChanged != null) {
            onPhoneNumberChanged!();
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
      ),
      gapH16,
      // Info message
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.accent,
              size: 20,
            ),
            gapW8,
            Expanded(
              child: AppText.primary(
                'Make sure this phone number is linked to your ${paymentType.displayName} account',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  /// Build card fields (for Credit/Debit Card)
  List<Widget> _buildCardFields() {
    return [
      // Card Number
      FormTextField(
        titleText: 'Card Number',
        isRequired: true,
        hintText: '1234 5678 9012 3456',
        backgroundColor: AppColors.whiteLight,
        borderRadius: 8,
        height: 55,
        textInputType: TextInputType.number,
        isInvalid: cardNumberError != null,
        invalidText: cardNumberError ?? '',
        suffixIcon: AppIcon.cardPaymentIcon.widget(
          height: 20,
          width: 20,
          color: AppColors.accent,
        ),
        controller: cardNumberController,
        onChanged: (value) {
          if (onCardNumberChanged != null) {
            onCardNumberChanged!();
          }
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(16),
          _CardNumberInputFormatter(),
        ],
      ),
      gapH16,

      // Card Holder Name
      FormTextField(
        titleText: 'Card Holder Name',
        isRequired: true,
        hintText: 'Enter name on card',
        backgroundColor: AppColors.whiteLight,
        borderRadius: 8,
        height: 55,
        textInputType: TextInputType.name,
        isInvalid: cardHolderNameError != null,
        invalidText: cardHolderNameError ?? '',
        suffixIcon: AppIcon.userIcon.widget(
          height: 20,
          width: 20,
          color: AppColors.accent,
        ),
        controller: cardHolderNameController,
        onChanged: (value) {
          if (onCardHolderNameChanged != null) {
            onCardHolderNameChanged!();
          }
        },
      ),
      gapH16,

      // Expiry Date and CVV Row
      Row(
        children: [
          // Expiry Date
          Expanded(
            child: FormTextField(
              titleText: 'Expiry Date',
              isRequired: true,
              hintText: 'MM/YY',
              backgroundColor: AppColors.whiteLight,
              borderRadius: 8,
              height: 55,
              textInputType: TextInputType.number,
              isInvalid: expiryDateError != null,
              invalidText: expiryDateError ?? '',
              controller: expiryDateController,
              onChanged: (value) {
                if (onExpiryDateChanged != null) {
                  onExpiryDateChanged!();
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
                _ExpiryDateInputFormatter(),
              ],
            ),
          ),
          gapW12,

          // CVV
          Expanded(
            child: FormTextField(
              titleText: 'CVV',
              isRequired: true,
              hintText: '123',
              backgroundColor: AppColors.whiteLight,
              borderRadius: 8,
              height: 55,
              textInputType: TextInputType.number,
              isInvalid: cvvError != null,
              invalidText: cvvError ?? '',
              controller: cvvController,
              onChanged: (value) {
                if (onCvvChanged != null) {
                  onCvvChanged!();
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ),
        ],
      ),
      gapH16,

      // Security info
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline,
              color: AppColors.accent,
              size: 20,
            ),
            gapW8,
            Expanded(
              child: AppText.primary(
                'Your card information is encrypted and secure',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  /// Build no details required message (for Cash on Delivery)
  List<Widget> _buildNoDetailsRequired() {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppColors.accent,
              size: 48,
            ),
            gapH12,
            AppText.primary(
              'No Additional Details Required',
              fontSize: 16,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            gapH8,
            AppText.primary(
              'You can pay in cash when your order arrives at your doorstep',
              fontSize: 14,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ];
  }
}

/// Card Number Input Formatter
/// Formats card number as: 1234 5678 9012 3456
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      final nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Expiry Date Input Formatter
/// Formats expiry date as: MM/YY
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');

    if (text.isEmpty) {
      return newValue;
    }

    final buffer = StringBuffer();

    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
