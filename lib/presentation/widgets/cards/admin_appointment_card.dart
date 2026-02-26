import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/domain/models/session_data.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';

class AdminAppointmentCard extends StatelessWidget {
  final AdminSessionData session;
  final VoidCallback? onTap;

  const AdminAppointmentCard({
    super.key,
    required this.session,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.primary,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (session.sessionType == AdminSessionType.ongoing) ...[
              Row(
                children: [
                  AppText.mandatory(
                    'In Progress',
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeightType.light,
                  ),
                  gapW6,
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 146, 252, 53),
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
              gapH14,
            ],
            // Therapist & Patient Row
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left side — Specialist
                  Expanded(
                    child: Center(
                      child: _PersonInfo(
                        label: 'Specialist',
                        name: session.specialistName,
                        imageUrl: session.specialistImageUrl,
                        isTherapist: true,
                      ),
                    ),
                  ),

                  // Small horizontal spacing before divider
                  gapW8,

                  // Vertical divider
                  Container(
                    width: 1,
                    color: Colors.grey.shade300,
                  ),

                  // Small horizontal spacing after divider
                  gapW8,

                  // Right side — Patient
                  Expanded(
                    child: Center(
                      child: _PersonInfo(
                        label: 'Patient',
                        name: session.patientName,
                        imageUrl: session.patientImageUrl,
                        isTherapist: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            gapH14,
            // Date & Time
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.accent
                    .withOpacity(0.3), // 👈 your background color here
                borderRadius: BorderRadius.circular(6),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left side — Time
                    Expanded(
                      child: Center(
                        child: _InfoChip(
                          icon: AppIcon.clock.widget(width: 14, height: 14),
                          text: session.time,
                        ),
                      ),
                    ),

                    // Small horizontal spacing before divider
                    gapW8,
                    // Divider line
                    Container(
                      width: 1,
                      color: Colors.grey.shade300,
                    ),
                    // Small horizontal spacing after divider
                    gapW8,
                    // Right side — Date
                    Expanded(
                      child: Center(
                        child: _InfoChip(
                          icon: AppIcon.datePickerIcon.widget(
                            color: AppColors.white,
                            width: 14,
                            height: 14,
                          ),
                          text: session.date,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            gapH14,
            // Check Details Button
            _buildCheckSessionDetailsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckSessionDetailsButton() {
    return PrimaryButton(
      color: AppColors.white,
      textColor: AppColors.primary,
      title: 'Check Session Details',
      height: 40,
      radius: 6,
      fontWeight: FontWeightType.semiBold,
      showIcon: true,
      iconWidget: AppIcon.rightArrowIcon.widget(
        width: 10,
        height: 10,
        color: AppColors.primary,
      ),
      onPressed: () {
        print('Session Details Button Tap');
       if (onTap != null) {
        onTap!(); // ✅ actually calls your provided callback
      } else {
        _defaultTapAction();
      }
      },
    );
  }

  void _defaultTapAction() {
    Get.snackbar(
      'Session Details',
      'Viewing details for ${session.specialistName} with ${session.patientName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _PersonInfo extends StatelessWidget {
  final String label;
  final String name;
  final String? imageUrl;
  final bool isTherapist;

  const _PersonInfo({
    required this.label,
    required this.name,
    this.imageUrl,
    required this.isTherapist,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Avatar(imageUrl: imageUrl, isTherapist: isTherapist),
        gapW8,
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(
                label,
                fontSize: 10,
                color: Colors.white70,
              ),
              const SizedBox(height: 4),
              AppText.primary(
                name,
                fontSize: 12,
                fontWeight: FontWeightType.semiBold,
                color: Colors.white,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? imageUrl;
  final bool isTherapist;

  const _Avatar({this.imageUrl, required this.isTherapist});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white24,
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) => isTherapist
                    ? AppImage.dummyDr.widget()
                    : AppImage.dummyPt.widget(),
              )
            : (isTherapist
                ? AppImage.dummyDr.widget()
                : AppImage.dummyPt.widget()),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final Widget icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        gapW8,
        Flexible(
          child: AppText.primary(
            text,
            fontSize: 14,
            color: AppColors.white,
          ),
        )
      ],
    );
  }
}
