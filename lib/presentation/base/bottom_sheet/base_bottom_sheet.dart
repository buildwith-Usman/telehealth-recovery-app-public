import 'package:flutter/material.dart';

abstract class BaseBottomSheet extends StatelessWidget {
  const BaseBottomSheet({super.key});

  /// Common method to close the bottom sheet
  void closeSheet(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Common method to show error
  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  /// Override this to build your bottom sheet content
  Widget buildSheetContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: buildSheetContent(context),
        ),
      ),
    );
  }
}