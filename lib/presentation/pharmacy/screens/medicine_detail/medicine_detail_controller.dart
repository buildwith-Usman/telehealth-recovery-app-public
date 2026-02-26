import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/services/cart_service.dart';
import 'package:recovery_consultation_app/domain/entity/medicine_entity.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_product_by_id_use_case.dart';
import '../../../../app/controllers/base_controller.dart';
import '../../../admin_medicine_add_product_screen/admin_medicine_add_product_controller.dart';

/// Medicine Detail Controller - Manages medicine detail screen state and logic
/// This follows the same pattern as PharmacyHomeController
class MedicineDetailController extends BaseController {
  // Use Case Dependencies
  final GetProductByIdUseCase _getProductByIdUseCase;

  // Get cart service
  final CartService _cartService = Get.find<CartService>();

  MedicineDetailController({
    required GetProductByIdUseCase getProductByIdUseCase,
  }) : _getProductByIdUseCase = getProductByIdUseCase;

  // Observable variables
  final Rx<MedicineEntity?> medicine = Rx<MedicineEntity?>(null);
  final Rx<ProductEntity?> product = Rx<ProductEntity?>(null);
  final RxInt quantity = 1.obs;
  final RxBool isAddedToCart = false.obs;
  final RxList<String> medicineImages = <String>[].obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxList<MedicineEntity> relatedMedicines = <MedicineEntity>[].obs;

  // Dosage selection
  final RxList<DosageVariant> dosageVariants = <DosageVariant>[].obs;
  final RxInt selectedDosageIndex = (-1).obs;

  // Reactive display price and stock (updated when dosage is selected)
  final RxDouble displayPrice = 0.0.obs;
  final RxInt displayStock = 0.obs;

  // Medicine ID passed from navigation
  late int medicineId;

  @override
  void onInit() {
    super.onInit();

    // Get medicine ID from route arguments
    if (Get.arguments != null) {
      // Parse as int - the argument comes from medicine card which passes the ID
      medicineId = int.tryParse(Get.arguments.toString()) ?? 0;
      if (medicineId > 0) {
        loadMedicineDetail();
      } else {
        logger.error('Invalid medicine ID: ${Get.arguments}');
        Get.back();
      }
    } else {
      logger.error('Medicine ID not provided');
      Get.back();
    }
  }

  /// Load medicine detail by ID
  Future<void> loadMedicineDetail() async {
    try {
      setLoading(true);

      // Fetch product detail from API
      final productResult = await _getProductByIdUseCase.execute(medicineId);

      if (productResult == null) {
        logger.error('Product not found for ID: $medicineId');
        Get.snackbar(
          'Error',
          'Product not found',
          snackPosition: SnackPosition.TOP,
        );
        Get.back();
        return;
      }

      // Store product entity
      product.value = productResult;

      // Convert ProductEntity to MedicineEntity for UI compatibility
      medicine.value = MedicineEntity(
        id: productResult.id,
        name: productResult.medicineName ?? 'Unknown Product',
        description: productResult.description ?? 'No description available',
        category: productResult.category?.name ?? 'Uncategorized',
        price: productResult.finalPrice ?? productResult.price ?? 0.0,
        imageUrl: productResult.imageUrl,
        stockQuantity: productResult.stockQuantity ?? 0,
        manufacturer: productResult.creator?.name ?? 'Unknown',
        requiresPrescription: productResult.category?.name == 'Prescription Drugs',
        tags: [],
      );

      // Set medicine images (use product image if available)
      if (productResult.imageUrl != null && productResult.imageUrl!.isNotEmpty) {
        medicineImages.value = [productResult.imageUrl!];
        selectedImageIndex.value = 0;
      }

      // Set base display price and stock from product
      displayPrice.value = productResult.finalPrice ?? productResult.price ?? 0.0;
      displayStock.value = productResult.stockQuantity ?? 0;

      // Set available dosages (UI-only, no API integration yet)
      // TODO: Load dosage variants from API when backend supports it
      dosageVariants.value = [];
      selectedDosageIndex.value = -1;

      // TODO: Load related medicines from API (same category)
      relatedMedicines.value = [];

      logger.controller('Medicine detail loaded: ${medicine.value?.name}');
      logger.controller('Stock quantity: ${productResult.stockQuantity}');
      logger.controller('Availability: ${productResult.availabilityStatus}');
    } catch (e) {
      logger.error('Error loading medicine detail', error: e);
      Get.snackbar(
        'Error',
        'Failed to load product details',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setLoading(false);
    }
  }

  /// Increase quantity
  void increaseQuantity() {
    if (quantity.value < displayStock.value) {
      quantity.value++;
      logger.userAction('Quantity increased to ${quantity.value}');
    } else {
      Get.snackbar(
        'Stock Limit',
        'Only ${displayStock.value} items available',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Decrease quantity
  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
      logger.userAction('Quantity decreased to ${quantity.value}');
    }
  }

  /// Select dosage variant and update display price/stock
  void selectDosage(int index) {
    if (index < 0 || index >= dosageVariants.length) return;

    selectedDosageIndex.value = index;
    final variant = dosageVariants[index];
    displayPrice.value = variant.price;
    displayStock.value = variant.stockQuantity;
    quantity.value = 1;
    logger.userAction('Selected dosage: ${variant.dosage}');
  }

  /// Add to cart and navigate to cart screen
  Future<void> addToCart() async {
    if (medicine.value == null) return;

    logger.userAction(
      'Adding to cart: ${medicine.value!.name}, '
      'Quantity: ${quantity.value}'
    );

    // Add to cart using cart service
    final success = await _cartService.addToCart(
      medicine: medicine.value!,
      quantity: quantity.value,
    );

    if (success) {
      isAddedToCart.value = true;

      // Navigate to cart screen after a short delay
      Future.delayed(const Duration(milliseconds: 800), () {
        navigateToCart();
      });
    }
  }

  /// Buy now - navigate to checkout
  void buyNow() {
    if (medicine.value == null) return;

    logger.userAction('Buy now: ${medicine.value!.name}, Quantity: ${quantity.value}');

    // TODO: Implement buy now logic - navigate to checkout
    Get.snackbar(
      'Coming Soon',
      'Checkout feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navigate back
  void goBack() {
    logger.navigation('Navigating back from medicine detail');
    Get.back();
  }

  /// Select medicine image
  void selectImage(int index) {
    selectedImageIndex.value = index;
    logger.userAction('Selected image index: $index');
  }

  /// Navigate to cart
  void navigateToCart() {
    logger.navigation('Navigating to cart');
    Get.toNamed(AppRoutes.cart);
  }

  /// Share on social media
  void shareOnSocialMedia(String platform) {
    logger.userAction('Sharing on $platform');
    // TODO: Implement social media sharing
    Get.snackbar(
      'Share',
      'Sharing on $platform',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
