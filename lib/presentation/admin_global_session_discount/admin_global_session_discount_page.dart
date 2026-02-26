import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_app_bar.dart';

import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/button/left_icon_button.dart';
import '../widgets/textfield/primary_textfield.dart';
import 'admin_global_session_discount_controller.dart';

class AdminGlobalSessionDiscountPage
    extends BaseStatefulPage<AdminGlobalSessionDiscountController> {
  const AdminGlobalSessionDiscountPage({super.key});

  @override
  BaseStatefulPageState<AdminGlobalSessionDiscountController> createState() =>
      _AdminGlobalSessionDiscountPageState();
}

class _AdminGlobalSessionDiscountPageState
    extends BaseStatefulPageState<AdminGlobalSessionDiscountController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Global Session Discount',
      showBackButton: true,
      onBackPressed: () => Get.back(),
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: widget.controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDiscountTitleField(),
                  gapH14,
                  _buildDiscountApplyOnField(),
                  gapH14,
                  Row(
                    children: [
                      Expanded(child: _buildDiscountTypeField()),
                      gapW14,
                      Expanded(child: _buildDiscountValueField()),
                    ],
                  ),
                  gapH14,
                  Row(
                    children: [
                      Expanded(child: _buildDatePicker('Valid From')),
                      gapW14,
                      Expanded(child: _buildDatePicker('Valid Till')),
                    ],
                  ),
                  gapH14,
                  _buildLimitFieldTitle(),
                  gapH14,
                  _buildStatusField(),
                  gapH30,
                  _buildCreateBannerButtons()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountTitleField() {
    return _buildTitleField(
      "Discount Title",
      "Summer Deal, July Special",
      false,
      widget.controller.discountTitleController,
    );
  }

  Widget _buildDiscountApplyOnField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppText.primary(
          'Discount Apply On',
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        Obx(() => Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: const Color(0xFFDEDEDE),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<DiscountApplyOn>(
                    value: DiscountApplyOn.session,
                    groupValue: widget.controller.discountApplyOn.value,
                    activeColor: AppColors.accent,
                    onChanged: (value) {
                      widget.controller.setDiscountApplyOn(value!);
                    },
                  ),
                  AppText.primary(
                    'Session',
                    fontSize: 12.0,
                    fontFamily: FontFamilyType.poppins,
                    color: AppColors.grey60,
                    fontWeight: FontWeightType.medium,
                  ),
                  gapW40,
                  Radio<DiscountApplyOn>(
                    value: DiscountApplyOn.pharmacy,
                    groupValue: widget.controller.discountApplyOn.value,
                    activeColor: AppColors.accent,
                    onChanged: (value) {
                      widget.controller.setDiscountApplyOn(value!);
                    },
                  ),
                  AppText.primary(
                    'Pharmacy',
                    fontSize: 12.0,
                    fontFamily: FontFamilyType.poppins,
                    color: AppColors.grey60,
                    fontWeight: FontWeightType.medium,
                  )
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildDiscountTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          "Discount Type",
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH8,
        SizedBox(
          height: 40,
          child: Obx(() => DropdownButtonFormField<String>(
                initialValue: widget.controller.selectedDiscountType.value,
                isExpanded: true,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    widget.controller.setDiscountType(newValue);
                  }
                },
                items: widget.controller.discountTypes
                    .map<DropdownMenuItem<String>>((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: AppText.primary(type, fontSize: 14),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey60.withValues(alpha: 0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9.0),
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

  Widget _buildDiscountValueField() {
    return _buildTitleField(
      "Discount Value",
      "10",
      false,
      widget.controller.discountValueController,
    );
  }

  Widget _buildDatePicker(String title) {
    final isFromDate = title == 'Valid From';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          title,
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH10,
        GestureDetector(
          onTap: () async {
            final date = await _selectDate();
            if (date != null) {
              if (isFromDate) {
                widget.controller.setFromDate(date);
              } else {
                widget.controller.setToDate(date);
              }
            }
          },
          child: Obx(() {
            final date = isFromDate
                ? widget.controller.fromDate.value
                : widget.controller.toDate.value;
            return Container(
              height: 40.0,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyF7),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.greyF7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  AppText.primary(
                    date != null
                        ? '${date.toLocal()}'.split(' ')[0]
                        : isFromDate
                            ? '01 July 2025'
                            : '15 July 2025',
                    fontSize: 12.0,
                    fontFamily: FontFamilyType.poppins,
                    fontWeight: FontWeightType.regular,
                    color: AppColors.grey50,
                  ),
                  gapW20,
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.0,
                    color: AppColors.accent,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<DateTime?> _selectDate() async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  Widget _buildStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Status',
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH8,
        GestureDetector(
          onTap: () {
            final currentStatus = widget.controller.status.value;
            final nextStatus = DiscountStatus.values[
                (currentStatus.index + 1) % DiscountStatus.values.length];
            widget.controller.setStatus(nextStatus);
          },
          child: Obx(() {
            final status = widget.controller.status.value;
            String statusText;
            Color statusColor;
            Widget statusIcon;

            switch (status) {
              case DiscountStatus.active:
                statusText = 'Active';
                statusColor = Colors.green;
                statusIcon = const Icon(
                  Icons.check_box,
                  color: Colors.green,
                  size: 12.0,
                );
                break;
              case DiscountStatus.inactive:
                statusText = 'Inactive';
                statusColor = AppColors.grey50;
                statusIcon = const Icon(
                  Icons.check_box_outline_blank,
                  color: AppColors.grey50,
                  size: 12.0,
                );
                break;
              case DiscountStatus.scheduled:
                statusText = 'Scheduled';
                statusColor = AppColors.grey50;
                statusIcon = const Icon(
                  Icons.check_box_outline_blank,
                  color: AppColors.grey50,
                  size: 12.0,
                );
                break;
            }

            return Container(
              height: 40.0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.grey60.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText.primary(
                    statusText,
                    color: statusColor,
                    fontWeight: FontWeightType.regular,
                    fontSize: 12.0,
                    fontFamily: FontFamilyType.poppins,
                  ),
                  statusIcon,
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCreateBannerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LeftIconButton(
            title: "Cancel",
            height: 35.0,
            color: AppColors.textPrimary,
            textColor: AppColors.white,
            borderColor: AppColors.textPrimary,
            iconColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            onPressed: () => Get.back(),
            icon: Icons.block,
          ),
        ),
        gapW10,
        Expanded(
          child: LeftIconButton(
            title: "Save",
            height: 35.0,
            color: AppColors.checkedColor,
            textColor: AppColors.white,
            borderColor: AppColors.checkedColor,
            iconColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            onPressed: () => Get.back(),
            icon: Icons.bookmark,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(
    String name,
    String hintText,
    bool isShowIcon,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          name,
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.bold,
          color: AppColors.primary,
        ),
        gapH8,
        PrimaryTextField(
          controller: controller,
          hintText: hintText,
          height: 40,
          radius: 5,
          readOnly: false,
          suffixIcon:
              isShowIcon ? const Icon(Icons.keyboard_arrow_down_rounded) : null,
          showBorder: false,
          backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13.0),
        ),
      ],
    );
  }

  Widget _buildLimitFieldTitle() {
    return _buildLimitField('Limit per User', '1 time', false,
        widget.controller.discountTitleController, '(Optional)');
  }

  Widget _buildLimitField(
    String name,
    String hintText,
    bool isShowIcon,
    TextEditingController controller,
    String optional,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText.primary(
              name,
              fontFamily: FontFamilyType.poppins,
              fontSize: 12,
              fontWeight: FontWeightType.bold,
              color: AppColors.primary,
            ),
            gapW6,
            AppText.primary(
              optional,
              fontFamily: FontFamilyType.poppins,
              fontSize: 12,
              fontWeight: FontWeightType.light,
              color: AppColors.grey50,
            ),
          ],
        ),
        gapH8,
        PrimaryTextField(
          controller: controller,
          hintText: hintText,
          height: 40,
          radius: 5,
          readOnly: false,
          suffixIcon:
              isShowIcon ? const Icon(Icons.keyboard_arrow_down_rounded) : null,
          showBorder: false,
          backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13.0),
        ),
      ],
    );
  }

  @override
  void setupAdditionalListeners() {}
}
