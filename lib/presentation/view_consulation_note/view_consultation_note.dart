import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/view_consulation_note/view_consultation_note_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/session_notes_with_prescription_card.dart';
import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';

class ViewConsultationNote extends BaseStatefulPage<ViewConsultationNoteController> {
  const ViewConsultationNote({super.key});

  @override
  BaseStatefulPageState<ViewConsultationNoteController> createState() =>
      _ViewConsultationNotePageState();
}

class _ViewConsultationNotePageState
    extends BaseStatefulPageState<ViewConsultationNoteController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Obx(() {
          if (widget.controller.isLoading.value) {
            return _buildLoadingState();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  gapH16,
                  if (widget.controller.shouldShowPatientHistory)
                    _buildPatientHistoryView()
                  else if (widget.controller.shouldShowCurrentNotes)
                    _buildCurrentNotesView()
                  else
                    _buildEmptyState(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {Get.back()},
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              widget.controller.getPageTitle(),
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

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            gapH16,
            AppText.primary(
              'No notes available',
              fontFamily: FontFamilyType.poppins,
              fontSize: 18,
              fontWeight: FontWeightType.medium,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  /// Build patient history view (for upcoming appointments)
  Widget _buildPatientHistoryView() {
    if (widget.controller.patientHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              gapH16,
              AppText.primary(
                'No previous sessions',
                fontFamily: FontFamilyType.poppins,
                fontSize: 18,
                fontWeight: FontWeightType.medium,
                color: AppColors.textSecondary,
              ),
              gapH8,
              AppText.primary(
                'This patient has no completed sessions yet',
                fontFamily: FontFamilyType.poppins,
                fontSize: 14,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: widget.controller.patientHistory.map((appointment) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor info with image
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grey80.withOpacity(0.3),
                      image: appointment.doctorProfileImageUrl != null &&
                              appointment.doctorProfileImageUrl!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(
                                  appointment.doctorProfileImageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: appointment.doctorProfileImageUrl == null ||
                            appointment.doctorProfileImageUrl!.isEmpty
                        ? AppIcon.userIcon.widget(
                            width: 24,
                            height: 24,
                            color: AppColors.textSecondary,
                          )
                        : null,
                  ),
                  gapW12,

                  // Doctor details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.primary(
                          appointment.doctorName ?? 'Unknown Doctor',
                          fontFamily: FontFamilyType.poppins,
                          fontSize: 16,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.black,
                        ),
                        gapH4,
                        if (appointment.doctor?.doctorInfo?.specialization !=
                            null)
                          AppText.primary(
                            appointment.doctor!.doctorInfo!.specialization!,
                            fontFamily: FontFamilyType.inter,
                            fontSize: 12,
                            fontWeight: FontWeightType.regular,
                            color: AppColors.black.withValues(alpha: 0.6),
                          ),
                        // Date and time with clock icon
                        Row(
                          children: [
                            AppIcon.durationIcon.widget(
                              width: 12,
                              height: 12,
                              color: AppColors.accent,
                            ),
                            gapW4,
                            Expanded(
                              child: AppText.primary(
                                widget.controller.formatAppointmentDateTime(appointment),
                                fontFamily: FontFamilyType.inter,
                                fontSize: 12,
                                fontWeight: FontWeightType.regular,
                                color: AppColors.black.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gapH16,

              // Session notes with prescription card
              _buildSessionNotesWithPrescriptionImage(
                notes: widget.controller.getCurrentNotes(),
                imageUrl: appointment.prescriptionUrl,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Build current notes view (for completed appointments)
  Widget _buildCurrentNotesView() {
    final appointment = widget.controller.currentAppointment;

    if (appointment == null) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient name
          AppText.primary(
            appointment.patientName ?? 'Unknown Patient',
            fontFamily: FontFamilyType.poppins,
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.black,
          ),
          gapH4,
          // Date and time with clock icon
          Row(
            children: [
              AppIcon.durationIcon.widget(
                width: 12,
                height: 12,
                color: AppColors.accent,
              ),
              gapW4,
              AppText.primary(
                widget.controller.formatAppointmentDateTime(appointment),
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.black.withValues(alpha: 0.7),
              ),
            ],
          ),
          gapH16,
          // Session notes with prescription card
          _buildSessionNotesWithPrescriptionImage(
            notes: widget.controller.getCurrentNotes(),
            imageUrl: widget.controller.getPrescriptionUrl(),
          ),
        ],
      ),
    );
  }

  /// Build session notes with prescription image card
  Widget _buildSessionNotesWithPrescriptionImage({
    required String notes,
    String? imageUrl,
  }) {
    return SessionNotesWithPrescriptionCard(
      notes: notes,
      imageUrl: imageUrl,
      onImageTap: () {
        // open full-screen image
      },
    );
  }
}
