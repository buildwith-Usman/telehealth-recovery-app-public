import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/recovery_app_bar.dart';

import '../../app/config/app_colors.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../admin_manage_feature_product/admin_manage_feature_product_controller.dart';
import '../widgets/button/left_icon_button.dart';
import '../widgets/common/icon_text_row_item.dart';
import '../widgets/textfield/search_textfield.dart';
import 'admin_add_featured_product_controller.dart';

class AdminAddFeaturedProductPage
    extends BaseStatefulPage<AdminAddFeaturedProductController> {
  const AdminAddFeaturedProductPage({super.key});

  @override
  BaseStatefulPageState<AdminAddFeaturedProductController> createState() =>
      _AdminAddFeaturedProductPageState();
}

class _AdminAddFeaturedProductPageState
    extends BaseStatefulPageState<AdminAddFeaturedProductController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Add Featured Product',
      showBackButton: true,
      onBackPressed: () => Get.back(),
    );
  }

  @override
  bool get useStandardPadding => true;

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        gapH20,
        Expanded(
          child: Obx(() => _buildBody()),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SearchTextField(
      hintText: 'Search products...',
      height: 50,
      borderRadius: 8,
      backgroundColor: AppColors.white,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: AppIcon.searchIcon.widget(
          width: 24,
          height: 24,
        ),
      ),
      onChanged: (value) {
        widget.controller.searchController = TextEditingController(text: value);
        widget.controller.filterProducts();
      },
      onFieldSubmitted: (value) {},
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
            onPressed: () => widget.controller.fetchProducts(),
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
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 200,
      ),
      itemCount: widget.controller.filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(widget.controller.filteredProducts[index]);
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.imageUrl != null
                          ? Image.network(
                              product.imageUrl!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: AppColors.grey90,
                                  child: const Icon(
                                    Icons.medication,
                                    color: AppColors.grey60,
                                    size: 30,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: AppColors.grey90,
                              child: const Icon(
                                Icons.medication,
                                color: AppColors.grey60,
                                size: 30,
                              ),
                            ),
                    ),
                  ),
                  gapH8,
                  IconTextRowItem(
                    iconWidget: AppIcon.icParacetamol.widget(width: 12, height: 12),
                    text: product.name,
                  ),
                  gapH4,
                  if (product.hasDiscount)
                    IconTextRowItem(
                      iconWidget: AppIcon.icFever.widget(width: 12, height: 12),
                      text: "${product.discountPercentage?.toStringAsFixed(0)}% Off",
                    ),
                  if (product.hasDiscount) gapH4,
                  IconTextRowItem(
                    iconWidget: AppIcon.icWalutPrice.widget(width: 12, height: 12),
                    text: "Rs. ${product.price?.toStringAsFixed(2) ?? '0.00'}",
                  ),
                ],
              ),
              LeftIconButton(
                title: "Add to Featured",
                width: double.infinity,
                height: 32.0,
                fontSize: 10,
                color: AppColors.primary,
                textColor: AppColors.white,
                borderColor: AppColors.primary,
                iconColor: AppColors.white,
                onPressed: () => widget.controller.addToFeatured(product),
                icon: Icons.star_purple500_outlined,
              ),
            ],
          )),
    );
  }

  @override
  void setupAdditionalListeners() {}
}