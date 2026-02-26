import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/presentation/pharmacy/screens/pharmacy_home/pharmacy_home_controller.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/config/app_icon.dart';
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/banner/pharmacy_banner.dart';
import '../../../widgets/button/custom_navigation_button.dart';
import '../../../widgets/common/recovery_app_bar.dart';
import '../../../widgets/common/recovery_grid_view.dart';
import '../../../widgets/common/section_header_with_dropdown.dart';
import '../../../widgets/textfield/search_textfield.dart';
import '../../../widgets/card/featured_product_card.dart';
import '../../../widgets/card/medicine_card.dart';
import '../../widgets/category_filter_dropdown.dart';

class PharmacyHomePage extends BaseStatefulPage<PharmacyHomeController> {
  const PharmacyHomePage({super.key});

  @override
  BaseStatefulPageState<PharmacyHomeController> createState() =>
      _PharmacyHomePageState();
}

class _PharmacyHomePageState
    extends BaseStatefulPageState<PharmacyHomeController> {
  final GlobalKey _categoryDropdownKey = GlobalKey();

  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.branded(
      brandWidget: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppIcon.pharmacyGroupIcon.widget(
            width: 104,
            height: 32,
            color: AppColors.primary,
          ),
        ],
      ),
      actions: [
        // View Cart Button
        CustomNavigationButton.withIcon(
          onPressed: () {
            // Navigate to cart
            widget.controller.navigateToCart();
          },
          customIcon: AppIcon.cartIcon.widget(
            width: 16,
            height: 16,
          ),
          isFilled: true,
          filledColor: AppColors.white,
          size: 35,
          borderRadius: 6,
          showBorder: false,
        ),
        // View Prescription Button
        CustomNavigationButton.withIcon(
          onPressed: () {
            // Navigate to prescriptions
            widget.controller.viewPrescription();
          },
          customIcon: AppIcon.viewPrescriptionIcon.widget(
            width: 16,
            height: 16,
          ),
          size: 35,
          isFilled: true,
          filledColor: AppColors.white,
          borderRadius: 6,
          showBorder: false,
        ),
      ],
      horizontalPadding: 20,
      verticalPadding: 16,
    );
  }

  @override
  bool get useStandardPadding => false; // We'll handle padding per section

  @override
  Widget buildPageContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await widget.controller.refreshMedicines();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search field with horizontal padding
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: _buildSearchField(),
            ),
            gapH20,
            // Banner without padding (full width)
            _buildPromotionalBanner(),
            gapH20,
            // Featured Products Section
            _buildFeaturedProductsSection(),
            gapH20,
            // Rest of content with horizontal padding
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCategorySection(),
                  gapH20,
                  _buildMedicinesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return SearchTextField(
      hintText: 'Search here...',
      height: 40,
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
        widget.controller.onSearchChanged(value);
      },
      onFieldSubmitted: (value) {
        widget.controller.onSearchSubmitted(value);
      },
    );
  }

  Widget _buildPromotionalBanner() {
    return Obx(() {
      // Show loading indicator while banners are loading
      if (widget.controller.isBannersLoading.value &&
          widget.controller.banners.isEmpty) {
        return const SizedBox(
          height: 180,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
      }

      // Show banner if available
      if (widget.controller.banners.isNotEmpty) {
        return PharmacyBanner(
          banners: widget.controller.banners,
          onBannerTap: widget.controller.onBannerTap,
          height: 180,
          showIndicators: true,
          enableAutoPlay: false,
        );
      }

      // Don't show anything if no banners
      return const SizedBox.shrink();
    });
  }

  Widget _buildCategorySection() {
    return Obx(() => Container(
          key: _categoryDropdownKey,
          child: SectionHeaderWithDropdown(
            title: 'Medicines',
            dropdownText: widget.controller.categoryFilterDisplayText,
            onDropdownTap: () => _showCategoryFilterDialog(),
            titleColor: AppColors.textPrimary,
            dropdownColor: AppColors.accent,
          ),
        ));
  }

  void _showCategoryFilterDialog() {
    CategoryFilterDropdown.show(
      context: context,
      key: _categoryDropdownKey,
      selectedCategories: widget.controller.selectedCategoryFilters,
      onChanged: (filters) {
        widget.controller.onCategoryFilterChanged(filters);
      },
    );
  }

  Widget _buildMedicinesSection() {
    return Obx(() {
      // Show loading indicator while medicines are loading
      if (widget.controller.isMedicinesLoading.value &&
          widget.controller.medicines.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
      }

      // Show empty state if no medicines
      if (widget.controller.medicines.isEmpty) {
        return SizedBox(
          height: 200,
          child: Center(
            child: AppText.primary(
              'No medicines available',
              fontSize: 14,
              fontWeight: FontWeightType.regular,
              color: AppColors.grey60,
            ),
          ),
        );
      }

      // Show medicines grid
      return RecoveryGridView(
        itemCount: widget.controller.medicines.length,
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 181,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final medicine = widget.controller.medicines[index];
          return MedicineCard(
            medicine: medicine,
            onTap: () => widget.controller.navigateToMedicineDetail(
              medicine.id.toString(),
            ),
          );
        },
      );
    });
  }

  Widget _buildFeaturedProductsSection() {
    return Obx(() {
      // Show loading indicator while featured products are loading
      if (widget.controller.isFeaturedProductsLoading.value &&
          widget.controller.featuredProducts.isEmpty) {
        return Container(
          height: 220,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.primary(
                'Featured Products',
                fontSize: 16,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.textPrimary,
              ),
              gapH12,
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Don't show section if no featured products
      if (widget.controller.featuredProducts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header with "View All" button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.primary(
                  'Featured Products',
                  fontSize: 16,
                  fontWeight: FontWeightType.semiBold,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
            gapH12,
            // Horizontal scrollable featured products list
            SizedBox(
              height: 160,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.controller.featuredProducts.length,
                separatorBuilder: (_, __) => gapW12,
                itemBuilder: (context, index) {
                  final product = widget.controller.featuredProducts[index];
                  return FeaturedProductCard(
                    product: product,
                    width: 120,
                    height: 120,
                    onTap: () => {},
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
