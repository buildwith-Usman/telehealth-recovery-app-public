import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/services/base_stateful_page.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/presentation/view_notes/view_notes_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/custom_navigation_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/prescription_image.dart';

class ViewNotesPage extends BaseStatefulPage<ViewNotesController> {
  const ViewNotesPage({super.key});

  @override
  BaseStatefulPageState<ViewNotesController> createState() =>
      _ViewNotesPageState();
}

class _ViewNotesPageState
    extends BaseStatefulPageState<ViewNotesController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildHeader(),
              ),
              gapH20,
              Expanded(
                child: Obx(() => _buildContent()),
              ),
            ],
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
              {debugPrint("No previous route to pop")}
          },
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

  Widget _buildContent() {
    if (widget.controller.isLoading.value) {
      return _buildLoadingState();
    }

    if (widget.controller.shouldShowPatientHistory) {
      return _buildPatientHistoryView();
    } else if (widget.controller.shouldShowCurrentNotes) {
      return _buildCurrentNotesView();
    }

    return _buildEmptyState();
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
    );
  }

  /// Build patient history view (for upcoming appointments)
  Widget _buildPatientHistoryView() {
    if (widget.controller.patientHistory.isEmpty) {
      return Center(
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
      );
    }

    return RefreshIndicator(
      onRefresh: widget.controller.refresh,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.controller.patientHistory.length,
        itemBuilder: (context, index) {
          final appointment = widget.controller.patientHistory[index];
          return _buildHistoryCard(appointment);
        },
      ),
    );
  }

  /// Build history card for each previous session
  Widget _buildHistoryCard(AppointmentEntity appointment) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');
    final appointmentDate = appointment.date != null
        ? DateTime.tryParse(appointment.date!)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          if (appointmentDate != null) ...[
            Row(
              children: [
                AppIcon.durationIcon.widget(width: 10, height: 10),
                gapW4,
                AppText.primary(
                  dateFormat.format(appointmentDate),
                  fontFamily: FontFamilyType.inter,
                  fontSize: 12,
                  fontWeight: FontWeightType.regular,
                  color: AppColors.black.withValues(alpha: 0.4),
                ),
                if (appointment.startTime != null) ...[
                  gapW4,
                  AppText.primary(
                    '|',
                    fontFamily: FontFamilyType.inter,
                    fontSize: 12,
                    fontWeight: FontWeightType.regular,
                    color: AppColors.black.withValues(alpha: 0.4),
                  ),
                  gapW4,
                  AppText.primary(
                    appointment.startTime!,
                    fontFamily: FontFamilyType.inter,
                    fontSize: 12,
                    fontWeight: FontWeightType.regular,
                    color: AppColors.black.withValues(alpha: 0.4),
                  ),
                ],
              ],
            ),
            gapH12,
          ],

          // Doctor info with image
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor avatar
              Container(
                width: 60,
                height: 60,
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
                        width: 25,
                        height: 25,
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
                        color: AppColors.black.withValues(alpha: 0.4),
                      ),
                  ],
                ),
              ),
            ],
          ),

          gapH12,

          // Session notes placeholder
          // TODO: Replace with actual notes when available in the entity
          AppText.primary(
            'Consultation notes from this session',
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.black.withValues(alpha: 0.6),
          ),

          // Prescription if available
          if (appointment.prescriptionUrl != null &&
              appointment.prescriptionUrl!.isNotEmpty) ...[
            gapH12,
            AppText.primary(
              'Prescription',
              fontFamily: FontFamilyType.inter,
              fontSize: 12,
              fontWeight: FontWeightType.medium,
              color: AppColors.black,
            ),
            gapH8,
            PrescriptionImage(
              imageUrl: appointment.prescriptionUrl,
              onTap: () {
                // Optionally show full-screen image
              },
            ),
          ],
        ],
      ),
    );
  }

  /// Build current notes view (for completed appointments)
  Widget _buildCurrentNotesView() {
    final appointment = widget.controller.currentAppointment;

    if (appointment == null) {
      return _buildEmptyState();
    }

    final dateFormat = DateFormat('MMM dd, yyyy');
    final appointmentDate = appointment.date != null
        ? DateTime.tryParse(appointment.date!)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appointment date and time
            if (appointmentDate != null) ...[
              Row(
                children: [
                  AppIcon.durationIcon.widget(width: 12, height: 12),
                  gapW6,
                  AppText.primary(
                    dateFormat.format(appointmentDate),
                    fontFamily: FontFamilyType.inter,
                    fontSize: 14,
                    fontWeight: FontWeightType.medium,
                    color: AppColors.black.withValues(alpha: 0.6),
                  ),
                  if (appointment.startTime != null) ...[
                    gapW8,
                    AppText.primary(
                      '|',
                      fontFamily: FontFamilyType.inter,
                      fontSize: 14,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.black.withValues(alpha: 0.4),
                    ),
                    gapW8,
                    AppText.primary(
                      appointment.startTime!,
                      fontFamily: FontFamilyType.inter,
                      fontSize: 14,
                      fontWeight: FontWeightType.medium,
                      color: AppColors.black.withValues(alpha: 0.6),
                    ),
                  ],
                ],
              ),
              gapH20,
            ],

            // Patient info
            AppText.primary(
              'Patient',
              fontFamily: FontFamilyType.poppins,
              fontSize: 12,
              fontWeight: FontWeightType.medium,
              color: AppColors.black.withValues(alpha: 0.5),
            ),
            gapH4,
            AppText.primary(
              appointment.patientName ?? 'Unknown Patient',
              fontFamily: FontFamilyType.poppins,
              fontSize: 16,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),

            gapH20,

            // Session notes
            AppText.primary(
              'Consultation Notes',
              fontFamily: FontFamilyType.poppins,
              fontSize: 14,
              fontWeight: FontWeightType.medium,
              color: AppColors.black,
            ),
            gapH8,
            AppText.primary(
              widget.controller.getCurrentNotes(),
              fontFamily: FontFamilyType.inter,
              fontSize: 14,
              fontWeight: FontWeightType.regular,
              color: AppColors.black.withValues(alpha: 0.7),
            ),

            // Prescription section (only for psychiatrists)
            if (widget.controller.isPsychiatrist &&
                widget.controller.getPrescriptionUrl() != null &&
                widget.controller.getPrescriptionUrl()!.isNotEmpty) ...[
              gapH20,
              AppText.primary(
                'Prescribed Medication',
                fontFamily: FontFamilyType.poppins,
                fontSize: 14,
                fontWeight: FontWeightType.medium,
                color: AppColors.black,
              ),
              gapH10,
              PrescriptionImage(
                imageUrl: widget.controller.getPrescriptionUrl(),
                onTap: () {
                  // Optionally show full-screen image
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
