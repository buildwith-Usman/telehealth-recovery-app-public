import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/domain/models/specialist_item.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';

class SpecialistCard extends StatelessWidget {
  final SpecialistItem specialist;
  final EdgeInsets margin;
  final double borderRadius;

  const SpecialistCard({
    super.key,
    required this.specialist,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: specialist.onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Profile Image (Full width, no padding)
              _buildProfileImage(),
              // Bottom Section: Content without padding
              _buildContentSection()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Name
          AppText.primary(
            specialist.name,
            fontFamily: FontFamilyType.poppins,
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          gapH4,
          // Profession and Rating in one row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.primary(
                specialist.profession,
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              gapW8,
              // Star Rating
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon.starIcon.widget(
                    width: 14,
                    height: 14,
                  ),
                  gapW4,
                  AppText.primary(
                    specialist.rating.toString(),
                    fontFamily: FontFamilyType.inter,
                    fontSize: 12,
                    fontWeight: FontWeightType.medium,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ],
          ),
          gapH6,
          // Credentials and Experience in one row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.primary(
                specialist.credentials,
                fontFamily: FontFamilyType.inter,
                fontSize: 10,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              gapW8,
              AppText.primary(
                specialist.experience,
                fontFamily: FontFamilyType.inter,
                fontSize: 10,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity, // Take full width of the main card
        height: 120, // Increased height for better proportion
        decoration: BoxDecoration(
          color: AppColors.whiteLight,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: specialist.imageUrl != null
              ? Image.network(
                  specialist.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                )
              : _buildPlaceholderImage(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          color: AppColors.textSecondary,
          size: 40,
        ),
      ),
    );
  }
}
