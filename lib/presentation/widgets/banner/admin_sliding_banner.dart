import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/domain/models/session_data.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../cards/admin_appointment_card.dart';

class AdminSlidingBanner extends StatefulWidget {
  final List<AdminSessionData> sessions;
  final Duration autoScrollDuration;
  final double? height;
  final Function(AdminSessionData)? onSessionTap;

  const AdminSlidingBanner({
    super.key,
    required this.sessions,
    this.autoScrollDuration = const Duration(seconds: 4),
    this.height,
    this.onSessionTap,
  });

  @override
  State<AdminSlidingBanner> createState() => _AdminSlidingBannerState();
}

class _AdminSlidingBannerState extends State<AdminSlidingBanner> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start at the middle card to show both left and right portions
    int initialPage =
        widget.sessions.length > 1 ? (widget.sessions.length / 2).floor() : 0;
    _currentIndex = initialPage;

    _pageController = PageController(
      viewportFraction: 0.9,
      initialPage: initialPage,
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (mounted && widget.sessions.isNotEmpty) {
        _currentIndex = (_currentIndex + 1) % widget.sessions.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sessions.isEmpty) {
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
            itemCount: widget.sessions.length,
            itemBuilder: (context, index) {
              final session = widget.sessions[index];
              return AdminAppointmentCard(
                  session: session,
                  onTap: () => {
                        if (widget.onSessionTap != null)
                          {widget.onSessionTap!(session)}
                      });
            },
          ),
        ),
        if (widget.sessions.length > 1) ...[
          gapH8,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.sessions.length,
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
          ),
        ],
      ],
    );
  }
}
