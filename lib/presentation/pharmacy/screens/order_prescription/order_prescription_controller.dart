import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import '../../../../app/config/app_colors.dart';
import '../../../../app/controllers/base_controller.dart';
import '../../../../domain/entity/prescription_entity.dart';
import '../../../../domain/entity/cart_item_entity.dart';
import '../../../../domain/entity/medicine_entity.dart';

  /// Order Prescription Controller - Manages prescription ordering screen
class OrderPrescriptionController extends BaseController {
  // ==================== OBSERVABLES ====================
  late Rx<PrescriptionEntity> prescription;
  final RxList<String> selectedMedicineIds = <String>[].obs;
  final RxBool selectAll = false.obs;
  final RxBool isDownloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPrescriptionData();
  }

  /// Load prescription data from navigation arguments
  void _loadPrescriptionData() {
    try {
      final args = Get.arguments;
      if (args != null && args['prescription'] != null) {
        prescription = Rx<PrescriptionEntity>(args['prescription'] as PrescriptionEntity);

        // By default, select all available medicines
        selectedMedicineIds.value = prescription.value.medicines
            .where((m) => m.isAvailable)
            .map((m) => m.medicineId)
            .toList();

        _updateSelectAllState();
      } else {
        logger.error('No prescription data found in arguments');
        Get.back();
      }
    } catch (e) {
      logger.error('Error loading prescription data: $e');
      Get.back();
    }
  }

  /// Toggle selection of a medicine
  void toggleMedicineSelection(String medicineId) {
    if (selectedMedicineIds.contains(medicineId)) {
      selectedMedicineIds.remove(medicineId);
    } else {
      selectedMedicineIds.add(medicineId);
    }
    _updateSelectAllState();
  }

  /// Check if a medicine is selected
  bool isMedicineSelected(String medicineId) {
    return selectedMedicineIds.contains(medicineId);
  }

  /// Toggle select all medicines
  void toggleSelectAll() {
    if (selectAll.value) {
      // Deselect all
      selectedMedicineIds.clear();
      selectAll.value = false;
    } else {
      // Select all available medicines
      selectedMedicineIds.value = prescription.value.medicines
          .where((m) => m.isAvailable)
          .map((m) => m.medicineId)
          .toList();
      selectAll.value = true;
    }
  }

  /// Update select all state based on current selection
  void _updateSelectAllState() {
    final availableMedicines = prescription.value.medicines
        .where((m) => m.isAvailable)
        .toList();

    selectAll.value = availableMedicines.isNotEmpty &&
        selectedMedicineIds.length == availableMedicines.length;
  }

  /// Get selected medicines
  List<PrescribedMedicineEntity> getSelectedMedicines() {
    return prescription.value.medicines
        .where((m) => selectedMedicineIds.contains(m.medicineId))
        .toList();
  }

  /// Calculate total price of selected medicines
  double getTotalPrice() {
    return getSelectedMedicines()
        .fold(0.0, (sum, medicine) => sum + medicine.totalPrice);
  }

  /// Get selected medicines count
  int getSelectedCount() {
    return selectedMedicineIds.length;
  }

  /// Add selected medicines to cart and navigate
  Future<void> addToCartAndProceed() async {
    if (selectedMedicineIds.isEmpty) {
      Get.snackbar(
        'No Medicines Selected',
        'Please select at least one medicine to order',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      setLoading(true);

      // Convert selected medicines to cart items
      final cartItems = getSelectedMedicines().map((medicine) {
        // Create MedicineEntity from prescription medicine
        final medicineEntity = MedicineEntity(
          id: int.tryParse(medicine.medicineId) ?? 0,
          name: medicine.medicineName,
          price: medicine.unitPrice,
          imageUrl: medicine.medicineImage,
          manufacturer: medicine.manufacturer,
          requiresPrescription: true,
        );

        return CartItemEntity(
          id: int.tryParse(medicine.id) ?? 0,
          medicine: medicineEntity,
          quantity: medicine.quantity,
          totalPrice: medicine.totalPrice,
        );
      }).toList();

      // TODO: Add items to cart via service
      // await cartService.addItems(cartItems);

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 500));

      logger.userAction('Added ${cartItems.length} prescription medicines to cart');

      // Navigate to cart
      Get.offNamed('/cart', arguments: {
        'prescriptionItems': cartItems,
        'prescriptionId': prescription.value.id,
        'message': '${cartItems.length} prescription medicine(s) added to cart',
      });

    } catch (e) {
      logger.error('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add medicines to cart. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setLoading(false);
    }
  }

  /// Skip ordering and go to pharmacy home
  void skipOrdering() {
    logger.userAction('User skipped prescription ordering');
    Get.toNamed(AppRoutes.pharmacy);
  }

  /// View prescription details
  void viewPrescriptionImage() {
    if (prescription.value.prescriptionImageUrl != null) {
      // TODO: Show full screen image viewer
      logger.userAction('Viewing prescription image');
      Get.snackbar(
        'Prescription Image',
        'Image viewer will be implemented',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Download prescription image
  Future<void> downloadPrescriptionImage() async {
    final imageUrl = prescription.value.prescriptionImageUrl;
    
    if (kDebugMode) {
      print('downloadPrescriptionImage called. URL: $imageUrl');
    }
    
    if (imageUrl == null || imageUrl.isEmpty) {
      if (kDebugMode) {
        print('No image URL available');
      }
      Get.snackbar(
        'Error',
        'Prescription image URL is not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red513,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isDownloading.value = true;
      logger.userAction('Downloading prescription image');

      // Request storage permission (Android 13+ uses photos permission)
      if (!kIsWeb) {
        PermissionStatus status;
        if (Platform.isAndroid) {
          // For Android 13+, use photos permission; for older versions, use storage
          status = await Permission.photos.request();
          if (!status.isGranted) {
            status = await Permission.storage.request();
          }
        } else if (Platform.isIOS) {
          status = await Permission.photos.request();
        } else {
          status = await Permission.storage.request();
        }

        if (!status.isGranted) {
          Get.snackbar(
            'Permission Denied',
            'Storage permission is required to download the image',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.red513,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      
      if (response.statusCode == 200) {
        // Get the download directory
        Directory? directory;
        if (Platform.isAndroid) {
          // For Android, use Pictures directory which doesn't require special permissions on Android 10+
          final externalDir = await getExternalStorageDirectory();
          if (externalDir != null) {
            // Navigate to Pictures directory
            final picturesDir = Directory(path.join(externalDir.parent.path, 'Pictures', 'RecoveryConsultation'));
            if (!await picturesDir.exists()) {
              await picturesDir.create(recursive: true);
            }
            directory = picturesDir;
          } else {
            directory = await getApplicationDocumentsDirectory();
          }
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          directory = await getDownloadsDirectory();
        }

        if (directory == null) {
          throw Exception('Could not access download directory');
        }

        // Create filename from URL or use default
        final uri = Uri.parse(imageUrl);
        final fileName = path.basename(uri.path);
        final finalFileName = fileName.isNotEmpty && fileName.contains('.')
            ? fileName
            : 'prescription_${prescription.value.appointmentId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Save the file
        final filePath = path.join(directory.path, finalFileName);
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        logger.userAction('Prescription image downloaded to: $filePath');

        Get.snackbar(
          'Downloaded',
          'Prescription image saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.checkedColor,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      logger.error('Error downloading prescription image: $e');
      Get.snackbar(
        'Download Failed',
        'Failed to download prescription image. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.red513,
        colorText: Colors.white,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  /// Go back to home
  void goBackToHome() {
    logger.navigation('Going back to home from prescription order');
    Get.offAllNamed('/navScreen');
  }
}
