import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/item_horizontal_content_card.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/session_notes_with_prescription_card.dart';
import '../../../app/config/app_colors.dart';

class ItemRecentPatientConsultationHistory extends StatelessWidget {
  final ItemHorizontalContentCardData item;
  final EdgeInsets margin;
  final double borderRadius;
  final bool isExpanded;
  final VoidCallback onHeaderTap;

  const ItemRecentPatientConsultationHistory({
    super.key,
    required this.item,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 8,
    required this.isExpanded,
    required this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onHeaderTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(child: ItemHorizontalContentCard(item: item)),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: AppIcon.itemExpand.widget(),
                  ),
                ],
              ),
            ),
          ),

          // Expandable section
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: SessionNotesWithPrescriptionCard(
                notes: item.notes ?? '',
                imageUrl: (item.prescriptionUrl != null && item.prescriptionUrl!.isNotEmpty)
                    ? item.prescriptionUrl
                    : null,
                onImageTap: () {
                  // handle full screen image
                },
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
