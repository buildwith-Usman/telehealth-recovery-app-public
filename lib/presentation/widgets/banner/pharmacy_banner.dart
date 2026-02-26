import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/domain/entity/pharmacy_banner_entity.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_icon.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';
import '../button/primary_button.dart';

class PharmacyBanner extends StatefulWidget {
  final List<PharmacyBannerEntity> banners;
  final Function(PharmacyBannerEntity)? onBannerTap;
  final double height;
  final EdgeInsets margin;
  final bool showIndicators;
  final Duration autoPlayDuration;
  final bool enableAutoPlay;

  const PharmacyBanner({
    super.key,
    required this.banners,
    this.onBannerTap,
    this.height = 180,
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
    this.showIndicators = true,
    this.autoPlayDuration = const Duration(seconds: 5),
    this.enableAutoPlay = false, // Disabled by default for user control
  });

  @override
  State<PharmacyBanner> createState() => _PharmacyBannerState();
}

class _PharmacyBannerState extends State<PharmacyBanner> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start at the middle card to show both left and right portions
    int initialPage =
        widget.banners.length > 1 ? (widget.banners.length / 2).floor() : 0;
    _currentIndex = initialPage;

    _pageController = PageController(
      viewportFraction: 0.9, // Shows portions of adjacent banners
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              bool isActive = index == _currentIndex;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildBannerCard(widget.banners[index], isActive),
              );
            },
          ),
        ),
        if (widget.showIndicators && widget.banners.length > 1) ...[
          gapH8,
          _buildIndicators(),
        ],
      ],
    );
  }

  Widget _buildBannerCard(PharmacyBannerEntity banner, bool isActive) {
    // Use static AppColors for active/inactive states
    Color bgColor = isActive ? AppColors.primary : AppColors.accent;

    return GestureDetector(
      onTap: () => widget.onBannerTap?.call(banner),
      child: Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background: Landscape Image
              if (banner.imageUrl != null)
                Image.network(
                  banner.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: bgColor,
                    child: const Center(
                      child: Icon(
                        Icons.medication_outlined,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  color: bgColor,
                  child: const Center(
                    child: Icon(
                      Icons.medication_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),

              // // Gradient Overlay for readability
              // Container(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.centerLeft,
              //       end: Alignment.centerRight,
              //       colors: [
              //         bgColor.withValues(alpha: 0.95),
              //         bgColor.withValues(alpha: 0.7),
              //         bgColor.withValues(alpha: 0.3),
              //         Colors.transparent,
              //       ],
              //       stops: const [0.0, 0.4, 0.7, 1.0],
              //     ),
              //   ),
              // ),

              // Content: Text + Button
              // Positioned(
              //   left: 20,
              //   top: 16,
              //   bottom: 16,
              //   right: 100, // Leave space for image on right
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       // Discount badge (if available)
              //       if (banner.hasDiscount) ...[
              //         Container(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 8,
              //             vertical: 4,
              //           ),
              //           decoration: BoxDecoration(
              //             color: Colors.white.withValues(alpha: 0.25),
              //             borderRadius: BorderRadius.circular(4),
              //           ),
              //           child: AppText.primary(
              //             banner.discountText,
              //             fontSize: 12,
              //             fontWeight: FontWeightType.bold,
              //             color: Colors.white,
              //           ),
              //         ),
              //         gapH8,
              //       ],
              //       // Title
              //       AppText.primary(
              //         banner.title,
              //         fontFamily: FontFamilyType.poppins,
              //         fontSize: 20,
              //         fontWeight: FontWeightType.bold,
              //         color: Colors.white,
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       gapH6,
              //       // Description
              //       AppText.primary(
              //         banner.description,
              //         fontFamily: FontFamilyType.inter,
              //         fontSize: 13,
              //         fontWeight: FontWeightType.regular,
              //         color: Colors.white,
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       gapH16,
              //       // Action button
              //       PrimaryButton(
              //         color: AppColors.white,
              //         textColor: bgColor,
              //         title: banner.displayButtonText,
              //         height: 30,
              //         width: 140,
              //         radius: 6,
              //         fontSize: 12,
              //         fontWeight: FontWeightType.semiBold,
              //         showIcon: true,
              //         iconWidget: AppIcon.rightArrowIcon.widget(
              //           width: 10,
              //           height: 10,
              //           color: bgColor,
              //         ),
              //         onPressed: () => widget.onBannerTap?.call(banner),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.banners.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? AppColors.primary
                : AppColors.grey80.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

}
