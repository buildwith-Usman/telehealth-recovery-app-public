import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'dart:io';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/utils/sizes.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';

class PrescriptionImage extends StatefulWidget {
  final String? imageUrl;
  final double? height;
  final double borderRadius;
  final bool showPicker; // 👈 Controls visibility of gallery icon
  final VoidCallback? onTap;
  final Function(File imageFile)? onImagePicked; // 👈 Callback when new image is picked

  const PrescriptionImage({
    super.key,
    this.imageUrl,
    this.height = 500,
    this.borderRadius = 12,
    this.showPicker = false,
    this.onTap,
    this.onImagePicked,
  });

  @override
  State<PrescriptionImage> createState() => _PrescriptionImageState();
}

class _PrescriptionImageState extends State<PrescriptionImage> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });

      // Call external callback if provided
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(_selectedImage!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // --- Display image (picked → url → placeholder)
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
            )
          else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
            Image.network(
              widget.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  AppImage.prescriptionImage.widget(),
            )
          else
            if(!widget.showPicker)
              AppImage.prescriptionImage.widget(),
          // --- Optional overlay button ---
          if (widget.showPicker)
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcon.uploadIcon.widget(width: 32,height: 32),
                    gapH6,
                    AppText.primary('Add Image', fontSize: 14,color: AppColors.black,fontWeight: FontWeightType.medium)
                  ],
                ),
              ),
            ),
        ],
      ),
    );

    // Allow outer tap if provided
    return widget.onTap != null
        ? GestureDetector(onTap: widget.onTap, child: imageWidget)
        : imageWidget;
  }
}
