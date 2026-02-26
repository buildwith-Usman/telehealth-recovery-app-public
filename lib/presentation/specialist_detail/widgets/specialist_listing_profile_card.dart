import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/utils/string_extensions.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_icon.dart';
import '../../../app/utils/sizes.dart';
import '../../widgets/app_text.dart';

class SpecialistListingProfileCard extends StatelessWidget {
  final String name;
  final String? profession;
  final String? credentials;
  final String? experience;
  final double? rating;
  final String? availability;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool? showViewProfile;

  const SpecialistListingProfileCard(
      {super.key,
      required this.name,
      this.profession,
      this.credentials,
      this.experience,
      this.rating,
      this.availability,
      required this.imageUrl,
      this.onTap,
      this.showViewProfile = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 👇 Main content (Row)
            Padding(
              padding: const EdgeInsets.only(
                  top: 14), // 👈 add vertical gap from "View Profile"
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileImage(),
                  gapW16,
                  Expanded(
                    child: _buildProfileDetails(),
                  ),
                ],
              ),
            ),
            // 👇 "View Profile" positioned at top-right
            if (showViewProfile ?? false) ...[
              Positioned(
                right: 0,
                top: 0,
                child: _buildViewProfile(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grey80.withValues(alpha: 0.3),
      ),
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.grey80.withValues(alpha: 0.3),
      child: AppIcon.userIcon.widget(
        width: 35,
        height: 35,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildViewProfile() {
    return GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText.primary(
              'View Profile',
              fontFamily: FontFamilyType.inter,
              fontSize: 12,
              fontWeight: FontWeightType.medium,
              color: AppColors.accent,
            ),
            gapW6,
            AppIcon.rightArrowIcon.widget(
              width: 12,
              height: 12,
              color: AppColors.accent,
            ),
          ],
        ));
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        AppText.primary(
          name,
          fontFamily: FontFamilyType.poppins,
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH4,
        // Profession
        if (profession != null && profession!.isNotEmpty) ...[
          AppText.primary(
            profession!.capitalizeFirst(),
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
          gapH8,
        ],
        // Credentials and Experience (only show if either is provided)
        if (_hasCredentialsOrExperience()) ...[
          AppText.primary(
            _buildCredentialsExperienceText(),
            fontFamily: FontFamilyType.inter,
            fontSize: 12,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
          ),
          gapH8,
        ],
        // Rating and Availability (conditionally shown)
        Row(
          children: [
            if (rating != null) ...[
              AppIcon.starIcon.widget(
                width: 12,
                height: 12,
                color: Colors.amber,
              ),
              gapW4,
              AppText.primary(
                rating!.toStringAsFixed(1),
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
              ),
              gapW8,
            ] else ...[
              const Icon(
                Icons.verified_user,
                size: 12,
                color: AppColors.primary,
              ),
              gapW4,
              AppText.primary(
                'New Specialist',
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
              ),
              gapW8,
            ],
            // Only show availability separator and content when availability is provided
            if (availability != null && availability!.isNotEmpty) ...[
              AppText.primary(
                '|',
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
              ),
              gapW8,
              AppIcon.durationIcon.widget(
                width: 12,
                height: 12,
              ),
              gapW4,
              AppText.primary(
                availability!,
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ],
    );
  }

  /// Check if credentials or experience data is available
  bool _hasCredentialsOrExperience() {
    return (credentials != null && credentials!.isNotEmpty) ||
        (experience != null && experience!.isNotEmpty);
  }

  /// Build credentials and experience text based on available data
  String _buildCredentialsExperienceText() {
    final hasCredentials = credentials != null && credentials!.isNotEmpty;
    final hasExperience = experience != null && experience!.isNotEmpty;

    if (hasCredentials && hasExperience) {
      return '$credentials | $experience Years';
    } else if (hasCredentials) {
      return credentials!;
    } else if (hasExperience) {
      return '$experience Years';
    }
    return '';
  }
}
