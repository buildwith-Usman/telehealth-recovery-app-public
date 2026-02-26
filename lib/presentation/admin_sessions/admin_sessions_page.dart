import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/presentation/navigation/nav_controller.dart';
import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/cards/admin_appointment_card.dart';
import 'admin_sessions_controller.dart';

class AdminSessionsPage extends BaseStatefulPage<AdminSessionsController> {
  const AdminSessionsPage({super.key});

  @override
  BaseStatefulPageState<AdminSessionsController> createState() =>
      _AdminSessionsPageState();
}

class _AdminSessionsPageState
    extends BaseStatefulPageState<AdminSessionsController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                gapH20,
                _buildTabSelector(),
                gapH20,
                Expanded(
                  child: Obx(() => _buildContent()),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildHeader() {
    final  NavController navController = Get.find();
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {
            if (navController.currentIndex == 2)
              {navController.changeTab(0)}
            else
              Get.back()
          },
          isFilled: true,
          filledColor: AppColors.whiteLight,
          iconColor: AppColors.accent,
          backgroundColor: AppColors.white,
        ),
        Expanded(
          child: Center(
            child: AppText.primary(
              'All Appointments',
              fontFamily: FontFamilyType.poppins,
              fontSize: 20,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.black,
            ),
          ),
        ),
        // Empty container to balance the layout
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() => Row(
            children: [
              _buildTabButton(
                type: AdminSessionType.upcoming,
                title: 'Upcoming',
                count: widget.controller.upcomingSessions.length,
              ),
              _buildTabButton(
                type: AdminSessionType.ongoing,
                title: 'Ongoing',
                count: widget.controller.ongoingSessions.length,
              ),
              _buildTabButton(
                type: AdminSessionType.completed,
                title: 'Completed',
                count: widget.controller.completedSessions.length,
              ),
            ],
          )),
    );
  }

  Widget _buildTabButton({
    required AdminSessionType type,
    required String title,
    required int count,
  }) {
    final isSelected = widget.controller.selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.controller.selectType(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppText.primary(
                title,
                fontWeight: isSelected
                    ? FontWeightType.semiBold
                    : FontWeightType.regular,
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
              // gapW4,
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              //   decoration: BoxDecoration(
              //     color: isSelected
              //         ? Colors.white.withOpacity(0.2)
              //         : AppColors.primary.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: AppText.primary(
              //     count.toString(),
              //     fontWeight: FontWeightType.regular,
              //     color: isSelected ? AppColors.white : AppColors.primary,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (widget.controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (widget.controller.filteredSessions.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => widget.controller.refreshData(),
      child: ListView.builder(
        itemCount: widget.controller.filteredSessions.length,
        itemBuilder: (context, index) {
          final session = widget.controller.filteredSessions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () => widget.controller.viewSessionDetails(session),
              child: AdminAppointmentCard(
                  session: session,
                  onTap: () => widget.controller.viewSessionDetails(session)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String title;
    String message;
    IconData icon;

    switch (widget.controller.selectedType) {
      case AdminSessionType.upcoming:
        title = 'No Upcoming Sessions';
        message = 'There are no upcoming consultation sessions at the moment.';
        icon = Icons.schedule;
        break;
      case AdminSessionType.ongoing:
        title = 'No Ongoing Sessions';
        message = 'There are no active consultation sessions right now.';
        icon = Icons.play_circle_outline;
        break;
      case AdminSessionType.cancelled:
        title = 'No Cancelled Sessions';
        message = 'There are no cancelled consultation sessions to display.';
        icon = Icons.cancel_outlined;
        break;
      case AdminSessionType.completed:
        title = 'No Completed Sessions';
        message = 'There are no completed consultation sessions to display.';
        icon = Icons.check_circle_outline;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => widget.controller.refreshData(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
