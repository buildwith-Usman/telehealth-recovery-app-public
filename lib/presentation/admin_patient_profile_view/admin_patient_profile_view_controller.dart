import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/entity/user_entity.dart';
import '../splash/splash_controller.dart';

class AdminPatientProfileViewController extends BaseController {
  AdminPatientProfileViewController({
    required this.getUserUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final GetUserUseCase getUserUseCase;
  // ==================== OBSERVABLES ====================
  final RxString _userName = 'Usman'.obs;
  final RxString _userEmail = 'muhammadusman@mailinator.com'.obs;
  final RxString _profileImageUrl = ''.obs;
  final RxString _phoneNumber = '03244596096'.obs;
  final RxString _gender = 'Male'.obs;
  final RxString _dateOfBirth = '22/11/1996'.obs;
  final RxString _age = '23'.obs;

  // ==================== GETTERS ====================
  RxString get userName => _userName;
  RxString get userEmail => _userEmail;
  RxString get profileImageUrl => _profileImageUrl;
  RxString get phoneNumber => _phoneNumber;
  RxString get gender => _gender;
  RxString get dateOfBirth => _dateOfBirth;
  RxString get age => _age;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('ProfileController - onInit called');
    }
    
    // _loadUserProfile();
  }

  // ==================== METHODS ====================
  void _loadUserProfile() async {
    if (kDebugMode) {
      print('ProfileController - Starting to load user profile...');
    }

    // Try to get existing user data from SplashController first
    try {
      final splashController = Get.find<SplashController>();
      final existingUser = splashController.user;

      if (existingUser != null) {
        if (kDebugMode) {
          print(
              'ProfileController - Using existing user data from SplashController');
          print('ProfileController - User: ${existingUser.name}');
        }
        _populateUserDataFromUserEntity(existingUser);
        return;
      } else {
        if (kDebugMode) {
          print(
              'ProfileController - No existing user data found, making API call...');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            'ProfileController - SplashController not found, making API call... Error: $e');
      }
    }

    // Fallback to API call if no existing data
    _loadUserProfileFromApi();
  }

  /// Load user data from API (fallback method)
  void _loadUserProfileFromApi() async {
    if (kDebugMode) {
      print('ProfileController - Starting to load user profile...');
    }

    // Execute API call using BaseController
    final result = await executeApiCall<UserEntity>(
      () async {
        if (kDebugMode) {
          print('ProfileController - Calling getUserUseCase.execute()...');
        }
        return await getUserUseCase.execute();
      },
      onSuccess: () {
        if (kDebugMode) {
          print('ProfileController - Successfully loaded user profile');
        }
      },
      onError: (errorMessage) {
        if (kDebugMode) {
          print(
              'ProfileController - Error loading user profile: $errorMessage');
        }
        // Set default values if API fails
        _setDefaultUserData();
      },
    );

    if (kDebugMode) {
      print(
          'ProfileController - API result: ${result != null ? "success" : "null"}');
    }

    // If we got user data, populate the fields
    if (result != null) {
      _populateUserData(result);
    } else {
      // Fallback to default data if no result
      if (kDebugMode) {
        print('ProfileController - No result from API, setting default data');
      }
      _setDefaultUserData();
    }
  }

  /// Populate user data from API response
  void _populateUserData(UserEntity userEntity) {
    _populateUserDataFromUserEntity(userEntity);
  }

  /// Populate user data directly from UserEntity
  void _populateUserDataFromUserEntity(UserEntity user) {
    if (kDebugMode) {
      print('ProfileController - Populating user data:');
      print('Name: ${user.name}');
      print('Email: ${user.email}');
      print('Phone: ${user.phone}');
      print('PatientInfo exists: ${user.patientInfo != null}');
      if (user.patientInfo != null) {
        print('Gender: ${user.patientInfo!.gender}');
        print('DOB: ${user.patientInfo!.dob}');
      }
    }

    // Set values directly like EditProfileController does
    _userName.value = user.name;
    // _userEmail.value = user.email;
    _phoneNumber.value = user.phone ?? '';

    // Get additional info from patientInfo if available
    if (user.patientInfo != null) {
      _gender.value = user.patientInfo!.gender ?? '';
      _dateOfBirth.value = user.patientInfo!.dob ?? '';

      // Calculate age if date of birth is available
      if (user.patientInfo!.dob != null && user.patientInfo!.dob!.isNotEmpty) {
        _age.value = _calculateAge(user.patientInfo!.dob!) ?? '';
      } else {
        _age.value = '';
      }
    } else {
      _gender.value = '';
      _dateOfBirth.value = '';
      _age.value = '';
    }

    // Set profile image - you can add this field to UserEntity later
    // _profileImageUrl.value = 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400';

    // Call debug method
    debugValues();
  }

  /// Set default user data if API fails or returns no data
  void _setDefaultUserData() {
    _userName.value = '';
    // _userEmail.value = '';
    // _profileImageUrl.value = 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400';
    _phoneNumber.value = '';
    _gender.value = '';
    _dateOfBirth.value = '';
    _age.value = '';

    if (kDebugMode) {
      print('ProfileController - Set default user data (empty strings)');
    }
  }

  /// Calculate age from date of birth string
  String? _calculateAge(String dateOfBirth) {
    try {
      // Parse different date formats
      DateTime? birthDate;

      if (dateOfBirth.contains('-')) {
        // Handle YYYY-MM-DD or DD-MM-YYYY format
        List<String> parts = dateOfBirth.split('-');
        if (parts.length == 3) {
          int year, month, day;
          if (parts[0].length == 4) {
            // YYYY-MM-DD format
            year = int.parse(parts[0]);
            month = int.parse(parts[1]);
            day = int.parse(parts[2]);
          } else {
            // DD-MM-YYYY format
            day = int.parse(parts[0]);
            month = int.parse(parts[1]);
            year = int.parse(parts[2]);
          }
          birthDate = DateTime(year, month, day);
        }
      } else if (dateOfBirth.contains('/')) {
        // Handle DD/MM/YYYY format
        List<String> parts = dateOfBirth.split('/');
        if (parts.length == 3) {
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          birthDate = DateTime(year, month, day);
        }
      }

      if (birthDate != null) {
        final now = DateTime.now();
        int age = now.year - birthDate.year;
        if (now.month < birthDate.month ||
            (now.month == birthDate.month && now.day < birthDate.day)) {
          age--;
        }
        return '$age years';
      }
    } catch (e) {
      if (kDebugMode) {
        print('ProfileController - Error calculating age: $e');
      }
    }

    return null;
  }

  // ==================== NAVIGATION & ACTIONS ====================
  void goBack() {
    Get.back();
  }

  void refreshProfile() {
    if (kDebugMode) {
      print('Refreshing profile data...');
    }
    _loadUserProfile();
  }

  /// Debug method to test values
  void debugValues() {
    if (kDebugMode) {
      print('=== DEBUG VALUES ===');
      print('_userName.value: ${_userName.value}');
      print('_userEmail.value: ${_userEmail.value}');
      print('_phoneNumber.value: ${_phoneNumber.value}');
      print('userName getter: $userName');
      print('userEmail getter: $userEmail');
      print('phoneNumber getter: $phoneNumber');
      print('==================');
    }
  }

  void onEditProfile() {
    // Navigate to edit profile screen
    if (kDebugMode) {
      print('Edit profile tapped');
    }
    Get.toNamed(AppRoutes.editProfile)?.then((_) {
      // Refresh profile data when coming back from edit screen
      refreshProfile();
    });
  }

  void onChangeProfileImage() {
    // Handle change profile image action
    if (kDebugMode) {
      print('Change profile image tapped');
    }
  }

  void onChangePassword() {
    // Handle change password action
    if (kDebugMode) {
      print('Change password tapped');
    }
    // TODO: Navigate to change password screen or show change password dialog
  }

  void onAccountSettings() {
    // Handle account settings action
    if (kDebugMode) {
      print('Account settings tapped');
    }
    // TODO: Navigate to account settings screen
  }
}
