import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_image.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_icon.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';
import '../button/primary_button.dart';

class BannerItem {
  final String time;
  final String name;
  final String? profession;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Color? backgroundColor;
  final String? imageUrl;

  const BannerItem(
      {required this.time,
      required this.name,
      this.profession,
      required this.buttonText,
      this.onButtonPressed,
      this.backgroundColor,
      this.imageUrl});
}

class SlidingBanner extends StatefulWidget {
  final List<BannerItem> items;
  final double height;
  final EdgeInsets margin;
  final bool showIndicators;
  final Duration autoPlayDuration;
  final bool enableAutoPlay;

  const SlidingBanner({
    super.key,
    required this.items,
    this.height = 200,
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
    this.showIndicators = true,
    this.autoPlayDuration = const Duration(seconds: 5),
    this.enableAutoPlay = true,
  });

  @override
  State<SlidingBanner> createState() => _SlidingBannerState();
}

class _SlidingBannerState extends State<SlidingBanner> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start at the middle card to show both left and right portions
    int initialPage =
        widget.items.length > 1 ? (widget.items.length / 2).floor() : 0;
    _currentIndex = initialPage;

    _pageController = PageController(
      viewportFraction:
          0.9, // Increased width while still showing side portions
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
    if (widget.items.isEmpty) {
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
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              bool isActive = index == _currentIndex;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildBannerCard(widget.items[index], isActive),
              );
            },
          ),
        ),
        if (widget.showIndicators && widget.items.length > 1) ...[
          gapH8,
          _buildIndicators(),
        ],
      ],
    );
  }

  Widget _buildBannerCard(BannerItem item, bool isActive) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.accent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
        child: Row(
          children: [
            // Left: Text + Button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Time with clock icon
                  Row(
                    children: [
                      AppIcon.clock.widget(
                        width: 16,
                        height: 16,
                      ),
                      gapW8,
                      Flexible(
                        child: AppText.primary(
                          item.time,
                          fontFamily: FontFamilyType.inter,
                          fontSize: 14,
                          fontWeight: FontWeightType.medium,
                          color: Colors.white,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  gapH8,
                  // Doctor name
                  AppText.primary(
                    item.name,
                    fontFamily: FontFamilyType.poppins,
                    fontSize: 20,
                    fontWeight: FontWeightType.bold,
                    color: Colors.white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  gapH4,
                  // Profession
                  if (item.profession != null) ...[
                    AppText.primary(
                      item.profession!,
                      fontFamily: FontFamilyType.inter,
                      fontSize: 14,
                      fontWeight: FontWeightType.regular,
                      color: Colors.white.withOpacity(0.9),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  gapH12,
                  // Action button
                  Flexible(
                    child: PrimaryButton(
                      color: AppColors.white,
                      textColor: AppColors.primary,
                      title: 'Start Session',
                      height: 35,
                      width: 160,
                      radius: 6,
                      fontWeight: FontWeightType.semiBold,
                      showIcon: true,
                      iconWidget: AppIcon.rightArrowIcon.widget(
                        width: 10,
                        height: 10,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        if (item.backgroundColor != null) {
                          item.onButtonPressed?.call();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Right: Image
            if (item.imageUrl != null) ...[
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.imageUrl!,
                    width: 120,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => SizedBox(
                          width: 120,
                          child: AppImage.recoveryDr.widget(),
                        )),
              ),
            ] else
              SizedBox(
                width: 120,
                child: AppImage.recoveryDr.widget(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? AppColors.primary
                : AppColors.grey80.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
