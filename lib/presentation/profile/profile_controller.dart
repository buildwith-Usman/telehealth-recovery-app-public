import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/entity/user_entity.dart';
import '../../app/utils/date_utils.dart';

/// Controller for managing user profile data and actions
class ProfileController extends BaseController {
  ProfileController({
    required this.getUserUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final GetUserUseCase getUserUseCase;

  // ==================== OBSERVABLES ====================
  final RxString _userName = ''.obs;
  final RxString _userEmail = ''.obs;
  final RxString _profileImageUrl = ''.obs;
  final RxString _phoneNumber = ''.obs;
  final RxString _gender = ''.obs;
  final RxString _dateOfBirth = ''.obs;
  final RxString _age = ''.obs;

  // ==================== GETTERS ====================
  String get userName => _userName.value;
  String get userEmail => _userEmail.value;
  String get profileImageUrl => _profileImageUrl.value;
  String get phoneNumber => _phoneNumber.value;
  String get gender => _gender.value;
  String get dateOfBirth => _dateOfBirth.value;
  String get age => _age.value;

  /// Returns true if gender/DOB data is available (for patient or doctor users)
  bool get hasProfileDetails => _gender.value.isNotEmpty || _dateOfBirth.value.isNotEmpty;

  @override
  void onReady() {
    super.onReady();
    // Load user profile after page is fully ready and listeners are set up
    _loadUserProfile();
  }

  // ==================== METHODS ====================

  /// Loads user profile data from API
  Future<void> _loadUserProfile() async {
    logger.controller('Fetching user profile from API');

    final result = await executeApiCall<UserEntity>(
      () => getUserUseCase.execute(),
      onSuccess: () {
        logger.controller('Successfully loaded user profile');
      },
      onError: (errorMessage) {
        logger.error('Failed to load user profile: $errorMessage');
        _clearUserData();
      },
    );

    if (result != null) {
      _populateUserDataFromUserEntity(result);
    } else {
      logger.warning('No user data received from API');
      _clearUserData();
    }
  }

  /// Populates user data from UserEntity
  void _populateUserDataFromUserEntity(UserEntity user) {
    logger.controller('Populating user data for: ${user.name} (${user.type})');

    _userName.value = user.name;
    _userEmail.value = user.email;
    _phoneNumber.value = user.phone ?? '';

    // Image URL is already converted to full URL in the mapper
    _profileImageUrl.value = user.imageUrl ?? '';

    // Get gender, DOB, and age based on user type
    if (user.patientInfo != null) {
      // Patient user - get from patientInfo
      final patientInfo = user.patientInfo!;
      _gender.value = patientInfo.gender ?? '';
      _dateOfBirth.value = patientInfo.dob ?? '';

      // Calculate age if date of birth is available
      if (patientInfo.dob != null && patientInfo.dob!.isNotEmpty) {
        _age.value = DateUtils.calculateAge(patientInfo.dob!) ?? '';
      } else {
        _age.value = '';
      }
    } else if (user.doctorInfo != null) {
      // Doctor user - get from doctorInfo
      final doctorInfo = user.doctorInfo!;
      _gender.value = doctorInfo.gender ?? '';
      _dateOfBirth.value = doctorInfo.dob ?? '';

      // Calculate age if date of birth is available
      if (doctorInfo.dob != null && doctorInfo.dob!.isNotEmpty) {
        _age.value = DateUtils.calculateAge(doctorInfo.dob!) ?? '';
      } else {
        _age.value = '';
      }
    } else {
      // Admin user or user without additional info - no gender/DOB available
      logger.controller('No patient_info or doctor_info available for user');
      _gender.value = '';
      _dateOfBirth.value = '';
      _age.value = '';
    }

    logger.controller('User data populated successfully');
  }

  /// Clears all user data fields
  void _clearUserData() {
    logger.controller('Clearing user data');

    _userName.value = '';
    _userEmail.value = '';
    _phoneNumber.value = '';
    _gender.value = '';
    _dateOfBirth.value = '';
    _age.value = '';
    _profileImageUrl.value = '';
  }

  // ==================== NAVIGATION & ACTIONS ====================

  /// Navigates back to previous screen
  void goBack() {
    Get.back();
  }

  /// Refreshes profile data from cache or API
  void refreshProfile() {
    logger.controller('Refreshing profile data');
    _loadUserProfile();
  }

  /// Navigates to edit profile screen
  void onEditProfile() {
    logger.controller('Navigating to edit profile');
    Get.toNamed(AppRoutes.editProfile)?.then((_) {
      refreshProfile();
    });
  }

  /// Handles profile image change action
  void onChangeProfileImage() {
    logger.controller('Change profile image requested');
    // Implementation pending: Image picker integration
  }

  /// Navigates to change password screen
  void onChangePassword() {
    logger.controller('Change password requested');
    // Implementation pending: Navigate to change password screen
  }

  /// Navigates to account settings screen
  void onAccountSettings() {
    logger.controller('Account settings requested');
    // Implementation pending: Navigate to account settings screen
  }
}
