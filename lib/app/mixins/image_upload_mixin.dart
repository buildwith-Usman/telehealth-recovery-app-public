import 'dart:io';
import 'package:get/get.dart';
import '../services/image_upload_service.dart';

/// Mixin to provide image upload functionality to controllers
mixin ImageUploadMixin on GetxController {
  /// Selected image file (for single selection)
  final Rxn<File> selectedImage = Rxn<File>();
  
  /// Image upload service instance
  ImageUploadService get _imageUploadService => ImageUploadService.to;
  
  /// Whether image is being processed
  final RxBool isImageProcessing = false.obs;

  /// Show image picker with default configuration
  Future<void> showImagePicker({
    ImageUploadConfig? config,
    Function(File?)? onImageSelected,
  }) async {
    await showImagePickerWithConfig(
      config ?? const ImageUploadConfig(),
      onImageSelected,
    );
  }

  /// Show image picker with custom configuration
  Future<void> showImagePickerWithConfig(
    ImageUploadConfig config,
    Function(File?)? onImageSelected,
  ) async {
    isImageProcessing.value = true;
    
    try {
      final result = await _imageUploadService.showImagePicker(
        config: config,
        currentImage: selectedImage.value,
      );

      _handleImageResult(result, onImageSelected);
    } finally {
      isImageProcessing.value = false;
    }
  }

  /// Pick image from camera directly
  Future<void> pickFromCamera({
    ImageUploadConfig? config,
    Function(File?)? onImageSelected,
  }) async {
    isImageProcessing.value = true;
    
    try {
      final result = await _imageUploadService.pickFromCamera(
        config: config ?? const ImageUploadConfig(),
      );

      _handleImageResult(result, onImageSelected);
    } finally {
      isImageProcessing.value = false;
    }
  }

  /// Handle single image result
  void _handleImageResult(
    ImageUploadResult result, 
    Function(File?)? onImageSelected,
  ) {
    if (result.isSuccess) {
      selectedImage.value = result.file;
      onImageSelected?.call(result.file);
      _imageUploadService.showSuccessSnackbar('Image selected successfully');
    } else if (result.isRemoved) {
      selectedImage.value = null;
      onImageSelected?.call(null);
      _imageUploadService.showSuccessSnackbar('Image removed');
    } else if (result.isError) {
      _imageUploadService.showErrorSnackbar(result.error!);
    }
    // For cancelled, do nothing (no feedback needed)
  }

  /// Remove selected image
  void removeSelectedImage({Function(File?)? onImageRemoved}) {
    selectedImage.value = null;
    onImageRemoved?.call(null);
    _imageUploadService.showSuccessSnackbar('Image removed');
  }

  /// Get image display path for UI (handles both File and network URLs)
  String? getImageDisplayPath() {
    return selectedImage.value?.path;
  }

  /// Check if any image is selected
  bool get hasSelectedImage => selectedImage.value != null;

  /// Validate image file (size, format, etc.)
  bool validateImageFile(File file) {
    // Check file size (max 5MB)
    const maxSizeInBytes = 5 * 1024 * 1024;
    if (file.lengthSync() > maxSizeInBytes) {
      _imageUploadService.showErrorSnackbar('Image size must be less than 5MB');
      return false;
    }

    // Check file extension
    final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    final extension = file.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      _imageUploadService.showErrorSnackbar('Please select a valid image format');
      return false;
    }

    return true;
  }

  /// Create configuration for profile images
  static ImageUploadConfig createProfileImageConfig() {
    return const ImageUploadConfig(
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
      title: 'Update Profile Picture',
      showRemoveOption: true,
    );
  }

  /// Create configuration for document uploads
  static ImageUploadConfig createDocumentImageConfig() {
    return const ImageUploadConfig(
      maxWidth: 1200,
      maxHeight: 1600,
      imageQuality: 85,
      title: 'Upload Document',
      showRemoveOption: false,
    );
  }

  @override
  void onClose() {
    // Clean up resources
    selectedImage.close();
    isImageProcessing.close();
    super.onClose();
  }
}
