import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteLight,
      child: const Center(
        child: Icon(Icons.person, color: AppColors.textSecondary, size: 40),
      ),
    );
  }
}