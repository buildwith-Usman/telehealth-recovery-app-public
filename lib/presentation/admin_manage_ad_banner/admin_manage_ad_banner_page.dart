import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/left_icon_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_app_bar.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/config/app_routes.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import 'admin_manage_ad_banner_controller.dart';

class AdminManageAdBannerPage
    extends BaseStatefulPage<AdminManageAdBannerController> {
  const AdminManageAdBannerPage({super.key});

  @override
  BaseStatefulPageState<AdminManageAdBannerController> createState() =>
      _AdminManageAdBannerPageState();
}

class _AdminManageAdBannerPageState
    extends BaseStatefulPageState<AdminManageAdBannerController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Manage Ad Banners',
      showBackButton: true,
      onBackPressed: () => Get.back(),
      actions: [
        Obx(() {
          final isLoading = widget.controller.isLoading.value;
          return IconButton(
            icon: Icon(
              Icons.refresh,
              color: isLoading ? AppColors.grey50 : AppColors.primary,
            ),
            onPressed: isLoading ? null : () => widget.controller.refreshAdBanners(),
            tooltip: 'Refresh',
          );
        }),
      ],
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.adminAdBannerCreationPage),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppIcon.recoveryAdd.widget(width: 12.0, height: 12.0),
              gapW8,
              AppText.h4(
                "New Banner",
                fontSize: 16.0,
              )
            ],
          ),
        ),
        gapH16,
        Expanded(
          child: Obx(() => _buildBody()),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (widget.controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.controller.errorMessage != null) {
      return _buildErrorState();
    }

    return _buildAdBannerList();
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
            widget.controller.errorMessage ?? 'Unable to load ad banners',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH30,
          PrimaryButton(
            title: 'Try Again',
            onPressed: () => widget.controller.fetchAdBanners(),
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 55,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildAdBannerList() {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.controller.refreshAdBanners();
      },
      child: ListView.builder(
        itemCount: widget.controller.adBanners.length,
        itemBuilder: (context, index) {
          return _buildAdBannerCard(widget.controller.adBanners[index], index);
        },
      ),
    );
  }

  Widget _buildAdBannerCard(AdBannerModel banner, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    gapW10,
                    AppIcon.datePickerIcon.widget(width: 12.0, height: 12.0),
                    gapW8,
                    AppText.primary(
                      "${banner.startDate} – ${banner.endDate}",
                      fontSize: 10.0,
                      fontFamily: FontFamilyType.inter,
                      fontWeight: FontWeightType.regular,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText.primary(
                      banner.isActive ? "Active" : "Inactive",
                      fontSize: 10.0,
                      fontFamily: FontFamilyType.inter,
                      fontWeight: FontWeightType.regular,
                    ),
                    gapW5,
                    Container(
                      height: 10.0,
                      width: 10.0,
                      decoration: BoxDecoration(
                          color: banner.isActive ? Colors.green : Colors.grey,
                          shape: BoxShape.circle),
                    ),
                    gapW10,
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 147.0,
            width: double.infinity,
            color: AppColors.whiteLightAlt,
            margin: const EdgeInsets.all(10.0),
            child: banner.imageUrl != null
                ? Image.network(
                    banner.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: AppText.primary(
                      banner.title,
                      fontSize: 14.0,
                      fontFamily: FontFamilyType.inter,
                      fontWeight: FontWeightType.medium,
                      color: AppColors.textSecondary,
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              gapW10,
              LeftIconButton(
                title: "Edit",
                width: 150.0,
                height: 35.0,
                color: AppColors.primary,
                textColor: AppColors.white,
                borderColor: AppColors.primary,
                iconColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                onPressed: () => widget.controller.editBanner(banner),
                icon: Icons.edit,
              ),
              const Spacer(),
              LeftIconButton(
                title: banner.isActive ? "Disable" : "Enable",
                width: 150.0,
                height: 35.0,
                color: banner.isActive ? AppColors.red513 : Colors.green,
                textColor: AppColors.white,
                borderColor: banner.isActive ? AppColors.red513 : Colors.green,
                iconColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                onPressed: () => widget.controller.toggleBannerStatus(banner.id),
                icon: banner.isActive
                    ? Icons.disabled_visible_rounded
                    : Icons.check_circle_outline,
              ),
              gapW10,
            ],
          ),
          gapH10,
        ],
      ),
    );
  }

  @override
  void setupAdditionalListeners() {
    // Could add additional page-specific listeners here if needed
  }
}
