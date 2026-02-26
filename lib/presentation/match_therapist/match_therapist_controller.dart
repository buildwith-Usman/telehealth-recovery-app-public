import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';
import 'package:recovery_consultation_app/domain/entity/match_doctors_list_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/domain/models/specialist_item.dart';
import 'package:recovery_consultation_app/domain/usecase/get_match_doctors_list_use_case.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../di/client_module.dart';

class MatchTherapistController extends BaseController with ClientModule {
  MatchTherapistController({
    required this.getMatchDoctorsListUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final GetMatchDoctorsListUseCase getMatchDoctorsListUseCase;

  // ==================== REACTIVE VARIABLES ====================
  final RxList<ProfileCardItem> _matchedDoctors = <ProfileCardItem>[].obs;
  final RxString _selectedSpecialization = ''.obs;
  final RxString _selectedGender = ''.obs;
  final RxInt _minExperience = 0.obs;
  final RxInt _maxExperience = 20.obs;
  final RxList<ProfileCardItem> _originalDoctors = <ProfileCardItem>[].obs;

  // ==================== GETTERS ====================
  List<ProfileCardItem> get matchedDoctors => _matchedDoctors.toList();
  String get selectedSpecialization => _selectedSpecialization.value;
  String get selectedGender => _selectedGender.value;
  int get minExperience => _minExperience.value;
  int get maxExperience => _maxExperience.value;
  bool get hasMatches => _matchedDoctors.isNotEmpty;

  /// Compatibility getters for the UI
  List<ProfileCardItem> get matchedTherapists => matchedDoctors;
  String? get errorMessage => generalError.value;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit();
    _loadDummyPsychiatrists();
    // loadMatchedDoctors();
  }

  // ==================== DATA LOADING METHODS ====================
  /// Load matched doctors from API using the use case
  // Future<void> loadMatchedDoctors() async {
  //   // Execute API call using BaseController
  //   final result = await executeApiCall<MatchDoctorsListEntity>(
  //     () async {
  //       return await getMatchDoctorsListUseCase.execute();
  //     },
  //     onSuccess: () {
  //       if (kDebugMode) {
  //         print(
  //             'MatchTherapistController - Loaded ${_matchedDoctors.length} doctors');
  //       }
  //     },
  //     onError: (errorMessage) {
  //       if (kDebugMode) {
  //         print(
  //             'MatchTherapistController - Error loading doctors: $errorMessage');
  //       }
  //       _matchedDoctors.clear();
  //     },
  //   );
  //
  //   // Handle successful result
  //   if (result != null) {
  //     _originalDoctors.assignAll(result.doctors ?? []);
  //     _matchedDoctors.assignAll(result.doctors ?? []);
  //
  //     // Apply initial filters for verified doctors only
  //     _applyFilters();
  //   }
  // }

  /// Refresh the matched doctors list
  Future<void> refreshDoctors() async {
    // await loadMatchedDoctors();
  }

  /// Compatibility method for UI
  Future<void> retryMatching() async {
    await refreshDoctors();
  }

  // ==================== FILTER METHODS ====================
  /// Filter doctors by specialization
  void filterBySpecialization(String specialization) {
    _selectedSpecialization.value = specialization;
    _applyFilters();
  }

  /// Filter doctors by gender
  void filterByGender(String gender) {
    _selectedGender.value = gender;
    _applyFilters();
  }

  /// Filter doctors by experience range
  void filterByExperience(int minYears, int maxYears) {
    _minExperience.value = minYears;
    _maxExperience.value = maxYears;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _selectedSpecialization.value = '';
    _selectedGender.value = '';
    _minExperience.value = 0;
    _maxExperience.value = 20;
    _applyFilters();
  }

  /// Apply current filters to the doctors list
  void _applyFilters() {
    try {
      var filteredDoctors = _originalDoctors.toList();

      // Filter by specialization
      if (selectedSpecialization.isNotEmpty) {
        filteredDoctors = filteredDoctors
            .where((doctor) =>
                doctor.doctorInfo?.specialization?.toLowerCase() ==
                selectedSpecialization.toLowerCase())
            .toList();
      }

      // Filter by gender
      if (selectedGender.isNotEmpty) {
        filteredDoctors = filteredDoctors
            .where((doctor) =>
                doctor.doctorInfo?.gender?.toLowerCase() ==
                selectedGender.toLowerCase())
            .toList();
      }

      // Filter by experience
      filteredDoctors = filteredDoctors.where((doctor) {
        final experienceStr = doctor.doctorInfo?.experience;
        if (experienceStr == null) return false;

        // Extract number from experience string (e.g., "5 Years" -> 5)
        final match = RegExp(r'(\d+)').firstMatch(experienceStr);
        if (match == null) return false;

        final years = int.tryParse(match.group(1)!);
        if (years == null) return false;

        return years >= minExperience && years <= maxExperience;
      }).toList();

      // Only show verified doctors
      // filteredDoctors = filteredDoctors
      //     .where((doctor) =>
      //         (doctor.isVerified ?? false) &&
      //         // (doctor.doctorInfo?.approved == 1))
      //     .toList();

      // Sort by experience (descending order)
      filteredDoctors.sort((a, b) {
        final aExperience = _extractExperienceYears(a.doctorInfo?.experience);
        final bExperience = _extractExperienceYears(b.doctorInfo?.experience);
        return bExperience.compareTo(aExperience); // Descending order
      });

      _matchedDoctors.assignAll(filteredDoctors);
    } catch (e) {
      if (kDebugMode) {
        print('MatchTherapistController - Error applying filters: $e');
      }
    }
  }

  /// Extract years from experience string
  int _extractExperienceYears(String? experienceStr) {
    if (experienceStr == null) return 0;
    final match = RegExp(r'(\d+)').firstMatch(experienceStr);
    return int.tryParse(match?.group(1) ?? '0') ?? 0;
  }

  // ==================== UI CONVERSION METHODS ====================
  /// Convert DoctorUserEntity to SpecialistItem for UI
  // List<SpecialistItem> get specialistItems {
  //   return matchedDoctors
  //       .map((doctor) => _convertToSpecialistItem(doctor))
  //       .toList();
  // }

  void _loadDummyPsychiatrists() {
    _matchedDoctors.clear();
    final psychiatrists = [
      ProfileCardItem(
        name: 'Dr. Jennifer Lee',
        profession: 'Therapist',
        degree: 'MD, PhD',
        experience: '10 Years',
        rating: 4.8,
        noOfRatings: "33",
        doctorInfo: const DoctorInfoEntity(
          id: 104,
          userId: 1004,
          specialization: 'Therapist',
          degree: 'MD, Clinical Psychology',
        ),
        imageUrl:
        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400',
        onTap: () {
          onSpecialistTap(123);
        },
      ),
      ProfileCardItem(
        name: 'Dr. Lisa Thompson',
        profession: 'Therapist',
        degree: 'MD, Clinical',
        experience: '7 Years',
        rating: 4.6,
        noOfRatings: "14",
        doctorInfo: const DoctorInfoEntity(
          id: 102,
          userId: 1002,
          specialization: 'Therapist',
          degree: 'MD, Psychiatry',
        ),
        imageUrl:
        'https://images.unsplash.com/photo-1594824985937-d0501ba2fe65?w=400',
        onTap: () {
          onSpecialistTap(123);
        },
      ),
    ];
    _matchedDoctors.value = psychiatrists;
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

  /// Convert DoctorUserEntity to SpecialistItem
  SpecialistItem _convertToSpecialistItem(DoctorUserEntity doctor) {
    return SpecialistItem(
      name: doctor.name ?? 'Unknown Doctor',
      profession: doctor.doctorInfo?.specialization ?? 'Specialist',
      credentials: doctor.doctorInfo?.degree ?? '',
      experience: doctor.doctorInfo?.experience ?? '0 Years',
      rating: 4.5, // Default rating since it's not in the API response
      imageUrl: doctor.profileImage,
      onTap: () => onDoctorTap(doctor),
    );
  }

  // ==================== ACTION METHODS ====================
  /// Handle doctor tap - navigate to doctor details
  void onDoctorTap(DoctorUserEntity doctor) {
    if (kDebugMode) {
      print('MatchTherapistController - Tapped on doctor: ${doctor.name}');
    }

    // Navigate to doctor detail screen
    Get.toNamed(AppRoutes.specialistDetail, arguments: {
      'doctorId': doctor.id,
      'doctor': doctor,
    });
  }

  // ==================== UTILITY METHODS ====================
  /// Get doctors count by specialization
  Map<String, int> getDoctorsCountBySpecialization() {
    final counts = <String, int>{};
    for (final doctor in matchedDoctors) {
      final specialization = doctor.doctorInfo?.specialization ?? 'Unknown';
      counts[specialization] = (counts[specialization] ?? 0) + 1;
    }
    return counts;
  }

  /// Get available specializations
  List<String> get availableSpecializations {
    return matchedDoctors
        .map((doctor) => doctor.doctorInfo?.specialization)
        .where((specialization) => specialization != null)
        .cast<String>()
        .toSet()
        .toList();
  }

  /// Get error message when no doctors found
  String get noDocsMessage {
    if (selectedSpecialization.isNotEmpty || selectedGender.isNotEmpty) {
      return 'No doctors found matching your criteria. Try adjusting your filters.';
    }
    return 'No matched doctors found. Please try again or contact support.';
  }

  // ==================== NAVIGATION METHODS ====================
  void goToDashboard() {
    Get.offAllNamed(AppRoutes.navScreen);
  }

  void skipMatching() {
    // Navigate directly to main app without selecting a doctor
    Get.offAllNamed(AppRoutes.navScreen);
  }

  void navigateToSpecialistDetail(DoctorUserEntity doctor) {
    // Navigate to specialist detail screen with doctor data
    Get.toNamed(
      AppRoutes.specialistDetail,
      arguments: {
        'specialistId': doctor.id,
        'specialistName': doctor.name,
        'specialistTitle': doctor.doctorInfo?.specialization,
        'specialization': doctor.doctorInfo?.specialization,
        'imageUrl': doctor.profileImage,
        'rating': 4.5, // Default since not in API
        'reviewCount': 0, // Default since not in API
        'experience': doctor.doctorInfo?.experience,
        'isOnline': doctor.isVerified,
        'qualifications': doctor.doctorInfo?.degree,
        'approved': doctor.doctorInfo?.approved,
      },
    );
  }
}
