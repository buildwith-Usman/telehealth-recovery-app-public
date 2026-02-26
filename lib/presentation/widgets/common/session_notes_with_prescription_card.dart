import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/prescription_image.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';

class SessionNotesWithPrescriptionCard extends StatelessWidget {
  final String notes;
  final String? imageUrl;
  final VoidCallback? onImageTap;

  const SessionNotesWithPrescriptionCard({
    super.key,
    required this.notes,
    this.imageUrl,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.expandable(
            notes,
            trimLines: 3,
            seeMoreColor: AppColors.accent,
          ),
          gapH10,
          // Only show prescription image when a valid URL is provided
          if (imageUrl != null && imageUrl!.isNotEmpty)
            PrescriptionImage(
              imageUrl: imageUrl,
              onTap: onImageTap,
            ),
        ],
      ),
    );
  }
}
