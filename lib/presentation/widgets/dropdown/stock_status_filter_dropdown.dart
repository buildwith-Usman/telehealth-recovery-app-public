import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/admin_medicine_product_listing/admin_medicine_product_listing_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/custom_check_box.dart';

class StockStatusFilterDropdown {
  static void show({
    required BuildContext context,
    required GlobalKey key,
    required StockStatus selectedStatus,
    required ValueChanged<StockStatus> onChanged,
  }) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    const List<StockStatus> availableStatuses = StockStatus.values;

    final screenWidth = MediaQuery.of(context).size.width;
    const dropdownWidth = 200.0;

    showMenu<StockStatus>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height + 4, // 4px gap below trigger
        screenWidth - (position.dx + dropdownWidth),
        0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: AppColors.white,
      elevation: 8,
      items: availableStatuses.map((status) {
        final isSelected = selectedStatus == status;
        return PopupMenuItem<StockStatus>(
          value: status,
          padding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (context, setState) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  onChanged(status);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CustomCheckbox(isSelected: isSelected),
                      gapW12,
                      AppText.primary(
                        _getStatusText(status), // Use helper for display text
                        fontSize: 14,
                        fontWeight: FontWeightType.regular,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  // Helper to get display-friendly text for each status
  static String _getStatusText(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.hidden:
        return 'Hidden';
      case StockStatus.all:
      default:
        return 'All';
    }
  }
}
