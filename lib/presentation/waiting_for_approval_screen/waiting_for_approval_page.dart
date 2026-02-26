import 'package:recovery_consultation_app/app/services/app_get_view_stateful.dart';
import 'package:recovery_consultation_app/presentation/waiting_for_approval_screen/waiting_for_approval_controller.dart';
import 'package:flutter/material.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_image.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';

class WaitingForApprovalPage extends GetStatefulWidget<WaitingForApprovalController> {
  const WaitingForApprovalPage({super.key});

  @override
  State<WaitingForApprovalPage> createState() => _WaitingForApprovalPageState();
}

class _WaitingForApprovalPageState extends State<WaitingForApprovalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: _buildWaitingForApprovalContent(),
      ),
    );
  }

  /// Main content area with approval icon, heading, and message
  Widget _buildWaitingForApprovalContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Approval Icon
                  _buildApprovalIcon(),
                  gapH32,

                  // Approval Heading
                  _buildApprovalHeading(),
                  gapH16,

                  // Approval Message
                  _buildApprovalMessage(),
                  gapH24,

                  // Status Information
                  _buildStatusInfo(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Approval icon widget using the recovery approval image
  Widget _buildApprovalIcon() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.primary.withOpacity(0.1),
      ),
      child: Center(
        child: AppImage.recoveryForApproval.widget(
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  /// Main approval heading text
  Widget _buildApprovalHeading() {
    return AppText.primary(
      'Waiting for Approval',
      fontFamily: FontFamilyType.poppins,
      fontSize: 24,
      fontWeight: FontWeightType.semiBold,
      color: AppColors.black,
      textAlign: TextAlign.center,
    );
  }

  /// Approval message text
  Widget _buildApprovalMessage() {
    return AppText.primary(
      'Your specialist registration is currently under review. We will notify you once your application has been approved.',
      fontFamily: FontFamilyType.inter,
      fontSize: 16,
      fontWeight: FontWeightType.regular,
      color: AppColors.textSecondary,
      textAlign: TextAlign.center,
    );
  }

  /// Status information widget
  Widget _buildStatusInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 20,
              ),
              gapW8,
              Expanded(
                child: AppText.primary(
                  'Application Status',
                  fontFamily: FontFamilyType.inter,
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          gapH8,
          AppText.primary(
            'Your application is currently being reviewed by our medical team. This process typically takes 2-3 business days. You will receive an email notification once the review is complete.',
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

}
