import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import '../../app/config/app_enum.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../domain/usecase/get_paginated_doctors_list_use_case.dart';
import '../../app/utils/image_url_utils.dart';

class SpecialistListController extends BaseController {
  // ==================== DEPENDENCIES ====================
  SpecialistListController({
    required this.getPaginatedDoctorsListUseCase,
  });

  final GetPaginatedDoctorsListUseCase getPaginatedDoctorsListUseCase;

  // ==================== REACTIVE VARIABLES ====================
  final Rx<SpecialistType> _selectedType = SpecialistType.therapist.obs;
  final RxList<String> _selectedLanguages = <String>[].obs;
  final RxList<String> _selectedDays = <String>[].obs;
  final RxList<String> _selectedTimes = <String>[].obs;
  final RxList<UserEntity> _doctors = <UserEntity>[].obs;
  final RxList<ProfileCardItem> _filteredSpecialists = <ProfileCardItem>[].obs;

  // Pagination variables
  final RxInt _currentPage = 1.obs;
  final RxBool _hasMoreData = true.obs;
  final RxBool _isLoadingMore = false.obs;

  // Add this for filter selections
  final RxList<String> selectedFilters = <String>[].obs;

  // ==================== GETTERS ====================
  SpecialistType get selectedType => _selectedType.value;
  List<String> get selectedTimes => _selectedTimes.toList();
  List<String> get selectedLanguages => _selectedLanguages.toList();
  List<String> get selectedDays => _selectedDays.toList();
  List<UserEntity> get doctors => _doctors.toList();
  List<ProfileCardItem> get filteredSpecialists =>
      _filteredSpecialists.toList();
  bool get hasMoreData => _hasMoreData.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get currentPage => _currentPage.value;

  RoleManager roleManager = RoleManager.instance;

  @override
  void onInit() {
    super.onInit();

    if (kDebugMode) {
      print('SpecialistListController: onInit called');
    }
  }

  @override
  void onReady() {
    super.onReady();

    if (kDebugMode) {
      print('SpecialistListController: onReady called');
    }

    // Initial load on first creation
    updateFromArguments();
  }

  /// Update specialist type from route arguments and reload data
  /// This method is called:
  /// 1. In onReady() when controller is first created
  /// 2. From the page's initState() every time the page is visited
  void updateFromArguments() {
    final arguments = Get.arguments;

    if (kDebugMode) {
      print('SpecialistListController: updateFromArguments called');
      print('SpecialistListController: Arguments = $arguments');
    }

    if (arguments != null && arguments[Arguments.initialType] != null) {
      final typeString = arguments[Arguments.initialType] as String;

      if (kDebugMode) {
        print('SpecialistListController: Received type string = "$typeString"');
        print('SpecialistListController: SpecialistType.therapist.name = "${SpecialistType.therapist.name}"');
        print('SpecialistListController: SpecialistType.psychiatrist.name = "${SpecialistType.psychiatrist.name}"');
        print('SpecialistListController: Comparison (therapist): ${typeString == SpecialistType.therapist.name}');
        print('SpecialistListController: Comparison (psychiatrist): ${typeString == SpecialistType.psychiatrist.name}');
      }

      // Determine the specialist type from the argument
      final selectedType = typeString == SpecialistType.therapist.name
          ? SpecialistType.therapist
          : SpecialistType.psychiatrist;

      if (kDebugMode) {
        print('SpecialistListController: Determined type = ${selectedType.name}');
      }

      // Use selectType which will update the type AND reload data
      selectType(selectedType);
    } else {
      if (kDebugMode) {
        print('SpecialistListController: No initialType argument found, using current type: ${_selectedType.value.name}');
      }

      // No arguments, just load data with current type
      logger.method('Selected specialist type: ${_selectedType.value.name}');
      _loadSpecialists();
    }
  }

  void _loadSpecialists() {
    _currentPage.value = 1;
    _hasMoreData.value = true;
    _loadDoctorsFromAPI();
  }

  void selectType(SpecialistType type) {
    _selectedType.value = type;

    if (kDebugMode) {
      print('SpecialistListController: Type changed to = ${type.name}');
    }
    logger.method('Specialist type changed to: ${type.name}');

    _loadSpecialists(); // Reload data for new type
  }

  /// Load doctors from API based on selected type
  Future<void> _loadDoctorsFromAPI() async {
    try {
      final params = GetPaginatedDoctorsListParams.withDefaults(
        specialization: selectedType.name,
        page: _currentPage.value,
        limit: 20, // Load 20 doctors per page
      );

      final result = await executeApiCall<PaginatedListEntity<UserEntity>?>(
        () => getPaginatedDoctorsListUseCase.execute(params),
        onSuccess: () => logger.method('✅ Doctors fetched successfully'),
        onError: (error) => logger.method("⚠️ Failed to fetch doctors: $error"),
      );

      if (result != null) {
        if (_currentPage.value == 1) {
          // First page - replace data
          _doctors.assignAll(result.data);
        } else {
          // Additional pages - append data
          _doctors.addAll(result.data);
        }

        // Check if there's more data
        _hasMoreData.value = result.data.length >= 20;

        logger.method(
            'Loaded ${result.data.length} doctors for ${selectedType.name}');
        if (kDebugMode) {
          print(
              'SpecialistListController: Loaded ${result.data.length} doctors');
          print('SpecialistListController: Total doctors = ${_doctors.length}');
        }
      } else {
        if (_currentPage.value == 1) {
          _doctors.clear();
        }
        _hasMoreData.value = false;
        logger.method('⚠️ No doctors data received');
        if (kDebugMode) {
          print('SpecialistListController: No doctors data received from API');
        }
      }

      _filterSpecialists();

      if (kDebugMode) {
        print('SpecialistListController: Filtered specialists = ${_filteredSpecialists.length}');
      }
    } catch (e) {
      logger.method("❌ Error loading doctors: $e");
      if (_currentPage.value == 1) {
        _doctors.clear();
        _filteredSpecialists.clear();
      }
      _hasMoreData.value = false;
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Load more doctors for pagination
  Future<void> loadMoreDoctors() async {
    if (_isLoadingMore.value || !_hasMoreData.value) return;

    _isLoadingMore.value = true;
    _currentPage.value = _currentPage.value + 1;
    await _loadDoctorsFromAPI();
  }

  /// Refresh doctors data
  Future<void> refreshDoctors() async {
    _currentPage.value = 1;
    _hasMoreData.value = true;
    await _loadDoctorsFromAPI();
  }

  // Update this to use selectedFilters if needed
  void applyFilters(List<String> filters) {
    selectedFilters.value = filters;
    _filterSpecialists();
  }

  void _filterSpecialists() {
    if (kDebugMode) {
      print('SpecialistListController: _filterSpecialists called with ${_doctors.length} doctors');
    }

    // Convert DoctorEntity to ProfileCardItem and filter
    List<ProfileCardItem> filtered =
        _doctors.map((doctor) => _mapDoctorToSpecialistItem(doctor)).toList();

    if (kDebugMode) {
      print('SpecialistListController: Mapped to ${filtered.length} ProfileCardItems');
    }

    // Filter by specialist type (if needed - API already filters by specialization)
    // This is additional client-side filtering if needed
    if (selectedFilters.isNotEmpty) {
      filtered = filtered
          .where((specialist) => selectedFilters.any((filter) =>
              (specialist.profession ?? '')
                  .toLowerCase()
                  .contains(filter.toLowerCase())))
          .toList();

      if (kDebugMode) {
        print('SpecialistListController: After filtering = ${filtered.length}');
      }
    }

    _filteredSpecialists.value = filtered;

    if (kDebugMode) {
      print('SpecialistListController: Final filtered specialists = ${_filteredSpecialists.length}');
    }
  }

  /// Helper method to map DoctorEntity to ProfileCardItem
  ProfileCardItem _mapDoctorToSpecialistItem(UserEntity doctor) {
    final doctorInfo = doctor.doctorInfo;
    final averageRating = _calculateAverageRating(doctor.reviews);
    final numberOfRatings = _getNumberOfRatings(doctor.reviews);
    final experience = _formatExperience(doctorInfo?.experience);

    return ProfileCardItem(
        name: doctor.name,
        profession: doctorInfo?.specialization,
        degree: doctorInfo?.degree,
        experience: experience,
        rating: averageRating,
        noOfRatings: numberOfRatings,
        imageUrl: ImageUrlUtils().getFullImageUrl(doctor.fileInfo?.url),
        onTap: () => onSpecialistTap(doctor.doctorInfo?.userId),
        doctorInfo: doctor.doctorInfo,
        licenseNo: doctorInfo?.licenseNo);
  }

  /// Calculate average rating from reviews
  double? _calculateAverageRating(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) return null;

    final validRatings = reviews
        .where((review) => review.rating != null)
        .map((review) => review.rating!)
        .toList();

    if (validRatings.isEmpty) return null;

    final sum = validRatings.reduce((a, b) => a + b);
    return sum / validRatings.length;
  }

  /// Get number of ratings
  String? _getNumberOfRatings(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) return null;

    final validRatings = reviews
        .where((review) => review.rating != null)
        .toList();

    if (validRatings.isEmpty) return null;

    return validRatings.length.toString();
  }

  /// Format experience to include 'years' suffix
  String _formatExperience(String? experience) {
    if (experience == null || experience.isEmpty) return '0 years';
    // Check if 'years' is already included
    if (experience.toLowerCase().contains('year')) {
      return experience;
    }
    return '$experience years';
  }

  void goBack() {
    Get.back();
  }

  void onSpecialistTap(int? specialistId) {
    // Handle specialist tap - navigate to specialist detail
    if (kDebugMode) {
      print('Tapped on $specialistId');
    }

    // Navigate to unified specialist view with specialist ID
    Get.toNamed(
      AppRoutes.specialistView,
      arguments: {Arguments.doctorId: specialistId},
    );
  }

  void toggleLanguage(String language) {
    if (_selectedLanguages.contains(language)) {
      _selectedLanguages.remove(language);
    } else {
      _selectedLanguages.add(language);
    }
  }

  void clearLanguages() {
    _selectedLanguages.clear();
  }

  void toggleTime(String time) {
    if (_selectedTimes.contains(time)) {
      _selectedTimes.remove(time);
    } else {
      _selectedTimes.add(time);
    }
  }

  void clearTimes() {
    _selectedTimes.clear();
  }

  void toggleDay(String day) {
    if (_selectedDays.contains(day)) {
      _selectedDays.remove(day);
    } else {
      _selectedDays.add(day);
    }
  }

  void clearDays() {
    _selectedDays.clear();
  }

  String getSelectedLanguagesDisplay() {
    if (_selectedLanguages.isEmpty) {
      return 'Select a Language';
    }
    if (_selectedLanguages.length == 1) {
      return _selectedLanguages.first;
    }
    return '${_selectedLanguages.length} languages selected';
  }

  void navigateToQuestionnaires() {
    Get.toNamed(AppRoutes.questionnaire);
  }

  /// Reset all filters to default values
  void resetFiltersToDefaults() {
    _selectedTimes.clear();
    _selectedDays.clear();
    _selectedLanguages.clear();
  }

}
