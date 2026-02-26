import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_app_bar.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../../domain/entity/pharmacy_order_entity.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/button/custom_navigation_button.dart';
import '../../../widgets/cards/pharmacy_order_card.dart';
import '../../../widgets/tabLayout/custom_tab_layout.dart';
import 'pharmacy_orders_controller.dart';

/// Pharmacy Orders Management Page with Custom Tab Layout
class PharmacyOrdersPage extends BaseStatefulPage<PharmacyOrdersController> {
  const PharmacyOrdersPage({super.key});

  @override
  BaseStatefulPageState<PharmacyOrdersController> createState() =>
      _PharmacyOrdersPageState();
}

class _PharmacyOrdersPageState
    extends BaseStatefulPageState<PharmacyOrdersController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'My Orders',
      showBackButton: true,
      backgroundColor: AppColors.whiteLight,
      onBackPressed: widget.controller.goBack,
    );
  }

  @override
  bool get useStandardPadding => false;

  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Expanded Tab Layout
            Expanded(
              child: CustomTabLayout(
                tabs: const ['All Orders', 'In Progress', 'Delivered'],
                pages: [
                  _buildAllOrdersTab(),
                  _buildInProgressOrdersTab(),
                  _buildDeliveredOrdersTab(),
                ],
                onTabChanged: (index) {
                  widget.controller.onTabChanged(index);
                  debugPrint("Switched to pharmacy orders tab $index");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build header with back button and title
  Widget _buildHeader() {
    return Row(
      children: [
        // Left button
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => Navigator.pop(context),
          isFilled: true,
          filledColor: AppColors.white,
          iconColor: AppColors.accent,
          size: 40,
          iconSize: 18,
          showBorder: false,
        ),
        // Title centered
        Expanded(
          child: Center(
            child: AppText.primary(
              'My Orders',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        // Filter button (matching original design)
        IconButton(
          icon: const Icon(
            Icons.filter_list,
            color: AppColors.accent,
            size: 24,
          ),
          onPressed: () {
            widget.controller.showFilterDialog();
            debugPrint("Filter button pressed");
          },
        ),
      ],
    );
  }

  /// Build All Orders Tab
  Widget _buildAllOrdersTab() {
    return Obx(() {
      final controller = widget.controller;

      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.allOrders.isEmpty) {
        return _buildEmptyState(
          'No Orders Found',
          'You haven\'t placed any orders yet.',
          'Start Shopping',
          () => Navigator.pop(context),
        );
      }

      return _buildOrdersList(
        controller.allOrders,
        showRefresh: true,
      );
    });
  }

  /// Build In Progress Orders Tab
  Widget _buildInProgressOrdersTab() {
    return Obx(() {
      final controller = widget.controller;

      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.inProgressOrders.isEmpty) {
        return _buildEmptyState(
          'No In Progress Orders',
          'All your orders have been delivered or completed.',
          'Browse Medicines',
          () => Navigator.pop(context),
        );
      }

      return _buildOrdersList(
        controller.inProgressOrders,
        showTrackingInfo: true,
      );
    });
  }

  /// Build Delivered Orders Tab
  Widget _buildDeliveredOrdersTab() {
    return Obx(() {
      final controller = widget.controller;

      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      if (controller.deliveredOrders.isEmpty) {
        return _buildEmptyState(
          'No Delivered Orders',
          'You don\'t have any delivered orders yet.',
          'Place an Order',
          () => Navigator.pop(context),
        );
      }

      return _buildOrdersList(
        controller.deliveredOrders,
      );
    });
  }

  /// Build orders list with pull-to-refresh
  Widget _buildOrdersList(
    List<PharmacyOrderEntity> orders, {
    bool showRefresh = false,
    bool showTrackingInfo = false,
  }) {
    final controller = widget.controller;

    final listView = ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (context, index) => gapH16,
      itemBuilder: (context, index) {
        final order = orders[index];
        return PharmacyOrderCard(
          order: order,
          showTrackingInfo: showTrackingInfo,
          onTap: () => controller.viewOrderDetails(order),
          onTrackOrder: () => controller.trackOrder(order),
          onCancelOrder:
              order.canBeCancelled ? () => controller.cancelOrder(order) : null,
          onReorder: order.status == OrderStatus.delivered ||
                  order.status == OrderStatus.cancelled
              ? () => controller.reorderItems(order)
              : null,
        );
      },
    );

    if (showRefresh) {
      return RefreshIndicator(
        onRefresh: controller.refreshAllOrders,
        child: listView,
      );
    }

    return listView;
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          gapH16,
          AppText.primary(
            'Loading orders...',
            fontSize: 16,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(
    String title,
    String message,
    String buttonText,
    VoidCallback onButtonPressed,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.grey95,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                size: 50,
                color: AppColors.grey60,
              ),
            ),
            gapH24,

            // Title
            AppText.primary(
              title,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            gapH8,

            // Message
            AppText.primary(
              message,
              fontSize: 16,
              fontWeight: FontWeightType.regular,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            gapH32,

            // Action button
            SizedBox(
              width: 200,
              child: PrimaryButton(
                title: buttonText,
                onPressed: onButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
