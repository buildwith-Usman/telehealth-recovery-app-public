import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/data/api/request/create_product_request.dart';
import 'package:recovery_consultation_app/data/api/request/update_product_request.dart';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';
import 'package:recovery_consultation_app/domain/entity/product_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/create_product_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/update_product_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/upload_file_use_case.dart';
import 'package:recovery_consultation_app/presentation/admin_medicine_product_listing/admin_medicine_product_listing_controller.dart';

enum MedicineStockStatus { inStock, outOfStock, hidden }

class DosageVariant {
  final String dosage;
  final double price;
  final int stockQuantity;

  DosageVariant({
    required this.dosage,
    required this.price,
    required this.stockQuantity,
  });
}

class AdminMedicineAddProductController extends BaseController {
  AdminMedicineAddProductController({
    required this.uploadFileUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
  });

  final UploadFileUseCase uploadFileUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;

  // For edit mode
  ProductEntity? existingProduct;
  bool isEditMode = false;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockQuantityController = TextEditingController();
  final discountValueController = TextEditingController();
  final ingrediantValueController = TextEditingController();
  final howToUseController = TextEditingController();

  // Dosage variants (UI-only, no API integration yet)
  final dosageInputController = TextEditingController();
  final dosagePriceController = TextEditingController();
  final dosageStockController = TextEditingController();
  final dosageVariants = <DosageVariant>[].obs;
  final editingDosageIndex = (-1).obs; // -1 means not editing

  final List<String> categories = ['Prescription Drugs', 'Supplements'];
  final selectedCategory = 'Prescription Drugs'.obs;

  final List<String> discountTypes = ['Percentage', 'Fixed'];
  final selectedDiscountType = 'Percentage'.obs;

  // Multi-image support (max 5 images)
  static const int maxImages = 5;
  final images = <File>[].obs;
  final uploadedImageIds = <int>[].obs;
  final existingImageUrls = <String>[].obs;
  final selectedImageIndex = 0.obs;

  final _isUploadingImage = false.obs;
  bool get isUploadingImage => _isUploadingImage.value;

  final stockStatus = MedicineStockStatus.inStock.obs;
  final isVisibleToCustomers = true.obs;
  final isVisibleToUnCheck = false.obs;

  @override
  void onInit() {
    super.onInit();

    logger.method('🔍 onInit called - Checking for edit mode');
    logger.method('🔍 Get.arguments: ${Get.arguments}');

    // Check if we're in edit mode
    if (Get.arguments != null) {
      final args = Get.arguments as Map<String, dynamic>;
      logger.method('🔍 Arguments map: $args');

      final bool isEdit = args[Arguments.isEdit] ?? false;
      logger.method('🔍 isEdit flag: $isEdit');

      if (isEdit) {
        isEditMode = true;
        existingProduct = args[Arguments.product] as ProductEntity?;

        logger.method('🔍 existingProduct: ${existingProduct?.medicineName}');

        if (existingProduct != null) {
          logger.method('✅ Loading product data for edit mode');
          _loadProductData();
        } else {
          logger.error('❌ existingProduct is null even though isEdit is true');
        }
      } else {
        logger.method('📝 Create mode - no product to load');
      }
    } else {
      logger.method('📝 No arguments - create mode');
    }
  }

  /// Load existing product data for edit mode
  void _loadProductData() {
    if (existingProduct == null) {
      logger.error('❌ _loadProductData called but existingProduct is null');
      return;
    }

    final product = existingProduct!;
    logger.method('📝 Loading data for product: ${product.medicineName}');

    // Populate form fields
    nameController.text = product.medicineName ?? '';
    logger.method('  - Name: ${nameController.text}');

    descriptionController.text = product.description ?? '';
    logger.method('  - Description: ${descriptionController.text}');

    priceController.text = product.price?.toString() ?? '';
    logger.method('  - Price: ${priceController.text}');

    stockQuantityController.text = product.stockQuantity?.toString() ?? '';
    logger.method('  - Stock: ${stockQuantityController.text}');

    discountValueController.text = product.discountValue?.toString() ?? '';
    logger.method('  - Discount Value: ${discountValueController.text}');

    ingrediantValueController.text = product.ingredients ?? '';
    logger.method('  - Ingredients: ${ingrediantValueController.text}');

    howToUseController.text = product.howToUse ?? '';
    logger.method('  - How to Use: ${howToUseController.text}');

    // Set category based on category entity name
    if (product.category?.name != null) {
      selectedCategory.value = product.category!.name!;
      logger.method('  - Category: ${selectedCategory.value}');
    }

    // Set discount type
    if (product.discountType != null) {
      selectedDiscountType.value =
          product.discountType!.toLowerCase() == 'percentage' ? 'Percentage' : 'Fixed';
      logger.method('  - Discount Type: ${selectedDiscountType.value}');
    }

    // Set visibility
    isVisibleToCustomers.value = product.isVisible ?? true;
    logger.method('  - Is Visible: ${isVisibleToCustomers.value}');

    isVisibleToUnCheck.value = product.isTemporarilyHidden ?? false;
    logger.method('  - Is Temporarily Hidden: ${isVisibleToUnCheck.value}');

    // Set stock status based on availability_status string
    if (product.availabilityStatus != null) {
      logger.method('  - Availability Status: ${product.availabilityStatus}');
      switch (product.availabilityStatus!.toLowerCase()) {
        case 'in_stock':
          stockStatus.value = MedicineStockStatus.inStock;
          break;
        case 'out_of_stock':
          stockStatus.value = MedicineStockStatus.outOfStock;
          break;
        case 'hidden':
          stockStatus.value = MedicineStockStatus.hidden;
          break;
        default:
          stockStatus.value = MedicineStockStatus.inStock;
      }
      logger.method('  - Stock Status: ${stockStatus.value}');
    }

    // Set existing image URL
    if (product.imageUrl != null) {
      existingImageUrls.add(product.imageUrl!);
      logger.method('  - Image URL: ${product.imageUrl}');
    }

    logger.method('✅ Product data loaded successfully for edit mode: ${product.medicineName}');
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockQuantityController.dispose();
    discountValueController.dispose();
    ingrediantValueController.dispose();
    howToUseController.dispose();
    dosageInputController.dispose();
    dosagePriceController.dispose();
    dosageStockController.dispose();
    super.onClose();
  }

  void toggleVisibility() {
    isVisibleToCustomers.value = !isVisibleToCustomers.value;
  }

  void toggleVisibleToUnCheck() {
    isVisibleToUnCheck.value = !isVisibleToUnCheck.value;
  }

  Future<void> pickImage() async {
    if (totalImageCount >= maxImages) {
      Get.snackbar(
        'Limit Reached',
        'You can add up to $maxImages images',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      final selectedFile = File(pickedFile.path);
      images.add(selectedFile);
      selectedImageIndex.value = existingImageUrls.length + images.length - 1;

      // Immediately upload the image and get image_id
      await _uploadImage(selectedFile);
    }
  }

  /// Remove image at index
  void removeImage(int index) {
    if (index < existingImageUrls.length) {
      // Removing an existing network image
      existingImageUrls.removeAt(index);
    } else {
      // Removing a locally picked image
      final localIndex = index - existingImageUrls.length;
      images.removeAt(localIndex);
      if (localIndex < uploadedImageIds.length) {
        uploadedImageIds.removeAt(localIndex);
      }
    }

    // Adjust selected index
    if (selectedImageIndex.value >= totalImageCount) {
      selectedImageIndex.value = totalImageCount > 0 ? totalImageCount - 1 : 0;
    }
  }

  /// Select image to preview
  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  /// Total image count (existing + picked)
  int get totalImageCount => existingImageUrls.length + images.length;

  /// Upload image and store the image_id
  Future<void> _uploadImage(File imageFile) async {
    _isUploadingImage.value = true;

    try {
      final uploadResult = await executeApiCall<FileEntity?>(
        () => uploadFileUseCase.execute(
          UploadFileParams(
            file: imageFile,
            directory: 'profile',
          ),
        ),
        onSuccess: () {
          logger.method('✅ Image uploaded successfully');
        },
        onError: (errorMessage) {
          logger.error('❌ Failed to upload image: $errorMessage');
          // Remove the last added image if upload fails
          if (images.isNotEmpty) {
            images.removeLast();
          }
        },
      );

      if (uploadResult != null) {
        uploadedImageIds.add(uploadResult.id);
        logger.method('✅ Image ID stored: ${uploadResult.id}');
      } else {
        // Remove the last added image if upload fails
        if (images.isNotEmpty) {
          images.removeLast();
        }
      }
    } catch (e) {
      logger.error('❌ Unexpected error uploading image: $e');
      if (images.isNotEmpty) {
        images.removeLast();
      }
    } finally {
      _isUploadingImage.value = false;
    }
  }

  /// Add a new dosage variant or update an existing one
  void addOrUpdateDosageVariant() {
    final dosage = dosageInputController.text.trim();
    final price = double.tryParse(dosagePriceController.text.trim());
    final stock = int.tryParse(dosageStockController.text.trim());

    if (dosage.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter a dosage',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (price == null || price <= 0) {
      Get.snackbar('Validation Error', 'Please enter a valid price',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (stock == null || stock < 0) {
      Get.snackbar('Validation Error', 'Please enter a valid stock quantity',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final variant = DosageVariant(
      dosage: dosage,
      price: price,
      stockQuantity: stock,
    );

    if (editingDosageIndex.value >= 0) {
      dosageVariants[editingDosageIndex.value] = variant;
      editingDosageIndex.value = -1;
    } else {
      dosageVariants.add(variant);
    }

    _clearDosageInputs();
  }

  /// Edit an existing dosage variant
  void editDosageVariant(int index) {
    final variant = dosageVariants[index];
    dosageInputController.text = variant.dosage;
    dosagePriceController.text = variant.price.toString();
    dosageStockController.text = variant.stockQuantity.toString();
    editingDosageIndex.value = index;
  }

  /// Remove a dosage variant
  void removeDosageVariant(int index) {
    dosageVariants.removeAt(index);
    if (editingDosageIndex.value == index) {
      editingDosageIndex.value = -1;
      _clearDosageInputs();
    } else if (editingDosageIndex.value > index) {
      editingDosageIndex.value--;
    }
  }

  /// Cancel editing a dosage variant
  void cancelDosageEdit() {
    editingDosageIndex.value = -1;
    _clearDosageInputs();
  }

  void _clearDosageInputs() {
    dosageInputController.clear();
    dosagePriceController.clear();
    dosageStockController.clear();
  }

  void setStockStatus(MedicineStockStatus status) {
    stockStatus.value = status;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setDiscountType(String type) {
    selectedDiscountType.value = type;
  }

  /// Map category name to static category ID
  /// Prescription Drugs = 1, Supplements = 2
  int _getCategoryId(String categoryName) {
    switch (categoryName) {
      case 'Prescription Drugs':
        return 1;
      case 'Supplements':
        return 2;
      default:
        return 1; // Default to Prescription Drugs
    }
  }

  /// Map discount type to API format (lowercase)
  String _getDiscountTypeForApi(String discountType) {
    return discountType.toLowerCase();
  }

  Future<void> addProduct() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // At least 1 image is required
    if (!isEditMode && uploadedImageIds.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please upload at least one image',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isEditMode && existingImageUrls.isEmpty && uploadedImageIds.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please upload at least one image',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_isUploadingImage.value) {
      Get.snackbar(
        'Please Wait',
        'Image is still uploading. Please wait...',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Parse numeric values
      final price = double.tryParse(priceController.text.trim());
      final stockQuantity = int.tryParse(stockQuantityController.text.trim());
      final discountValue = double.tryParse(discountValueController.text.trim());

      if (price == null || price <= 0) {
        Get.snackbar(
          'Validation Error',
          'Please enter a valid price',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (stockQuantity == null || stockQuantity < 0) {
        Get.snackbar(
          'Validation Error',
          'Please enter a valid stock quantity',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (discountValue == null || discountValue < 0) {
        Get.snackbar(
          'Validation Error',
          'Please enter a valid discount value',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (isEditMode) {
        // Update existing product
        await _updateProduct(
          price: price,
          stockQuantity: stockQuantity,
          discountValue: discountValue,
        );
      } else {
        // Create new product
        await _createProduct(
          price: price,
          stockQuantity: stockQuantity,
          discountValue: discountValue,
        );
      }
    } catch (e) {
      logger.error('❌ Unexpected error: $e');
    }
  }

  /// Create new product
  Future<void> _createProduct({
    required double price,
    required int stockQuantity,
    required double discountValue,
  }) async {
    final request = CreateProductRequest(
      medicineName: nameController.text.trim(),
      imageId: uploadedImageIds.first,
      categoryId: _getCategoryId(selectedCategory.value),
      price: price,
      stockQuantity: stockQuantity,
      ingredients: ingrediantValueController.text.trim(),
      discountType: _getDiscountTypeForApi(selectedDiscountType.value),
      discountValue: discountValue,
      howToUse: howToUseController.text.trim(),
      description: descriptionController.text.trim(),
      isVisible: isVisibleToCustomers.value,
      isTemporarilyHidden: isVisibleToUnCheck.value,
    );

    final result = await executeApiCall(
      () => createProductUseCase.execute(request),
      onSuccess: () {
        logger.method('✅ Product created successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to create product: $errorMessage');
      },
    );

    if (result != null) {
      logger.method('✅ Navigating back after successful product creation');
      // Add a small delay to ensure loading indicator is fully dismissed
      await Future.delayed(const Duration(milliseconds: 300));
      if (Get.isRegistered<AdminMedicineAddProductController>()) {
        Get.back(result: true);
      }
    } else {
      logger.error('Product creation returned null result');
    }
  }

  /// Update existing product
  Future<void> _updateProduct({
    required double price,
    required int stockQuantity,
    required double discountValue,
  }) async {
    if (existingProduct == null) return;

    // Determine availability status based on stock status
    String availabilityStatus;
    switch (stockStatus.value) {
      case MedicineStockStatus.inStock:
        availabilityStatus = 'in_stock';
        break;
      case MedicineStockStatus.outOfStock:
        availabilityStatus = 'out_of_stock';
        break;
      case MedicineStockStatus.hidden:
        availabilityStatus = 'hidden';
        break;
    }

    final request = UpdateProductRequest(
      medicineName: nameController.text.trim(),
      imageId: uploadedImageIds.isNotEmpty ? uploadedImageIds.first : null, // Can be null if not changed
      categoryId: _getCategoryId(selectedCategory.value),
      price: price,
      stockQuantity: stockQuantity,
      ingredients: ingrediantValueController.text.trim(),
      discountType: _getDiscountTypeForApi(selectedDiscountType.value),
      discountValue: discountValue,
      howToUse: howToUseController.text.trim(),
      description: descriptionController.text.trim(),
      isVisible: isVisibleToCustomers.value,
      isTemporarilyHidden: isVisibleToUnCheck.value,
      availabilityStatus: availabilityStatus,
    );

    final result = await executeApiCall(
      () => updateProductUseCase.execute(
        UpdateProductParams(
          id: existingProduct!.id,
          request: request,
        ),
      ),
      onSuccess: () {
        logger.method('✅ Product updated successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to update product: $errorMessage');
      },
    );

    if (result != null) {
      logger.method('✅ Navigating back after successful product update');
      // Add a small delay to ensure loading indicator is fully dismissed
      await Future.delayed(const Duration(milliseconds: 300));
      if (Get.isRegistered<AdminMedicineAddProductController>()) {
        Get.back(result: true);
      }
    } else {
      logger.error('Product update returned null result');
    }
  }
}
