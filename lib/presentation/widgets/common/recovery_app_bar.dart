import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/utils/sizes.dart';
import '../app_text.dart';
import '../button/custom_navigation_button.dart';

/// Enum to define different app bar types used across the app
enum RecoveryAppBarType {
  /// Simple header with back button, centered title, and optional right actions
  /// Used in: Profile, Edit Profile, Appointments, Specialist List, etc.
  simple,

  /// Profile header with avatar, greeting text, and right action buttons
  /// Used in: Patient Home, Specialist Home
  profile,

  /// Branded header with logo/icon and right action buttons
  /// Used in: Pharmacy Home and other branded sections
  branded,

  /// Custom header when you want full control over the layout
  custom,
}

/// A flexible and reusable app bar widget for the Recovery app
/// Supports different header types and configurations
class RecoveryAppBar extends StatelessWidget {
  /// The type of app bar to display
  final RecoveryAppBarType type;

  // ==================== Simple Header Properties ====================
  /// Title text for simple header
  final String? title;

  /// Whether to show back button (default: true for simple type)
  final bool showBackButton;

  /// Custom back button press handler
  final VoidCallback? onBackPressed;

  /// Custom back button icon widget
  final Widget? backButtonIcon;

  /// Whether to center the title (default: true)
  final bool centerTitle;

  // ==================== Profile Header Properties ====================
  /// Profile image URL for profile header
  final String? profileImageUrl;

  /// Name to display in greeting (e.g., "Hi, John")
  final String? userName;

  /// Subtitle text under the greeting
  final String? subtitle;

  /// Callback when profile image is tapped
  final VoidCallback? onProfileTap;

  // ==================== Branded Header Properties ====================
  /// Custom widget for branding (logo, icon, etc.)
  final Widget? brandWidget;

  // ==================== Common Properties ====================
  /// List of action widgets to display on the right side
  final List<Widget>? actions;

  /// Background color of the app bar
  final Color? backgroundColor;

  /// Height of the app bar
  final double? height;

  /// Horizontal padding
  final double horizontalPadding;

  /// Vertical padding
  final double verticalPadding;

  /// Whether to show a bottom border
  final bool showBorder;

  /// Border color (if showBorder is true)
  final Color? borderColor;

  /// Spacing between action items
  final double actionSpacing;

  // ==================== Custom Header Properties ====================
  /// Custom widget to replace the entire app bar content
  final Widget? customWidget;

  const RecoveryAppBar({
    super.key,
    this.type = RecoveryAppBarType.simple,
    // Simple header
    this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.backButtonIcon,
    this.centerTitle = true,
    // Profile header
    this.profileImageUrl,
    this.userName,
    this.subtitle,
    this.onProfileTap,
    // Branded header
    this.brandWidget,
    // Common
    this.actions,
    this.backgroundColor,
    this.height,
    this.horizontalPadding = 20.0,
    this.verticalPadding = 10.0,
    this.showBorder = false,
    this.borderColor,
    this.actionSpacing = 10.0,
    // Custom
    this.customWidget,
  });

  /// Factory constructor for simple header with back button and title
  factory RecoveryAppBar.simple({
    required String title,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    Widget? backButtonIcon,
    List<Widget>? actions,
    Color? backgroundColor,
    double? height,
    double horizontalPadding = 20.0,
    double verticalPadding = 10.0,
  }) {
    return RecoveryAppBar(
      type: RecoveryAppBarType.simple,
      title: title,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      backButtonIcon: backButtonIcon,
      actions: actions,
      backgroundColor: backgroundColor,
      height: height,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }

  /// Factory constructor for profile header
  factory RecoveryAppBar.profile({
    required String userName,
    String? subtitle,
    String? profileImageUrl,
    VoidCallback? onProfileTap,
    List<Widget>? actions,
    Color? backgroundColor,
    double? height,
    double horizontalPadding = 20.0,
    double verticalPadding = 10.0,
  }) {
    return RecoveryAppBar(
      type: RecoveryAppBarType.profile,
      userName: userName,
      subtitle: subtitle,
      profileImageUrl: profileImageUrl,
      onProfileTap: onProfileTap,
      actions: actions,
      backgroundColor: backgroundColor,
      height: height,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }

  /// Factory constructor for branded header
  factory RecoveryAppBar.branded({
    required Widget brandWidget,
    List<Widget>? actions,
    Color? backgroundColor,
    double? height,
    double horizontalPadding = 20.0,
    double verticalPadding = 16.0,
  }) {
    return RecoveryAppBar(
      type: RecoveryAppBarType.branded,
      brandWidget: brandWidget,
      actions: actions,
      backgroundColor: backgroundColor,
      height: height,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }

  /// Factory constructor for custom header
  factory RecoveryAppBar.custom({
    required Widget customWidget,
    Color? backgroundColor,
    double? height,
    double horizontalPadding = 20.0,
    double verticalPadding = 10.0,
  }) {
    return RecoveryAppBar(
      type: RecoveryAppBarType.custom,
      customWidget: customWidget,
      backgroundColor: backgroundColor,
      height: height,
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.whiteLight,
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: borderColor ?? AppColors.grey90,
                  width: 1,
                ),
              )
            : null,
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (type) {
      case RecoveryAppBarType.simple:
        return _buildSimpleHeader();
      case RecoveryAppBarType.profile:
        return _buildProfileHeader();
      case RecoveryAppBarType.branded:
        return _buildBrandedHeader();
      case RecoveryAppBarType.custom:
        return customWidget ?? const SizedBox.shrink();
    }
  }

  // ==================== Simple Header ====================
  Widget _buildSimpleHeader() {
    return Row(
      children: [
        // Back button
        if (showBackButton)
          backButtonIcon != null
              ? GestureDetector(
                  onTap: onBackPressed ?? () => Get.back(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.whiteLight,
                        width: 1,
                      ),
                    ),
                    child: Center(child: backButtonIcon!),
                  ),
                )
              : CustomNavigationButton(
                  type: NavigationButtonType.previous,
                  onPressed: onBackPressed ?? () => Get.back(),
                  isFilled: true,
                  borderRadius: 6,
                  size: 40,
                  filledColor: AppColors.whiteLight,
                  iconColor: AppColors.accent,
                  backgroundColor: AppColors.white,
                ),
        if (showBackButton) SizedBox(width: actionSpacing),

        // Title
        Expanded(
          child: centerTitle
              ? Center(child: _buildTitleText())
              : _buildTitleText(),
        ),

        // Actions or balance spacer
        if (actions != null && actions!.isNotEmpty) ...[
          SizedBox(width: actionSpacing),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildActionWidgets(),
          ),
        ] else if (showBackButton)
          // Add balance spacer to keep title centered
          const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildTitleText() {
    if (title == null) return const SizedBox.shrink();

    return AppText.primary(
      title!,
      fontFamily: FontFamilyType.poppins,
      fontSize: 16,
      fontWeight: FontWeightType.semiBold,
      color: AppColors.black,
    );
  }

  // ==================== Profile Header ====================
  Widget _buildProfileHeader() {
    return Row(
      children: [
        // Profile section
        Expanded(
          child: Row(
            children: [
              // Profile Avatar
              GestureDetector(
                onTap: onProfileTap,
                child: _buildProfileAvatar(),
              ),
              gapW12,
              // Greeting Text
              Expanded(
                child: _buildGreetingText(),
              ),
            ],
          ),
        ),
        // Right Action Buttons
        if (actions != null && actions!.isNotEmpty) ...[
          gapW16,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildActionWidgets(),
          ),
        ],
      ],
    );
  }

  Widget _buildProfileAvatar() {
    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        color: AppColors.grey80.withValues(alpha: 0.3),
        child: profileImageUrl != null && profileImageUrl!.isNotEmpty
            ? Image.network(
                profileImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderAvatar(),
              )
            : _buildPlaceholderAvatar(),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return const Icon(
      Icons.person,
      color: AppColors.textSecondary,
      size: 30,
    );
  }

  Widget _buildGreetingText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (userName != null)
          AppText.primary(
            'Hi, $userName',
            fontFamily: FontFamilyType.poppins,
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.black,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (subtitle != null) ...[
          gapH2,
          AppText.primary(
            subtitle!,
            fontFamily: FontFamilyType.inter,
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  // ==================== Branded Header ====================
  Widget _buildBrandedHeader() {
    return Row(
      children: [
        // Brand widget
        if (brandWidget != null)
          Expanded(child: brandWidget!)
        else
          const Spacer(),

        // Right Action Buttons
        if (actions != null && actions!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildActionWidgets(),
          ),
      ],
    );
  }

  // ==================== Common Helper Methods ====================
  List<Widget> _buildActionWidgets() {
    if (actions == null || actions!.isEmpty) return [];

    final List<Widget> actionWidgets = [];

    for (int i = 0; i < actions!.length; i++) {
      actionWidgets.add(actions![i]);

      // Add spacing between actions (except for the last item)
      if (i < actions!.length - 1) {
        actionWidgets.add(SizedBox(width: actionSpacing));
      }
    }

    return actionWidgets;
  }
}
