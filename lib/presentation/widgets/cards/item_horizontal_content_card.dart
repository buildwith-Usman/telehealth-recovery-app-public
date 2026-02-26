import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/app/utils/string_extension.dart';
import '../app_text.dart';

class ItemHorizontalContentCardData {
  final String id;
  final String name;
  final String imageUrl;
  final DateTime? appointmentDate;
  final String status; // e.g., "Completed", "Upcoming"
  final String? notes;
  final String? prescriptionUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDropdownTap;

  const ItemHorizontalContentCardData({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.appointmentDate,
    required this.status,
    this.notes,
    this.prescriptionUrl,
    this.onTap,
    this.onDropdownTap,
  });
}

class ItemHorizontalContentCard extends StatelessWidget {
  final ItemHorizontalContentCardData item;

  const ItemHorizontalContentCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Stack(
        children: [
          // Main item layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(),
              gapW16,
              Expanded(child: _buildMainContent()),
            ],
          ),
          // // Dropdown icon at top-right
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: GestureDetector(
          //     onTap: item.onDropdownTap,
          //     behavior: HitTestBehavior.translucent, // makes tap area easier to hit
          //     child: Padding(
          //       padding: const EdgeInsets.all(4.0),
          //       child: AppIcon.itemExpand.widget(width: 10, height: 10),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }


  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grey80.withOpacity(0.3),
        image: item.imageUrl.isNotEmpty
            ? DecorationImage(
          image: NetworkImage(item.imageUrl),
          fit: BoxFit.cover,
        )
            : null,
      ),
      child: item.imageUrl.isEmpty
          ? AppIcon.userIcon.widget(
        width: 35,
        height: 35
      )
          : null,
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          item.name,
          fontSize: 16,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH4,
        if (item.appointmentDate != null) _buildDateInfo(),
        gapH6,
        Row(
          children: [
            AppIcon.confirmedIcon.widget(width: 10, height: 10),
            gapW6,
            AppText.primary(
              item.status.capitalizeFirstLetter(),
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateInfo() {
    final date = DateFormat('MMM dd, yyyy').format(item.appointmentDate!);
    final time = DateFormat('hh:mm a').format(item.appointmentDate!);
    return Row(
      children: [
        AppIcon.durationIcon.widget(width: 10, height: 10),
        gapW4,
        AppText.primary(
          '$date - $time',
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
