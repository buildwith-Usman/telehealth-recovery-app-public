import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/navigation/nav_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/item_vertical_card.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_grid_view.dart';
import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import 'recent_patients_list_controller.dart';

class RecentPatientsListPage
    extends BaseStatefulPage<RecentPatientsListController> {
  const RecentPatientsListPage({super.key});

  @override
  BaseStatefulPageState<RecentPatientsListController> createState() =>
      _RecentPatientsListPageState();
}

class _RecentPatientsListPageState
    extends BaseStatefulPageState<RecentPatientsListController> {
  @override
  Widget buildPageContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildHeader()),
              gapH20,
              _buildPatientList(),
              gapH30,
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildHeader() {
    final NavController navController = Get.find();
    return Row(
      children: [
        CustomNavigationButton(
          type: NavigationButtonType.previous,
          onPressed: () => {
            if (navController.currentIndex == 1)
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
              'Recent Patients',
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

  Widget _buildPatientList() {
    return Obx(() {
      if (widget.controller.recentPatients.isEmpty) {
        return _buildEmptyState();
      }

      return _buildGridView();
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.accent,
          ),
          gapH16,
          AppText.primary(
            'No patients found',
            fontFamily: FontFamilyType.poppins,
            fontSize: 18,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return RecoveryGridView(
      itemCount: widget.controller.recentPatients.length,
      itemBuilder: (context, index) {
        return ItemVerticalCard(
          margin: EdgeInsets.zero,
          item: widget.controller.recentPatients[index],
        );
      },
      mainAxisExtent: 220,
    );
  }
}
