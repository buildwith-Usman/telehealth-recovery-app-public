import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/app/utils/string_extension.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_icon.dart';
import '../../../app/utils/sizes.dart';
import '../../../domain/entity/appointment_entity.dart';
import '../app_text.dart';
import '../button/primary_button.dart';

// Appointment data model for card display
class AppointmentData {
  final String id;
  final String name;
  final String title;
  final String specialization;
  final String imageUrl;
  final double? rating; // Nullable - null means no ratings available yet
  final String? nextAvailable;
  final bool isOnline;
  final String? buttonText;
  final DateTime? appointmentDate;
  final String? appointmentType; // 'upcoming' or 'completed'
  final String userRole;
  final VoidCallback? onTap;
  final VoidCallback? onButtonPressed;
  final VoidCallback? onViewPrescriptionPressed; // For completed appointments
  final VoidCallback? onBookAgainPressed; // For completed appointments
  final VoidCallback? onViewNotePressed;
  final AppointmentEntity? entity; // Store the original entity for navigation

  AppointmentData({
    required this.id,
    required this.name,
    required this.title,
    required this.specialization,
    required this.imageUrl,
    this.rating,
    this.nextAvailable,
    this.isOnline = true,
    this.buttonText = 'View Details',
    this.appointmentDate,
    this.appointmentType,
    required this.userRole,
    this.onTap,
    this.onButtonPressed,
    this.onViewPrescriptionPressed,
    this.onBookAgainPressed,
    this.onViewNotePressed,
    this.entity,
  });

  // Helper getters for status checks
  bool get isCompleted => appointmentType == 'completed';
  bool get isPending => appointmentType == 'upcoming';
}

class AppointmentCard extends StatelessWidget {
  final AppointmentData specialist;

  const AppointmentCard({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: specialist.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
        child: Stack(
          children: [
            /// Main card content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (specialist.appointmentDate != null &&
                    specialist.userRole == UserRole.patient.name)
                  _buildDateHeader(),
                gapH12,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildSpecialistAvatar(),
                    gapW16,
                    Expanded(child: _buildSpecialistMainInfo()),
                  ],
                ),
                gapH12,
                _buildStartSessionButton(),
              ],
            ),

            /// Removed "View Note" from top-right corner - now shown as button instead
          ],
        ),
      ),
    );
  }


  Widget _buildDateHeader() {
    if (specialist.appointmentDate == null) return const SizedBox.shrink();

    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Row(
      children: [
        AppIcon.durationIcon.widget(width: 10, height: 10),
        gapW4,
        AppText.primary(
          dateFormat.format(specialist.appointmentDate!),
          fontFamily: FontFamilyType.inter,
          fontSize: 12,
          fontWeight: FontWeightType.regular,
          color: AppColors.black.withValues(alpha: 0.4),
        ),
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
          timeFormat.format(specialist.appointmentDate!),
          fontFamily: FontFamilyType.inter,
          fontSize: 12,
          fontWeight: FontWeightType.regular,
          color: AppColors.black.withValues(alpha: 0.4),
        ),
      ],
    );
  }

  Widget _buildSpecialistAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grey80.withOpacity(0.3),
        image: specialist.imageUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(specialist.imageUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: specialist.imageUrl.isEmpty
          ? AppIcon.userIcon.widget(
              width: 35,
              height: 35,
              color: AppColors.textSecondary,
            )
          : null,
    );
  }

  Widget _buildSpecialistMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          specialist.name,
          fontFamily: FontFamilyType.poppins,
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH4,
        if (specialist.userRole == UserRole.patient.name) ...[
          Row(
            children: [
              AppText.primary(
                specialist.title.isNotEmpty ? specialist.title.capitalizeFirstLetter() : 'Specialist',
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.black.withValues(alpha: 0.4),
              ),
              gapW12,
              AppIcon.confirmedIcon.widget(
                width: 10,
                height: 10,
              ),
              gapW6,
              AppText.primary(
                _getStatusText(),
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.black.withValues(alpha: 0.4),
              ),
            ],
          ),
        ] else ...[
          // For specialists: show date, time, and status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateHeader(),
              gapH8,
              Row(
                children: [
                  AppIcon.confirmedIcon.widget(
                    width: 10,
                    height: 10,
                  ),
                  gapW6,
                  AppText.primary(
                    _getStatusText(),
                    fontFamily: FontFamilyType.inter,
                    fontSize: 12,
                    fontWeight: FontWeightType.regular,
                    color: AppColors.black.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ],
          ),
        ],
        gapH8,
        if (specialist.userRole == UserRole.patient.name && specialist.rating != null)
          Row(
            children: [
              AppIcon.starIcon.widget(
                width: 10,
                height: 10,
              ),
              gapW6,
              AppText.primary(
                specialist.rating!.toStringAsFixed(1),
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.black.withValues(alpha: 0.4),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStartSessionButton() {
    final isSpecialist = specialist.userRole == UserRole.doctor.name ||
                        specialist.userRole == UserRole.specialist.name;

    if (specialist.appointmentType == 'completed') {
      // COMPLETED APPOINTMENTS
      if (isSpecialist) {
        // For specialists: Show only "View Notes" button
        return SizedBox(
          width: double.infinity,
          height: 40,
          child: PrimaryButton(
            color: AppColors.primary,
            textColor: AppColors.white,
            title: 'View Notes',
            height: 45,
            radius: 6,
            fontSize: 14,
            fontWeight: FontWeightType.semiBold,
            showIcon: true,
            iconWidget: AppIcon.rightArrowIcon.widget(
              width: 8,
              height: 8,
              color: AppColors.white,
            ),
            onPressed: specialist.onViewNotePressed ?? () {},
          ),
        );
      } else {
        // For patients: Show "View Prescription" (if psychiatrist) and "Book Again"
        final isPsychiatrist = specialist.title.toLowerCase().contains('psychiatrist');

        return Row(
          children: [
            if (isPsychiatrist) ...[
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: PrimaryButton(
                    color: AppColors.whiteLight,
                    textColor: AppColors.black,
                    title: 'Prescription',
                    height: 45,
                    radius: 6,
                    fontSize: 14,
                    fontWeight: FontWeightType.semiBold,
                    showIcon: true,
                    iconWidget: AppIcon.rightArrowIcon.widget(
                      width: 8,
                      height: 8,
                      color: AppColors.black,
                    ),
                    onPressed: specialist.onViewPrescriptionPressed ?? () {},
                  ),
                ),
              ),
              gapW12,
            ],
            Expanded(
              child: SizedBox(
                height: 40,
                child: PrimaryButton(
                  color: AppColors.primary,
                  textColor: AppColors.white,
                  title: 'Book Again',
                  height: 45,
                  radius: 6,
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  showIcon: true,
                  iconWidget: AppIcon.rightArrowIcon.widget(
                    width: 8,
                    height: 8,
                    color: AppColors.white,
                  ),
                  onPressed: specialist.onBookAgainPressed ?? () {},
                ),
              ),
            ),
          ],
        );
      }
    } else {
      // UPCOMING APPOINTMENTS
      if (isSpecialist) {
        // For specialists: Show "View Notes" and "Start Session" buttons
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: PrimaryButton(
                  color: AppColors.whiteLight,
                  textColor: AppColors.black,
                  title: 'View Notes',
                  height: 45,
                  radius: 6,
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  showIcon: true,
                  iconWidget: AppIcon.rightArrowIcon.widget(
                    width: 8,
                    height: 8,
                    color: AppColors.black,
                  ),
                  onPressed: specialist.onViewNotePressed ?? () {},
                ),
              ),
            ),
            gapW12,
            Expanded(
              child: SizedBox(
                height: 40,
                child: PrimaryButton(
                  color: AppColors.primary,
                  textColor: AppColors.white,
                  title: 'Start Session',
                  height: 45,
                  radius: 6,
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  showIcon: true,
                  iconWidget: AppIcon.rightArrowIcon.widget(
                    width: 8,
                    height: 8,
                    color: AppColors.white,
                  ),
                  onPressed: specialist.onButtonPressed ?? () {},
                ),
              ),
            ),
          ],
        );
      } else {
        // For patients: Show only "Start Session" button
        return SizedBox(
          width: double.infinity,
          height: 40,
          child: PrimaryButton(
            color: AppColors.primary,
            textColor: AppColors.white,
            title: 'Start Session',
            height: 45,
            radius: 6,
            fontSize: 14,
            fontWeight: FontWeightType.semiBold,
            showIcon: true,
            iconWidget: AppIcon.rightArrowIcon.widget(
              width: 10,
              height: 10,
              color: AppColors.white,
            ),
            onPressed: specialist.onButtonPressed ?? () {},
          ),
        );
      }
    }
  }

  /// Get the status text based on appointment type and entity status
  String _getStatusText() {
    // If we have the entity, use its actual status for more accuracy
    if (specialist.entity?.status != null) {
      final status = specialist.entity!.status!.toLowerCase();
      switch (status) {
        case 'completed':
          return 'Completed';
        case 'cancelled':
          return 'Cancelled';
        case 'pending':
          return 'Pending';
        case 'draft':
          return 'Draft';
        default:
          return 'Pending';
      }
    }
    
    // Fallback to appointmentType if entity is not available
    if (specialist.appointmentType == 'completed') {
      return 'Completed';
    }
    
    // For upcoming appointments, show "Pending" or "Confirmed" based on user role
    return specialist.userRole == UserRole.patient.name
        ? 'Confirmed'
        : 'Pending';
  }
}
