import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/presentation/navigation/nav_controller.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/base_horizontal_profile_card.dart';
import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/button/custom_navigation_button.dart';
import 'admin_patients_list_controller.dart';

class AdminPatientsListPage
    extends BaseStatefulPage<AdminPatientsListController> {
  const AdminPatientsListPage({super.key});

  @override
  BaseStatefulPageState<AdminPatientsListController> createState() =>
      _AdminPatientListPageState();
}

class _AdminPatientListPageState
    extends BaseStatefulPageState<AdminPatientsListController> {
  @override
  Widget buildPageContent(BuildContext context) {
    final NavController navController = Get.find();
    return Scaffold(
      backgroundColor: AppColors.whiteLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(navController),
                gapH20,
                Obx(() => _buildBody())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(NavController navController) {
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
              'Patients',
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

  Widget _buildBody() {
    return _buildPatientList();
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
            widget.controller.errorMessage ??
                'Unable to load matched therapists',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH30,
          PrimaryButton(
            title: 'Try Again',
            onPressed: () => widget.controller.retryLoading(),
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 55,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList() {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.controller.refreshPatients();
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.controller.patientList.length,
        itemBuilder: (context, index) {
          return _buildPatientCard(widget.controller.patientList[index], index);
        },
      ),
    );
  }

  Widget _buildPatientCard(ProfileCardItem patient, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: BaseHorizontalProfileCard(
        item: patient,
      ),
    );
  }

  @override
  void setupAdditionalListeners() {
    // Could add additional page-specific listeners here if needed
  }
}
