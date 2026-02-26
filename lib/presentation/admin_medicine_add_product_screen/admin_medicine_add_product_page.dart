import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/custom_check_box.dart';
import 'package:recovery_consultation_app/presentation/widgets/text_field/custom_text_form_field.dart';
import 'package:recovery_consultation_app/presentation/widgets/textfield/primary_textfield.dart';

import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/button/left_icon_button.dart';
import '../widgets/common/icon_text_row_item.dart';
import '../widgets/common/recovery_app_bar.dart';
import 'admin_medicine_add_product_controller.dart';

class AdminMedicineAddProductPage
    extends BaseStatefulPage<AdminMedicineAddProductController> {
  const AdminMedicineAddProductPage({super.key});

  @override
  BaseStatefulPageState<AdminMedicineAddProductController> createState() =>
      _AdminMedicineAddProductPageState();
}

class _AdminMedicineAddProductPageState
    extends BaseStatefulPageState<AdminMedicineAddProductController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: widget.controller.isEditMode ? 'Edit Medicine Product' : 'Add Medicine Product',
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
                  AppText.primary(
                    "Add New Product",
                    fontFamily: FontFamilyType.poppins,
                    fontSize: 14,
                    fontWeight: FontWeightType.semiBold,
                    color: AppColors.primary,
                  ),
                  gapH14,
                  Container(
                    height: 1.0,
                    color: AppColors.lightDivider,
                  ),
                  _buildTitleField(
                    "Medicine Name",
                    "Paracetamol 500mg ",
                    false,
                    widget.controller.nameController,
                  ),
                  gapH14,
                  _buildImagePicker(),
                  gapH14,
                  Row(
                    children: [
                      Expanded(
                        child: _buildCategoryField(),
                      ),
                      gapW14,
                      Expanded(
                        child: _buildTitleField(
                          "Price",
                          "Rs. 500",
                          false,
                          widget.controller.priceController,
                        ),
                      ),
                    ],
                  ),
                  gapH14,
                  Row(
                    children: [
                      Expanded(
                        child: _buildTitleField(
                          "Stock Quantity",
                          "100",
                          false,
                          widget.controller.stockQuantityController,
                        ),
                      ),
                      gapW14,
                      Expanded(
                        child: _buildAvailabilityStatusField(),
                      ),
                    ],
                  ),
                  gapH14,
                  _buildTitleField(
                    "Ingredients",
                    "Acetaminophen",
                    false,
                    widget.controller.ingrediantValueController,
                  ),
                  gapH14,
                  _buildDosageSection(),
                  gapH14,
                  Row(
                    children: [
                      Expanded(
                        child: _buildDiscountTypeField(),
                      ),
                      gapW14,
                      Expanded(
                        child: _buildTitleField(
                          "Discount Value",
                          "10",
                          false,
                          widget.controller.discountValueController,
                        ),
                      ),
                    ],
                  ),
                  _buildTitleFieldDescription(
                    "How to Use",
                    "1 tab × 3/day after meals ",
                    false,
                    widget.controller.howToUseController,
                  ),
                  _buildTitleFieldDescription(
                    "Description",
                    "Used for pain relief and reducing fever.",
                    false,
                    widget.controller.descriptionController,
                  ),
                  gapH14,
                  IconTextRowItem(
                    iconWidget:
                        AppIcon.icProductVisibilty.widget(width: 14, height: 15),
                    text: "Product Visibility ",
                  ),
                  gapH14,
                  GestureDetector(
                    onTap: () => widget.controller.toggleVisibility(),
                    child: Obx(() => Row(
                          children: [
                            CustomCheckbox(
                                isSelected: widget.controller
                                    .isVisibleToCustomers.value),
                            gapW12,
                            AppText.primary(
                              "Visible to Customers",
                              fontSize: 14,
                              fontWeight: FontWeightType.regular,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        )),
                  ),
                  gapH20,
                  _buildCreateBannerButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Obx(() {
      final controller = widget.controller;
      final totalImages = controller.totalImageCount;
      final selectedIndex = controller.selectedImageIndex.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main preview area (card with centered image)
          GestureDetector(
            onTap: totalImages == 0 ? () => controller.pickImage() : null,
            child: Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.whiteLightAlt),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.whiteLightAlt,
              ),
              child: totalImages == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcon.icAddBannerImage.widget(width: 30.0, height: 30.0),
                        gapH10,
                        AppText.primary(
                          'Upload Image',
                          color: AppColors.accent,
                          fontWeight: FontWeightType.bold,
                          fontSize: 12.0,
                        ),
                        gapH10,
                        AppText.primary(
                          'Select JPG/PNG (1:1 ratio) ',
                          color: AppColors.grey50,
                          fontWeight: FontWeightType.regular,
                          fontSize: 8.0,
                        ),
                      ],
                    )
                  : Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: _buildPreviewImage(selectedIndex),
                        ),
                      ),
                    ),
            ),
          ),
          gapH10,
          // Thumbnail row
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: totalImages + (totalImages < AdminMedicineAddProductController.maxImages ? 1 : 0),
              separatorBuilder: (_, __) => gapW8,
              itemBuilder: (context, index) {
                // Last item is the "Add" button
                if (index == totalImages) {
                  return _buildAddImageButton();
                }
                return _buildThumbnail(index);
              },
            ),
          ),
        ],
      );
    });
  }

  /// Build the main preview image based on index
  Widget _buildPreviewImage(int index) {
    final controller = widget.controller;
    final existingCount = controller.existingImageUrls.length;

    if (index < existingCount) {
      // Existing network image
      return Image.network(
        controller.existingImageUrls[index],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, size: 40, color: AppColors.grey50),
          );
        },
      );
    } else {
      // Locally picked image
      final localIndex = index - existingCount;
      if (localIndex < controller.images.length) {
        return Image.file(
          controller.images[localIndex],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
      return const SizedBox.shrink();
    }
  }

  /// Build a thumbnail with selection border and remove button
  Widget _buildThumbnail(int index) {
    final controller = widget.controller;
    final isSelected = controller.selectedImageIndex.value == index;
    final existingCount = controller.existingImageUrls.length;

    return GestureDetector(
      onTap: () => controller.selectImage(index),
      child: Stack(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.whiteLightAlt,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: index < existingCount
                  ? Image.network(
                      controller.existingImageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 20, color: AppColors.grey50);
                      },
                    )
                  : Image.file(
                      controller.images[index - existingCount],
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          // Remove button
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => controller.removeImage(index),
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the "Add image" button in the thumbnail row
  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: () => widget.controller.pickImage(),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.whiteLightAlt),
          color: AppColors.whiteLightAlt,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 24, color: AppColors.accent),
            SizedBox(height: 2),
            Text(
              'Add',
              style: TextStyle(fontSize: 10, color: AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDosageSection() {
    return Obx(() {
      final controller = widget.controller;
      final isEditing = controller.editingDosageIndex.value >= 0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapH10,
          AppText.primary(
            "Dosage Variants",
            fontFamily: FontFamilyType.poppins,
            fontSize: 12,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.primary,
          ),
          gapH8,
          // Dosage input field
          PrimaryTextField(
            controller: controller.dosageInputController,
            hintText: "e.g. 500mg",
            height: 50,
            radius: 6,
            readOnly: false,
            showBorder: false,
            backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          ),
          gapH8,
          // Price and Stock row for this dosage
          Row(
            children: [
              Expanded(
                child: PrimaryTextField(
                  controller: controller.dosagePriceController,
                  hintText: "Price",
                  height: 50,
                  radius: 6,
                  readOnly: false,
                  showBorder: false,
                  backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                ),
              ),
              gapW14,
              Expanded(
                child: PrimaryTextField(
                  controller: controller.dosageStockController,
                  hintText: "Stock Qty",
                  height: 50,
                  radius: 6,
                  readOnly: false,
                  showBorder: false,
                  backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                ),
              ),
            ],
          ),
          gapH8,
          // Add / Update button row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.addOrUpdateDosageVariant(),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isEditing ? Icons.check : Icons.add,
                          color: AppColors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        AppText.primary(
                          isEditing ? "Update" : "Add Dosage",
                          fontSize: 12,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isEditing) ...[
                gapW8,
                GestureDetector(
                  onTap: () => controller.cancelDosageEdit(),
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.grey60.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: AppText.primary(
                        "Cancel",
                        fontSize: 12,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          // Dosage variant cards
          if (controller.dosageVariants.isNotEmpty) ...[
            gapH10,
            ...controller.dosageVariants.asMap().entries.map((entry) {
              final index = entry.key;
              final variant = entry.value;
              return _buildDosageCard(variant, index);
            }),
          ],
        ],
      );
    });
  }

  Widget _buildDosageCard(DosageVariant variant, int index) {
    final isEditing = widget.controller.editingDosageIndex.value == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isEditing
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.grey60.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: isEditing
            ? Border.all(color: AppColors.primary, width: 1)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.primary(
                  '${variant.dosage} mg',
                  fontSize: 14,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.textPrimary,
                ),
                gapH4,
                Row(
                  children: [
                    AppText.primary(
                      "Rs. ${variant.price.toStringAsFixed(2)}",
                      fontSize: 12,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 16),
                    AppText.primary(
                      "Stock: ${variant.stockQuantity}",
                      fontSize: 12,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.grey50,
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => widget.controller.editDosageVariant(index),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.edit_outlined, size: 18, color: AppColors.accent),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => widget.controller.removeDosageVariant(index),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.delete_outline, size: 18, color: Colors.red),
            ),
          ),
        ],
      ),
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
        gapH10,
        AppText.primary(
          name,
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH8,
        PrimaryTextField(
          controller: controller,
          hintText: hintText,
          height: 50,
          radius: 6,
          readOnly: false,
          suffixIcon:
              isShowIcon ? const Icon(Icons.keyboard_arrow_down_rounded) : null,
          showBorder: false,
          backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapH10,
        AppText.primary(
          "Category",
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH8,
        SizedBox(
          height: 50,
          child: Obx(() => DropdownButtonFormField<String>(
                initialValue: widget.controller.selectedCategory.value,
                isExpanded: true,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    widget.controller.setCategory(newValue);
                  }
                },
                items: widget.controller.categories
                    .map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: AppText.primary(
                      category,
                      fontSize: 14,
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey60.withValues(alpha: 0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accent),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildDiscountTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapH10,
        AppText.primary(
          "Discount Type",
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH8,
        SizedBox(
          height: 50,
          child: Obx(() => DropdownButtonFormField<String>(
                initialValue: widget.controller.selectedDiscountType.value,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    widget.controller.setDiscountType(newValue);
                  }
                },
                items: widget.controller.discountTypes
                    .map<DropdownMenuItem<String>>((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: AppText.primary(
                      type,
                      fontSize: 14,
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey60.withValues(alpha: 0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accent,),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildAvailabilityStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapH10,
        AppText.primary(
          "Availability Status",
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH8,
        SizedBox(
          height: 50,
          child: Obx(() => DropdownButtonFormField<MedicineStockStatus>(
                initialValue: widget.controller.stockStatus.value,
                onChanged: (MedicineStockStatus? newValue) {
                  if (newValue != null) {
                    widget.controller.setStockStatus(newValue);
                  }
                },
                items: MedicineStockStatus.values
                    .map<DropdownMenuItem<MedicineStockStatus>>(
                        (MedicineStockStatus status) {
                  return DropdownMenuItem<MedicineStockStatus>(
                    value: status,
                    child: AppText.primary(
                      status.toString().split('.').last,
                      fontSize: 14,
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey60.withValues(alpha: 0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accent,),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildTitleFieldDescription(
    String name,
    String hintText,
    bool isShowIcon,
    TextEditingController controller,
  ) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      gapH10,
      AppText.primary(
        name,
        fontFamily: FontFamilyType.poppins,
        fontSize: 12,
        fontWeight: FontWeightType.semiBold,
        color: AppColors.primary,
      ),
      gapH8,
      CustomTextFormField(
        controller: controller,
        hintText: hintText,
        maxLines: 3,
        minLines: 3,
      ),
    ]);
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
            title: "Save Product",
            height: 35.0,
            color: AppColors.checkedColor,
            textColor: AppColors.white,
            borderColor: AppColors.checkedColor,
            iconColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            onPressed: () => widget.controller.addProduct(),
            icon: Icons.bookmark,
          ),
        ),
      ],
    );
  }

  @override
  void setupAdditionalListeners() {}
}
