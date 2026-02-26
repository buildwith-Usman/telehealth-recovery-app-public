import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/prescription_image.dart';
import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/cards/session_detail_card.dart';
import 'session_details_controller.dart';

class SessionDetailsPage extends BaseStatefulPage<SessionDetailsController> {
  const SessionDetailsPage({super.key});

  @override
  BaseStatefulPageState<SessionDetailsController> createState() =>
      _SessionDetailsPageState();
}

class _SessionDetailsPageState
    extends BaseStatefulPageState<SessionDetailsController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildHeader(),
                ),
                gapH20,
                Obx(() => _buildContent()),
                Obx(() => _buildAdditionalSections()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {
            if (Navigator.canPop(context))
              {Navigator.pop(context)}
            else
              {
                // Optional: handle case when there's no previous page
                debugPrint("No previous route to pop")
              }
          },
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              'Session Detail',
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

  Widget _buildContent() {
    if (widget.controller.isLoading.value) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final session = widget.controller.sessions;

    if (session == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text('No session data available'),
        ),
      );
    }

    return Column(
      children: [
        SessionDetailCard(
          session: session,
          onTap: () {
            // Handle card tap if needed
          },
        ),
      ],
    );
  }

  Widget _buildAdditionalSections() {
    final appointment = widget.controller.appointmentDetail;

    // Only show additional sections for completed appointments
    if (appointment == null || !appointment.isCompleted) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Show prescription only if available
        if (appointment.prescriptionUrl != null &&
            appointment.prescriptionUrl!.isNotEmpty) ...[
          gapH20,
          _buildPrescriptionSection(appointment.prescriptionUrl!),
        ],

        // Show reviews section - this would come from a separate API call
        // For now, we'll hide it until we have review data from the API
        // If you have review data in the appointment, uncomment and adjust:
        // if (appointment.hasReview) ...[
        //   gapH20,
        //   _buildReviewSection(),
        // ],

        gapH20,
      ],
    );
  }

  Widget _buildPrescriptionSection(String prescriptionUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.primary(
              'Prescription',
              color: AppColors.black,
              fontWeight: FontWeightType.medium,
              fontSize: 14,
            ),
            gapH10,
            PrescriptionImage(
              imageUrl: prescriptionUrl,
              onTap: () {
                // Optionally show full-screen image
              },
            ),
          ],
        ),
      ),
    );
  }
}
