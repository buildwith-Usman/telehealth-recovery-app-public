import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:recovery_consultation_app/presentation/widgets/button/primary_button.dart';
import 'package:recovery_consultation_app/presentation/widgets/common/section_header_with_dropdown.dart';
import 'package:recovery_consultation_app/presentation/widgets/textfield/search_textfield.dart';

import '../../app/config/app_colors.dart';
import '../../app/config/app_constant.dart';
import '../../app/config/app_routes.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/button/left_icon_button.dart';
import '../widgets/common/icon_text_row_item.dart';
import '../widgets/common/recovery_app_bar.dart';
import '../widgets/dropdown/stock_status_filter_dropdown.dart';
import 'admin_medicine_product_listing_controller.dart';

class AdminMedicineProductListingPage
    extends BaseStatefulPage<AdminMedicineProductListingController> {
  const AdminMedicineProductListingPage({super.key});

  @override
  BaseStatefulPageState<AdminMedicineProductListingController> createState() =>
      _AdminMedicineProductListingPageState();
}

class _AdminMedicineProductListingPageState
    extends BaseStatefulPageState<AdminMedicineProductListingController> {
  final GlobalKey _productDropdownKey = GlobalKey();

  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Medicine Products',
      showBackButton: true,
      onBackPressed: () => Get.back(),
    );
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSearchBar(),
        gapH14,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAddProductButton(),
            _buildFilterDropdown(),
          ],
        ),
        gapH20,
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SearchTextField(
      controller: widget.controller.searchController,
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
      onFieldSubmitted: (value) {},
    );
  }

  Widget _buildAddProductButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.adminMedicineAddProductPage),
      child: IconTextRowItem(
        iconWidget: AppIcon.recoveryAdd.widget(width: 12, height: 12),
        textWidget: AppText.primary(
          "Add Product",
          fontFamily: FontFamilyType.poppins,
          fontWeight: FontWeightType.semiBold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Obx(() => Container(
          key: _productDropdownKey,
          child: SectionHeaderWithDropdown(
            title: '',
            dropdownText: widget.controller.stockFilterDisplayText,
            onDropdownTap: () => _showProductFilterDialog(),
            titleColor: AppColors.textPrimary,
            dropdownColor: AppColors.accent,
          ),
        ));
  }

  void _showProductFilterDialog() {
    StockStatusFilterDropdown.show(
      context: context,
      key: _productDropdownKey,
      selectedStatus: widget.controller.selectedStockFilter.value,
      onChanged: (status) {
        widget.controller.onStockFilterChanged(status);
      },
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

      return _buildProductList();
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
            onPressed: () => widget.controller.fetchMedicineProducts(),
            color: AppColors.primary,
            textColor: AppColors.white,
            height: 55,
            radius: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Obx(() {
      // Show empty state if no products match the filter
      if (widget.controller.filteredProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: AppColors.grey50,
              ),
              gapH20,
              AppText.primary(
                'No products found',
                fontFamily: FontFamilyType.inter,
                fontSize: 18,
                fontWeight: FontWeightType.semiBold,
                color: AppColors.textPrimary,
              ),
              gapH8,
              AppText.primary(
                'Try adjusting your search or filter',
                fontFamily: FontFamilyType.inter,
                fontSize: 14,
                fontWeight: FontWeightType.regular,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          await widget.controller.refreshMedicineProducts();
        },
        child: ListView.builder(
          itemCount: widget.controller.filteredProducts.length,
          itemBuilder: (context, index) {
            return _buildProductCard(
                widget.controller.filteredProducts[index], index);
          },
        ),
      );
    });
  }

  String _getStatusText(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.hidden:
        return 'Hidden';
      default:
        return 'All';
    }
  }

  Widget _buildProductCard(MedicineProduct product, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconTextRowItem(
                    iconWidget:
                        AppIcon.icParacetamol.widget(width: 12, height: 12),
                    text: product.name,
                  ),
                  GestureDetector(
                    onTap: () => widget.controller.deleteProduct(product.id),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppIcon.icRemoveProduct.widget(),
                        gapW5,
                        AppText.primary(
                          fontSize: 10.0,
                          fontWeight: FontWeightType.regular,
                          fontFamily: FontFamilyType.roboto,
                          'Remove',
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            gapH10,
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapH10,
                        IconTextRowItem(
                          iconWidget:
                              AppIcon.icParacetamol.widget(width: 12, height: 12),
                          text: product.name,
                        ),
                        gapH14,
                        IconTextRowItem(
                          iconWidget:
                              AppIcon.icWalutPrice.widget(width: 12, height: 12),
                          text: product.finalPrice != null
                              ? "Rs.${product.finalPrice!.toStringAsFixed(0)}"
                              : "Rs.${product.price?.toStringAsFixed(0) ?? '0'}",
                        ),
                        gapH14,
                        IconTextRowItem(
                          iconWidget:
                              AppIcon.icVisibilty.widget(width: 12, height: 12),
                          text: "Visible: ${product.isVisible == true ? 'Yes' : 'No'}",
                        ),
                        gapH10,
                      ],
                    ),
                  ),
                  gapW10,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapH10,
                        IconTextRowItem(
                          iconWidget: AppIcon.icSupplementDrug
                              .widget(width: 12, height: 12),
                          text: product.categoryName ?? "Uncategorized",
                        ),
                        gapH14,
                        IconTextRowItem(
                          iconWidget: AppIcon.icSupplementMedicen
                              .widget(width: 12, height: 12),
                          text: _getStatusText(product.status),
                        ),
                        gapH14,
                        IconTextRowItem(
                          iconWidget: AppIcon.icStockMedicen
                              .widget(width: 12, height: 12),
                          text: "Stock Quantity | ${product.stockQuantity ?? 0}",
                        ),
                        gapH10,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  onPressed: () async {
                    widget.controller.logger.method('🖱️ Edit button pressed for product: ${product.name}');
                    final productEntity = widget.controller.getProductEntityById(product.id);

                    if (productEntity != null) {
                      widget.controller.logger.method('✅ Navigating to edit page with product: ${productEntity.medicineName}');

                      final result = await Get.toNamed(
                        AppRoutes.adminMedicineAddProductPage,
                        arguments: {
                          Arguments.isEdit: true,
                          Arguments.product: productEntity,
                        },
                      );

                      widget.controller.logger.method('🔙 Returned from edit page with result: $result');

                      // Refresh list if product was updated
                      if (result == true) {
                        widget.controller.logger.method('🔄 Refreshing product list');
                        await widget.controller.refreshMedicineProducts();
                      }
                    } else {
                      widget.controller.logger.error('❌ Product entity not found for ID: ${product.id}');
                    }
                  },
                  icon: Icons.edit,
                ),
                const Spacer(),
                LeftIconButton(
                  title: product.status == StockStatus.hidden ? "Show" : "Hide",
                  width: 150.0,
                  height: 35.0,
                  color: product.status == StockStatus.hidden
                      ? Colors.green
                      : AppColors.red513,
                  textColor: AppColors.white,
                  borderColor: product.status == StockStatus.hidden
                      ? Colors.green
                      : AppColors.red513,
                  iconColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  onPressed: () =>
                      widget.controller.toggleProductVisibility(product.id),
                  icon: product.status == StockStatus.hidden
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                gapW10,
              ],
            ),
            gapH10,
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return Colors.green;
      case StockStatus.outOfStock:
        return Colors.red;
      case StockStatus.hidden:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  void setupAdditionalListeners() {
    // Could add additional page-specific listeners here if needed
  }
}
