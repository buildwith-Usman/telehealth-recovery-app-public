import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_app_bar.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_routes.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/button/left_icon_button.dart';
import '../widgets/common/icon_text_row_item.dart';
import 'admin_medicine_orders_controller.dart';

class AdminMedicineOrdersPage
    extends BaseStatefulPage<AdminMedicineOrdersController> {
  const AdminMedicineOrdersPage({super.key});

  @override
  BaseStatefulPageState<AdminMedicineOrdersController> createState() =>
      _AdminMedicineOrdersPageState();
}

class _AdminMedicineOrdersPageState
    extends BaseStatefulPageState<AdminMedicineOrdersController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Medicine Orders',
      showBackButton: true,
      onBackPressed: () => Get.back(),
    );
  }

  @override
  bool useStandardPadding = true;

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Obx(
      () => DefaultTabController(
        length: widget.controller.tabs.length,
        initialIndex: widget.controller.tabIndex.value,
        child: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelPadding: const EdgeInsets.only(right: 24.0),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: widget.controller.tabs
              .map((tabText) => Tab(
                    text: tabText,
                    height: 36,
                  ))
              .toList(),
          onTap: (index) => widget.controller.changeTabIndex(index),
          labelColor: AppColors.accent,
          unselectedLabelColor: Colors.black,
          indicatorColor: AppColors.accent,
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: FontFamilyType.inter.name(),
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (widget.controller.errorMessage != null) {
        return _buildErrorState();
      }

      return _buildOrderList();
    });
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          gapH20,
          AppText.primary(
            'Oops! Something went wrong',
            fontFamily: FontFamilyType.inter,
            fontSize: 18,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH8,
          AppText.primary(
            widget.controller.errorMessage ?? 'Unable to load orders',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH30,
          PrimaryButton(
            title: 'Try Again',
            onPressed: () => widget.controller.fetchOrders(),
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 55,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.controller.refreshOrders();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        shrinkWrap: true,
        itemCount: widget.controller.filteredOrders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(
              widget.controller.filteredOrders[index], index);
        },
      ),
    );
  }

  Widget _buildOrderCard(MedicineOrder order, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(
                "#MED-001251",
                fontFamily: FontFamilyType.inter,
                fontSize: 12,
                fontWeight: FontWeightType.regular,
                color: AppColors.black,
              ),
              gapH10,
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapH14,
                      IconTextRowItem(
                        iconWidget:
                            AppIcon.userIcon.widget(width: 12, height: 12),
                        text: "Usman Haider",
                      ),
                      gapH14,
                      IconTextRowItem(
                        iconWidget:
                            AppIcon.userIcon.widget(width: 12, height: 12),
                        text: "Rs.250",
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gapH14,
                      IconTextRowItem(
                        iconWidget: AppIcon.datePickerIcon
                            .widget(width: 12, height: 12),
                        text: "Jul 6, 2025",
                      ),
                      gapH14,
                      IconTextRowItem(
                        iconWidget:
                            AppIcon.sessionClock.widget(width: 12, height: 12),
                        text: "Status: | ${_getStatusText(order.status)}",
                      ),
                    ],
                  ),
                ],
              ),
              gapH20,
              LeftIconButton(
                title: "View",
                width: 150.0,
                height: 35.0,
                color: AppColors.checkedColor,
                textColor: AppColors.white,
                borderColor: AppColors.checkedColor,
                iconColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                onPressed: () => Get.toNamed(AppRoutes.adminOrderDetailsPage),
                icon: Icons.remove_red_eye,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.dispatched:
        return 'Dispatched';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.dispatched:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  @override
  void setupAdditionalListeners() {}
}
