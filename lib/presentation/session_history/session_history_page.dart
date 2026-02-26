import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/presentation/session_history/session_history_controller.dart';
import '../../app/config/app_colors.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/cards/payment_session_history_card.dart';

class SessionHistoryPage extends BaseStatefulPage<SessionHistoryController> {
  const SessionHistoryPage({super.key});

  @override
  BaseStatefulPageState<SessionHistoryController> createState() =>
      _SessionHistoryPageState();
}

class _SessionHistoryPageState
    extends BaseStatefulPageState<SessionHistoryController> {
  @override
  void setupAdditionalListeners() {
    super.setupAdditionalListeners();
    if (kDebugMode) {
      print('Session History - Additional listeners setup');
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

      return ListView.builder(
        // padding: const EdgeInsets.all(16),
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
                label: "Session Duration",
                value: DateFormat('dd MMM yyyy').format(DateTime(2025, 10, 21)),
                icon: AppIcon.sessionClock.widget(width: 12, height: 12),
                valueColor: AppColors.primary,
              ),
            ],
            rightFields: [
              InfoFieldData(
                label: "Patient Name",
                value: payment.patientName,
              ),
              InfoFieldData(
                label: "Session Date",
                value:DateFormat('dd MMM, yyyy').format(payment.sessionDate!),
                icon: AppIcon.datePickerIcon.widget(width: 12, height: 12),
                highlight: true,
                valueColor: AppColors.primary,
              ),
            ],
            onTap: () => debugPrint("Card tapped"),
          );
        },
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
