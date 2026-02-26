import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_app_bar.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/config/app_routes.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import 'admin_manage_feature_product_controller.dart';

class AdminManageFeatureProductPage
    extends BaseStatefulPage<AdminManageFeatureProductController> {
  const AdminManageFeatureProductPage({super.key});

  @override
  BaseStatefulPageState<AdminManageFeatureProductController> createState() =>
      _AdminManageFeatureProductPageState();
}

class _AdminManageFeatureProductPageState
    extends BaseStatefulPageState<AdminManageFeatureProductController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Manage Feature Products',
      showBackButton: true,
      onBackPressed: () => Get.back(),
    );
  }

  @override
  Widget? buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: PrimaryButton(
        title: 'Add New Featured Product',
        onPressed: () => Get.toNamed(AppRoutes.adminAddFeaturedProductPage),
        color: AppColors.primary,
        textColor: AppColors.white,
      ),
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCurrentlyFeaturedHeader(),
        gapH20,
        Obx(() => _buildBody()),
      ],
    );
  }

  Widget _buildCurrentlyFeaturedHeader() {
    return AppText.primary(
      'Currently Featured (${widget.controller.products.length}/${widget.controller.maxFeaturedProducts})',
      fontFamily: FontFamilyType.poppins,
      fontSize: 16,
      fontWeight: FontWeightType.semiBold,
      color: AppColors.black,
    );
  }

  Widget _buildBody() {
    if (widget.controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.controller.errorMessage != null) {
      return _buildErrorState();
    }

    return _buildProductGrid();
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
            widget.controller.errorMessage ?? 'Unable to load products',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          gapH30,
          PrimaryButton(
            title: 'Try Again',
            onPressed: () => widget.controller.fetchFeatureProducts(),
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 55,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.controller.refreshFeatureProducts();
      },
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          mainAxisExtent: 160,
        ),
        itemCount: widget.controller.products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(widget.controller.products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with background
          Container(
            width: 150,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.grey90,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: product.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        width: 63,
                        height: 75,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.medication,
                          size: 60,
                          color: AppColors.grey80,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.medication,
                      size: 60,
                      color: AppColors.grey80,
                    ),
            ),
          ),
          gapH8,
          // Product name
          AppText.primary(
            product.name,
            fontSize: 13,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          gapH8,
          // Remove button
          GestureDetector(
            onTap: () => widget.controller.removeProduct(product.id),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 14.0,
                  width: 14.0,
                  padding: const EdgeInsets.all(2.0),
                  child: AppIcon.icDeleteProduct.widget(),
                ),
                gapW6,
                AppText.primary(
                  'Remove',
                  fontSize: 11,
                  fontWeight: FontWeightType.medium,
                  fontFamily: FontFamilyType.roboto,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void setupAdditionalListeners() {
    // Could add additional page-specific listeners here if needed
  }
}
