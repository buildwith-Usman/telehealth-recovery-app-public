import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/presentation/payment_history/payment_history_controller.dart';
import '../../app/config/app_colors.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/cards/payment_session_history_card.dart';

class PaymentHistoryPage extends BaseStatefulPage<PaymentHistoryController> {
  const PaymentHistoryPage({super.key});

  @override
  BaseStatefulPageState<PaymentHistoryController> createState() =>
      _PaymentHistoryPageState();
}

class _PaymentHistoryPageState
    extends BaseStatefulPageState<PaymentHistoryController> {
  @override
  void setupAdditionalListeners() {
    super.setupAdditionalListeners();
    if (kDebugMode) {
      print('Payment History - Additional listeners setup');
    }
  }

@override
Widget buildPageContent(BuildContext context) {
  return Obx(() {
    if (widget.controller.isLoading.value) {
      return _buildLoadingState();
    }

    if (widget.controller.paymentHistory.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ Header text before the list
          AppText.primary(
            "Total Payment",
            fontFamily: FontFamilyType.poppins,
            fontSize: 16,
            fontWeight: FontWeightType.medium,
            color: AppColors.accent,
          ),
          gapH8,
          AppText.primary(
            "50,000",
            fontFamily: FontFamilyType.inter,
            fontSize: 24,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.black,
          ),
          gapH20,
          // ✅ Scrollable list takes remaining space
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.controller.paymentHistory.length,
              itemBuilder: (context, index) {
                final payment = widget.controller.paymentHistory[index];
                return PaymentSessionHistoryCard(
                  leftFields: [
                    InfoFieldData(
                      label: "Therapist Name",
                      value: payment.therapistName,
                    ),
                    InfoFieldData(
                      label: "Session Date",
                      value: DateFormat('dd MMM, yyyy')
                          .format(payment.sessionDate!),
                      icon: AppIcon.datePickerIcon
                          .widget(width: 12, height: 12),
                      highlight: true,
                      valueColor: AppColors.primary,
                    ),
                    InfoFieldData(
                      label: "Amount",
                      value: payment.amount.toString(),
                      icon: AppIcon.navPayment
                          .widget(width: 12, height: 12, color: AppColors.accent),
                      highlight: true,
                      valueColor: AppColors.primary,
                    ),
                  ],
                  rightFields: [
                    InfoFieldData(
                      label: "Patient Name",
                      value: payment.patientName,
                    ),
                    InfoFieldData(
                      label: "Session Duration",
                      value: DateFormat('hh:mm a').format(DateTime(2025, 10, 21)),
                      icon: AppIcon.sessionClock
                          .widget(width: 12, height: 12),
                      valueColor: AppColors.primary,
                    ),
                    const InfoFieldData(label: "", value: ""),
                  ],
                  onTap: () => debugPrint("Card tapped"),
                );
              },
            ),
          ),
        ],
      ),
    );
  });
}


  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          gapH16,
          AppText.primary(
            'No payment history',
            fontFamily: FontFamilyType.poppins,
            fontSize: 18,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
          ),
          gapH8,
          AppText.primary(
            'Your payment transactions and billing history will be displayed here',
            fontFamily: FontFamilyType.poppins,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
