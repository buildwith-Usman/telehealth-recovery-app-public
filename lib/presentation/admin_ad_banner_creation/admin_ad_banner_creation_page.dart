import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_app_bar.dart';

import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/button/left_icon_button.dart';
import '../widgets/textfield/primary_textfield.dart';
import 'admin_ad_banner_creation_controller.dart';

class AdminAdBannerCreationPage
    extends BaseStatefulPage<AdminAdBannerCreationController> {
  const AdminAdBannerCreationPage({super.key});

  @override
  BaseStatefulPageState<AdminAdBannerCreationController> createState() =>
      _AdminAdBannerCreationPageState();
}

class _AdminAdBannerCreationPageState
    extends BaseStatefulPageState<AdminAdBannerCreationController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Ad Banner Creation',
      showBackButton: true,
      onBackPressed: () => Get.back(),
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Form(
      key: widget.controller.formKey,
      child: SingleChildScrollView(
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTitleField(),
                  gapH14,
                  _buildImagePicker(),
                  gapH20,
                  _buildDatePickers(),
                  gapH14,
                  _buildStatusField(),
                  gapH30,
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
    return GestureDetector(
      onTap: () => widget.controller.pickImage(),
      child: Obx(() {
        final image = widget.controller.image;
        final existingImageUrl = widget.controller.existingImageUrl;
        final hasImageId = widget.controller.uploadedImageId != null;
        final hasImage = image != null || existingImageUrl != null;

        return Container(
          width: double.infinity,
          constraints: hasImage
              ? const BoxConstraints(minHeight: 100.0)
              : const BoxConstraints(minHeight: 130.0, maxHeight: 130.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.whiteLightAlt),
              borderRadius: BorderRadius.circular(10),
              color: AppColors.whiteLightAlt),
          child: hasImage
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: image != null
                          ? Image.file(
                              image,
                              fit: BoxFit.contain,
                              width: double.infinity,
                            )
                          : Image.network(
                              existingImageUrl!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                      gapH8,
                                      AppText.primary(
                                        'Failed to load image',
                                        fontSize: 10,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    if (hasImageId)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 14,
                                color: Colors.white,
                              ),
                              gapW4,
                              AppText.primary(
                                'Uploaded',
                                fontSize: 10,
                                fontWeight: FontWeightType.semiBold,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Edit icon overlay for existing network image
                    if (existingImageUrl != null && image == null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                )
              : Column(
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
                      'Select JPG/PNG (4:1 ratio) ',
                      color: AppColors.grey50,
                      fontWeight: FontWeightType.regular,
                      fontSize: 8.0,
                    ),
                  ],
                ),
        );
      }),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          "Title",
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.primary,
        ),
        gapH8,
        PrimaryTextField(
          controller: widget.controller.titleController,
          hintText: "Enter banner title",
          height: 50,
          radius: 6,
          readOnly: false,
          showBorder: false,
          backgroundColor: AppColors.grey60.withValues(alpha: 0.1),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          "Status",
          fontFamily: FontFamilyType.poppins,
          fontSize: 12,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH8,
        GestureDetector(
          onTap: () {
            final currentStatus = widget.controller.status.value;
            final nextStatus = BannerStatus
                .values[(currentStatus.index + 1) % BannerStatus.values.length];
            widget.controller.setStatus(nextStatus);
          },
          child: Obx(() {
            final status = widget.controller.status.value;
            String statusText;
            Color statusColor;
            Widget statusIcon;

            switch (status) {
              case BannerStatus.active:
                statusText = 'Active';
                statusColor = AppColors.grey50;
                statusIcon = const Icon(Icons.check_box,
                    color: Colors.green, size: 18.0);
                break;
              case BannerStatus.inactive:
                statusText = 'Inactive';
                statusColor = AppColors.grey50;
                statusIcon = const Icon(Icons.close,
                    color: AppColors.red513, size: 18.0);
                break;
            }

            return Container(
              height: 50,
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
                    fontWeight: FontWeightType.semiBold,
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

  Widget _buildDatePickers() {
    return Row(
      children: [
        Expanded(child: _buildStartDatePicker()),
        gapW20,
        Expanded(child: _buildEndDatePicker()),
      ],
    );
  }

  Widget _buildStartDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Start Date',
          fontSize: 12.0,
          fontWeight: FontWeightType.semiBold,
          fontFamily: FontFamilyType.poppins,
        ),
        gapH10,
        GestureDetector(
          onTap: () async {
            final date = await _selectDate();
            if (date != null) {
              widget.controller.setStartDate(date);
            }
          },
          child: Obx(() {
            final startDate = widget.controller.startDate;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyF7),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.greyF7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: AppText.primary(
                      startDate != null
                          ? '${startDate.toLocal()}'.split(' ')[0]
                          : 'Pick Date & Time',
                      fontSize: 12.0,
                      fontFamily: FontFamilyType.poppins,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.grey50,
                    ),
                  ),
                  gapW8,
                  const Icon(
                    Icons.edit,
                    size: 14.0,
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

  Widget _buildEndDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'End Date',
          fontSize: 12.0,
          fontWeight: FontWeightType.semiBold,
          fontFamily: FontFamilyType.poppins,
        ),
        gapH10,
        GestureDetector(
          onTap: () async {
            final date = await _selectDate();
            if (date != null) {
              widget.controller.setEndDate(date);
            }
          },
          child: Obx(() {
            final endDate = widget.controller.endDate;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.greyF7),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.greyF7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: AppText.primary(
                      endDate != null
                          ? '${endDate.toLocal()}'.split(' ')[0]
                          : 'Optional',
                      fontSize: 12.0,
                      fontFamily: FontFamilyType.poppins,
                      fontWeight: FontWeightType.regular,
                      color: AppColors.grey50,
                    ),
                  ),
                  gapW8,
                  const Icon(
                    Icons.edit,
                    size: 14.0,
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

  void _showImagePreviewDialog() {
    final image = widget.controller.image;
    final existingImageUrl = widget.controller.existingImageUrl;

    if (image == null && existingImageUrl == null) {
      Get.snackbar(
        'No Image Selected',
        'Please select an image to preview.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red513,
        colorText: AppColors.white,
      );
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText.primary(
                        'Banner Preview',
                        fontSize: 18,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.black,
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 24,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Banner Preview (Pharmacy Style)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  constraints: const BoxConstraints(minHeight: 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.whiteLightAlt,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: image != null
                        ? Image.file(
                            image,
                            fit: BoxFit.contain,
                            width: double.infinity,
                          )
                        : Image.network(
                            existingImageUrl!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    gapH8,
                                    AppText.primary(
                                      'Failed to load image',
                                      fontSize: 12,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
                gapH20,
                // Close Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: AppText.primary(
                        'Close Preview',
                        fontSize: 14,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BannerStatus status) {
    switch (status) {
      case BannerStatus.active:
        return Colors.green;
      case BannerStatus.inactive:
        return AppColors.red513;
    }
  }

  IconData _getStatusIcon(BannerStatus status) {
    switch (status) {
      case BannerStatus.active:
        return Icons.check_circle;
      case BannerStatus.inactive:
        return Icons.cancel;
    }
  }

  String _getStatusText(BannerStatus status) {
    switch (status) {
      case BannerStatus.active:
        return 'Active';
      case BannerStatus.inactive:
        return 'Inactive';
    }
  }

  Widget _buildCreateBannerButtons() {
    return Obx(() {
      final isSaving = widget.controller.isSaving.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: LeftIconButton(
              title: "Preview",
              height: 35.0,
              color: AppColors.textPrimary,
              textColor: AppColors.white,
              borderColor: AppColors.textPrimary,
              iconColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              onPressed: isSaving ? () {} : _showImagePreviewDialog,
              icon: Icons.remove_red_eye,
            ),
          ),
          gapW10,
          Expanded(
            child: isSaving
                ? Container(
                    height: 35.0,
                    decoration: BoxDecoration(
                      color: AppColors.checkedColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      ),
                    ),
                  )
                : LeftIconButton(
                    title: "Save Banner",
                    height: 35.0,
                    color: AppColors.checkedColor,
                    textColor: AppColors.white,
                    borderColor: AppColors.checkedColor,
                    iconColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    onPressed: () => widget.controller.saveBanner(),
                    icon: Icons.bookmark,
                  ),
          ),
        ],
      );
    });
  }

  @override
  void setupAdditionalListeners() {}
}
