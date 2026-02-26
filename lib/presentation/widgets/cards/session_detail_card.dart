import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/domain/models/session_data.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../../widgets/app_text.dart';

class SessionDetailCard extends StatelessWidget {
  final AdminSessionData session;
  final VoidCallback? onTap;

  const SessionDetailCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            // Therapist and Patient Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Specialist Info
                Expanded(
                  child: _buildSessionDetailCardItem(
                      label: 'Patient Name',
                      name: session.patientName,
                      showIcon: false,
                      alignment: MainAxisAlignment.start),
                ),
                gapW12,
                // Patient Info
                Expanded(
                  child: _buildSessionDetailCardItem(
                      label: 'Specialist Name',
                      name: session.specialistName,
                      alignment: MainAxisAlignment.start),
                ),
              ],
            ),
            gapH12,
            // Session Duration and Session Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Specialist Info
                Expanded(
                  child: _buildSessionDetailCardItem(
                      label: 'Session Duration',
                      name: session.duration,
                      showIcon: true,
                      icon: AppIcon.durationIcon.widget(
                          height: 16, width: 16, color: AppColors.accent),
                      alignment: MainAxisAlignment.start),
                ),
                gapW12,
                // Patient Info
                Expanded(
                  child: _buildSessionDetailCardItem(
                      label: 'Session Date',
                      name: session.date,
                      showIcon: true,
                      icon: AppIcon.datePickerIcon.widget(
                          height: 16, width: 16, color: AppColors.accent),
                      alignment: MainAxisAlignment.start),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDetailCardItem({
    required String label,
    required String name,
    MainAxisAlignment alignment = MainAxisAlignment.center,
    bool showIcon = false,
    Widget? icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Name and Label
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.primary(
                label,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.grey80,
              ),
              gapH6,
              Row(
                children: [
                  if (showIcon && icon != null) icon,
                  gapW8,
                  Expanded(
                    child: AppText.primary(
                      name,
                      fontSize: 14,
                      fontWeight: FontWeightType.medium,
                      color: AppColors.black,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required Widget icon,
    required String text,
    MainAxisAlignment alignment = MainAxisAlignment.start,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        gapW8,
        AppText.primary(
          text,
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: Colors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
