import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_user_use_case.dart';
import '../../app/config/app_routes.dart';
import '../../presentation/specialist/base_specialist_controller.dart';
import 'admin_patient_details_config.dart';



class AdminPatientDetailsController extends BaseSpecialistController {
  AdminPatientDetailsController({
    required super.getSpecialistByIdUseCase,
    required this.getUserUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final GetUserUseCase getUserUseCase;
  
  // ==================== CONFIGURATION ====================
  late final AdminPatientDetailsConfig config;

  // Patient ID from arguments
  int? _patientId;

  // ==================== GETTERS ====================
  String get screenTitle => config.title;
  String get bottomButtonText => config.buttonText;
  List<String> get tabPages => config.tabs;
  List<Widget> get tabWidgets => config.tabWidgets;
  bool get showBottomButton => config.showBottomButton;

  // Use inherited getters from BaseSpecialistController for patient info
  String get patientName => specialistName; // Alias for compatibility
  String get patientImageUrl => specialistImageUrl; // Alias for compatibility
  String get patientCredentials => specialistCredentials; // Alias for compatibility

  // Additional properties for UI
  String get patientBio => specialistBio;

  // ==================== INITIALIZATION ====================
  RoleManager roleManager = RoleManager.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeConfig();
    _initializeScreen();
    _loadPatientDetails();
  }

  // ==================== METHODS ====================

  void _initializeConfig() {
    // Initialize configuration based on admin view
    config = AdminPatientDetailsConfig.adminView();
  }

  void _initializeScreen() {
    // Get patient ID from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    _patientId = arguments?[Arguments.patientId] as int? ?? arguments?[Arguments.doctorId] as int?;

    if (kDebugMode) {
      print('AdminPatientDetailsController - Initialized with patient ID: $_patientId');
    }
  }

  void _loadPatientDetails() async {
    if (_patientId == null) {
      if (kDebugMode) {
        print('AdminPatientDetailsController - No patient ID provided');
      }
      _showErrorSnackbar('Error', 'Patient ID is required');
      return;
    }

    // Load patient data using inherited loadSpecialist method
    await loadSpecialist(_patientId!);
    
    if (specialist.value != null) {
      if (kDebugMode) {
        print('AdminPatientDetailsController - Loaded patient: ${specialist.value!.name}');
      }
    } else {
      if (kDebugMode) {
        print('AdminPatientDetailsController - No patient data found');
      }
      _showErrorSnackbar('Error', 'Patient not found');
    }
  }

  /// Get patient by ID (uses inherited loadSpecialist from BaseSpecialistController)
  Future<UserEntity?> getPatientById(int patientId) async {
    await loadSpecialist(patientId);
    return specialist.value;
  }

  /// Helper method to show error snackbar
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      duration: const Duration(seconds: 3),
    );
  }

  void navigationButtonClick() {
    if (kDebugMode) {
      print('Edit patient profile: $patientName');
    }
    _navigateToEditProfile(_patientId);
  }

  void _navigateToEditProfile(int? userId) {
    if (kDebugMode) {
      print('Edit profile tapped for user: $userId');
    }
    Get.toNamed(
      AppRoutes.editProfile,
      arguments: {
        Arguments.openedFrom: AppRoutes.adminPatientDetails,
        Arguments.userId: userId,
      },
    )?.then((_) {
      // Refresh patient data when coming back from edit screen
      if (_patientId != null) {
        loadSpecialist(_patientId!);
      }
    });
  }

  void viewReviews() {
    if (kDebugMode) {
      print('View reviews for $patientName');
    }

    // TODO: Navigate to reviews screen
    Get.snackbar(
      'Reviews',
      'Reviews feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void sharePatient() {
    if (kDebugMode) {
      print('Share patient: $patientName');
    }

    // TODO: Implement share functionality
    Get.snackbar(
      'Share',
      'Share feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
