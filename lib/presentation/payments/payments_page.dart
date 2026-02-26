import 'package:easy_localization/easy_localization.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/services/app_get_view_stateful.dart';
import 'package:recovery_consultation_app/presentation/navigation/nav_controller.dart';
import 'package:recovery_consultation_app/presentation/payments/payments_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/app_colors.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/cards/payment_session_history_card.dart';

class PaymentsPage extends GetStatefulWidget<PaymentsController> {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              gapH20,
              Expanded(
                child: Obx(() => _buildPaymentsList()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final  NavController navController = Get.find();
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {
            if (navController.currentIndex == 3)
              {navController.changeTab(0)}
            else
              Get.back()
          },
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              'Payment History',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        // Empty container to balance the layout
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildPaymentsList() {
    if (widget.controller.isLoading) {
      return _buildLoadingState();
    }

    if (widget.controller.paymentHistory.isEmpty) {
      return _buildEmptyState();
    }

    return _buildListView();
  }

  Widget _buildListView() {
    return ListView.builder(
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
                value: DateFormat('dd MMM yyyy').format(payment.sessionDate!),
                icon: AppIcon.datePickerIcon.widget(width: 12, height: 12),
                valueColor: AppColors.primary,
              ),
            ],
            rightFields: [
              InfoFieldData(
                label: "Session Duration",
                value: payment.sessionDuration,
                 icon: AppIcon.sessionClock.widget(width: 12, height: 12),
              ),
              InfoFieldData(
                label: "Amount",
                value:payment.amount.toString(),
                icon: AppIcon.navPayment.widget(width: 12, height: 12),
                highlight: true,
                valueColor: AppColors.primary,
              ),
            ],
            onTap: () => debugPrint("Card tapped"),
          );
      },
    );
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
