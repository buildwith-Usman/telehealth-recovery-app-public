import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import '../../app/controllers/base_controller.dart';

/// Base controller containing shared logic for all specialist-related views
/// Follows DRY principle by centralizing common calculations and state management
abstract class BaseSpecialistController extends BaseController {
  final GetUserDetailByIdUseCase getSpecialistByIdUseCase;

  BaseSpecialistController({required this.getSpecialistByIdUseCase});

  // ==================== SHARED STATE ====================
  final Rx<UserEntity?> specialist = Rx<UserEntity?>(null);
  final Rx<ProfileCardItem> specialistDetails = const ProfileCardItem().obs;

  // ==================== SHARED CALCULATIONS ====================

  /// Calculate average rating from reviews
  /// Returns null if no valid ratings exist
  double? calculateRating(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) return null;

    final validRatings = reviews
        .map((r) => r.rating)
        .where((rating) => rating != null && rating > 0)
        .cast<int>()
        .toList();

    if (validRatings.isEmpty) return null;

    final average = validRatings.reduce((a, b) => a + b) / validRatings.length;
    return double.parse(average.toStringAsFixed(1));
  }

  /// Get count of valid reviews
  int getReviewCount(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) return 0;
    return reviews.where((r) => r.rating != null && r.rating! > 0).length;
  }

  /// Extract years from experience string (e.g., "5 years" -> 5)
  int extractYearsFromExp(String? experienceStr) {
    if (experienceStr == null) return 0;
    final match = RegExp(r'(\d+)').firstMatch(experienceStr);
    return int.tryParse(match?.group(1) ?? '0') ?? 0;
  }

  // ==================== COMPUTED PROPERTIES ====================

  /// Get specialist's rating from current specialist entity
  double? get specialistRating => calculateRating(specialist.value?.reviews);

  /// Get review count from current specialist entity
  int get reviewCount => getReviewCount(specialist.value?.reviews);

  /// Get years of experience from current specialist entity
  int get yearsOfExperience => extractYearsFromExp(specialist.value?.doctorInfo?.experience);

  /// Get patient count from API data
  /// Falls back to experience-based estimation if API data is not available
  String get patientsCount {
    if (specialist.value == null) return '--';

    // Use actual distinct patients count from API if available
    final actualCount = specialist.value!.distinctPatientsCount;
    if (actualCount != null) {
      if (actualCount == 0) return 'New';
      if (actualCount >= 500) return '500+';
      if (actualCount >= 200) return '200+';
      if (actualCount >= 100) return '100+';
      if (actualCount >= 50) return '50+';
      return actualCount.toString();
    }

    // Fallback to experience-based estimation
    if (yearsOfExperience >= 10) return '500+';
    if (yearsOfExperience >= 5) return '200+';
    if (yearsOfExperience >= 2) return '50+';
    return 'New';
  }

  /// Get formatted experience display
  String get experienceDisplay {
    if (specialist.value == null) return '--';
    if (yearsOfExperience == 0) return 'New';
    return '$yearsOfExperience';
  }

  /// Get formatted rating display
  String get ratingDisplay {
    if (specialist.value == null) return '--';
    if (specialistRating == null || reviewCount == 0) return 'New';
    return specialistRating!.toStringAsFixed(1);
  }

  /// Get specialist bio
  String get specialistBio =>
      specialist.value?.bio ??
      'A dedicated healthcare professional committed to providing quality medical care.';

  /// Get specialist name
  String get specialistName => specialist.value?.name ?? '';

  /// Get specialist profession
  String get specialistProfession => specialist.value?.doctorInfo?.specialization ?? '';

  /// Get specialist credentials
  String get specialistCredentials => specialist.value?.doctorInfo?.degree ?? '';

  /// Get specialist image URL
  String get specialistImageUrl => specialist.value?.imageUrl ?? '';

  /// Get specialist experience string
  String get specialistExperience => specialist.value?.doctorInfo?.experience ?? '0 Years';

  /// Check if specialist has rating
  bool get hasRating => specialistRating != null && reviewCount > 0;

  // ==================== SHARED METHODS ====================

  /// Map UserEntity to ProfileCardItem for display
  void mapSpecialistDetailsToProfileCardItem(UserEntity userEntity) {
    final reviewCount = getReviewCount(userEntity.reviews);

    specialistDetails.value = ProfileCardItem(
      name: userEntity.name,
      profession: userEntity.doctorInfo?.specialization ?? 'Therapist',
      degree: userEntity.doctorInfo?.degree ?? 'LPC/LMHC',
      licenseNo: userEntity.doctorInfo?.licenseNo,
      rating: calculateRating(userEntity.reviews),
      noOfRatings: reviewCount > 0 ? reviewCount.toString() : null,
      imageUrl: userEntity.imageUrl,
      doctorInfo: userEntity.doctorInfo ?? const DoctorInfoEntity(
        id: 1,
        userId: 123,
        specialization: 'Therapist',
        degree: 'BS-Therapy'
      ),
    );
  }

  /// Load specialist data by ID
  Future<void> loadSpecialist(int id) async {
    final result = await executeApiCall<UserEntity>(
      () => getSpecialistByIdUseCase.execute(id),
      onSuccess: () {
        logger.controller('Successfully loaded specialist with ID: $id');
      },
      onError: (errorMessage) {
        logger.error('Error loading specialist: $errorMessage');
      },
    );

    if (result != null) {
      specialist.value = result;
      mapSpecialistDetailsToProfileCardItem(result);
    }
  }
}
