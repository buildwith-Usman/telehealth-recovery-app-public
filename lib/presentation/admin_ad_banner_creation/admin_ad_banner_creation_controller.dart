import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/data/api/request/create_ad_banner_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_ad_banner_request.dart';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/create_ad_banner_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/update_ad_banner_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/upload_file_use_case.dart';
import 'package:recovery_consultation_app/presentation/admin_manage_ad_banner/admin_manage_ad_banner_controller.dart';

enum BannerStatus { active, inactive }

class AdminAdBannerCreationController extends BaseController {
  AdminAdBannerCreationController({
    required this.uploadFileUseCase,
    required this.createAdBannerUseCase,
    required this.updateAdBannerUseCase,
  });

  final UploadFileUseCase uploadFileUseCase;
  final CreateAdBannerUseCase createAdBannerUseCase;
  final UpdateAdBannerUseCase updateAdBannerUseCase;
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  final _image = Rx<File?>(null);

  File? get image => _image.value;

  final _uploadedImageId = Rx<int?>(null);

  int? get uploadedImageId => _uploadedImageId.value;

  final _existingImageUrl = Rx<String?>(null);

  String? get existingImageUrl => _existingImageUrl.value;

  final _isUploadingImage = false.obs;

  bool get isUploadingImage => _isUploadingImage.value;

  final _startDate = Rx<DateTime?>(null);

  DateTime? get startDate => _startDate.value;

  final _endDate = Rx<DateTime?>((null));

  DateTime? get endDate => _endDate.value;

  final status = BannerStatus.active.obs;

  final isSaving = false.obs;

  // For edit mode
  AdBannerModel? existingBanner;
  bool isEditMode = false;

  @override
  void onInit() {
    super.onInit();
    _checkEditMode();
  }

  void _checkEditMode() {
    final args = Get.arguments;
    if (args != null && args is Map) {
      isEditMode = args[Arguments.isEdit] ?? false;
      existingBanner = args[Arguments.banner] as AdBannerModel?;

      if (isEditMode && existingBanner != null) {
        _loadBannerData(existingBanner!);
      }
    }
  }

  void _loadBannerData(AdBannerModel banner) {
    titleController.text = banner.title;
    // Parse dates from raw ISO format
    try {
      _startDate.value = DateTime.parse(banner.startDateRaw);
      if (banner.endDateRaw != null) {
        _endDate.value = DateTime.parse(banner.endDateRaw!);
      }
    } catch (e) {
      logger.error('Failed to parse dates: $e');
      // If parsing fails, leave dates as null
    }

    // Set status based on banner.isActive
    status.value = banner.isActive ? BannerStatus.active : BannerStatus.inactive;

    // Store existing image URL to display in edit mode
    _existingImageUrl.value = banner.imageUrl;
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final selectedFile = File(pickedFile.path);
      _image.value = selectedFile;

      // Clear existing image URL when new image is selected
      _existingImageUrl.value = null;

      // Immediately upload the image and get image_id
      await _uploadImage(selectedFile);
    }
  }

  /// Upload image and store the image_id
  Future<void> _uploadImage(File imageFile) async {
    _isUploadingImage.value = true;
    _uploadedImageId.value = null; // Reset previous image_id

    try {
      final uploadResult = await executeApiCall<FileEntity?>(
        () => uploadFileUseCase.execute(
          UploadFileParams(
            file: imageFile,
            directory: 'profile', // Using 'profile' directory as per API pattern
          ),
        ),
        onSuccess: () {
          logger.method('✅ Image uploaded successfully');
        },
        onError: (errorMessage) {
          logger.error('❌ Failed to upload image: $errorMessage');
          // Clear the selected image if upload fails
          _image.value = null;
        },
      );

      if (uploadResult != null) {
        _uploadedImageId.value = uploadResult.id;
        logger.method('✅ Image ID stored: ${uploadResult.id}');
      } else {
        // Clear the selected image if upload fails
        _image.value = null;
      }
    } catch (e) {
      logger.error('❌ Unexpected error uploading image: $e');
      // Clear the selected image if upload fails
      _image.value = null;
    } finally {
      _isUploadingImage.value = false;
    }
  }

  void setStartDate(DateTime date) {
    _startDate.value = date;
  }

  void setEndDate(DateTime date) {
    _endDate.value = date;
  }

  void setStatus(BannerStatus newStatus) {
    status.value = newStatus;
  }

  bool _validateBannerData() {
    if (titleController.text.trim().isEmpty) {
      logger.warning('Validation failed: Title is empty');
      return false;
    }

    // In edit mode, image is optional (keep existing if not changed)
    // In create mode, image is required
    if (!isEditMode && _uploadedImageId.value == null) {
      logger.warning('Validation failed: No image uploaded');
      return false;
    }

    if (_isUploadingImage.value) {
      logger.warning('Validation failed: Image is still uploading');
      return false;
    }

    if (_startDate.value == null) {
      logger.warning('Validation failed: No start date selected');
      return false;
    }

    if (_endDate.value != null && _startDate.value != null) {
      if (_endDate.value!.isBefore(_startDate.value!)) {
        logger.warning('Validation failed: End date is before start date');
        return false;
      }
    }

    return true;
  }

  Future<void> saveBanner() async {
    // Validate banner data
    if (!_validateBannerData()) {
      return;
    }

    isSaving.value = true;

    try {
      if (isEditMode && existingBanner != null) {
        // UPDATE MODE
        await _updateBanner();
      } else {
        // CREATE MODE
        await _createBanner();
      }
    } catch (e) {
      logger.error('❌ Unexpected error saving banner: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> _createBanner() async {
    // Use the already uploaded image_id
    final imageId = _uploadedImageId.value;

    if (imageId == null) {
      logger.error('Image ID is null. Cannot create banner.');
      return;
    }

    // Format date as DD-MM-YYYY
    final formattedStartDate = _formatDateForApi(_startDate.value!);

    // Map status enum to string
    final statusString = _statusToString(status.value);

    // Create request
    final request = CreateAdBannerRequest(
      title: titleController.text.trim(),
      imageId: imageId,
      status: statusString,
      startDate: formattedStartDate,
    );

    // Create banner
    final result = await executeApiCall(
      () => createAdBannerUseCase.execute(request),
      onSuccess: () {
        logger.method('✅ Ad banner created successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to create ad banner: $errorMessage');
      },
    );

    if (result != null) {
      logger.method('✅ Navigating back after successful banner creation');
      Get.back();
    } else {
      logger.error('Banner creation returned null result');
    }
  }

  Future<void> _updateBanner() async {
    // Parse banner ID from string
    final bannerId = int.tryParse(existingBanner!.id);
    if (bannerId == null) {
      logger.error('Invalid banner ID: ${existingBanner!.id}');
      return;
    }

    // Format dates as DD-MM-YYYY
    final formattedStartDate = _formatDateForApi(_startDate.value!);
    final formattedEndDate = _endDate.value != null
        ? _formatDateForApi(_endDate.value!)
        : null;

    // Map status enum to string
    final statusString = _statusToString(status.value);

    // Build update request with optional fields
    final request = UpdateAdBannerRequest(
      title: titleController.text.trim(),
      imageId: _uploadedImageId.value, // null if no new image uploaded
      status: statusString,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
    );

    logger.method('🔍 Updating banner ID: $bannerId');

    // Update banner
    final result = await executeApiCall(
      () => updateAdBannerUseCase.execute(
        UpdateAdBannerParams(
          id: bannerId,
          request: request,
        ),
      ),
      onSuccess: () {
        logger.method('✅ Ad banner updated successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to update ad banner: $errorMessage');
      },
    );

    if (result != null) {
      logger.method('✅ Navigating back after successful banner update');
      Get.back();
    } else {
      logger.error('Banner update returned null result');
    }
  }

  /// Format DateTime to DD-MM-YYYY format for API
  String _formatDateForApi(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  /// Convert BannerStatus enum to API string
  String _statusToString(BannerStatus status) {
    switch (status) {
      case BannerStatus.active:
        return 'active';
      case BannerStatus.inactive:
        return 'inactive';
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.onClose();
  }
}
