import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_icon.dart';

enum NavigationButtonType {
  previous,
  next,
}

/// A customizable navigation button widget that supports various icon types and styling options.
///
/// Features:
/// - Standard navigation types (previous/next) with default styling
/// - Custom icon support (Widget, IconData, or AppIconBuilder)
/// - Flexible color customization for background, icon, and border
/// - Configurable size, border radius, and border width
/// - Filled or outlined styles
class CustomNavigationButton extends StatelessWidget {
  /// The type of navigation button (previous or next) - affects default styling (optional)
  final NavigationButtonType? type;
  
  /// Callback function when the button is pressed
  final VoidCallback onPressed;
  
  /// The size of the button (width and height)
  final double size;
  
  /// Border radius for rounded corners
  final double borderRadius;
  
  /// Width of the border (when applicable)
  final double borderWidth;
  
  /// Size of the icon inside the button
  final double iconSize;
  
  /// Whether the button should have a filled background
  final bool isFilled;
  
  /// Custom background color (overrides default type-based color)
  final Color? backgroundColor;
  
  /// Custom icon color (overrides default type-based color)
  final Color? iconColor;
  
  /// Background color when isFilled is true
  final Color? filledColor;
  
  /// Custom border color (overrides default primary color)
  final Color? borderColor;
  
  /// Whether to show border (overrides default type-based logic)
  final bool? showBorder;
  
  /// Custom icon widget (highest priority - overrides all other icon options)
  final Widget? customIcon;
  
  /// Custom IconData (second priority - used if customIcon is null)
  final IconData? customIconData;
  
  /// Custom AppIcon (third priority - used if customIcon and customIconData are null)
  final AppIconBuilder? customAppIcon;

  const CustomNavigationButton({
    super.key,
    this.type,
    required this.onPressed,
    this.size = 45,
    this.borderRadius = 8,
    this.borderWidth = 1.5,
    this.iconSize = 15,
    this.isFilled = false,
    this.backgroundColor,
    this.iconColor,
    this.filledColor,
    this.borderColor,
    this.showBorder,
    this.customIcon,
    this.customIconData,
    this.customAppIcon,
  });

  /// Creates a custom navigation button with a specific IconData
  const CustomNavigationButton.withIcon({
    super.key,
    this.type,
    required this.onPressed,
    IconData? iconData,
    this.size = 45,
    this.borderRadius = 8,
    this.borderWidth = 1.5,
    this.iconSize = 15,
    this.isFilled = false,
    this.backgroundColor,
    this.iconColor,
    this.filledColor,
    this.borderColor,
    this.showBorder,
    this.customIcon,
    this.customAppIcon,
  }) : customIconData = iconData;

  /// Creates a custom navigation button with a specific AppIcon
  const CustomNavigationButton.withAppIcon({
    super.key,
    this.type,
    required this.onPressed,
    required AppIconBuilder appIcon,
    this.size = 45,
    this.borderRadius = 8,
    this.borderWidth = 1.5,
    this.iconSize = 15,
    this.isFilled = false,
    this.backgroundColor,
    this.iconColor,
    this.filledColor,
    this.borderColor,
    this.showBorder,
    this.customIcon,
    this.customIconData,
  }) : customAppIcon = appIcon;

  /// Creates a custom navigation button with a completely custom widget
  const CustomNavigationButton.withWidget({
    super.key,
    this.type,
    required this.onPressed,
    required Widget widget,
    this.size = 45,
    this.borderRadius = 8,
    this.borderWidth = 1.5,
    this.iconSize = 15,
    this.isFilled = false,
    this.backgroundColor,
    this.iconColor,
    this.filledColor,
    this.borderColor,
    this.showBorder,
    this.customIconData,
    this.customAppIcon,
  }) : customIcon = widget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(borderRadius),
          border: _shouldShowBorder()
              ? Border.all(
                  color: borderColor ?? AppColors.primary,
                  width: borderWidth,
                )
              : null,
        ),
        child: Center(
          child: _getCustomIcon(),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    
    if (isFilled) {
      return filledColor ?? AppColors.primary;
    }
    
    if (type == null) return AppColors.background;
    
    switch (type!) {
      case NavigationButtonType.previous:
        return AppColors.background;
      case NavigationButtonType.next:
        return AppColors.primary;
    }
  }

  Color _getIconColor() {
    if (iconColor != null) return iconColor!;
    
    if (isFilled) {
      return AppColors.white;
    }
    
    if (type == null) return AppColors.textPrimary;
    
    switch (type!) {
      case NavigationButtonType.previous:
        return AppColors.textPrimary;
      case NavigationButtonType.next:
        return AppColors.white;
    }
  }

  Widget _getCustomIcon() {
    // Priority 1: Custom widget icon
    if (customIcon != null) {
      return customIcon!;
    }
    
    // Priority 2: Custom IconData
    if (customIconData != null) {
      return Icon(
        customIconData!,
        size: iconSize,
        color: _getIconColor(),
      );
    }
    
    // Priority 3: Custom AppIcon
    if (customAppIcon != null) {
      return customAppIcon!.widget(
        width: iconSize,
        height: iconSize * 0.8, // Maintain aspect ratio
        color: _getIconColor(),
      );
    }
    
    // Priority 4: Default icons based on type
    if (type == null) {
      // Return a default icon when no type is specified
      return AppIcon.leftArrowIcon.widget(
        width: 15,
        height: 12,
        color: _getIconColor(),
      );
    }
    
    AppIconBuilder iconBuilder;
    switch (type!) {
      case NavigationButtonType.previous:
        iconBuilder = AppIcon.leftArrowIcon;
        break;
      case NavigationButtonType.next:
        iconBuilder = AppIcon.rightArrowIcon;
        break;
    }

    return iconBuilder.widget(
      width: 15,
      height: 12,
      color: _getIconColor(),
    );
  }

  bool _shouldShowBorder() {
    // If showBorder is explicitly set, use that value
    if (showBorder != null) return showBorder!;
    
    // If filled, don't show border
    if (isFilled) return false;
    
    // Default logic: show border only for previous type
    return type == NavigationButtonType.previous;
  }
}
