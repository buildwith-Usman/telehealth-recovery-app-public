import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/utils/string_extensions.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_icon.dart';
import '../../../app/utils/sizes.dart';
import '../../widgets/app_text.dart';

class BaseHorizontalProfileCard extends StatelessWidget {
  final ProfileCardItem item;
  final EdgeInsets margin;
  final double borderRadius;

  const BaseHorizontalProfileCard({
    super.key,
    required this.item,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
        child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
            ? Image.network(
                item.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    // Use a plain colored area as the default avatar instead of a dummy image.
    // The parent container provides the circular shape and background color,
    // so here we simply return an expanding box to occupy the space.
    return const SizedBox.expand();
  }

  Widget _buildProfileDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        AppText.primary(
          item.name ?? 'Dr. Raahim Ahsan',
          fontFamily: FontFamilyType.poppins,
          fontSize: 18,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH4,
        // Email & Sessions row
        Row(
          children: [
            if (item.email != null) ...[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppIcon.emailIcon.widget(width: 12, height: 12),
                    gapW6,
                    Flexible(
                      child: AppText.primary(
                        item.email!, // replace with actual email if available
                        fontFamily: FontFamilyType.inter,
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.black.withOpacity(0.4),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              gapH4,
            ],
            if (item.totalSessions != null) ...[
              // Sessions
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppIcon.sessionIcon
                        .widget(width: 14, height: 14, color: AppColors.accent),
                    gapW6,
                    Flexible(
                      child: AppText.primary(
                        '${item.totalSessions} Sessions',
                        fontFamily: FontFamilyType.inter,
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.black.withOpacity(0.4),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        if (item.totalPayments != null) ...[
          // Payment row
          gapH4,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppIcon.navPayment
                  .widget(width: 14, height: 14, color: AppColors.accent),
              gapW6,
              AppText.primary(
                '${item.totalPayments} Payment',
                fontFamily: FontFamilyType.inter,
                fontSize: 14,
                fontWeight: FontWeightType.regular,
                color: AppColors.black.withOpacity(0.4),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          gapH4,
        ],
        if (item.doctorInfo != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: AppText.primary(
                  _buildProfessionText(item),
                  fontFamily: FontFamilyType.inter,
                  fontSize: 14,
                  fontWeight: FontWeightType.regular,
                  color: AppColors.black.withOpacity(0.4),
                  maxLines: 2, // 👈 allows wrapping to next line
                  overflow: TextOverflow.ellipsis, // 👈 adds "..." if too long
                ),
              ),
            ],
          ),
        ],
// Rating and Duration Row
        if (item.doctorInfo != null) ...[
          gapH6,
          SingleChildScrollView(
            scrollDirection:
                Axis.horizontal, // allows horizontal scrolling if too wide
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Rating - show actual rating or "Not Rated Yet"
                if (item.rating != null && item.rating! > 0) ...[
                  Row(
                    children: [
                      if (item.timeAvailability == null) ...[
                        ...List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Icon(
                              index < item.rating!.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          );
                        }),
                      ] else
                        AppIcon.starIcon.widget(width: 12, height: 12),
                      gapW6,
                      AppText.primary(
                        '${item.rating} (${item.noOfRatings ?? '0'})',
                        fontFamily: FontFamilyType.inter,
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.black.withOpacity(0.4),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ] else ...[
                  // Show "Not Rated Yet" when no rating
                  Row(
                    children: [
                      AppIcon.starIcon.widget(
                        width: 12,
                        height: 12,
                        color: AppColors.black.withOpacity(0.3),
                      ),
                      gapW6,
                      AppText.primary(
                        'Not Rated Yet',
                        fontFamily: FontFamilyType.inter,
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.black.withOpacity(0.4),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
                // Spacing between rating & time
                if (item.timeAvailability != null)
                  Row(
                    children: [
                      gapW12,
                      Container(
                        width: 1,
                        height: 14,
                        color: AppColors.black.withOpacity(0.2),
                      ),
                      gapW12,
                    ],
                  ),
                // Time availability
                if (item.timeAvailability != null) ...[
                  Row(
                    children: [
                      AppIcon.durationIcon.widget(
                        width: 14,
                        height: 14,
                        color: AppColors.accent,
                      ),
                      gapW6,
                      AppText.primary(
                        '${item.timeAvailability}',
                        fontFamily: FontFamilyType.inter,
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.black.withOpacity(0.4),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _buildProfessionText(ProfileCardItem item) {
  final profession = item.profession?.capitalizeFirst().trim();
  final degreeAbbreviations = _getDegreeAbbreviations(item.degree);

  if ((profession == null || profession.isEmpty) &&
      (degreeAbbreviations == null || degreeAbbreviations.isEmpty)) {
    return '—';
  }

  return [
    if (profession != null && profession.isNotEmpty) profession,
    if (degreeAbbreviations != null && degreeAbbreviations.isNotEmpty)
      degreeAbbreviations,
  ].join('\n'); // Separate lines
}

String? _getDegreeAbbreviations(String? degree) {
  if (degree == null || degree.trim().isEmpty) return null;

  return degree
      .split(',') // Handle multiple degrees
      .map((d) => d.trim())
      .where((d) => d.isNotEmpty)
      .map((d) => _abbreviate(d))
      .join(', ');
}

String _abbreviate(String text) {
  return text
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase())
      .join();
}

}
