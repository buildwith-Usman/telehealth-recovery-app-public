import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/domain/entity/featured_product_entity.dart';
import 'package:recovery_consultation_app/domain/entity/medicine_entity.dart';
import 'package:recovery_consultation_app/domain/entity/pharmacy_banner_entity.dart';
import 'package:recovery_consultation_app/domain/entity/prescription_entity.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_ad_banners_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_featured_products_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_medicines_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_pharmacy_products_use_case.dart';
import '../../../../app/controllers/base_controller.dart';

class PharmacyHomeController extends BaseController {
  // Use Case Dependencies
  final GetAdBannersUseCase _getAdBannersUseCase;
  final GetFeaturedProductsUseCase _getFeaturedProductsUseCase;
  final GetMedicinesUseCase _getMedicinesUseCase;
  final GetPharmacyProductsUseCase _getPharmacyProductsUseCase;

  PharmacyHomeController({
    required GetAdBannersUseCase getAdBannersUseCase,
    required GetFeaturedProductsUseCase getFeaturedProductsUseCase,
    required GetMedicinesUseCase getMedicinesUseCase,
    required GetPharmacyProductsUseCase getPharmacyProductsUseCase,
  })  : _getAdBannersUseCase = getAdBannersUseCase,
        _getFeaturedProductsUseCase = getFeaturedProductsUseCase,
        _getMedicinesUseCase = getMedicinesUseCase,
        _getPharmacyProductsUseCase = getPharmacyProductsUseCase;

  // Observable variables
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxList<String> categories = <String>[].obs;
  final RxList<PharmacyBannerEntity> banners = <PharmacyBannerEntity>[].obs;
  final RxBool isBannersLoading = false.obs;
  final RxList<FeaturedProductEntity> featuredProducts = <FeaturedProductEntity>[].obs;
  final RxBool isFeaturedProductsLoading = false.obs;
  final RxList<MedicineEntity> medicines = <MedicineEntity>[].obs;
  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final RxBool isMedicinesLoading = false.obs;
  final RxList<String> selectedCategoryFilters = <String>[].obs;
  final RxString sortBy = 'price'.obs;
  final RxString sortOrder = 'asc'.obs;

  // Category name to ID mapping (based on API data)
  // Only two categories exist: Prescription Drugs (1) and Supplements (2)
  final Map<String, int> _categoryNameToId = {
    'Prescription Drugs': 1,
    'Supplements': 2,
  };

  @override
  void onInit() {
    super.onInit();
    _initializeCategories();
    loadBanners();
    loadFeaturedProducts();
    loadMedicines();
  }

  void _initializeCategories() {
    categories.value = [
      'All',
      'Prescription Drugs',
      'Supplements',
    ];
  }

  /// Load promotional banners from repository
  Future<void> loadBanners() async {
    try {
      isBannersLoading.value = true;

      final params = GetAdBannersParams(limit: 3);
      final result = await _getAdBannersUseCase.execute(params);

      // Convert AdBannerEntity to PharmacyBannerEntity (focusing on image only)
      banners.value = result.data.map((adBanner) => PharmacyBannerEntity(
        id: adBanner.id,
        title: adBanner.title,
        description: '', // Not showing description details
        imageUrl: adBanner.imageUrl,
        bannerType: PharmacyBannerType.promotion,
      )).toList();

      logger.controller('Pharmacy banners loaded: ${banners.length} items');
    } catch (e) {
      logger.error('Error loading pharmacy banners', error: e);
      // Don't show error to user, just log it
      // Banners are not critical for the app to function
    } finally {
      isBannersLoading.value = false;
    }
  }

  /// Load featured products from repository
  Future<void> loadFeaturedProducts() async {
    try {
      isFeaturedProductsLoading.value = true;

      final result = await _getFeaturedProductsUseCase.execute();
      featuredProducts.value = result;

      logger.controller('Featured products loaded: ${featuredProducts.length} items');
    } catch (e) {
      logger.error('Error loading featured products', error: e);
      // Don't show error to user, just log it
      // Featured products are not critical for the app to function
    } finally {
      isFeaturedProductsLoading.value = false;
    }
  }

  /// Load medicines from repository
  Future<void> loadMedicines() async {
    try {
      isMedicinesLoading.value = true;

      // Build category ID from selected filters
      // Note: API only supports single category_id, so we'll fetch all and filter client-side
      // if multiple categories are selected
      int? categoryId;
      if (selectedCategoryFilters.length == 1) {
        // Single category selected - use API filter
        final categoryName = selectedCategoryFilters.first;
        categoryId = _categoryNameToId[categoryName];
        logger.controller('Filtering by category: $categoryName (ID: $categoryId)');
      }

      final params = GetPharmacyProductsParams(
        limit: 50,
        categoryId: categoryId,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      );

      final result = await _getPharmacyProductsUseCase.execute(params);

      // Apply client-side filtering if multiple categories selected
      List<ProductEntity> filteredResults = result;
      if (selectedCategoryFilters.length > 1) {
        filteredResults = result.where((product) {
          final categoryName = product.category?.name ?? '';
          return selectedCategoryFilters.contains(categoryName);
        }).toList();
        logger.controller('Client-side filtered to ${filteredResults.length} products from ${result.length}');
      }

      products.value = filteredResults;

      // Convert products to medicines for backward compatibility with UI
      medicines.value = filteredResults.map((product) => MedicineEntity(
        id: product.id,
        name: product.medicineName ?? 'Unknown',
        description: product.description ?? '',
        category: product.category?.name ?? 'Uncategorized',
        price: product.price ?? 0.0,
        imageUrl: product.imageUrl,
        stockQuantity: product.stockQuantity ?? 0,
        manufacturer: '',
        requiresPrescription: false,
        tags: [],
      )).toList();

      logger.controller('Products loaded: ${products.length} items');
    } catch (e) {
      logger.error('Error loading products', error: e);
      // Don't show error to user, just log it
      // Medicines list will be empty and UI can handle that gracefully
    } finally {
      isMedicinesLoading.value = false;
    }
  }

  /// Handle search input
  void onSearchChanged(String query) {
    searchQuery.value = query;
    logger.userAction('Search query: $query');
  }

  /// Handle search submit
  void onSearchSubmitted(String query) {
    logger.userAction('Search submitted: $query');
    loadMedicines();
  }

  /// Handle category selection
  void onCategorySelected(String category) {
    selectedCategory.value = category;
    logger.userAction('Category selected: $category');

    // TODO: Filter medicines by category
    loadMedicinesByCategory(category);
  }

  /// Load medicines by category
  Future<void> loadMedicinesByCategory(String category) async {
    try {
      setLoading(true);

      // TODO: Implement API call to fetch medicines by category
      logger.controller('Loading medicines for category: $category');

      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      logger.error('Error loading medicines by category', error: e);
      Get.snackbar(
        'Error',
        'Failed to load medicines',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      setLoading(false);
    }
  }

  /// Add medicine to cart
  void addToCart(String medicineId) {
    logger.userAction('Adding medicine to cart: $medicineId');

    // TODO: Implement add to cart logic
    Get.snackbar(
      'Success',
      'Added to cart',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.primaryColor,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  /// Navigate to medicine detail
  void navigateToMedicineDetail(String medicineId) {
    logger.navigation('Navigating to medicine detail: $medicineId');

    Get.toNamed(AppRoutes.medicineDetail, arguments: medicineId);
  }

  /// Refresh medicines and banners
  Future<void> refreshMedicines() async {
    logger.controller('Refreshing pharmacy data');
    await Future.wait([
      loadBanners(),
      loadFeaturedProducts(),
      loadMedicines(),
    ]);
  }

  /// Handle banner tap action
  void onBannerTap(PharmacyBannerEntity banner) {
    logger.userAction('Banner tapped: ${banner.title}');

    // TODO: Implement navigation based on banner type
    // Example: Navigate to product detail, category page, etc.
    Get.snackbar(
      'Coming Soon',
      'Navigating to ${banner.title}',
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle category filter changes
  void onCategoryFilterChanged(List<String> filters) {
    selectedCategoryFilters.value = filters;
    logger.userAction('Category filters applied: $filters');

    // Reload medicines with new filters
    loadMedicines();
  }

  /// Get display text for category filter dropdown
  String get categoryFilterDisplayText {
    if (selectedCategoryFilters.isEmpty) {
      return 'Category';
    } else if (selectedCategoryFilters.length == 1) {
      return selectedCategoryFilters.first;
    } else {
      return 'Categories (${selectedCategoryFilters.length})';
    }
  }

    /// Navigate to cart
  void navigateToCart() {
    logger.navigation('Navigating to cart');
    Get.toNamed(AppRoutes.cart);
  }

    /// Handle navigation after rating is submitted
  Future<void> viewPrescription() async {
    try {
      if (kDebugMode) {
        print('Checking for prescription after rating submission');
      }

      // Check if there's a prescription to show
      // TODO: Replace with actual API call to get prescription
      final prescription = await _getMockPrescription();

      if (kDebugMode) {
        print('Prescription fetched: ${prescription.medicines.length} medicines');
      }

      // Only show prescription screen if there are medicines prescribed
      if (prescription.hasMedicines) {
        if (kDebugMode) {
          print('Navigating to prescription screen');
        }
        Get.offNamed(AppRoutes.orderPrescription, arguments: {
          'prescription': prescription,
        });
      } else {
        if (kDebugMode) {
          print('No medicines prescribed, going to home');
        }
        // No prescription, navigate back to navigation screen
        //
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching prescription: $e');
      }
      // Navigate back to navigation screen if prescription fetch fails
      //
    }
  }

    /// Get mock prescription data
  Future<PrescriptionEntity> _getMockPrescription() async {
    // TODO: Replace with actual API call to get prescription
    // This creates mock prescription data for demonstration

    return PrescriptionEntity(
      id: 'PRESC-${DateTime.now().millisecondsSinceEpoch}',
      appointmentId: "APP-789",
      doctorId: 'DOC-123',
      doctorName: 'Dr. John Smith',
      doctorImageUrl: null,
      patientId: 'PAT-456',
      patientName: 'Current Patient',
      prescriptionDate: DateTime.now(),
      diagnosis: 'Seasonal Flu with mild fever and body aches',
      notes: 'Please take medicines as prescribed. Drink plenty of water and get adequate rest.',
      medicines: [
        const PrescribedMedicineEntity(
          id: '1',
          medicineId: '101',
          medicineName: 'Paracetamol',
          medicineImage: null,
          manufacturer: 'PharmaCorp',
          unitPrice: 15.00,
          dosage: '500mg',
          frequency: 'Three times daily',
          duration: '5 days',
          instructions: 'Take after meals',
          quantity: 15,
          isAvailable: true,
        ),
        const PrescribedMedicineEntity(
          id: '2',
          medicineId: '102',
          medicineName: 'Ibuprofen',
          medicineImage: null,
          manufacturer: 'HealthPlus',
          unitPrice: 20.00,
          dosage: '400mg',
          frequency: 'Twice daily',
          duration: '5 days',
          instructions: 'Take with food to avoid stomach upset',
          quantity: 10,
          isAvailable: true,
        ),
        const PrescribedMedicineEntity(
          id: '3',
          medicineId: '103',
          medicineName: 'Vitamin C Tablets',
          medicineImage: null,
          manufacturer: 'VitaLife',
          unitPrice: 12.00,
          dosage: '1000mg',
          frequency: 'Once daily',
          duration: '7 days',
          instructions: 'Take in the morning',
          quantity: 7,
          isAvailable: true,
        ),
        const PrescribedMedicineEntity(
          id: '4',
          medicineId: '104',
          medicineName: 'Cough Syrup',
          medicineImage: null,
          manufacturer: 'MediCare',
          unitPrice: 25.00,
          dosage: '10ml',
          frequency: 'Three times daily',
          duration: '5 days',
          instructions: 'Shake well before use',
          quantity: 1,
          isAvailable: true,
        ),
      ],
    );
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
