import 'package:flutter/material.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';

class CustomTabLayout extends StatefulWidget {
  final List<String> tabs;
  final List<Widget> pages;
  final ValueChanged<int>? onTabChanged;

  const CustomTabLayout({
    super.key,
    required this.tabs,
    required this.pages,
    this.onTabChanged,
  }) : assert(tabs.length == pages.length, "Tabs and pages must match");

  @override
  State<CustomTabLayout> createState() => _CustomTabLayoutState();
}

class _CustomTabLayoutState extends State<CustomTabLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged?.call(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        const SizedBox(height: 10),
        // Tab content fills remaining space
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.pages.map((page) {
                return page;
            }).toList(),
          ),
        ),
      ],
    );
  }

Widget _buildTabBar() {
  final isScrollable = widget.tabs.length > 2; // 👈 scroll only if more than 2 tabs

  return Container(
    width: double.infinity,
    height: 55,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    decoration: BoxDecoration(
      color: AppColors.grey95,
      borderRadius: BorderRadius.circular(6),
    ),
    child: TabBar(
      controller: _tabController,
      isScrollable: isScrollable,
      labelColor: AppColors.white,
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelColor: Colors.black87,
      indicator: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      tabs: widget.tabs.map((tab) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            // 👇 fill available space evenly when not scrollable
            width: isScrollable ? null : double.infinity,
            child: Center(
              child: Text(
                tab,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

}
