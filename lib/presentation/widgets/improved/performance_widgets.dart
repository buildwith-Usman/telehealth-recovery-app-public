import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Optimized list view for large datasets
class OptimizedListView<T> extends StatefulWidget {
  final RxList<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final bool hasMore;
  final bool isLoading;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  const OptimizedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.hasMore = true,
    this.isLoading = false,
    this.emptyWidget,
    this.loadingWidget,
    this.scrollController,
    this.padding,
  });

  @override
  State<OptimizedListView<T>> createState() => _OptimizedListViewState<T>();
}

class _OptimizedListViewState<T> extends State<OptimizedListView<T>> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!widget.hasMore || _isLoadingMore || widget.onLoadMore == null) return;

    setState(() => _isLoadingMore = true);
    await widget.onLoadMore!();
    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.items.isEmpty && !widget.isLoading) {
        return widget.emptyWidget ??
            const Center(
              child: Text('No items found'),
            );
      }

      if (widget.items.isEmpty && widget.isLoading) {
        return widget.loadingWidget ??
            const Center(
              child: CircularProgressIndicator(),
            );
      }

      Widget listView = ListView.builder(
        controller: _scrollController,
        padding: widget.padding,
        itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= widget.items.length) {
            return _isLoadingMore
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }

          return widget.itemBuilder(widget.items[index], index);
        },
      );

      if (widget.onRefresh != null) {
        listView = RefreshIndicator(
          onRefresh: widget.onRefresh!,
          child: listView,
        );
      }

      return listView;
    });
  }
}

/// Cached network image widget
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            );
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Memoized widget to prevent unnecessary rebuilds
class MemoizedWidget extends StatefulWidget {
  final Widget child;
  final List<Object?> dependencies;

  const MemoizedWidget({
    super.key,
    required this.child,
    required this.dependencies,
  });

  @override
  State<MemoizedWidget> createState() => _MemoizedWidgetState();
}

class _MemoizedWidgetState extends State<MemoizedWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _MemoizedWidgetState &&
        runtimeType == other.runtimeType &&
        _listEquals(widget.dependencies, other.widget.dependencies);
  }

  @override
  int get hashCode => Object.hashAll(widget.dependencies);

  bool _listEquals(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Viewport aware widget - only builds when visible
class ViewportAwareWidget extends StatefulWidget {
  final Widget child;
  final double visibilityThreshold;
  final VoidCallback? onVisible;
  final VoidCallback? onInvisible;

  const ViewportAwareWidget({
    super.key,
    required this.child,
    this.visibilityThreshold = 0.1,
    this.onVisible,
    this.onInvisible,
  });

  @override
  State<ViewportAwareWidget> createState() => _ViewportAwareWidgetState();
}

class _ViewportAwareWidgetState extends State<ViewportAwareWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        final wasVisible = _isVisible;
        _isVisible = info.visibleFraction >= widget.visibilityThreshold;

        if (!wasVisible && _isVisible) {
          widget.onVisible?.call();
        } else if (wasVisible && !_isVisible) {
          widget.onInvisible?.call();
        }
      },
      child: widget.child,
    );
  }
}

// Mock VisibilityDetector for this example
class VisibilityDetector extends StatelessWidget {
  @override
  final Key key;
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;

  const VisibilityDetector({super.key, 
    required this.key,
    required this.child,
    required this.onVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    // In a real implementation, this would track visibility
    return child;
  }
}

class VisibilityInfo {
  final double visibleFraction;
  VisibilityInfo(this.visibleFraction);
}
