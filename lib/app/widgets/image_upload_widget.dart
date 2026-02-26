import 'dart:io';
import 'package:flutter/material.dart';

/// Reusable widget for displaying and selecting images
class ImageUploadWidget extends StatelessWidget {
  final File? imageFile;
  final String? networkImageUrl;
  final String? placeholderAsset;
  final double size;
  final BoxShape shape;
  final VoidCallback? onTap;
  final bool showEditIcon;
  final IconData editIcon;
  final Color editIconColor;
  final Color editIconBackground;
  final bool isLoading;
  final Widget? loadingWidget;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const ImageUploadWidget({
    super.key,
    this.imageFile,
    this.networkImageUrl,
    this.placeholderAsset,
    this.size = 120,
    this.shape = BoxShape.circle,
    this.onTap,
    this.showEditIcon = true,
    this.editIcon = Icons.camera_alt,
    this.editIconColor = Colors.white,
    this.editIconBackground = Colors.blue,
    this.isLoading = false,
    this.loadingWidget,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: shape,
              borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
              border: border,
              boxShadow: boxShadow ?? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: shape == BoxShape.circle
                  ? BorderRadius.circular(size / 2)
                  : (borderRadius ?? BorderRadius.zero),
              child: _buildImageContent(),
            ),
          ),
          
          // Loading overlay
          if (isLoading) _buildLoadingOverlay(),
          
          // Edit icon
          if (showEditIcon && !isLoading) _buildEditIcon(),
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    // Priority: File image > Network image > Placeholder > Default
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      return Image.network(
        networkImageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    if (placeholderAsset != null) {
      return Image.asset(
        placeholderAsset!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }
    
    return Container(
      width: size,
      height: size,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.person,
        size: size * 0.5,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        color: Colors.black.withOpacity(0.5),
      ),
      child: Center(
        child: loadingWidget ?? 
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
      ),
    );
  }

  Widget _buildEditIcon() {
    final iconSize = size * 0.25;
    
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: iconSize + 8,
        height: iconSize + 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: editIconBackground,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(
          editIcon,
          color: editIconColor,
          size: iconSize * 0.6,
        ),
      ),
    );
  }
}

/// Widget for displaying multiple selected images in a grid
class MultiImageUploadWidget extends StatelessWidget {
  final List<File> imageFiles;
  final List<String> networkImageUrls;
  final VoidCallback? onAddImage;
  final Function(int index)? onRemoveImage;
  final Function(int index)? onImageTap;
  final double imageSize;
  final int crossAxisCount;
  final double spacing;
  final bool showAddButton;
  final bool showRemoveButton;
  final String addButtonText;
  final IconData addIcon;
  final IconData removeIcon;

  const MultiImageUploadWidget({
    super.key,
    this.imageFiles = const [],
    this.networkImageUrls = const [],
    this.onAddImage,
    this.onRemoveImage,
    this.onImageTap,
    this.imageSize = 100,
    this.crossAxisCount = 3,
    this.spacing = 8,
    this.showAddButton = true,
    this.showRemoveButton = true,
    this.addButtonText = 'Add Image',
    this.addIcon = Icons.add_photo_alternate,
    this.removeIcon = Icons.close,
  });

  @override
  Widget build(BuildContext context) {
    final totalImages = imageFiles.length + networkImageUrls.length;
    final hasImages = totalImages > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasImages) _buildImageGrid(),
        if (showAddButton) ...[
          if (hasImages) SizedBox(height: spacing),
          _buildAddButton(),
        ],
      ],
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1,
      ),
      itemCount: imageFiles.length + networkImageUrls.length,
      itemBuilder: (context, index) {
        if (index < imageFiles.length) {
          return _buildImageItem(
            imageFile: imageFiles[index],
            index: index,
          );
        } else {
          final networkIndex = index - imageFiles.length;
          return _buildImageItem(
            networkImageUrl: networkImageUrls[networkIndex],
            index: index,
          );
        }
      },
    );
  }

  Widget _buildImageItem({
    File? imageFile,
    String? networkImageUrl,
    required int index,
  }) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => onImageTap?.call(index),
          child: Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageFile != null
                  ? Image.file(
                      imageFile,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      networkImageUrl!,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildErrorPlaceholder(),
                    ),
            ),
          ),
        ),
        
        // Remove button
        if (showRemoveButton)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => onRemoveImage?.call(index),
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(
                  removeIcon,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddImage,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 2),
          color: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              addIcon,
              color: Colors.grey.shade600,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              addButtonText,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      width: imageSize,
      height: imageSize,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.error_outline,
        color: Colors.grey.shade400,
        size: imageSize * 0.5,
      ),
    );
  }
}

/// Circular progress indicator for image uploads
class ImageUploadProgress extends StatelessWidget {
  final double progress;
  final double size;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;
  final Widget? child;

  const ImageUploadProgress({
    super.key,
    required this.progress,
    this.size = 60,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.strokeWidth = 4,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: backgroundColor.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            strokeWidth: strokeWidth,
          ),
          if (child != null)
            Center(child: child!),
        ],
      ),
    );
  }
}

/// Utility extension for easy image upload integration
extension ImageUploadWidgetExtensions on Widget {
  /// Wrap with image upload functionality
  Widget withImageUpload({
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Stack(
        children: [
          this,
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
