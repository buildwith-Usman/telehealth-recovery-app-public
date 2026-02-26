import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';

class InfoFieldData {
  final String label;
  final String? value;
  final Widget? icon;
  final bool highlight;
  final Color? valueColor;

  const InfoFieldData({
    required this.label,
    this.value,
    this.icon,
    this.highlight = false,
    this.valueColor,
  });
}

class PaymentSessionHistoryCard extends StatelessWidget {
  final List<InfoFieldData> leftFields;
  final List<InfoFieldData> rightFields;
  final VoidCallback? onTap;

  const PaymentSessionHistoryCard({
    super.key,
    required this.leftFields,
    required this.rightFields,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Make both sides have the same number of elements
    final maxLength = leftFields.length > rightFields.length
        ? leftFields.length
        : rightFields.length;

    final balancedLeft = List<InfoFieldData>.from(leftFields);
    final balancedRight = List<InfoFieldData>.from(rightFields);

    // ✅ Add empty placeholder fields to balance shorter column
    while (balancedLeft.length < maxLength) {
      balancedLeft.add(const InfoFieldData(label: '', value: ''));
    }
    while (balancedRight.length < maxLength) {
      balancedRight.add(const InfoFieldData(label: '', value: ''));
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // align top by default
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildInfoSection(balancedLeft)),
            gapW16,
            Expanded(child: _buildInfoSection(balancedRight)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(List<InfoFieldData> fields) {
    final visibleFields = fields;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < visibleFields.length; i++) ...[
          if (visibleFields[i].label.isNotEmpty) ...[
            AppText.primary(
              visibleFields[i].label,
              fontFamily: FontFamilyType.inter,
              fontSize: 12,
              fontWeight: FontWeightType.regular,
              color: AppColors.black.withValues(alpha: 0.4),
            ),
            gapH4,
            Row(
              children: [
                if (visibleFields[i].icon != null) ...[
                  visibleFields[i].icon!,
                  gapW6,
                ],
                Flexible(
                  child: AppText.primary(
                    visibleFields[i].value ?? '',
                    fontFamily: FontFamilyType.inter,
                    fontSize: 14,
                    fontWeight: visibleFields[i].highlight
                        ? FontWeightType.semiBold
                        : FontWeightType.medium,
                    color: visibleFields[i].valueColor ?? AppColors.black,
                  ),
                ),
              ],
            ),
          ] else
            // ✅ Empty space placeholder to match opposite side height
            const SizedBox(height: 38), // adjust for field + spacing height
          if (i != visibleFields.length - 1) gapH10,
        ],
      ],
    );
  }
}