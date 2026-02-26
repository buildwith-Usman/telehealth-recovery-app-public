import 'package:flutter/material.dart';

class RecoveryGridView extends StatelessWidget {
  /// Total number of items to display
  final int itemCount;

  /// Function that builds each grid item
  final IndexedWidgetBuilder itemBuilder;

  /// Layout customization options
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double mainAxisExtent;
  final EdgeInsetsGeometry padding;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  const RecoveryGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.mainAxisExtent = 180,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
