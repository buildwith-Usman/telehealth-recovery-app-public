import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/entity/specialist_available_time_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';

enum DetailTabType { about, reviews }

class SpecialistDetailController extends BaseController {
  SpecialistDetailController({
    required this.getSpecialistByIdUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final GetUserDetailByIdUseCase getSpecialistByIdUseCase;
  // ==================== OBSERVABLES ====================
  final Rx<DetailTabType> _selectedTab = DetailTabType.about.obs;
  final Rx<UserEntity?> _specialist = Rx<UserEntity?>(null);

  // ==================== REACTIVE VARIABLES ====================
  final Rx<ProfileCardItem> _specialistDetails = const ProfileCardItem().obs;

  // Screen configuration
  final RxString _screenTitle = 'Specialist Details'.obs;
  final RxString _bottomButtonText = 'Book Consultation'.obs;

  // Specialist ID from arguments
  int? _specialistId;

  // ==================== GETTERS ====================
  DetailTabType get selectedTab => _selectedTab.value;
  UserEntity? get specialist => _specialist.value;
  String get screenTitle => _screenTitle.value;
  String get bottomButtonText => _bottomButtonText.value;

  // Specialist info getters (computed from specialist entity)
  String get specialistName => specialist?.name ?? '';
  String get specialistProfession =>
      specialist?.doctorInfo?.specialization ?? '';
  String get specialistExperience =>
      specialist?.doctorInfo?.experience ?? '0 Years';
  String get specialistImageUrl => specialist?.imageUrl ?? '';
  String get specialistCredentials => specialist?.doctorInfo?.degree ?? '';
  double? get specialistRating =>
      specialist != null ? _calculateActualRating(null) : null;
  int get reviewCount => specialist != null ? _getActualReviewCount(null) : 0;
  ProfileCardItem get specialistDetail => _specialistDetails.value;

  // Rating display helpers
  bool get hasRating => specialistRating != null && reviewCount > 0;
  String get ratingDisplayText {
    if (specialist == null) return 'Loading...';
    if (!hasRating) return 'New Specialist';
    return '${specialistRating!.toStringAsFixed(1)} ($reviewCount reviews)';
  }

  String get trustIndicators {
    if (specialist == null) return '';
    List<String> indicators = [];

    if (specialist!.doctorInfo?.degree?.isNotEmpty == true) {
      indicators.add('Certified ${specialist!.doctorInfo!.degree}');
    }
    if (yearsOfExperience > 0) {
      indicators.add('$yearsOfExperience+ years experience');
    }
    if (specialist!.isVerified == true) {
      indicators.add('Verified Professional');
    }

    return indicators.isEmpty ? 'New Specialist' : indicators.join(' • ');
  }

  int get yearsOfExperience =>
      _extractYearsFromExpString(specialist?.doctorInfo?.experience);
  List<String> get specialistLanguages =>
      specialist?.languages?.map((lang) => lang.language ?? '').toList() ?? [];

  // Stats section getters
  String get patientsCount {
    if (specialist == null) return '--';
    // TODO: Get actual patient count from API when available
    // For now, show a placeholder based on experience
    if (yearsOfExperience >= 10) return '500+';
    if (yearsOfExperience >= 5) return '200+';
    if (yearsOfExperience >= 2) return '50+';
    return 'New';
  }

  String get experienceDisplay {
    if (specialist == null) return '--';
    if (yearsOfExperience == 0) return 'New';
    return '${yearsOfExperience}yr+';
  }

  String get ratingDisplay {
    if (specialist == null) return '--';
    if (!hasRating) return 'New';
    return specialistRating!.toStringAsFixed(1);
  }

  // Additional properties for UI (these reference _specialist observable)
  String get specialistBio => specialist != null
      ? 'A dedicated healthcare professional committed to providing quality medical care.'
      : 'Loading bio...';
  List<String> get availableTimeSlots => specialist != null
      ? ['9:00 AM', '10:30 AM', '2:00 PM']
      : []; // Default slots since not in API

  // ==================== HELPER METHODS ====================
  double? _calculateActualRating(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) {
      return null; // No reviews → show "Not rated yet"
    }

    final validRatings = reviews
        .map((r) => r.rating)
        .where((rating) => rating != null && rating > 0)
        .cast<int>()
        .toList();

    if (validRatings.isEmpty) {
      return null; // All ratings are invalid/null
    }

    final average = validRatings.reduce((a, b) => a + b) / validRatings.length;
    return double.parse(average.toStringAsFixed(1)); // e.g., 4.3
  }

  int _getActualReviewCount(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) {
      return 0;
    }

    return reviews.where((r) => r.rating != null && r.rating! > 0).length;
  }

  int _extractYearsFromExpString(String? experienceStr) {
    if (experienceStr == null) return 0;
    final match = RegExp(r'(\d+)').firstMatch(experienceStr);
    return int.tryParse(match?.group(1) ?? '0') ?? 0;
  }

  /// Format available times from the specialist's schedule for current day
  /// Returns a string like "9:00 AM - 5:00 PM" for today, or null if not available today
  String? _formatAvailableTime(List<SpecialistAvailableTimeEntity>? availableTimes) {
    if (availableTimes == null || availableTimes.isEmpty) {
      return null;
    }

    // Get current day abbreviation (e.g., "Mon", "Tue") to match API format
    final now = DateTime.now();
    final currentDayAbbr = _getDayAbbreviation(now.weekday);

    // Find times for current day
    String? earliestStart;
    String? latestEnd;

    for (var time in availableTimes) {
      if (time.isAvailable &&
          time.weekday?.toLowerCase() == currentDayAbbr.toLowerCase()) {
        if (earliestStart == null ||
            (time.startTime != null && _compareTime(time.startTime!, earliestStart) < 0)) {
          earliestStart = time.startTime;
        }
        if (latestEnd == null ||
            (time.endTime != null && _compareTime(time.endTime!, latestEnd) > 0)) {
          latestEnd = time.endTime;
        }
      }
    }

    if (earliestStart != null && latestEnd != null) {
      // Convert to 12-hour format if needed
      final formattedStart = _convertTo12HourFormat(earliestStart);
      final formattedEnd = _convertTo12HourFormat(latestEnd);
      return '$formattedStart - $formattedEnd';
    }

    // If not available today, try to find next available day
    return _findNextAvailableDay(availableTimes, now.weekday);
  }

  /// Convert time string to 12-hour format (e.g., "17:00" -> "05:00 PM", "09:00 AM" stays as is)
  String _convertTo12HourFormat(String timeStr) {
    // If already in 12-hour format (contains AM/PM), return as is
    if (timeStr.toUpperCase().contains('AM') || timeStr.toUpperCase().contains('PM')) {
      return timeStr;
    }

    // Parse 24-hour format (e.g., "17:00", "09:00")
    final parts = timeStr.split(':');
    if (parts.length != 2) return timeStr; // Return original if invalid format

    final hour24 = int.tryParse(parts[0]);
    final minutes = parts[1];

    if (hour24 == null) return timeStr; // Return original if invalid

    // Convert to 12-hour format
    String period;
    int hour12;

    if (hour24 == 0) {
      hour12 = 12;
      period = 'AM';
    } else if (hour24 < 12) {
      hour12 = hour24;
      period = 'AM';
    } else if (hour24 == 12) {
      hour12 = 12;
      period = 'PM';
    } else {
      hour12 = hour24 - 12;
      period = 'PM';
    }

    // Format with leading zero for single-digit hours if needed
    final formattedHour = hour12.toString().padLeft(2, '0');
    return '$formattedHour:$minutes $period';
  }

  /// Get day abbreviation from weekday number (1 = Mon, 7 = Sun) - matches API format
  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  /// Find the next available day if specialist is not available today
  String? _findNextAvailableDay(List<SpecialistAvailableTimeEntity> availableTimes, int currentWeekday) {
    // Try to find the next available day in the week
    for (int i = 1; i <= 7; i++) {
      final nextWeekday = ((currentWeekday + i - 1) % 7) + 1;
      final nextDayAbbr = _getDayAbbreviation(nextWeekday);

      for (var time in availableTimes) {
        if (time.isAvailable &&
            time.weekday?.toLowerCase() == nextDayAbbr.toLowerCase() &&
            time.startTime != null && time.endTime != null) {
          // Convert to 12-hour format and return like "Mon: 09:00 AM - 05:00 PM"
          final formattedStart = _convertTo12HourFormat(time.startTime!);
          final formattedEnd = _convertTo12HourFormat(time.endTime!);
          return '$nextDayAbbr: $formattedStart - $formattedEnd';
        }
      }
    }

    return null;
  }

  /// Compare two time strings (e.g., "09:00 AM" vs "05:00 PM")
  /// Returns negative if time1 < time2, 0 if equal, positive if time1 > time2
  int _compareTime(String time1, String time2) {
    try {
      final t1 = _parseTimeToMinutes(time1);
      final t2 = _parseTimeToMinutes(time2);
      return t1.compareTo(t2);
    } catch (e) {
      return 0;
    }
  }

  /// Parse time string to minutes since midnight for comparison
  int _parseTimeToMinutes(String timeStr) {
    final parts = timeStr.split(' ');
    if (parts.length != 2) return 0;

    final timeParts = parts[0].split(':');
    if (timeParts.length != 2) return 0;

    int hours = int.tryParse(timeParts[0]) ?? 0;
    final minutes = int.tryParse(timeParts[1]) ?? 0;
    final isPM = parts[1].toUpperCase() == 'PM';

    // Convert to 24-hour format
    if (isPM && hours != 12) {
      hours += 12;
    } else if (!isPM && hours == 12) {
      hours = 0;
    }

    return hours * 60 + minutes;
  }

  // ==================== INITIALIZATION ====================
  RoleManager roleManager = RoleManager.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeScreen();
    getSpecialistById();
  }

  // ==================== METHODS ====================

  void _initializeScreen() {
    // Configure screen based on user role
    if (roleManager.isPatient) {
      _screenTitle.value = 'Specialist Details';
      _bottomButtonText.value = 'Book Consultation';
    } else if (roleManager.isSpecialist) {
      _screenTitle.value = 'My Profile';
      _bottomButtonText.value = 'Edit Profile';
    } else if (roleManager.isAdmin) {
      _screenTitle.value = 'Specialist Profile';
      _bottomButtonText.value = 'Edit Profile';
    }

    // Get specialist ID from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    _specialistId = arguments?[Arguments.doctorId] as int?;

    if (kDebugMode) {
      print(
          'SpecialistDetailController - Initialized with specialist ID: $_specialistId');
    }
  }

  /// Get specialist by ID
  void getSpecialistById() async {
    if (_specialistId == null) {
      if (kDebugMode) {
        print('SpecialistDetailController - No specialist ID provided');
      }
      _showErrorSnackbar('Error', 'Specialist ID is required');
      return;
    }

    // Execute API call using BaseController
    final result = await executeApiCall<UserEntity>(
      () async {
        return await getSpecialistByIdUseCase.execute(_specialistId!);
      },
      onSuccess: () {
        if (kDebugMode) {
          print(
              'SpecialistDetailController - Successfully loaded specialist with ID: $_specialistId');
        }
      },
      onError: (errorMessage) {
        if (kDebugMode) {
          print(
              'SpecialistDetailController - Error loading specialist: $errorMessage');
        }
      },
    );

    if (result != null) {
      _specialist.value = result;
      mapSpecialistDetailsToProfileCardItem(result);
      if (kDebugMode) {
        print('SpecialistDetailController - Loaded specialist: ${result.name}');
      }
    } else {
      if (kDebugMode) {
        print('SpecialistDetailController - No specialist data found');
      }
      mapSpecialistDetailsToDefaultProfileCardItem();
      _showErrorSnackbar('Error', 'Specialist not found');
    }
  }

  void mapSpecialistDetailsToProfileCardItem(UserEntity userEntity) {
    final reviewCount = _getActualReviewCount(userEntity.reviews);

    _specialistDetails.value = ProfileCardItem(
        name: userEntity.name,
        profession: userEntity.doctorInfo?.specialization ?? 'Therapist',
        degree: userEntity.doctorInfo?.degree ?? 'LPC/LMHC',
        licenseNo: userEntity.doctorInfo?.licenseNo,
        rating: _calculateActualRating(userEntity.reviews),
        noOfRatings: reviewCount > 0 ? reviewCount.toString() : null,
        imageUrl: userEntity.imageUrl,
        doctorInfo: userEntity.doctorInfo ?? const DoctorInfoEntity(id: 1, userId: 123, specialization: 'Therapist', degree: 'BS-Therapy')
        );
  }

  void mapSpecialistDetailsToDefaultProfileCardItem() {
    _specialistDetails.value = const ProfileCardItem(
        name: 'Dr.Tahir Ikram',
        profession: 'Therapist',
        degree: 'LPC/LMHC',
        licenseNo: '56482603',
        rating: 4.9,
        noOfRatings: '29',
        doctorInfo: DoctorInfoEntity(id: 1, userId: 123, specialization: 'Therapist', degree: 'BS-Therapy')
        );
  }

  void navigationButtonClick() {
    if (kDebugMode) {
      print('Book consultation with $specialistName');
      print('Navigating to: ${AppRoutes.bookConsultation}');
    }

    if (roleManager.isPatient) {
      _navigateToBooking();
    } else if (roleManager.isSpecialist) {
      _navigateToEditProfile();
    }
  }

  void _navigateToBooking() {
    try {
      // Navigate to book consultation screen
      Get.toNamed(AppRoutes.bookConsultation, arguments: {
        'specialistId': _specialistId,
        'specialistName': specialistName,
        'specialistProfession': specialistProfession,
        'specialistCredentials': specialistCredentials,
        'specialistExperience': specialistExperience,
        'specialistRating': specialistRating ?? 0.0,
        'specialistImageUrl': specialistImageUrl,
        'availableTimeSlots':
            availableTimeSlots, // Today's slots for backward compatibility
        'consultationFee': 120.0, // Default fee since not in API
      });

      if (kDebugMode) {
        print('Navigation completed successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
      _showErrorSnackbar('Error', 'Unable to navigate to booking screen');
    }
  }

  void _navigateToEditProfile() {
    if (kDebugMode) {
      print('Edit profile tapped');
    }
    Get.toNamed(AppRoutes.editProfile,arguments: {
      Arguments.openedFrom : AppRoutes.specialistViewProfile
    })?.then((_) {
      // Refresh profile data when coming back from edit screen
      // refreshProfile();
    });
  }

  void goBack() {
    Get.back();
  }

  Future<void> refreshDoctor() async {}

  void selectTab(DetailTabType tab) {
    _selectedTab.value = tab;
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

  void viewReviews() {
    if (kDebugMode) {
      print('View reviews for $specialistName');
    }

    // TODO: Navigate to reviews screen
    Get.snackbar(
      'Reviews',
      'Reviews feature will be available soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
