import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/base_controller.dart';
import '../../presentation/widgets/common/recovery_app_bar.dart';
import '../config/app_colors.dart';
import '../utils/util.dart';

/// Base stateful page that automatically handles loading, errors, and toasts
/// for any controller that extends BaseController
abstract class BaseStatefulPage<T extends BaseController> extends StatefulWidget {
  const BaseStatefulPage({super.key});

  final String? tag = null;

  T get controller => Get.find<T>(tag: tag);

  @override
  BaseStatefulPageState<T> createState();
}

abstract class BaseStatefulPageState<T extends BaseController> extends State<BaseStatefulPage<T>> {

  @override
  void initState() {
    super.initState();
    _setupBaseListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setupBaseListeners() {
    _setupLoadingListener();
    _setupErrorListener();
    setupAdditionalListeners();
  }

  void _setupLoadingListener() {
    // Listen for loading state changes
    ever((widget.controller as BaseController).isLoading, (bool isLoading) {
      if (isLoading) {
        _showLoadingIndicator();
      } else {
        _hideLoadingIndicator();
      }
    });
  }

  void _setupErrorListener() {
    // Listen for general error changes
    final generalError = (widget.controller as BaseController).generalError;
    ever(generalError, (String? errorMessage) {
      if (errorMessage != null && errorMessage.isNotEmpty) {
        // _showErrorSnackbar(errorMessage);
      }
    });
    }

  /// Override this method to add page-specific listeners
  void setupAdditionalListeners() {}

  void _showLoadingIndicator() {
    Util.showLoadingIndicator();
  }

  void _hideLoadingIndicator() {
    Util.hideLoadingIndicator();
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(
        Icons.error_outline,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  /// Show success toast - can be called by child pages
  void showSuccessToast(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  // ==================== Optional App Bar Configuration (Opt-in) ====================
  // These features are OPTIONAL and backward compatible.
  // Pages that don't override buildAppBar() will work exactly as before.
  // Only pages that return a RecoveryAppBar will get the new scaffold structure.

  /// Override to provide app bar configuration (OPTIONAL - for new pages only)
  /// Return null (default) to maintain old behavior where buildPageContent handles everything
  /// Return a RecoveryAppBar to use the new scaffold structure with automatic SafeArea and padding
  RecoveryAppBar? buildAppBar() => null;

  /// Override to provide bottom bar/navigation (OPTIONAL - for new pages only)
  /// Return null (default) for no bottom bar
  /// Return a Widget to display at the bottom of the page (like bottom nav, action buttons, etc.)
  Widget? buildBottomBar() => null;

  /// Whether to wrap content in SafeArea when using buildAppBar (default: true)
  /// Only applies if buildAppBar() returns a non-null value
  bool get useSafeArea => true;

  /// Control which edges are protected by SafeArea (default: all edges)
  /// Override this if you want more granular control
  /// Only applies if buildAppBar() returns a non-null value and useSafeArea is true
  bool get safeAreaTop => true;
  bool get safeAreaBottom => true;
  bool get safeAreaLeft => true;
  bool get safeAreaRight => true;

  /// Background color for scaffold when using buildAppBar (default: AppColors.whiteLight)
  /// Only applies if buildAppBar() returns a non-null value
  Color get scaffoldBackgroundColor => AppColors.whiteLight;

  /// Whether to apply standard padding when using buildAppBar (default: true)
  /// Only applies if buildAppBar() returns a non-null value
  bool get useStandardPadding => true;

  /// Standard page padding when using buildAppBar (default: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20))
  /// Only applies if buildAppBar() returns a non-null value
  EdgeInsets get pagePadding => const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 20,
      );

  /// Override this method to build your page content
  Widget buildPageContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // Check if page is using the new app bar system (opt-in)
    final appBar = buildAppBar();

    // NEW BEHAVIOR: If app bar is provided, use new scaffold structure
    if (appBar != null) {
      Widget content = buildPageContent(context);

      // Apply standard padding if enabled
      if (useStandardPadding) {
        content = Padding(
          padding: pagePadding,
          child: content,
        );
      }

      // Build the main layout with app bar, content, and optional bottom bar
      final bottomBar = buildBottomBar();
      Widget layout = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          appBar,
          Expanded(child: content),
          if (bottomBar != null) bottomBar,
        ],
      );

      // Wrap entire layout (including app bar) in SafeArea if enabled
      // This prevents status bar overlap
      if (useSafeArea) {
        layout = SafeArea(
          top: safeAreaTop,
          bottom: safeAreaBottom,
          left: safeAreaLeft,
          right: safeAreaRight,
          child: layout,
        );
      }

      return Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: layout,
      );
    }

    // OLD BEHAVIOR: If no app bar, return buildPageContent directly
    // This maintains backward compatibility with all existing pages
    return buildPageContent(context);
  }
}
