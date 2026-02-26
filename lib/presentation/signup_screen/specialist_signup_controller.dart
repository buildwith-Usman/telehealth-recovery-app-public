import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/config/app_enum.dart';
import '../../app/config/app_routes.dart';
import '../../app/config/app_constant.dart';
import '../../app/utils/input_validator.dart';
import '../../app/controllers/base_controller.dart';
import '../../data/api/request/questionnaire_item.dart';
import '../../data/api/request/sign_up_request.dart';
import '../../data/api/request/update_profile_request.dart';
import '../../domain/entity/sign_up_entity.dart';
import '../../domain/entity/update_profile_entity.dart';
import '../../domain/usecase/sign_up_use_case.dart';
import '../../di/client_module.dart';
import '../../domain/usecase/update_profile_use_case.dart';

class SpecialistSignupController extends BaseController with ClientModule {
  SpecialistSignupController({
    required this.signUpUseCase,
    required this.updateProfileUseCase,
  });

  // ==================== DEPENDENCIES ====================
  final SignUpUseCase signUpUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ImagePicker _imagePicker = ImagePicker();

  // ==================== TEXT CONTROLLERS ====================
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController experienceTextEditingController =
      TextEditingController();
  final TextEditingController degreeTextEditingController =
      TextEditingController();
  final TextEditingController licenseTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  final TextEditingController professionTextEditingController =
      TextEditingController();
  final TextEditingController dayTextEditingController =
      TextEditingController();
  final TextEditingController monthTextEditingController =
      TextEditingController();
  final TextEditingController yearTextEditingController =
      TextEditingController();
  final TextEditingController bioTextEditingController =
      TextEditingController();

  // ==================== REACTIVE STATE ====================
  // Multi-step navigation
  var currentStep = 0.obs;
  final int totalSteps = 4;

  // Observable error states for reactive UI
  var nameError = RxnString();
  var emailError = RxnString();
  var phoneError = RxnString();
  var experienceError = RxnString();
  var degreeError = RxnString();
  var licenseError = RxnString();
  var bioError = RxnString();
  var passwordError = RxnString();
  var confirmPasswordError = RxnString();
  var profileImageError = RxnString();
  var professionError = RxnString();
  var dayError = RxnString();
  var monthError = RxnString();
  var yearError = RxnString();
  var ageGroupError = RxnString();
  var expertiseError = RxnString();

  // State observables for UI reactions
  var signupSuccess = false.obs;
  var signupErrorMessage = RxnString();

  // Profile image
  var selectedImagePath = ''.obs;

  // Languages
  final List<String> availableLanguages = [
    'English',
    'Urdu',
    'Punjabi',
    'Siraiki',
    'Balochi',
    'Pashto',
    'Sindhi'
  ];
  var selectedLanguages = <String>[].obs;

  // Date of Birth
  var selectedDay = ''.obs;
  var selectedMonth = ''.obs;
  var selectedYear = ''.obs;

  // Profession
  var selectedProfession = Rxn<SpecialistType>();

  // Gender
  var selectedGender = ''.obs;

  // Age Groups (Step 4)
  var selectedAgeGroups = <AgeGroup>[].obs;

  // Areas of Expertise (Step 4)
  var selectedAreasOfExpertise = <AreaOfExpertise>[].obs;

  // Screen tracking
  var screenType = ScreenName.specialistSignUp;

  // ==================== GETTERS ====================
  String get name => nameTextEditingController.text;
  String get email => emailTextEditingController.text;
  String get phone => phoneTextEditingController.text;
  String get experience => experienceTextEditingController.text;
  String get degree => degreeTextEditingController.text;
  String get license => licenseTextEditingController.text;
  String get password => passwordTextEditingController.text;
  String get confirmPassword => confirmPasswordTextEditingController.text;
  String get bio => bioTextEditingController.text;

  // Controller getters for UI binding
  TextEditingController get nameController => nameTextEditingController;
  TextEditingController get emailController => emailTextEditingController;
  TextEditingController get phoneController => phoneTextEditingController;
  TextEditingController get experienceController =>
      experienceTextEditingController;
  TextEditingController get degreeController => degreeTextEditingController;
  TextEditingController get licenseController => licenseTextEditingController;
  TextEditingController get passwordController => passwordTextEditingController;
  TextEditingController get confirmPasswordController =>
      confirmPasswordTextEditingController;
  TextEditingController get professionController =>
      professionTextEditingController;
  TextEditingController get dayController => dayTextEditingController;
  TextEditingController get monthController => monthTextEditingController;
  TextEditingController get yearController => yearTextEditingController;
  TextEditingController get bioController => bioTextEditingController;

  String get dateOfBirth {
    if (selectedDay.value.isNotEmpty &&
        selectedMonth.value.isNotEmpty &&
        selectedYear.value.isNotEmpty) {
      return '${selectedDay.value}/${selectedMonth.value}/${selectedYear.value}';
    }
    return '';
  }

  // Available professions for dropdown using enum
  List<SpecialistType> get availableProfessions => SpecialistType.values;

  // Available age groups for Step 4
  List<AgeGroup> get availableAgeGroups => AgeGroup.values;

  // Available areas of expertise for Step 4
  List<AreaOfExpertise> get availableAreasOfExpertise => AreaOfExpertise.values;

  // ==================== HELPER DISPLAY METHODS ====================
  String getProfessionDisplayName(SpecialistType type) {
    switch (type) {
      case SpecialistType.therapist:
        return 'Therapist';
      case SpecialistType.psychiatrist:
        return 'Psychiatrist';
    }
  }

  String getAgeGroupDisplayName(AgeGroup ageGroup) {
    switch (ageGroup) {
      case AgeGroup.teen:
        return 'Teen';
      case AgeGroup.adult:
        return 'Adult';
      case AgeGroup.senior:
        return 'Senior';
    }
  }

  String getAreaOfExpertiseDisplayName(AreaOfExpertise area) {
    switch (area) {
      case AreaOfExpertise.formalAssessmentAndDiagnosis:
        return 'Formal Assessment and Diagnosis';
      case AreaOfExpertise.addictions:
        return 'Addictions';
      case AreaOfExpertise.coupleCounseling:
        return 'Couple Counseling';
      case AreaOfExpertise.childTherapy:
        return 'Child Therapy';
      case AreaOfExpertise.familyTherapyAndEducation:
        return 'Family Therapy and Education';
      case AreaOfExpertise.otherTherapies:
        return 'Other Therapies';
    }
  }

  // ==================== LIFECYCLE METHODS ====================
  @override
  Future<void> onInit() async {
    super.onInit();
    _initializeForm();
    _preselectDefaultLanguages();
    _navigateToStep2();
  }

  @override
  void onClose() {
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    phoneTextEditingController.dispose();
    experienceTextEditingController.dispose();
    degreeTextEditingController.dispose();
    licenseTextEditingController.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    professionTextEditingController.dispose();
    dayTextEditingController.dispose();
    monthTextEditingController.dispose();
    yearTextEditingController.dispose();
    bioTextEditingController.dispose();
    super.onClose();
  }

  // ==================== INITIALIZATION METHODS ====================
  void _initializeForm() {
    nameTextEditingController.text = '';
    emailTextEditingController.text = '';
    phoneTextEditingController.text = '';
    experienceTextEditingController.text = '';
    degreeTextEditingController.text = '';
    licenseTextEditingController.text = '';
    passwordTextEditingController.text = '';
    confirmPasswordTextEditingController.text = '';
    professionTextEditingController.text = '';
    dayTextEditingController.text = '';
    monthTextEditingController.text = '';
    yearTextEditingController.text = '';
    bioTextEditingController.text = '';
  }

  void _preselectDefaultLanguages() {
    selectedLanguages.addAll(['English']);
  }

  void _navigateToStep2() {
    logger.controller(
        '_handleReturnFromOtp called - checking for return arguments');

    final arguments = Get.arguments;
    logger.controller('Arguments received', params: {'arguments': arguments});

    if (arguments != null && arguments is Map<String, dynamic>) {
      final returnStep = arguments[Arguments.navigateSpecialistSignUpToStepTwo];
      logger.controller('Arguments Not Null');

      if (returnStep != null && returnStep is int) {
        logger.controller(
            'Detected return from OTP, setting step to $returnStep');

        // Set the step - THIS IS CRITICAL
        setCurrentStep(returnStep);
      } else {
        logger.warning('Return step is null or invalid type');
      }
    } else {
      logger.controller(
          'No arguments found or arguments not a Map - this might be initial load');
    }
  }

  // ==================== MULTI-STEP NAVIGATION ====================
  Future<void> goToNextStep() async {
    logger.userAction('Attempting to go to next step',
        params: {'currentStep': currentStep.value});

    if (!validateCurrentStep()) {
      logger.warning('Validation failed for step ${currentStep.value + 1}');
      return;
    }

    // Handle step-specific logic BEFORE incrementing
    switch (currentStep.value) {
      case 0: // Step 1 - Call API and navigate to OTP
        logger.userAction('Step 1 completed - calling initial signup API');
        final success = await _handleStep1ApiCall();
        if (!success) {
          logger.warning('Step 1 API call failed - staying on current step');
          return;
        }
        return;

      case 1: // Step 2 - Normal progression
      case 2: // Step 3 - Normal progression
        logger.userAction(
            'Step ${currentStep.value + 1} completed - proceeding normally');
        break;

      case 3: // Step 4 (Final) - Complete signup
        logger.userAction('Final step - completing specialist signup');
        final success = await _handleFinalSignup();
        if (!success) {
          logger.warning('Final signup failed');
          return;
        }
        return;
    }

    // Increment step for normal progression (steps 1→2, 2→3)
    if (currentStep.value < totalSteps - 1) {
      final oldStep = currentStep.value;
      currentStep.value++;
      logger.stateChange('currentStep', oldStep, currentStep.value);
    }
  }

  void goToPreviousStep() {
    logger.userAction('Going to previous step',
        params: {'currentStep': currentStep.value});

    if (currentStep.value > 0) {
      // Check if we're in a registered user flow starting from step 2
      final arguments = Get.arguments;
      if (arguments != null && arguments is Map<String, dynamic>) {
        final returnStep =
            arguments[Arguments.navigateSpecialistSignUpToStepTwo];

        // If user started from step 2 and tries to go back from step 2
        if (returnStep != null && currentStep.value == 1) {
          logger.navigation(
              'Registered user at minimum step - calling goToPreviousScreen()');
          goToPreviousScreen(); // Use goToPreviousScreen instead of Get.back()
          return;
        }
      }

      // Normal step decrement
      final oldStep = currentStep.value;
      currentStep.value--;
      logger.stateChange('currentStep', oldStep, currentStep.value);
    } else {
      // At step 1, go back to previous screen
      goToPreviousScreen();
    }
  }

  // ==================== API METHODS ====================
  Future<bool> _handleStep1ApiCall() async {
    logger.method('_handleStep1ApiCall - Initial registration');

    final result = await executeApiCall<SignUpEntity>(
      () async {
        final params = SignUpRequest(
          name: name,
          email: email,
          phone: phone,
          password: password,
          passwordConfirmation: confirmPassword,
          type: UserRole.doctor.name,
        );
        return await signUpUseCase.execute(params);
      },
      onSuccess: () {
        signupSuccess.value = true;
        logger.controller("Step 1 SignUp API successful");
      },
      onError: (errorMessage) {
        logger.error("Step 1 Signup API failed", error: errorMessage);
        signupErrorMessage.value = errorMessage;
      },
    );

    if (result != null) {
      logger.navigation('Navigating to OTP screen after Step 1 completion');
      goToOtpScreenFromStep1(result.user.email);
      return true;
    }

    return false;
  }

  Future<bool> _handleFinalSignup() async {
    logger.method('_handleFinalSignup - Complete specialist profile');

    final result = await executeApiCall<UpdateProfileEntity>(
      () async {
        final request = UpdateProfileRequest(
          // Basic profile information
          dob: "${selectedDay.value.padLeft(2, '0')}-${selectedMonth.value.padLeft(2, '0')}-${selectedYear.value}", // Format: DD-MM-YYYY
          gender: selectedGender.value,
          age: _calculateAge(), // You'll need to implement this method
          completed: 1, // Mark profile as completed
          
          // Specialist-specific information
          specialization: selectedProfession.value?.name,
          experience: int.tryParse(experience),
          degree: degree,
          licenseNo: license,
          bio: bio,
          
          // Questionnaires
          // questionnaires: _buildQuestionnaires(),
        );
        return await updateProfileUseCase.execute(request);
      },
      onSuccess: () {
        logger.controller("Update Profile API successful");
      },
      onError: (errorMessage) {
        logger.error("Update Profile API failed", error: errorMessage);
      },
    );

    if (result != null) {
      logger.navigation('Navigating to Success Screen after Profile completion');
      //go to success Screen
      _navigateToSuccessScreen();
      return true;
    }

    return false;
  }

  void _navigateToSuccessScreen() {
    logger.navigation('Navigating to Success Screen (Regular Signup Flow)');

    Get.offAllNamed(
      AppRoutes.successPage,
      arguments: {
        Arguments.openedFrom:ScreenName.specialistSignUp,
      },
    );
  }

  // ==================== NAVIGATION METHODS ====================
  void goToOtpScreenFromStep1(String? email) {
    logger.navigation('Navigating to OTP from Step 1', arguments: {
      'email': email,
      'currentStep': currentStep.value,
      'returnToStep': 1,
    });

    Get.toNamed(AppRoutes.otp, arguments: {
      Arguments.token: null,
      Arguments.openedFrom: screenType,
      Arguments.email: email,
      Arguments.currentStep: currentStep.value,
      Arguments.returnToStep: 1,
      Arguments.isSpecialistFlow: true,
    });
  }

  void goToOtpScreen(String? verificationToken) {
    Get.toNamed(AppRoutes.otp, arguments: {
      Arguments.token: verificationToken,
      Arguments.openedFrom: screenType,
      Arguments.email: email,
    });
  }

  void setCurrentStep(int stepNumber) {
    logger.navigation('Returning from OTP to step',
        arguments: {'step': stepNumber});
    logger.warning('Current step is $currentStep');
    final oldStep = currentStep.value;
    currentStep.value = stepNumber; // ✅ This sets the page to Step 2
    logger.stateChange('currentStep', oldStep, currentStep.value);
  }

  // ==================== VALIDATION METHODS ====================
  bool validateCurrentStep() {
    clearAllErrors();

    switch (currentStep.value) {
      case 0: // Basic Information
        return validateStep1();
      case 1: // Personal Details
        return validateStep2();
      case 2: // Professional Information
        return validateStep3();
      case 3: // Preferences
        return validateStep4();
      default:
        return false;
    }
  }

  bool validateStep1() {
    bool isValid = true;

    if (name.trim().isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    }

    if (email.trim().isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(email.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }

    if (phone.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    }

    if (password.trim().isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (password.trim().length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }

    if (confirmPassword.trim().isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      isValid = false;
    } else if (password.trim() != confirmPassword.trim()) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }

    return isValid;
  }

  bool validateStep2() {
    bool isValid = true;

    if (dayController.text.trim().isEmpty) {
      dayError.value = 'Day is required';
      isValid = false;
    } else if (monthController.text.trim().isEmpty) {
      monthError.value = 'Month is required';
      isValid = false;
    } else if (yearController.text.trim().isEmpty) {
      yearError.value = 'Year is required';
      isValid = false;
    } else if (selectedGender.value.isEmpty) {
      setGeneralError('Please select a gender');
      isValid = false;
    } else if (selectedLanguages.isEmpty) {
      setGeneralError('Please select at least one language');
      isValid = false;
    }

    return isValid;
  }

  bool validateStep3() {
    bool isValid = true;

    if (professionController.text.trim().isEmpty) {
      professionError.value = 'Profession is required';
      isValid = false;
    }

    if (experience.trim().isEmpty) {
      experienceError.value = 'Experience is required';
      isValid = false;
    }

    if (degree.trim().isEmpty) {
      degreeError.value = 'Degree is required';
      isValid = false;
    }

    // Only validate license for psychiatrists
    if (selectedProfession.value == SpecialistType.psychiatrist) {
      if (license.trim().isEmpty) {
        licenseError.value = 'License number is required';
        isValid = false;
      }
    }

    if (bio.trim().isEmpty) {
      bioError.value = 'Bio is required';
      isValid = false;
    }

    return isValid;
  }

  bool validateStep4() {
    bool isValid = true;

    // Age groups validation - at least one must be selected
    if (selectedAgeGroups.isEmpty) {
      ageGroupError.value = 'Please select at least one age group';
      isValid = false;
    }

    // Areas of expertise validation - at least one must be selected
    if (selectedAreasOfExpertise.isEmpty) {
      expertiseError.value = 'Please select at least one area of expertise';
      isValid = false;
    }

    return isValid;
  }

  bool validateSpecialistSignUpForm([BuildContext? context]) {
    clearAllErrors();
    bool isValid = true;

    final nameValue = nameTextEditingController.text.trim();
    final emailValue = emailTextEditingController.text.trim();
    final phoneValue = phoneTextEditingController.text.trim();
    final experienceValue = experienceTextEditingController.text.trim();
    final licenseValue = licenseTextEditingController.text.trim();
    final passwordValue = passwordTextEditingController.text.trim();
    final confirmPasswordValue =
        confirmPasswordTextEditingController.text.trim();

    // Validate name field
    if (nameValue.isEmpty) {
      nameError.value = "Full name is required";
      isValid = false;
    } else {
      final nameValidation = InputValidator.validateName(nameValue);
      if (nameValidation != null) {
        nameError.value = nameValidation;
        isValid = false;
      }
    }

    // Validate email field
    if (emailValue.isEmpty) {
      emailError.value = "Email is required";
      isValid = false;
    } else {
      final emailValidation = InputValidator.validateEmail(emailValue);
      if (emailValidation != null) {
        emailError.value = emailValidation;
        isValid = false;
      }
    }

    // Validate phone field (if provided)
    if (phoneValue.isNotEmpty) {
      final phoneValidation = InputValidator.validatePhone(phoneValue);
      if (phoneValidation != null) {
        phoneError.value = phoneValidation;
        isValid = false;
      }
    }

    // Validate experience field
    if (experienceValue.isEmpty) {
      experienceError.value = "Experience is required";
      isValid = false;
    }

    // Validate profession selection
    if (selectedProfession.value == null) {
      professionError.value = "Please select a profession";
      isValid = false;
    }

    // Validate license number
    if (licenseValue.isEmpty) {
      licenseError.value = "License number is required";
      isValid = false;
    }

    // Validate password field
    if (passwordValue.isEmpty) {
      passwordError.value = "Password is required";
      isValid = false;
    } else {
      final passwordValidation = InputValidator.validatePassword(passwordValue);
      if (passwordValidation != null) {
        passwordError.value = passwordValidation;
        isValid = false;
      }
    }

    // Validate confirm password field
    if (confirmPasswordValue.isEmpty) {
      confirmPasswordError.value = "Confirm password is required";
      isValid = false;
    } else if (passwordValue != confirmPasswordValue) {
      confirmPasswordError.value = "Passwords do not match";
      isValid = false;
    }

    return isValid;
  }

  // ==================== ERROR HANDLING METHODS ====================
  void clearAllErrors() {
    nameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    experienceError.value = null;
    degreeError.value = null;
    licenseError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    profileImageError.value = null;
    professionError.value = null;
    dayError.value = null;
    monthError.value = null;
    yearError.value = null;
    ageGroupError.value = null;
    expertiseError.value = null;
    signupErrorMessage.value = null;
  }

  void clearFieldError(String fieldName) {
    switch (fieldName) {
      case 'name':
        nameError.value = null;
        break;
      case 'email':
        emailError.value = null;
        break;
      case 'phone':
        phoneError.value = null;
        break;
      case 'password':
        passwordError.value = null;
        break;
      case 'confirmPassword':
        confirmPasswordError.value = null;
        break;
      case 'day':
        dayError.value = null;
        break;
      case 'month':
        monthError.value = null;
        break;
      case 'year':
        yearError.value = null;
        break;
      case 'profession':
        professionError.value = null;
        break;
      case 'experience':
        experienceError.value = null;
        break;
      case 'degree':
        degreeError.value = null;
        break;
      case 'license':
        licenseError.value = null;
        break;
      case 'ageGroup':
        ageGroupError.value = null;
        break;
      case 'expertise':
        expertiseError.value = null;
      case 'bio':
        bioError.value = null;
        break;
    }
  }

  void clearNameError() => nameError.value = null;
  void clearEmailError() => emailError.value = null;
  void clearPhoneError() => phoneError.value = null;
  void clearExperienceError() => experienceError.value = null;
  void clearDegreeError() => degreeError.value = null;
  void clearLicenseError() => licenseError.value = null;
  void clearPasswordError() => passwordError.value = null;
  void clearConfirmPasswordError() => confirmPasswordError.value = null;
  void clearProfileImageError() => profileImageError.value = null;
  void clearProfessionError() => professionError.value = null;

  void clearSignupError() {
    signupErrorMessage.value = null;
    signupSuccess.value = false;
  }

  // ==================== UI INTERACTION METHODS ====================
  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImagePath.value = image.path;
        profileImageError.value = null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleLanguage(String language) {
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }
  }

  void showProfessionBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Profession',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...SpecialistType.values.map((profession) {
              String displayName = profession.toString().split('.').last;
              displayName =
                  displayName[0].toUpperCase() + displayName.substring(1);

              return ListTile(
                title: Text(displayName),
                onTap: () {
                  selectedProfession.value = profession;
                  professionController.text = displayName;
                  professionError.value = null;
                  Get.back();
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ==================== UTILITY METHODS ====================
  Future<void> reset() async {
    nameTextEditingController.clear();
    emailTextEditingController.clear();
    phoneTextEditingController.clear();
    experienceTextEditingController.clear();
    degreeTextEditingController.clear();
    licenseTextEditingController.clear();
    passwordTextEditingController.clear();
    confirmPasswordTextEditingController.clear();
    professionTextEditingController.clear();
    dayTextEditingController.clear();
    monthTextEditingController.clear();
    yearTextEditingController.clear();
    bioTextEditingController.clear();

    // Reset observables
    selectedImagePath.value = '';
    selectedLanguages.clear();
    selectedDay.value = '';
    selectedMonth.value = '';
    selectedYear.value = '';
    selectedProfession.value = null;
    selectedGender.value = '';
    currentStep.value = 0;

    clearAllErrors();
    _preselectDefaultLanguages();
  }

  void goToPreviousScreen() {
    logger.controller('Attempting to navigate to previous screen', params: {
      'canPop': Navigator.canPop(Get.context!),
    });

    // Check if we have more than 1 screen in the stack
    if (Navigator.canPop(Get.context!)) {
      logger.navigation('Multiple screens in stack - going back');
      Get.back();
    } else {
      // Only one screen in stack or cannot pop - close the app
      logger.navigation('Single screen in stack or cannot pop - closing app');
      SystemNavigator.pop();
    }
  }

  /// Check if this is a new user registration flow
  bool isNewUserFlow() {
    final arguments = Get.arguments;
    if (arguments == null) return true;

    return arguments[Arguments.navigateSpecialistSignUpToStepTwo] == null;
  }

  /// Check if this is a registered user completing profile
  bool isRegisteredUserFlow() {
    return !isNewUserFlow();
  }

  /// Get the current flow type for logging
  String getCurrentFlowType() {
    return isNewUserFlow() ? 'NEW_USER' : 'REGISTERED_USER';
  }

  /// Get minimum allowed step for current flow
  int getMinimumStep() {
    return isRegisteredUserFlow()
        ? 1
        : 0; // Step 2 (index 1) for registered, Step 1 (index 0) for new
  }

  // ==================== UTILITY METHODS ====================
  /// Calculate age from selected date of birth
  int _calculateAge() {
  if (selectedYear.value.isEmpty || selectedMonth.value.isEmpty || selectedDay.value.isEmpty) {
    return 0;
  }
  
  try {
    final dob = DateTime(
      int.parse(selectedYear.value),
      int.parse(selectedMonth.value),
      int.parse(selectedDay.value),
    );
    
    final now = DateTime.now();
    int age = now.year - dob.year;
    
    // Adjust if birthday hasn't occurred this year
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    
    return age;
  } catch (e) {
    logger.error('Error calculating age', error: e.toString());
    return 0;
  }
}

/// Build questionnaires list from form data
List<QuestionnaireItem> _buildQuestionnaires() {
  final questionnaires = <QuestionnaireItem>[];
  
  // Age group preference questionnaire
  if (selectedAgeGroups.isNotEmpty) {
    questionnaires.add(QuestionnaireItem(
      question: "What age group(s) do you prefer your clients to belong to?",
      options: ["Teen", "Adult", "Senior"],
      answer: selectedAgeGroups.toList(),
      key: "age_group_prefer",
    ));
  }
  
  // Areas of expertise questionnaire  
  if (selectedAreasOfExpertise.isNotEmpty) {
    questionnaires.add(QuestionnaireItem(
      question: "Which areas of expertise would you like to provide assistance in?",
      options: [
        "Formal Assessment and Diagnosis",
        "Addictions", 
        "Couple Counseling",
        "Child Therapy",
        "Family Therapy and Education",
        "Other Therapies"
      ],
      answer: selectedAreasOfExpertise.toList(),
      key: "help_support",
    ));
  }
  
  // Add more questionnaires as needed...
  
  return questionnaires;
}

}
