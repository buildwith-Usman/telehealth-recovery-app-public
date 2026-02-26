import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/utils/string_extension.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';
import '../../../app/config/app_icon.dart';

class ListProfileCard extends StatelessWidget {
  final ProfileCardItem item;
  final EdgeInsets margin;
  final double borderRadius;

  const ListProfileCard({
    super.key,
    required this.item,
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
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(),
              _buildContentSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        height: 120,
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
          child: item.imageUrl != null
              ? Image.network(
                  item.imageUrl!,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                )
              : _buildPlaceholderImage(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.whiteLight,
      child: const Center(
        child: Icon(
          Icons.person,
          color: AppColors.textSecondary,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.name != null)
            AppText.primary(
              item.name!,
              fontFamily: FontFamilyType.poppins,
              fontSize: 15,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          gapH4,
          if (item.sessionDuration != null || item.sessionDate != null)
            Row(
              children: [
                if (item.sessionDuration != null)
                  _buildIconText(
                    icon: AppIcon.durationIcon.widget(width: 14, height: 14),
                    text: item.sessionDuration!,
                  ),
                if (item.sessionDate != null)
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildIconText(
                          icon: AppIcon.datePickerIcon
                              .widget(width: 14, height: 14),
                          text: item.sessionDate!,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          if (item.profession != null || item.rating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (item.profession != null)
                  Flexible(
                    child: AppText.primary(
                      item.profession?.capitalizeFirstLetter() ?? '',
                      fontFamily: FontFamilyType.inter,
                      fontSize: 12,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                // Always show rating section - either actual rating or "Not rated yet"
                Row(
                  children: [
                    AppIcon.starIcon.widget(width: 14, height: 14),
                    gapW4,
                    AppText.primary(
                      item.rating != null
                          ? '${item.rating!.toStringAsFixed(1)} (${item.noOfRatings ?? '0'})'
                          : 'Not rated yet',
                      fontFamily: FontFamilyType.inter,
                      fontSize: 12,
                      fontWeight: FontWeightType.medium,
                      color: item.rating != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          gapH6,
          if (item.degree != null || item.experience != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Degree on the left
                if (item.degree != null)
                  Expanded(
                    child: AppText.primary(
                      _getDegreeAbbreviation(item.degree!),
                      fontFamily: FontFamilyType.inter,
                      fontSize: 10,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const Spacer(),
                // Small horizontal gap
                const SizedBox(width: 6),
                // Experience aligned to the right end
                if (item.experience != null)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 80), // 👈 optional limit
                    child: AppText.primary(
                      item.experience!,
                      fontFamily: FontFamilyType.inter,
                      fontSize: 10,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),
          gapH10,
        ],
      ),
    );
  }

  Widget _buildIconText({required Widget icon, required String text}) {
    return Row(
      children: [
        icon,
        gapW4,
        Flexible(
          child: AppText.primary(
            text,
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.black.withOpacity(0.4),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Convert degree names to abbreviations
  /// Handles comma-separated degrees and returns abbreviations separated by commas
  String _getDegreeAbbreviation(String degree) {
    if (degree.isEmpty) return degree;

    // Split by comma and process each degree
    final degrees = degree.split(',').map((d) => d.trim()).toList();
    final abbreviations = degrees.map((deg) => _convertToAbbreviation(deg)).toList();
    
    return abbreviations.join(', ');
  }

  /// Convert a single degree name to its abbreviation
  /// Takes the first letter of each word to create the abbreviation
  String _convertToAbbreviation(String degree) {
    if (degree.isEmpty) return degree;

    final normalizedDegree = degree.trim();

    // If already an abbreviation (2-5 uppercase letters, possibly with dots), return as is
    if (RegExp(r'^[A-Z]{2,5}(\.)?$').hasMatch(normalizedDegree)) {
      return normalizedDegree;
    }

    // Split into words and take first letter of each word
    final words = normalizedDegree.split(RegExp(r'\s+'));
    final abbreviation = words
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join();
    
    return abbreviation;
  }
}
