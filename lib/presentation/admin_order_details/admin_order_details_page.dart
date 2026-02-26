import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_app_bar.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/common/icon_text_row_item.dart';
import 'admin_order_details_controller.dart';

class AdminOrderDetailsPage
    extends BaseStatefulPage<AdminOrderDetailsController> {
  const AdminOrderDetailsPage({super.key});

  @override
  BaseStatefulPageState<AdminOrderDetailsController> createState() =>
      _AdminOrderDetailsPageState();
}

class _AdminOrderDetailsPageState
    extends BaseStatefulPageState<AdminOrderDetailsController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Order Details',
      showBackButton: true,
      onBackPressed: () => Get.back(),
    );
  }

  @override
  bool useStandardPadding = true;

  @override
  Widget buildPageContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() => _buildOrderDetails()),
          gapH12,
          _buildOrderPrice(),
          gapH14,
          _buildOrderPrescriptionInfo(),
          gapH14,
          _buildSelectStatus(),
          gapH20,
          PrimaryButton(
            title: "Update Order Status",
            height: 45.0,
            color: AppColors.textPrimary,
            textColor: AppColors.white,
            borderColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            onPressed: () {
              Get.back();
            },
          ),
          gapH20,
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    final order = widget.controller.order.value;
    if (order != null) {
      return Center(child: AppText.primary('No order details found.'));
    }
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.primary(
              "#MED-001251",
              fontFamily: FontFamilyType.inter,
              fontSize: 12,
              fontWeight: FontWeightType.regular,
              color: AppColors.black,
            ),
            gapH10,
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.userIcon.widget(width: 12, height: 12),
                      text: "Usman Haider",
                    ),
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.icWalutPrice.widget(width: 12, height: 12),
                      text: "Rs.250",
                    ),
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.icOrderLocation.widget(width: 12, height: 13),
                      text: "Model Town, Lahore",
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.datePickerIcon.widget(width: 12, height: 12),
                      text: "Jul 6, 2025",
                    ),
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.sessionClock.widget(width: 12, height: 12),
                      text: "Status: | Pending",
                    ),
                  ],
                ),
              ],
            ),
            gapH14,
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            gapH18,
            AppText.primary(
              "Order Items",
              fontFamily: FontFamilyType.poppins,
              fontSize: 14,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.primary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.icParacetamol.widget(width: 12, height: 12),
                      text: "Paracetamol 500mg ",
                    ),
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.icWalutPrice.widget(width: 12, height: 12),
                      text: "Rs.250",
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 65.0),
                      child: IconTextRowItem(
                        iconWidget:
                            AppIcon.icVisibilty.widget(width: 12, height: 12),
                        text: "QTY 1",
                      ),
                    ),
                    gapH18,
                  ],
                ),
              ],
            ),
            gapH14,
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            gapH14,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.icParacetamol.widget(width: 12, height: 12),
                      text: "Paracetamol 500mg ",
                    ),
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.icWalutPrice.widget(width: 12, height: 12),
                      text: "Rs.250",
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 65.0),
                      child: IconTextRowItem(
                        iconWidget:
                            AppIcon.icVisibilty.widget(width: 12, height: 12),
                        text: "QTY 1",
                      ),
                    ),
                    gapH18,
                  ],
                ),
              ],
            ),
            gapH14,
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            gapH14,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.icParacetamol.widget(width: 12, height: 12),
                      text: "Paracetamol 500mg ",
                    ),
                    gapH14,
                    IconTextRowItem(
                      iconWidget:
                          AppIcon.icWalutPrice.widget(width: 12, height: 12),
                      text: "Rs.250",
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 65.0),
                      child: IconTextRowItem(
                        iconWidget:
                            AppIcon.icVisibilty.widget(width: 12, height: 12),
                        text: "QTY 1",
                      ),
                    ),
                    gapH18,
                  ],
                ),
              ],
            ),
            gapH12,
          ],
        ),
      ),
    );
  }

  Widget _buildOrderPrice() {
    final order = widget.controller.order.value;
    if (order != null) {
      return const SizedBox.shrink();
    }
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.primary(
              "Price Summary",
              fontFamily: FontFamilyType.poppins,
              fontSize: 14,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.primary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH14,
                    AppText.primary(
                      "Subtotal: ",
                      fontFamily: FontFamilyType.inter,
                      fontSize: 14,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.grey60,
                    ),
                    gapH14,
                    AppText.primary(
                      "Delivery:",
                      fontFamily: FontFamilyType.inter,
                      fontSize: 14,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.grey60,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    gapH14,
                    AppText.primary(
                      "Rs. 990",
                      fontFamily: FontFamilyType.inter,
                      fontSize: 14,
                      fontWeight: FontWeightType.semiBold,
                      color: AppColors.primary,
                    ),
                    gapH14,
                    AppText.primary(
                      "Rs. 100",
                      fontFamily: FontFamilyType.inter,
                      fontSize: 14,
                      fontWeight: FontWeightType.semiBold,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
            gapH14,
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            gapH14,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.primary(
                  "Total:",
                  fontFamily: FontFamilyType.inter,
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.primary,
                ),
                AppText.primary(
                  "Rs. 1,090",
                  fontFamily: FontFamilyType.inter,
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.primary,
                ),
              ],
            ),
            gapH8,
          ],
        ),
      ),
    );
  }

  Widget _buildOrderPrescriptionInfo() {
    final order = widget.controller.order.value;
    if (order != null) {
      return const SizedBox.shrink();
    }
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppText.primary(
                  "Prescription Info",
                  fontFamily: FontFamilyType.poppins,
                  fontSize: 12,
                  fontWeight: FontWeightType.regular,
                  color: AppColors.black,
                ),
                AppText.primary(
                  "(Visible only if applicable)",
                  fontFamily: FontFamilyType.poppins,
                  fontSize: 12,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.accent,
                ),
              ],
            ),
            gapH14,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconTextRowItem(
                  iconWidget:
                      AppIcon.icPrescription.widget(width: 12, height: 12),
                  text: "Prescribed by: Dr. Ahsan",
                ),
                gapH14,
                IconTextRowItem(
                  iconWidget:
                      AppIcon.datePickerIcon.widget(width: 12, height: 12),
                  text: "Session Date: July 6, 2025",
                ),
              ],
            ),
            gapH8,
          ],
        ),
      ),
    );
  }

  Widget _buildSelectStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Order Status',
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH8,
        SizedBox(
          height: 40,
          child: Obx(() => DropdownButtonFormField<String>(
                initialValue: widget.controller.selectedStatus.value,
                hint: AppText.primary('Select Status'),
                isExpanded: true,
                items: widget.controller.availableStatuses.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: AppText.primary(status, fontSize: 12),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  widget.controller.updateStatus(newValue);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey60.withValues(alpha: 0.1),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.accent,
                    size: 20.0,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  @override
  void setupAdditionalListeners() {}
}
