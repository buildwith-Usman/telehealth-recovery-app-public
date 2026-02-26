import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/data/api/request/add_review_request.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import '../../app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import '../../app/controllers/base_controller.dart';
import '../../domain/usecase/add_review_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/get_paginated_doctors_list_use_case.dart';
import '../../domain/usecase/get_paginated_appointments_list_use_case.dart';
import '../../domain/entity/appointment_entity.dart';
import '../../domain/entity/paginated_appointments_list_entity.dart';
import '../../app/config/app_colors.dart';
import '../../app/utils/string_extensions.dart';
import '../../app/services/app_storage.dart';
import '../widgets/banner/sliding_banner.dart';
import '../widgets/rating_bottom_sheet.dart';
import '../navigation/nav_controller.dart';
import 'package:intl/intl.dart';

class PatientHomeController extends BaseController {
  
    // ==================== DEPENDENCIES ====================
  PatientHomeController({
    required this.getUserUseCase,
    required this.getPaginatedDoctorsListUseCase,
    required this.getPaginatedAppointmentsListUseCase,
    required this.addReviewUseCase,
  });

  final GetUserUseCase getUserUseCase;
  final GetPaginatedDoctorsListUseCase getPaginatedDoctorsListUseCase;
  final GetPaginatedAppointmentsListUseCase getPaginatedAppointmentsListUseCase;
  final AddReviewUseCase addReviewUseCase;
  
  // ==================== REACTIVE VARIABLES ====================
  final Rxn<UserEntity> _currentUserData = Rxn<UserEntity>();
  final RxList<UserEntity> _topTherapists = <UserEntity>[].obs;
  final RxList<UserEntity> _topPsychiatrists = <UserEntity>[].obs;
  final RxList<BannerItem> _upcomingAppointmentsBanner = <BannerItem>[].obs;
  
  // ==================== GETTERS ====================
  UserEntity? get currentUserData => _currentUserData.value;
  String get userName => currentUserData?.name ?? 'User';
  String? get userImageUrl => currentUserData?.imageUrl;
  
  // Doctors getters
  List<UserEntity> get topTherapists => _topTherapists;
  List<UserEntity> get topPsychiatrists => _topPsychiatrists;
  
  // Banner getters
  List<BannerItem> get upcomingAppointmentsBanner => _upcomingAppointmentsBanner;

  
  @override
  void onInit() {
    super.onInit();
    logger.controller('PatientHomeController initialized');
    _initializeData();
    // Check for post-call data and show dialogs after screen is ready
    final hasPostCallData = _checkAndShowPostCallDialog();
    // Only check for pending rating if there's no post-call data (to prevent double showing)
    if (!hasPostCallData) {
      _checkPendingRating();
    }
  }

  void _initializeData() {
    logger.method('_initializeData - Loading patient home dashboard data');
    _loadUserData();
    _loadTopDoctors();
    _loadUpcomingAppointments();
  }

  /// Check for post-call data from NavController and show rating dialog
  /// Returns true if post-call data was found and dialog will be shown
  bool _checkAndShowPostCallDialog() {
    try {
      if (Get.isRegistered<NavController>()) {
        final navController = Get.find<NavController>();
        final data = navController.postCallData;
        
        if (data != null && data[Arguments.showRating] == true) {
          if (kDebugMode) {
            print('PatientHomeController: Post-call data detected, scheduling dialog...');
          }
          
          // Save pending rating data before showing dialog (in case app closes)
          _savePendingRatingData(data);
          
          // Use WidgetsBinding to wait for the frame to settle
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Make the delayed callback async so we can await the dialog
            Future.delayed(const Duration(milliseconds: 3000), () async {
              await _showPostCallRatingDialog(data);
              // Clear the data after the dialog has completed
              navController.clearPostCallData();
            });
          });
          
          return true; // Post-call data found
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking post-call data: $e');
      }
    }
    return false; // No post-call data
  }

  /// Check for pending rating from previous app session
  void _checkPendingRating() {
    try {
      final pendingData = AppStorage.instance.pendingRatingData;
      
      if (pendingData != null && pendingData[Arguments.showRating] == true) {
        if (kDebugMode) {
          print('PatientHomeController: Pending rating data found from previous session');
        }
        
        // Use WidgetsBinding to wait for the frame to settle
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Make the delayed callback async so we can await the dialog
          Future.delayed(const Duration(milliseconds: 3000), () async {
            await _showPostCallRatingDialog(pendingData);
          });
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking pending rating: $e');
      }
    }
  }

  /// Save pending rating data to storage
  void _savePendingRatingData(Map<String, dynamic> data) {
    try {
      AppStorage.instance.setPendingRatingData(data);
      if (kDebugMode) {
        print('PatientHomeController: Saved pending rating data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving pending rating data: $e');
      }
    }
  }

  /// Clear pending rating data from storage
  void _clearPendingRatingData() {
    try {
      AppStorage.instance.clearPendingRatingData();
      if (kDebugMode) {
        print('PatientHomeController: Cleared pending rating data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing pending rating data: $e');
      }
    }
  }

  /// Internal method to show the rating dialog
  Future<void> _showPostCallRatingDialog(Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print('PatientHomeController: Showing post-call rating dialog');
      }

      if (Get.context == null || !Get.context!.mounted) {
        if (kDebugMode) {
          print('PatientHomeController: Context is invalid, cannot show dialog');
        }
        return;
      }

      // Use the actual rating bottom sheet from widgets
      await showRatingBottomSheet(
        Get.context!,
        doctorName: data[Arguments.doctorName] ?? '',
        doctorImageUrl: data[Arguments.doctorImageUrl],
        onSubmitRating: (rating, review) async {
          if (kDebugMode) {
            print('Rating submitted: $rating stars, review: $review');
          }
          // Submit rating via API
          final success = await _submitReview(
            receiverId: data[Arguments.receiverId] ?? 0,
            rating: rating,
            appointmentId: data[Arguments.appointmentId] ?? 0,
            message: review,
          );
          
          // Clear pending rating data only if submission was successful
          if (success) {
            _clearPendingRatingData();
          }
        },
      );
      
      // Show success message after the sheet closes
      // Get.snackbar(
      //   'Thank You!',
      //   'Your review has been submitted successfully',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: AppColors.checkedColor,
      //   colorText: AppColors.white,
      //   duration: const Duration(seconds: 2),
      // );

      // After rating, check for prescription
      await _handlePostRatingNavigation();
    } catch (e) {
      if (kDebugMode) {
        print('Error showing post-call rating dialog: $e');
      }
    }
  }

  /// Submit review/rating to API
  /// Returns true if submission was successful, false otherwise
  Future<bool> _submitReview({
    required int receiverId,
    required int rating,
    required int appointmentId,
    String? message,
  }) async {
    try {
      if (kDebugMode) {
        print('PatientHomeController: Submitting review...');
        print('  receiverId: $receiverId');
        print('  rating: $rating');
        print('  appointmentId: $appointmentId');
        print('  message: $message');
      }

      final request = AddReviewRequest(
        receiverId: receiverId,
        rating: rating,
        appointmentId: appointmentId,
        message: message,
      );

      final result = await executeApiCall<DoctorReviewEntity?>(
        () => addReviewUseCase.execute(request),
        onSuccess: () => logger.method('✅ Review submitted successfully'),
        onError: (error) => logger.method('⚠️ Failed to submit review: $error'),
      );

      if (result != null) {
        if (kDebugMode) {
          print('PatientHomeController: Review submitted successfully');
          print('  Review ID: ${result.id}');
          print('  Rating: ${result.rating}');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('PatientHomeController: Review result is null');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting review: $e');
      }
      return false;
    }
  }

  Future<void> _loadUserData() async {
    
    final result = await executeApiCall<UserEntity>(
          () => getUserUseCase.execute(),
      onSuccess: () =>  logger.method('✅ User data fetched successfully'),
      onError: (error) => logger.method("⚠️ Failed to fetch user data: $error"),
    );

    if (result != null) {
      _currentUserData.value = result;
      logger.method('User data loaded: ${result.name}');
      if (kDebugMode) {
        print('PatientHomeController: User data loaded');
        print('PatientHomeController: User name: ${result.name}');
      }
    } else {
      logger.method('⚠️ User data is null');
      if (kDebugMode) {
        print('PatientHomeController: User data result is null');
      }
    }
  }

  /// Load top doctors (therapists and psychiatrists)
  Future<void> _loadTopDoctors() async {
    logger.method('_loadTopDoctors - Loading top therapists and psychiatrists');
    
    // Load therapists and psychiatrists concurrently
    await Future.wait([
      _loadTopTherapists(),
      _loadTopPsychiatrists(),
    ]);
  }

  /// Load top 5 therapists
  Future<void> _loadTopTherapists() async {

    final params = GetPaginatedDoctorsListParams.withDefaults(
      specialization: SpecialistType.therapist.name,
      page: 1,
      limit: 5,
    );

    final result = await executeApiCall<PaginatedListEntity<UserEntity>?>(
          () => getPaginatedDoctorsListUseCase.execute(params),
      onSuccess: () => logger.method('✅ Top therapists fetched successfully'),
      onError: (error) => logger.method("⚠️ Failed to fetch top therapists: $error"),
    );

    if (result != null) {
      _topTherapists.assignAll(result.data);
      logger.method('Loaded ${result.data.length} therapists');
      if (kDebugMode) {
        print('PatientHomeController: Loaded ${result.data.length} therapists');
      }
    } else {
      _topTherapists.clear();
      logger.method('⚠️ No therapists data received');
    }
  }

  /// Load top 5 psychiatrists
  Future<void> _loadTopPsychiatrists() async {

    final params = GetPaginatedDoctorsListParams.withDefaults(
      specialization: SpecialistType.psychiatrist.name,
      page: 1,
      limit: 5,
    );

    final result = await executeApiCall<PaginatedListEntity<UserEntity>?>(
          () => getPaginatedDoctorsListUseCase.execute(params),
      onSuccess: () => logger.method('✅ Top psychiatrists fetched successfully'),
      onError: (error) => logger.method("⚠️ Failed to fetch top psychiatrists: $error"),
    );

    if (result != null) {
      _topPsychiatrists.assignAll(result.data);
      logger.method('Loaded ${result.data.length} psychiatrists');
      if (kDebugMode) {
        print('PatientHomeController: Loaded ${result.data.length} psychiatrists');
      }
    } else {
      _topPsychiatrists.clear();
      logger.method('⚠️ No psychiatrists data received');
    }
  }

  void refreshData() {
    logger.method('refreshData - Refreshing patient dashboard data');
    // Refresh dashboard data
    _initializeData();
  }

  /// Refresh user data specifically
  Future<void> refreshUserData() async {
    logger.method('refreshUserData - Refreshing user data');
    await _loadUserData();
  }

  /// Refresh doctors data specifically
  Future<void> refreshDoctorsData() async {
    logger.method('refreshDoctorsData - Refreshing doctors data');
    await Future.wait([
      _loadTopDoctors(),
      _loadUpcomingAppointments(),
    ]);
  }

  /// Load upcoming appointments for banner (limited to 3 items)
  Future<void> _loadUpcomingAppointments() async {
    logger.method('_loadUpcomingAppointments - Loading upcoming appointments for banner');

    final params = GetPaginatedAppointmentsListParams.byPatient(
      status: 'pending',
      page: 1,
      limit: 3, // Limit to 3 items for banner
    );

    final result = await executeApiCall<PaginatedAppointmentsListEntity?>(
      () => getPaginatedAppointmentsListUseCase.execute(params),
      onSuccess: () => logger.method('✅ Upcoming appointments fetched successfully'),
      onError: (error) => logger.method("⚠️ Failed to fetch upcoming appointments: $error"),
    );

    if (result != null && result.appointments != null && result.appointments!.isNotEmpty) {
      // Map appointments to banner items (limited to 3)
      final appointments = result.appointments!.take(3).toList();
      final bannerItems = appointments.asMap().entries.map((entry) {
        final index = entry.key;
        final appointment = entry.value;
        return _mapAppointmentToBannerItem(appointment, index);
      }).toList();
      
      _upcomingAppointmentsBanner.assignAll(bannerItems);
      logger.method('Loaded ${bannerItems.length} upcoming appointments for banner');
    } else {
      _upcomingAppointmentsBanner.clear();
      logger.method('⚠️ No upcoming appointments found');
    }
  }

  /// Map AppointmentEntity to BannerItem
  BannerItem _mapAppointmentToBannerItem(AppointmentEntity appointment, int index) {
    // Get doctor info
    final doctor = appointment.doctor;
    final doctorName = doctor?.name ?? 'Unknown';
    final doctorImageUrl = doctor?.imageUrl;
    final specialization = doctor?.doctorInfo?.specialization ?? 'Specialist';

    // Parse and format date/time
    String formattedTime = 'Upcoming';
    if (appointment.date != null && appointment.startTime != null) {
      try {
        final dateParts = appointment.date!.split('-');
        final timeParts = appointment.startTime!.split(':');
        if (dateParts.length == 3 && timeParts.length >= 2) {
          final appointmentDateTime = DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );
          
          // Format: "MMM dd, yyyy hh:mm a"
          final dateFormat = DateFormat('MMM dd, yyyy');
          final timeFormat = DateFormat('hh:mm a');
          formattedTime = '${dateFormat.format(appointmentDateTime)}, ${timeFormat.format(appointmentDateTime)}';
        }
      } catch (e) {
        logger.error('Error parsing appointment date/time: $e');
      }
    }

    // Color variations for banner items (rotate through colors)
    final bannerColors = [
      AppColors.primary,
      const Color(0xFF2E7D7D),
      const Color(0xFF1B5E5E),
    ];
    final backgroundColor = bannerColors[index % bannerColors.length];

    return BannerItem(
      time: formattedTime,
      name: doctorName,
      profession: specialization.capitalizeFirstOnly(),
      buttonText: 'Start Session',
      backgroundColor: backgroundColor,
      imageUrl: doctorImageUrl,
      onButtonPressed: () => _startVideoCallFromBanner(appointment),
    );
  }

  /// Start video call from banner item (patient side)
  /// Passes the complete appointment entity for type safety and maintainability
  void _startVideoCallFromBanner(AppointmentEntity appointment) {
    // Validate required appointment data
    if (appointment.id == null) {
      logger.error('Cannot start video call: Appointment ID is null');
      _showErrorSnackbar('Error', 'Unable to start video call. Please try again.');
      return;
    }

    // Pass the complete appointment entity
    // The video call controller will extract all necessary information from it
    Get.toNamed(
      AppRoutes.videoCall,
      arguments: appointment,
    );
    
    logger.navigation('Starting video call for appointment: ${appointment.id}');
  }

  /// Refresh therapists only
  Future<void> refreshTherapists() async {
    logger.method('refreshTherapists - Refreshing therapists data');
    await _loadTopTherapists();
  }

  /// Refresh psychiatrists only
  Future<void> refreshPsychiatrists() async {
    logger.method('refreshPsychiatrists - Refreshing psychiatrists data');
    await _loadTopPsychiatrists();
  }

  /// Navigate to specialist detail page from DoctorEntity
  void navigateToDoctorDetail(DoctorInfoEntity? doctor) {
    if (doctor?.userId == null) {
      logger.method('⚠️ Cannot navigate: Doctor ID is null');
      _showErrorSnackbar('Navigation Error', 'Unable to load doctor details');
      return;
    }

    logger.navigation('Navigating to specialist detail: ${doctor?.userId}');

    try {
      Get.toNamed(
        AppRoutes.specialistView,
        arguments: {
          Arguments.doctorId: doctor?.userId, 
        },
      );
    } catch (e) {
      logger.error('Navigation failed: $e');
      _showErrorSnackbar('Navigation Error', 'Failed to open doctor details');
    }
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

  /// Get display name for doctor
  String getDoctorDisplayName(String? name) {
    return name ?? '';
  }

  /// Get doctor specialization
  String getDoctorSpecialization(String? specialization) {
    if (specialization == null || specialization.isEmpty) return '';
    return specialization.capitalizeFirstOnly();
  }

  /// Get doctor experience
  String getDoctorExperience(DoctorInfoEntity? doctorInfo) {
    final experience = doctorInfo?.experience;
    if (experience == null || experience.isEmpty) return '0 years';
    return '$experience years';
  }

  /// Get doctor rating (calculated from reviews or default)
  double? getDoctorRating(List<DoctorReviewEntity>? reviews) {
  if (reviews == null || reviews.isEmpty) return null;

  final validRatings = reviews
      .map((review) => review.rating)
      .whereType<int>() // filters out nulls
      .toList();

  if (validRatings.isEmpty) return null;

  final total = validRatings.reduce((a, b) => a + b);
  return total / validRatings.length;
}

  /// Get number of ratings for a doctor
  String? getNumberOfRatings(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) return null;

    final validRatings = reviews
        .map((review) => review.rating)
        .whereType<int>() // filters out nulls
        .toList();

    if (validRatings.isEmpty) return null;

    return validRatings.length.toString();
  }


  /// Handle search functionality
  void onSearchChanged(String query) {
    logger.userAction('Search query changed', params: {'query': query});
    // Implement search logic here
    if (query.isEmpty) {
      // Clear search results
      return;
    }
    // Filter specialists or navigate to search results
  }

  /// Handle search submission
  void onSearchSubmitted(String query) {
    logger.userAction('Search submitted: $query');
    // Navigate to specialist list with search query
    if (query.isNotEmpty) {
      Get.toNamed(AppRoutes.specialistList, arguments: {'searchQuery': query});
    }
  }

  /// Navigate to notifications
  void navigateToNotifications() {
    logger.navigation('Navigating to notifications');
    // For now, show info message until notifications page is implemented
    Get.snackbar('Info', 'Notifications feature coming soon!');
  }

  /// Navigate to pharmacy
  void navigateToPharmacy() {
    logger.navigation('Navigating to pharmacy');
    Get.toNamed(AppRoutes.pharmacy);
  }

  /// Handle session start
  void startSession(String doctorName) {
    logger.userAction('Starting session with: $doctorName');
    // For now, show info message until video call is implemented
    Get.snackbar('Session', 'Starting session with $doctorName');
  }

  /// Navigate to specialist list with filter
  void navigateToSpecialistList(String specialistType) {
    logger.navigation('Navigating to specialist list: $specialistType');

    if (kDebugMode) {
      print('PatientHomeController: Navigating to specialist list with type: $specialistType');
      print('PatientHomeController: Route = ${AppRoutes.specialistList}');
      print('PatientHomeController: Arguments = {${Arguments.initialType}: $specialistType}');
    }

    try {
      final result = Get.toNamed(AppRoutes.specialistList, arguments: {
        Arguments.initialType: specialistType,
      });

      if (kDebugMode) {
        print('PatientHomeController: Navigation result = $result');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PatientHomeController: Navigation error = $e');
      }
      logger.error('Navigation to specialist list failed: $e');
    }
  }

  /// Navigate to user profile
  void navigateToProfile() {
    logger.navigation('Navigating to user profile');
    Get.toNamed(AppRoutes.profile);
  }

  /// Handle upcoming session actions
  void handleSessionAction(String sessionId, String action) {
    logger.userAction('Session action: $action for session: $sessionId');

    switch (action) {
      case 'start':
        // For now, show info message until video call is implemented
        Get.snackbar('Session', 'Starting session...');
        break;
      case 'reschedule':
        // For now, show info message until reschedule page is implemented
        Get.snackbar('Reschedule', 'Reschedule feature coming soon!');
        break;
      case 'cancel':
        // Show cancel confirmation
        _showCancelSessionDialog(sessionId);
        break;
      default:
        logger.warning('Unknown session action: $action');
    }
  }

  /// Show cancel session confirmation dialog
  void _showCancelSessionDialog(String sessionId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Cancel Session'),
        content: const Text('Are you sure you want to cancel this session?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _cancelSession(sessionId);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  /// Cancel session
  void _cancelSession(String sessionId) {
    logger.userAction('Session cancelled: $sessionId');
    // Implement session cancellation logic
    // Call API to cancel session
    Get.snackbar('Success', 'Session cancelled successfully');
  }

  void onSpecialistTap(int? specialistId) {
    // Handle specialist tap - navigate to specialist detail
    if (kDebugMode) {
      print('Tapped on $specialistId');
    }

    // Navigate to specialist detail screen with specialist data
    Get.toNamed(
      AppRoutes.specialistViewProfile,
      arguments: {Arguments.doctorId: specialistId},
    );
  }

  /// Handle navigation after rating
  Future<void> _handlePostRatingNavigation() async {
    // TODO: Check for prescription and navigate accordingly
    if (kDebugMode) {
      print('Checking for prescription after rating...');
    }
  }
}
