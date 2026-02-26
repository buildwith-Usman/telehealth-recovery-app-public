import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';

import '../../app/config/app_constant.dart';
import '../../app/config/app_config.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../app/services/app_storage.dart';
import '../../app/services/token_recovery_service.dart';
import '../../domain/usecase/get_access_token_use_case.dart';
import '../../domain/usecase/get_has_onboarding_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../di/client_module.dart';

/// Controller managing splash screen initialization and navigation logic
class SplashController extends BaseController with ClientModule {
  // ==================== CONSTANTS ====================
  static const double _progressIncrement = 0.02;
  static const int _progressIntervalMs = 50;

  // ==================== DEPENDENCIES ====================
  SplashController({
    required this.getHasOnboardingUseCase,
    required this.getAccessTokenUseCase,
    required this.getUserUseCase,
  });

  final GetHasOnboardingUseCase getHasOnboardingUseCase;
  final GetAccessTokenUseCase getAccessTokenUseCase;
  final GetUserUseCase getUserUseCase;

  // ==================== REACTIVE STATE ====================
  final progressValue = 0.0.obs;
  final currentUser = Rxn<UserEntity>();

  // ==================== GETTERS ====================
  double get progress => progressValue.value;
  UserEntity? get user => currentUser.value;

  // ==================== PRIVATE STATE ====================
  String? _accessToken;
  bool? _hasCompletedOnboarding;
  Timer? _progressTimer;

  // ==================== LIFECYCLE ====================
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  @override
  void onClose() {
    _progressTimer?.cancel();
    super.onClose();
  }

  // ==================== PUBLIC METHODS ====================
  
  /// Initialize the application and start splash sequence
  Future<void> _initializeApp() async {
    try {
      setLoadingState(true);
      
      await _performTokenRecovery();
      await _loadApplicationData();
      await _loadUserDataIfAuthenticated();
      
      _logApplicationState();
      _startProgressAnimation();
      
    } catch (error) {
      _handleInitializationError(error);
      _startProgressAnimation(); // Continue with fallback behavior
    } finally {
      setLoadingState(false);
    }
  }

  // ==================== PRIVATE METHODS ====================
  
  /// Attempt token recovery if available (non-blocking)
  Future<void> _performTokenRecovery() async {
    try {
      if (!Get.isRegistered<TokenRecoveryService>()) return;
      
      final tokenService = Get.find<TokenRecoveryService>();
      if (!tokenService.hasPendingToken) return;
      
      _logDebug("🔄 Attempting to recover pending access token...");
      await tokenService.attemptTokenRecovery();
      
    } catch (error) {
      _logDebug("⚠️ Token recovery failed (non-critical): $error");
    }
  }

  /// Load core application data
  Future<void> _loadApplicationData() async {
    final results = await Future.wait([
      getAccessTokenUseCase.execute(),
      getHasOnboardingUseCase.execute(),
    ]);
    
    _accessToken = results[0] as String?;
    _hasCompletedOnboarding = results[1] as bool?;
  }

  /// Load user data if user is authenticated
  Future<void> _loadUserDataIfAuthenticated() async {
    if (_accessToken?.isNotEmpty != true) return;
    
    try {
      _logDebug("🔄 Fetching logged-in user information...");
      
      final result = await executeApiCall<UserEntity>(
        () => getUserUseCase.execute(),
        onSuccess: () => _logDebug("✅ User data fetched successfully"),
        onError: (error) => _logDebug("⚠️ Failed to fetch user data: $error"),
      );

      if (result != null) {
        currentUser.value = result;
        _logDebug("✅ User loaded: ${result.name}");
        
        // Setup app config with baseUrl and userId
        await AppStorage.instance.setupAppConfig(
          baseUrl: AppConfig.shared.baseUrl,
          userId: result.id,
        );
        _logDebug("✅ App config setup completed with userId: ${result.id}");
      }
      
    } catch (error) {
      _logDebug("⚠️ Failed to fetch user information: $error");
    }
  }

  /// Start the progress bar animation
  void _startProgressAnimation() {
    _progressTimer = Timer.periodic(
      const Duration(milliseconds: _progressIntervalMs), 
      _updateProgress,
    );
  }

  /// Update progress and navigate when complete
  void _updateProgress(Timer timer) {
    if (progressValue.value >= 1.0) {
      timer.cancel();
      _navigateToAppropriateScreen();
      return;
    }
    
    progressValue.value += _progressIncrement;
  }

  /// Navigate based on application state
  void _navigateToAppropriateScreen() {
    if (_hasCompletedOnboarding != true) {
      _navigateToOnboarding();
      return;
    }

    if (_accessToken?.isNotEmpty != true) {
      _navigateToLogin();
      return;
    }

    // if (_shouldRedirectToProfileCompletion()) {
    //   _navigateToProfileCompletion();
    //   return;
    // }

    // if (_shouldRedirectToWaitingApprovalScreen()) {
    //   _navigateToWaitingApprovalScreen();
    //   return;
    // }

    _navigateToDashboard();
  }

  /// Check if user should be redirected to profile completion
  bool _shouldRedirectToProfileCompletion() {
    final user = currentUser.value;
    if (user == null) {
      logger.warning('User is null, redirecting to profile completion');
      return true;
    }

    logger.controller('Checking profile completion', params: {
      'userId': user.id,
      'userType': user.type,
      'userName': user.name,
    });

    // Check based on user type
    switch (user.type?.toLowerCase()) {
      case 'patient':
        return _isPatientProfileIncomplete(user);
      
      case 'doctor':
      case 'specialist':
        return _isDoctorProfileIncomplete(user);
      case 'admin':
        return false; // Admins do not need profile completion
      
      default:
        logger.warning('Unknown user type: ${user.type}, redirecting to profile completion');
        return true;
    }
  }

    /// Check if user should be redirected to waiting approval screen
  bool _shouldRedirectToWaitingApprovalScreen() {
    final user = currentUser.value;
    if (user == null) {
      logger.warning('User is null, redirecting to profile completion');
      return true;
    }

    if(user.doctorInfo == null){
      logger.warning('Doctor info is null, cannot check approval status');
      return false;
    }

    logger.controller('Checking Doctor Info', params: {
      'userId': user.id,
      'userType': user.type,
      'userName': user.name,
    });

    // Check based on user type
    switch (user.type?.toLowerCase()) {
      
      case 'doctor':
      case 'specialist':
        
      // 2️⃣ Then, check profile status
      final status = user.doctorInfo?.status;
      if (status == SpecialistStatus.pending.name) {
        return true; 
      } else if (status == SpecialistStatus.rejected.name) {
        return true;
      } else if (status == SpecialistStatus.approved.name) {
        _logDebug('Doctor profile approved, proceed normally');
        return false;
      } else {
        _logDebug('Unknown doctor status: $status');
        return false;
      }
      
      default:
        logger.warning('Unknown user type: ${user.type}, redirecting to profile completion');
        return true;
    }
  }

  /// Check if patient profile is incomplete
  bool _isPatientProfileIncomplete(UserEntity user) {
    logger.method('_isPatientProfileIncomplete');
    
    if (user.patientInfo == null) {
      logger.controller('Patient info is null, profile incomplete');
      return true;
    }
    
    final isComplete = user.patientInfo!.isCompleted;
    
    logger.controller('Patient profile completion status', params: {
      'completed': isComplete,
      'isComplete': isComplete,
    });
    
    return !isComplete;
  }

  /// Check if doctor profile is incomplete
  bool _isDoctorProfileIncomplete(UserEntity user) {
    logger.method('_isDoctorProfileIncomplete');
    
    if (user.doctorInfo == null) {
      logger.controller('Doctor info is null, profile incomplete');
      return true;
    }
    
    final isCompleted = user.doctorInfo?.isCompleted ?? false;
    
    logger.controller('Doctor profile completion status', params: {
      'isComplete': isCompleted,
    });
    
    return !isCompleted;
  }

  // ==================== NAVIGATION METHODS ====================
  
  void _navigateToOnboarding() => Get.offNamed(AppRoutes.onboarding);
  
  void _navigateToLogin() => Get.offNamed(AppRoutes.logIn);
  
  void _navigateToDashboard() => Get.offNamed(AppRoutes.navScreen);

  void _navigateToWaitingApprovalScreen() => Get.offNamed(AppRoutes.waitingForApproval);
  
  /// Navigate to appropriate profile completion screen based on user type
  void _navigateToProfileCompletion() {
    final user = currentUser.value;
    
    logger.navigation('Navigating to profile completion', arguments: {
      'userType': user?.type,
      'userId': user?.id,
    });
    
    // Determine navigation based on user type
    switch (user?.type?.toLowerCase()) {
      case 'doctor':
      case 'specialist':
        logger.navigation('Navigate to doctor profile completion');
        Get.offAllNamed(
          AppRoutes.specialistSignup,
          arguments: {
            Arguments.navigateSpecialistSignUpToStepTwo: 1,
          },
        );
        break;
        
      case 'patient':
      default:
        logger.navigation('Navigate to patient specialist selection');
        Get.offAllNamed(AppRoutes.specialistSelection); // Update with your actual route
        break;
    }
  }

  // ==================== UTILITY METHODS ====================
  
  /// Set loading state using BaseController capabilities
  void setLoadingState(bool loading) {
    setLoading(loading);
  }

  /// Log debug messages only in debug mode
  void _logDebug(String message) {
    if (kDebugMode) {
      print(message);
    }
  }

  /// Log current application state for debugging
  void _logApplicationState() {
    if (!kDebugMode) return;
    
    _logDebug("📊 Application State:");
    _logDebug("   Access Token: ${_accessToken?.isNotEmpty == true ? 'Present' : 'Absent'}");
    _logDebug("   Onboarding Complete: $_hasCompletedOnboarding");
    _logDebug("   Current User: ${currentUser.value?.name ?? 'Not logged in'}");
  }

  /// Handle initialization errors
  void _handleInitializationError(dynamic error) {
    _logDebug("❌ Initialization error: $error");
    // Simple error handling - could be extended later
  }
}