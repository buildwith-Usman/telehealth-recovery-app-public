import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_prescription_controller.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/config/app_icon.dart';
import '../../../../app/config/app_image.dart';
import '../../../../app/services/base_stateful_page.dart';
import '../../../../app/utils/sizes.dart';
import '../../../../domain/entity/medicine_entity.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/button/primary_button.dart';
import '../../../widgets/common/recovery_app_bar.dart';
import '../../../widgets/common/recovery_grid_view.dart';
import '../../../widgets/card/medicine_card.dart';

/// Order Prescription Page - Allows patient to order prescribed medicines
class OrderPrescriptionPage
    extends BaseStatefulPage<OrderPrescriptionController> {
  const OrderPrescriptionPage({super.key});

  @override
  BaseStatefulPageState<OrderPrescriptionController> createState() =>
      _OrderPrescriptionPageState();
}

class _OrderPrescriptionPageState
    extends BaseStatefulPageState<OrderPrescriptionController> {
  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Order Prescription',
      showBackButton: true,
      backButtonIcon: AppIcon.navHome.widget(
        width: 20,
        height: 20,
        color: AppColors.accent,
      ),
      backgroundColor: AppColors.whiteLight,
    );
  }

  @override
  bool get useStandardPadding => true;

  // Shared dummy medicines so cart and grid can read the same state
  final List<MedicineEntity> _dummyMedicines = [];
  final Map<int, int> _cartMedicineQuantities = {}; // Track medicine ID -> quantity

  @override
  void initState() {
    super.initState();

    // Initialize dummy medicines with MedicineEntity
    _dummyMedicines.addAll([
      const MedicineEntity(
        id: 1,
        name: 'Paracetamol',
        category: 'Pain Relief',
        price: 120.0,
        stockQuantity: 50,
        manufacturer: 'GSK',
        requiresPrescription: false,
      ),
      const MedicineEntity(
        id: 2,
        name: 'Amoxicillin',
        category: 'Antibiotic',
        price: 250.0,
        stockQuantity: 30,
        manufacturer: 'Pfizer',
        requiresPrescription: true,
      ),
      const MedicineEntity(
        id: 3,
        name: 'Ibuprofen',
        category: 'Pain Relief',
        price: 90.0,
        stockQuantity: 45,
        manufacturer: 'Abbott',
        requiresPrescription: false,
      ),
      const MedicineEntity(
        id: 4,
        name: 'Cetirizine',
        category: 'Antihistamine',
        price: 150.0,
        stockQuantity: 60,
        manufacturer: 'UCB',
        requiresPrescription: false,
      ),
      const MedicineEntity(
        id: 5,
        name: 'Vitamin D3',
        category: 'Vitamin',
        price: 300.0,
        stockQuantity: 100,
        manufacturer: 'Nature Made',
        requiresPrescription: false,
      ),
      const MedicineEntity(
        id: 6,
        name: 'Omeprazole',
        category: 'Antacid',
        price: 180.0,
        stockQuantity: 25,
        manufacturer: 'AstraZeneca',
        requiresPrescription: true,
      ),
    ]);
  }
  @override
  Widget buildPageContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prescription Image
          _buildPrescriptionImage(),
          gapH20,
          // Prescribed Medicines Grid
          _buildPrescribedMedicinesGrid(),
          // Your Cart Section
          _buildYourCartSection(),
          // Looking for other medicine section
          _buildOtherMedicineSection(),
        ],
      ),
    );
  }

  /// Build prescription image
  Widget _buildPrescriptionImage() {
    return Obx(() {
      final prescriptionImageUrl = widget.controller.prescription.value.prescriptionImageUrl;
      final isDownloading = widget.controller.isDownloading.value;

      return Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Prescription image
            prescriptionImageUrl != null && prescriptionImageUrl.isNotEmpty
                ? Image.network(
                    prescriptionImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return AppImage.prescriptionImage.widget(
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  )
                : AppImage.prescriptionImage.widget(
                    fit: BoxFit.cover,
                  ),
            // Download button at bottom right - show always
            Positioned(
              bottom: 12,
              right: 12,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (isDownloading || 
                          prescriptionImageUrl == null || 
                          prescriptionImageUrl.isEmpty ||
                          (!prescriptionImageUrl.startsWith('http://') && !prescriptionImageUrl.startsWith('https://')))
                      ? null
                      : () {
                          if (kDebugMode) {
                            print('Download button tapped. URL: $prescriptionImageUrl');
                          }
                          widget.controller.downloadPrescriptionImage();
                        },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isDownloading
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                        : Icon(
                            Icons.download,
                            color: (prescriptionImageUrl == null || 
                                    prescriptionImageUrl.isEmpty ||
                                    (!prescriptionImageUrl.startsWith('http://') && !prescriptionImageUrl.startsWith('https://')))
                                ? AppColors.textSecondary.withOpacity(0.5)
                                : AppColors.primary,
                            size: 24,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Build prescribed medicines grid
  Widget _buildPrescribedMedicinesGrid() {
    return RecoveryGridView(
      itemCount: _dummyMedicines.length,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      mainAxisExtent: 230, // Increased height to accommodate button
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final medicine = _dummyMedicines[index];
        final quantity = _cartMedicineQuantities[medicine.id] ?? 0;
        final isInCart = quantity > 0;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Medicine Card
            Expanded(
              child: MedicineCard(
                medicine: medicine,
                onTap: () {
                  // Handle medicine tap - could navigate to detail
                },
              ),
            ),
            gapH8,
            // Add to Cart / Quantity Controls
            if (!isInCart)
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  title: 'Add to Cart',
                  height: 32,
                  fontSize: 12,
                  color: AppColors.primary,
                  onPressed: () {
                    setState(() {
                      _cartMedicineQuantities[medicine.id] = 1;
                    });
                  },
                ),
              )
            else
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Decrease button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (quantity > 1) {
                            _cartMedicineQuantities[medicine.id] = quantity - 1;
                          } else {
                            _cartMedicineQuantities.remove(medicine.id);
                          }
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(7),
                            bottomLeft: Radius.circular(7),
                          ),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    // Quantity display
                    Expanded(
                      child: Center(
                        child: AppText.primary(
                          '$quantity',
                          fontSize: 14,
                          fontWeight: FontWeightType.semiBold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    // Increase button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _cartMedicineQuantities[medicine.id] = quantity + 1;
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(7),
                            bottomRight: Radius.circular(7),
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
  
  /// Build 'Your Cart' section shown below medicines grid
  Widget _buildYourCartSection() {
    final int totalItems = _cartMedicineQuantities.values.fold(0, (sum, qty) => sum + qty);
    final double totalAmount = _dummyMedicines
        .where((m) => _cartMedicineQuantities.containsKey(m.id))
        .fold(0.0, (s, m) => s + ((m.price ?? 0.0) * (_cartMedicineQuantities[m.id] ?? 0)));

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 0, right: 0, bottom: 18),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppIcon.cartIcon.widget(width: 18, height: 18, color: AppColors.primary),
                  gapW8,
                  AppText.primary('Your Cart', fontSize: 16, fontWeight: FontWeightType.semiBold, color: AppColors.textPrimary),
                ],
              ),
              gapH8,
              const Divider(height: 1),
              gapH8,

              Row(
                children: [
                  Row(
                    children: [
                      AppIcon.medicineIcon.widget(width: 16, height: 16, color: AppColors.accent),
                      gapW6,
                      AppText.primary('$totalItems medicine(s)', fontSize: 14, fontWeight: FontWeightType.medium, color: AppColors.textSecondary),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      AppIcon.navPayment.widget(width: 16, height: 16, color: AppColors.accent),
                      gapW6,
                      AppText.primary('Rs. ${totalAmount.toStringAsFixed(2)}', fontSize: 14, fontWeight: FontWeightType.semiBold, color: AppColors.textPrimary),
                    ],
                  ),
                ],
              ),
              gapH12,
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  title: 'View Cart & Checkout',
                  height: 44,
                  fontSize: 14,
                  color: AppColors.primary,
                  onPressed: () {
                    // Use existing controller method to navigate to cart
                    widget.controller.addToCartAndProceed();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build 'Looking for other medicine' section
  Widget _buildOtherMedicineSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppIcon.medicineIcon.widget(
                    width: 18, 
                    height: 18, 
                    color: AppColors.primary,
                  ),
                  gapW8,
                  AppText.primary(
                    'Looking for other medicine',
                    fontSize: 16,
                    fontWeight: FontWeightType.semiBold,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
              gapH16,
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  title: 'Browse Medicine Marketplace',
                  height: 44,
                  fontSize: 14,
                  showIcon: true,
                  color: AppColors.primary,
                  onPressed: () {
                    // Navigate to medicine marketplace
                    widget.controller.skipOrdering();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
