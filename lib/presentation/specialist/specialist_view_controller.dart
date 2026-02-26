import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/domain/usecase/get_user_use_case.dart';
import 'package:recovery_consultation_app/presentation/specialist/base_specialist_controller.dart';
import 'package:recovery_consultation_app/presentation/specialist/specialist_view_config.dart';

/// Unified controller for all specialist viewing scenarios
/// Follows Single Responsibility Principle - coordinates UI state only
/// Business logic is in BaseSpecialistController
class SpecialistViewController extends BaseSpecialistController {
  SpecialistViewController({
    required super.getSpecialistByIdUseCase,
    required this.getUserUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final RoleManager roleManager = RoleManager.instance;
  final GetUserUseCase getUserUseCase;

  // ==================== STATE ====================
  late final SpecialistViewConfig config;
  int? _specialistId;

  // ==================== GETTERS ====================
  String get screenTitle => config.title;
  String get bottomButtonText => config.buttonText;
  List<String> get tabPages => config.tabs;
  List<Widget> get tabWidgets => config.tabWidgets;
  bool get showBottomButton => config.showBottomButton;

  // ==================== INITIALIZATION ====================

  @override
  void onInit() {
    super.onInit();
    _initializeConfig();
    _loadSpecialistData();
  }

  /// Initialize configuration based on user role and arguments
  void _initializeConfig() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    _specialistId = arguments?[Arguments.doctorId] as int?;
    final openedFrom = arguments?[Arguments.openedFrom] as String?;

    if (kDebugMode) {
      print('SpecialistViewController - Initializing with:');
      print('  Role: ${roleManager.currentRole}');
      print('  Specialist ID: $_specialistId');
      print('  Opened from: $openedFrom');
    }

    // Determine view mode based on role and context
    if (roleManager.isPatient) {
      config = SpecialistViewConfig.patientView();
    } else if (roleManager.isSpecialist) {
      // Specialist viewing their own profile
      config = SpecialistViewConfig.specialistSelfView();
    } else if (roleManager.isAdmin) {
      config = SpecialistViewConfig.adminView();
    } else {
      // Fallback to patient view
      config = SpecialistViewConfig.patientView();
    }

    if (kDebugMode) {
      print('SpecialistViewController - Config mode: ${config.mode}');
    }
  }

  /// Load specialist data based on context
  void _loadSpecialistData() {
    if (roleManager.isSpecialist) {
      // Load current logged-in specialist's own data
      _loadOwnProfile();
    } else if (_specialistId != null) {
      // Load specific specialist by ID (patient viewing specialist or admin viewing specialist)
      loadSpecialist(_specialistId!);
    } else {
      // Fallback for other roles
      _loadDefaultSpecialistData();
    }
  }

  /// Load current logged-in specialist's own profile
  Future<void> _loadOwnProfile() async {
    if (kDebugMode) {
      print('SpecialistViewController - Loading own profile using GetUserUseCase');
    }

    final result = await executeApiCall<UserEntity>(
      () => getUserUseCase.execute(),
      onSuccess: () => logger.method('✅ Own profile data fetched successfully'),
      onError: (error) => logger.error('⚠️ Failed to fetch own profile: $error'),
    );

    if (result != null) {
      specialist.value = result;
      mapSpecialistDetailsToProfileCardItem(result);
      if (kDebugMode) {
        print('SpecialistViewController - Own profile loaded: ${result.name}');
      }
    } else {
      logger.warning('Own profile data is null');
      _loadDefaultSpecialistData();
    }
  }

  /// Load default/mock data for development
  void _loadDefaultSpecialistData() {
    specialistDetails.value = const ProfileCardItem(
      name: 'Dr. Tahir Ikram',
      profession: 'Therapist',
      degree: 'Clinical Psychology',
      licenseNo: '56482603',
      rating: 4.8,
      noOfRatings: '29',
      viewProfileCardButton: false,
      doctorInfo: DoctorInfoEntity(
        id: 1,
        userId: 123,
        specialization: 'Therapist',
        degree: 'BS-Therapy',
      ),
    );
  }

  // ==================== ACTIONS ====================

  /// Handle bottom button click based on view mode
  void navigationButtonClick() {
    if (kDebugMode) {
      print('SpecialistViewController - Button clicked: ${config.mode}');
    }

    switch (config.mode) {
      case SpecialistViewMode.patientView:
        _navigateToBooking();
        break;
      case SpecialistViewMode.specialistSelf:
        _navigateToEditProfile();
        break;
      case SpecialistViewMode.admin:
        _navigateToEditProfile();
        break;
    }
  }

  /// Navigate to booking screen (patient flow)
  /// Only passes specialist ID - the booking screen will fetch all data from API
  void _navigateToBooking() {
    if (_specialistId == null) {
      if (kDebugMode) {
        print('SpecialistViewController - Cannot book: No specialist ID');
      }
      return;
    }

    if (kDebugMode) {
      print('SpecialistViewController - Navigating to booking for specialist: $_specialistId');
    }

    // Pass only the specialist ID - booking screen fetches fresh data from API
    Get.toNamed(
      AppRoutes.bookConsultation,
      arguments: {
        Arguments.doctorId: _specialistId,
      },
    );
  }

  /// Navigate to edit profile screen (specialist/admin flow)
  void _navigateToEditProfile() {
    if (kDebugMode) {
      print('SpecialistViewController - Navigating to edit profile');
    }

    final userId = config.mode == SpecialistViewMode.admin && _specialistId != null
        ? _specialistId!
        : 0; // 0 means current user

    Get.toNamed(
      AppRoutes.editProfile,
      arguments: {
        Arguments.openedFrom: AppRoutes.specialistView,
        Arguments.userId: userId,
      },
    )?.then((_) {
      // Refresh data when coming back from edit
      if (roleManager.isSpecialist) {
        // Refresh own profile
        _loadOwnProfile();
      } else if (_specialistId != null) {
        // Refresh specific specialist
        loadSpecialist(_specialistId!);
      }
    });
  }

  /// Go back to previous screen
  void goBack() {
    Get.back();
  }

  /// Refresh specialist data
  Future<void> refreshSpecialist() async {
    if (roleManager.isSpecialist) {
      // Refresh own profile
      await _loadOwnProfile();
    } else if (_specialistId != null) {
      // Refresh specific specialist
      await loadSpecialist(_specialistId!);
    }
  }
}
