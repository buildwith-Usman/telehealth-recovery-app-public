import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_routes.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import 'pay_now_controller.dart';

class PayNowPage extends GetView<PayNowController> {
  const PayNowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: Obx(() => controller.paymentStatus.value == PaymentStatus.processing
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.white),
                onPressed: controller.cancelPayment,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: controller.goBackToSummary,
              )),
        title: AppText.primary(
          'Payment Processing',
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        switch (controller.paymentStatus.value) {
          case PaymentStatus.processing:
            return _buildProcessingView();
          case PaymentStatus.success:
            return _buildSuccessView();
          case PaymentStatus.failed:
            return _buildFailedView();
          case PaymentStatus.cancelled:
            return _buildCancelledView();
        }
      }),
    );
  }

  Widget _buildProcessingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          gapH20,
          _buildPaymentCard(),
          gapH24,
          _buildProgressSection(),
          gapH32,
          _buildPaymentDetails(),
          gapH24,
          _buildCancelButton(),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Payment amount
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                AppText.primary(
                  'Payment Amount',
                  fontSize: 14,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.textSecondary,
                ),
                gapH8,
                Obx(() => AppText.primary(
                  controller.getFormattedAmount(),
                  fontSize: 32,
                  fontWeight: FontWeightType.bold,
                  color: AppColors.primary,
                )),
              ],
            ),
          ),
          gapH20,
          
          // Specialist info
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightGrey,
                ),
                child: controller.specialistImageUrl.value.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          controller.specialistImageUrl.value,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 30, color: AppColors.white),
                        ),
                      )
                    : const Icon(Icons.person, size: 30, color: AppColors.white),
              ),
              gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => AppText.primary(
                      controller.specialistName.value,
                      fontSize: 16,
                      fontWeight: FontWeightType.semiBold,
                      color: AppColors.textPrimary,
                    )),
                    gapH4,
                    Obx(() => AppText.primary(
                      controller.specialistProfession.value,
                      fontSize: 14,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
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

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress indicator
          Obx(() => LinearProgressIndicator(
            value: controller.getProgressPercentage(),
            backgroundColor: AppColors.lightGrey.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          )),
          gapH16,
          
          // Current step
          Obx(() => AppText.primary(
            controller.getCurrentStepText(),
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          )),
          gapH12,
          
          // Loading animation
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
          gapH16,
          
          // Step counter
          Obx(() => AppText.primary(
            'Step ${controller.currentStep.value + 1} of ${controller.paymentSteps.length}',
            fontSize: 12,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          )),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.primary(
            'Consultation Details',
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
          ),
          gapH16,
          _buildDetailRow('Date', controller.consultationDate.value),
          gapH8,
          _buildDetailRow('Time', controller.consultationTime.value),
          gapH8,
          _buildDetailRow('Type', controller.consultationType.value),
          gapH8,
          _buildDetailRow('Payment Method', controller.paymentMethod.value),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.primary(
          label,
          fontSize: 14,
          fontWeight: FontWeightType.regular,
          color: AppColors.textSecondary,
        ),
        AppText.primary(
          value,
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: controller.cancelPayment,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.lightGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: AppText.primary(
          'Cancel Payment',
          fontSize: 16,
          fontWeight: FontWeightType.medium,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          gapH40,
          // Success icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              size: 60,
              color: Colors.green,
            ),
          ),
          gapH24,
          
          // Success message
          AppText.primary(
            'Payment Successful!',
            fontSize: 24,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH12,
          AppText.primary(
            'Your consultation has been booked successfully',
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH32,
          
          // Transaction details
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                AppText.primary(
                  'Transaction ID',
                  fontSize: 14,
                  fontWeight: FontWeightType.medium,
                  color: AppColors.textSecondary,
                ),
                gapH8,
                Obx(() => AppText.primary(
                  controller.transactionId.value,
                  fontSize: 16,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.primary,
                )),
                gapH20,
                _buildDetailRow('Amount Paid', controller.getFormattedAmount()),
                gapH8,
                _buildDetailRow('Specialist', controller.specialistName.value),
                gapH8,
                _buildDetailRow('Date & Time', '${controller.consultationDate.value} at ${controller.consultationTime.value}'),
              ],
            ),
          ),
          gapH32,
          
          // Action button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: 'Continue to Dashboard',
              onPressed: () => Get.offAllNamed(AppRoutes.navScreen),
              color: AppColors.primary,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          gapH40,
          // Failed icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error,
              size: 60,
              color: Colors.red,
            ),
          ),
          gapH24,
          
          // Failed message
          AppText.primary(
            'Payment Failed',
            fontSize: 24,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH12,
          AppText.primary(
            'We couldn\'t process your payment. Please try again or use a different payment method.',
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH32,
          
          // Action buttons
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: 'Try Again',
              onPressed: controller.retryPayment,
              color: AppColors.primary,
              height: 48,
            ),
          ),
          gapH16,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.goBackToSummary,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.lightGrey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: AppText.primary(
                'Change Payment Method',
                fontSize: 16,
                fontWeight: FontWeightType.medium,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          gapH40,
          // Cancelled icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cancel,
              size: 60,
              color: AppColors.textSecondary,
            ),
          ),
          gapH24,
          
          // Cancelled message
          AppText.primary(
            'Payment Cancelled',
            fontSize: 24,
            fontWeight: FontWeightType.bold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH12,
          AppText.primary(
            'Your payment has been cancelled. You can try again when you\'re ready.',
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH32,
          
          // Action button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: 'Back to Summary',
              onPressed: controller.goBackToSummary,
              color: AppColors.primary,
              height: 48,
            ),
          ),
        ],
      ),
    );
  }
}
