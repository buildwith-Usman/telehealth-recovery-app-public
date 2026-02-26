import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/icon_text_row_item.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/profile_image.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';

class ItemData {
  final String? name;
  final String? age;
  final String? note;
  final String? sessionDate;
  final String? sessionDuration;
  final String? imageUrl;
  final VoidCallback? onTap;

  const ItemData({
    this.name,
    this.age,
    this.note,
    this.sessionDate,
    this.sessionDuration,
    this.imageUrl,
    this.onTap,
  });
}

class ItemVerticalCard extends StatelessWidget {
  final ItemData item;
  final EdgeInsets margin;
  final double borderRadius;

  const ItemVerticalCard({
    super.key,
    required this.item,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: AppColors.white,
          child: InkWell(
            onTap: item.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileImage(imageUrl: item.imageUrl),
                  gapH4,
                  _CardInfo(item: item),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final ItemData item;

  const _CardInfo({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          item.name!,
          fontFamily: FontFamilyType.poppins,
          fontSize: 14,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.textPrimary,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        gapH6,
        Row(
          children: [
            Expanded(
              child: IconTextRowItem(
                iconWidget: AppIcon.durationIcon.widget(width: 12, height: 12),
                text: item.sessionDuration,
              ),
            ),
            gapW8,
            Expanded(
              child: IconTextRowItem(
                iconWidget: AppIcon.datePickerIcon.widget(width: 12, height: 12),
                text: item.sessionDate,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
