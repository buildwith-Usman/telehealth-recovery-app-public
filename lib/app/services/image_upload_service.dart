import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Configuration class for image upload options
class ImageUploadConfig {
  final double maxWidth;
  final double maxHeight;
  final int imageQuality;
  final String title;
  final String cameraText;
  final String removeText;
  final bool showRemoveOption;

  const ImageUploadConfig({
    this.maxWidth = 800,
    this.maxHeight = 800,
    this.imageQuality = 80,
    this.title = 'Select Image',
    this.cameraText = 'Camera',
    this.removeText = 'Remove Image',
    this.showRemoveOption = true,
  });
}

/// Result class for image selection
class ImageUploadResult {
  final File? file;
  final String? error;
  final bool wasRemoved;

  ImageUploadResult._({
    this.file,
    this.error,
    this.wasRemoved = false,
  });

  factory ImageUploadResult.success(File file) => ImageUploadResult._(file: file);
  factory ImageUploadResult.removed() => ImageUploadResult._(wasRemoved: true);
  factory ImageUploadResult.error(String error) => ImageUploadResult._(error: error);
  factory ImageUploadResult.cancelled() => ImageUploadResult._();

  bool get isSuccess => file != null;
  bool get isError => error != null;
  bool get isCancelled => file == null && error == null && !wasRemoved;
  bool get isRemoved => wasRemoved;
}

/// Centralized service for image upload functionality
class ImageUploadService extends GetxService {
  static ImageUploadService get to => Get.find<ImageUploadService>();
  
  final ImagePicker _imagePicker = ImagePicker();

  /// Show image selection bottom sheet with camera/gallery options
  Future<ImageUploadResult> showImagePicker({
    ImageUploadConfig config = const ImageUploadConfig(),
    File? currentImage,
  }) async {
    final Completer<ImageUploadResult> completer = Completer();

    Get.bottomSheet(
      _buildImagePickerBottomSheet(
        config: config,
        currentImage: currentImage,
        onResult: (result) {
          Get.back();
          completer.complete(result);
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );

    return completer.future;
  }

  /// Pick image from camera
  Future<ImageUploadResult> pickFromCamera({
    ImageUploadConfig config = const ImageUploadConfig(),
  }) async {
    try {
      if (!await _requestCameraPermission()) {
        return ImageUploadResult.error('Camera permission denied');
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: config.maxWidth,
        maxHeight: config.maxHeight,
        imageQuality: config.imageQuality,
      );

      if (image != null) {
        if (kDebugMode) {
          print('ImageUploadService - Image captured from camera: ${image.path}');
        }
        return ImageUploadResult.success(File(image.path));
      } else {
        return ImageUploadResult.cancelled();
      }
    } catch (e) {
      if (kDebugMode) {
        print('ImageUploadService - Camera error: $e');
      }
      return ImageUploadResult.error('Error accessing camera: $e');
    }
  }

  /// Build the image picker bottom sheet
  Widget _buildImagePickerBottomSheet({
    required ImageUploadConfig config,
    File? currentImage,
    required Function(ImageUploadResult) onResult,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Text(
                config.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOptionButton(
                    icon: Icons.camera_alt,
                    title: config.cameraText,
                    color: Colors.blue,
                    onTap: () async {
                      final result = await pickFromCamera(config: config);
                      onResult(result);
                    },
                  ),
                ],
              ),
              
              // Remove option
              if (config.showRemoveOption && currentImage != null) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => onResult(ImageUploadResult.removed()),
                  child: Text(
                    config.removeText,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Build option button for bottom sheet
  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Request camera permission
  Future<bool> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    
    if (status.isPermanentlyDenied) {
      _showPermissionDialog('Camera', 'camera access to take photos');
      return false;
    }
    
    return status.isGranted;
  }

  /// Show permission dialog for permanently denied permissions
  void _showPermissionDialog(String permission, String description) {
    Get.dialog(
      AlertDialog(
        title: Text('$permission Permission Required'),
        content: Text('Please enable $description in settings to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// Show error snackbar
  void showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
