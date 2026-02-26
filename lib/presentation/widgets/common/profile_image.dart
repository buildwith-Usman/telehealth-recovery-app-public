import 'package:flutter/cupertino.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/placeholder_image.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  const ProfileImage({super.key,
    this.imageUrl,
    this.width = double.infinity,
    this.height = 126,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => const PlaceholderImage(),
        )
            : const PlaceholderImage(),
      ),
    );
  }
}