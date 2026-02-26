import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import 'package:recovery_consultation_app/app/utils/string_extensions.dart';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/admin_update_profile_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/upload_file_use_case.dart';
import 'dart:io';
import '../../app/controllers/base_controller.dart';
import '../../app/utils/input_validator.dart';
import '../../app/utils/image_url_utils.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/update_profile_use_case.dart';
import '../../domain/entity/update_profile_entity.dart';
import '../../data/api/request/update_profile_request.dart';
import '../../data/api/request/available_time_slot.dart';
import '../../data/api/request/questionnaire_item.dart';
import '../../app/config/app_enum.dart';

/// EditProfileController handles profile editing and viewing for all user types.
///
/// This controller supports FOUR distinct use cases:
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │ CASE 1: Patient Editing Their Own Profile                              │
/// ├─────────────────────────────────────────────────────────────────────────┤
/// │ Navigation: Patient → Profile Page → Edit Profile                       │
/// │ Arguments: userId = 0, openedFrom = ''                                  │
/// │ Configuration:                                                           │
/// │   - editSpecialist = false (no professional fields)                     │
/// │   - showGroupAdminEditFields = false                                    │
/// │   - showHeaderTitles = false                                            │
/// │ Fields Visible: Name, Email, Phone, Gender, DOB                         │
/// │ Action Button: Save Changes                                             │
/// └─────────────────────────────────────────────────────────────────────────┘
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │ CASE 2: Admin Editing Their Own Profile                                │
/// ├─────────────────────────────────────────────────────────────────────────┤
/// │ Navigation: Admin → Profile Page → Edit Profile                         │
/// │ Arguments: userId = 0, openedFrom = ''                                  │
/// │ Configuration:                                                           │
/// │   - editSpecialist = false (admin has no professional fields)           │
/// │   - showGroupAdminEditFields = false                                    │
/// │   - showHeaderTitles = false                                            │
/// │ Fields Visible: Name, Email, Phone (NO Gender/DOB for admin)            │
/// │ Action Button: Save Changes                                             │
/// └─────────────────────────────────────────────────────────────────────────┘
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │ CASE 3: Specialist Editing Their Own Profile                           │
/// ├─────────────────────────────────────────────────────────────────────────┤
/// │ Navigation: Specialist → Profile Page → Edit Profile                    │
/// │ Arguments: userId = 0, openedFrom = ''                                  │
/// │ Configuration:                                                           │
/// │   - editSpecialist = true (show all professional fields)                │
/// │   - showGroupAdminEditFields = true (can edit schedule)                 │
/// │   - showHeaderTitles = false                                            │
/// │ Fields Visible: Name, Email, Phone, Gender, DOB, Languages, Profession, │
/// │                 Experience, Degree, License, Bio, Commission,           │
/// │                 Age Groups, Areas of Expertise, Schedule                │
/// │ Action Button: Save Changes                                             │
/// └─────────────────────────────────────────────────────────────────────────┘
///
/// ┌─────────────────────────────────────────────────────────────────────────┐
/// │ CASE 4: Admin Viewing Specialist for Approval                          │
/// ├─────────────────────────────────────────────────────────────────────────┤
/// │ Navigation: Admin → Specialist Approval → View Profile                  │
/// │ Arguments: userId = 12, openedFrom = AppRoutes.specialistApproval       │
/// │ Configuration:                                                           │
/// │   - editSpecialist = true (show all specialist fields)                  │
/// │   - showGroupAdminEditFields = false (admin can't edit schedule)        │
/// │   - openFromApproval = true (show approve/reject buttons)               │
/// │   - showHeaderTitles = true                                             │
/// │ Fields Visible: Name, Email, Phone, Gender, DOB, Languages, Profession, │
/// │                 Experience, Degree, License, Bio, Commission,           │
/// │                 Age Groups, Areas of Expertise (READ-ONLY)              │
/// │ Action Buttons: Approve / Reject                                        │
/// └─────────────────────────────────────────────────────────────────────────┘
///
/// Key Controller Flags:
/// - editSpecialist: Controls visibility of professional information section
/// - showGroupAdminEditFields: Controls visibility of schedule section
/// - openFromApproval: Controls whether to show Approve/Reject buttons
/// - showHeaderTitles: Controls header layout (back button + title vs simple)
///
class EditProfileController extends BaseController {
  EditProfileController(
      {required this.getUserUseCase,
      required this.updateProfileUseCase,
      required this.getSpecialistByIdUseCase,
      required this.uploadFileUseCase,
      required this.adminUpdateProfileUseCase});

  // ==================== DEPENDENCIES ====================
  final GetUserUseCase getUserUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetUserDetailByIdUseCase getSpecialistByIdUseCase;
  final UploadFileUseCase uploadFileUseCase;
  final AdminUpdateProfileUseCase adminUpdateProfileUseCase;
  final ImagePicker _imagePicker = ImagePicker();

  // ==================== Reciever from route arguments ====================
  RxString openedFrom = ''.obs;
  RxInt userId = 0.obs;

  // ==================== CONTROLLERS & OBSERVABLES ====================
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController genderTextEditingController =
      TextEditingController();
  final TextEditingController dobTextEditingController =
      TextEditingController();

  // Date picker controllers
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  // Professional field controllers
  final TextEditingController professionController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController degreeController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

// Observable error states for reactive UI
  var pageTitle = 'Edit Profile'.obs;
  final userEntity = Rxn<UserEntity>();
  final uploadFileEntity = Rxn<FileEntity>();

  // Observable error states for reactive UI
  var nameError = RxnString();
  var emailError = RxnString();
  var phoneError = RxnString();
  var genderError = RxnString();
  var dobError = RxnString();

  // Professional field error states
  var professionError = RxnString();
  var experienceError = RxnString();
  var degreeError = RxnString();
  var licenseError = RxnString();
  var bioError = RxnString();

  // Professional field selections
  var selectedLanguages = <String>[].obs;
  var selectedProfession = Rx<SpecialistType?>(null);

  // Age group and expertise selections
  var selectedAgeGroups = <AgeGroup>[].obs;
  var selectedAreasOfExpertise = <AreaOfExpertise>[].obs;

  // Age group and expertise error states
  var ageGroupError = RxnString();
  var expertiseError = RxnString();

  // Commission fields
  final TextEditingController commissionValueController =
      TextEditingController();
  var selectedCommissionType = 'Percentage'.obs;
  var commissionError = RxnString();

  // Available commission types
  List<String> get availableCommissionTypes => [
        'Percentage',
        'Flat',
      ];

  // Schedule fields - Map of day to list of time slots
  var scheduleData = <String, List<String>>{}.obs;
  var scheduleError = RxnString();

  // Session duration and day availability
  var sessionDuration = '30 min'.obs;
  var selectedDays = <String>[].obs;
  var dayStartTimes = <String, String>{}.obs;
  var dayEndTimes = <String, String>{}.obs;

  // Available days for scheduling
  List<String> get availableDays => [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

  // Available options for professional fields
  List<String> get availableLanguages =>
      ['English', 'Urdu', 'Pashto', 'Punjabi', 'Siraiki', 'Sindhi', 'Balochi'];

  List<SpecialistType> get availableProfessions => [
        SpecialistType.therapist,
        SpecialistType.psychiatrist,
      ];

  List<AgeGroup> get availableAgeGroups => [
        AgeGroup.teen,
        AgeGroup.adult,
        AgeGroup.senior,
      ];

  List<AreaOfExpertise> get availableAreasOfExpertise => [
        AreaOfExpertise.formalAssessmentAndDiagnosis,
        AreaOfExpertise.addictions,
        AreaOfExpertise.coupleCounseling,
        AreaOfExpertise.childTherapy,
        AreaOfExpertise.familyTherapyAndEducation,
        AreaOfExpertise.otherTherapies,
      ];

  // State observables for UI reactions
  var isSaving = false.obs;
  var profileImageUrl = ''.obs;
  var selectedImageFile = Rxn<File>(); // For storing selected image file

  // Date picker observables
  var selectedDay = ''.obs;
  var selectedMonth = ''.obs;
  var selectedYear = ''.obs;

  // Gender selection observable
  var selectedGender = ''.obs;

  // ==================== GETTERS ====================
  String get name => nameTextEditingController.text;
  String get email => emailTextEditingController.text;
  String get phone => phoneTextEditingController.text;
  String get gender => genderTextEditingController.text;
  String get dateOfBirth => dobTextEditingController.text;

  // Professional field getters
  String get profession => professionController.text;
  String get experience => experienceController.text;
  String get degree => degreeController.text;
  String get license => licenseController.text;
  String get bio => bioController.text;

  // Commission field getter
  String get commissionValue => commissionValueController.text;

  // Conditional display logic - Observable for reactive UI updates
  var openFromApproval = false.obs;
  var editSpecialist = false.obs;
  var showHeaderTitles = false.obs;
  var showGroupAdminEditFields = true.obs;
  var showScheduleSection = false.obs; // Show schedule section (view or edit)
  var canEditSchedule = false.obs; // Can add/remove time slots (admin only)
  var canEditProfessionalFields = false.obs; // Can edit professional fields (languages, profession, etc.)

  int get getUserId => userId.value;

  //Getter
  UserEntity? get user => userEntity.value;
  FileEntity? get uploadFile => uploadFileEntity.value;

  // ==================== HELPER METHODS ====================
  String getProfessionDisplayName(SpecialistType profession) {
    switch (profession) {
      case SpecialistType.therapist:
        return 'Therapist';
      case SpecialistType.psychiatrist:
        return 'Psychiatrist';
    }
  }

  String getAgeGroupDisplayName(AgeGroup ageGroup) {
    switch (ageGroup) {
      case AgeGroup.teen:
        return 'Teenagers (13-17 years)';
      case AgeGroup.adult:
        return 'Adults (18-64 years)';
      case AgeGroup.senior:
        return 'Seniors (65+ years)';
    }
  }

  String getAreaOfExpertiseDisplayName(AreaOfExpertise expertise) {
    switch (expertise) {
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

  // Schedule management methods
  void addTimeSlot(String day, String timeSlot) {
    if (!scheduleData.containsKey(day)) {
      scheduleData[day] = [];
    }
    if (!scheduleData[day]!.contains(timeSlot)) {
      scheduleData[day]!.add(timeSlot);
      scheduleData.refresh(); // Refresh the observable
    }
  }

  void removeTimeSlot(String day, String timeSlot) {
    if (scheduleData.containsKey(day)) {
      scheduleData[day]!.remove(timeSlot);
      if (scheduleData[day]!.isEmpty) {
        scheduleData.remove(day);
      }
      scheduleData.refresh(); // Refresh the observable
    }
  }

  List<String> getTimeSlotsForDay(String day) {
    return scheduleData[day] ?? [];
  }

  bool hasScheduleForDay(String day) {
    return scheduleData.containsKey(day) && scheduleData[day]!.isNotEmpty;
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
      case 'gender':
        genderError.value = null;
        break;
      case 'dob':
        dobError.value = null;
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
      case 'bio':
        bioError.value = null;
        break;
      case 'ageGroup':
        ageGroupError.value = null;
        break;
      case 'expertise':
        expertiseError.value = null;
        break;
      case 'commission':
        commissionError.value = null;
        break;
      case 'schedule':
        scheduleError.value = null;
        break;
    }
  }

  RoleManager roleManager = RoleManager.instance;

  @override
  void onInit() {
    super.onInit();
    logger.controller('==================== onInit START ====================');

    final args = Get.arguments as Map<String, dynamic>?;
    logger.controller('Get.arguments: $args');

    if (args != null && args.containsKey(Arguments.userId)) {
      userId.value = args[Arguments.userId];
      logger.controller('userId set from arguments: ${userId.value}');
    } else {
      logger.controller(
          'No userId in arguments, userId remains: ${userId.value}');
    }

    if (args != null && args.containsKey(Arguments.openedFrom)) {
      openedFrom.value = args[Arguments.openedFrom];
      logger.controller('openedFrom set from arguments: ${openedFrom.value}');
    } else {
      logger.controller(
          'No openedFrom in arguments, openedFrom remains: ${openedFrom.value}');
    }

    logger.controller(
        'Final values - userId: ${userId.value}, openedFrom: ${openedFrom.value}');
    logger.controller('==================== onInit END ====================');
  }

  @override
  void onReady() {
    super.onReady();
    // Load profile data after page is fully ready and listeners are set up
    _initializeProfile();
  }

  void _initializeProfile() {
    logger.controller(
        '==================== _initializeProfile START ====================');
    logger.controller('userId.value: ${userId.value}');
    logger.controller('openedFrom.value: ${openedFrom.value}');
    logger.controller('roleManager.isSpecialist: ${roleManager.isSpecialist}');
    logger.controller('roleManager.isAdmin: ${roleManager.isAdmin}');
    logger.controller('roleManager.isPatient: ${roleManager.isPatient}');

    // Determine which case we're in and configure accordingly
    if (userId.value == 0) {
      // User is editing their own profile
      _handleOwnProfileEdit();
    } else {
      // Admin/User is viewing another user's profile
      _handleViewingAnotherProfile();
    }

    logger.controller(
        '==================== _initializeProfile END ====================');
  }

  /// Case 1: Patient editing their own profile
  /// Case 2: Admin editing their own profile
  /// Case 3: Specialist editing their own profile
  void _handleOwnProfileEdit() {
    logger.controller('--- CASE: User Editing Own Profile ---');

    pageTitle.value = 'Edit Profile';
    showHeaderTitles.value = false; // No header titles for own profile

    // Determine field visibility based on user role
    if (roleManager.isSpecialist) {
      logger.controller('User Role: Specialist');
      editSpecialist.value = true; // Show professional fields
      canEditProfessionalFields.value = false; // Specialist CANNOT edit professional fields (read-only)
      showGroupAdminEditFields.value =
          false; // Hide commission fields for specialist
      showScheduleSection.value = true; // Show schedule section (view only)
      canEditSchedule.value = false; // Specialist cannot edit schedule
    } else if (roleManager.isPatient) {
      logger.controller('User Role: Patient');
      editSpecialist.value = false; // Hide professional fields
      showGroupAdminEditFields.value = false;
      showScheduleSection.value = false; // No schedule for patient
      canEditSchedule.value = false;
    } else if (roleManager.isAdmin) {
      logger.controller('User Role: Admin');
      editSpecialist.value = false; // Admin has no professional fields
      showGroupAdminEditFields.value = false;
      showScheduleSection.value = false; // No schedule for admin
      canEditSchedule.value = false;
    }

    logger.controller('editSpecialist: ${editSpecialist.value}');
    logger.controller(
        'showGroupAdminEditFields: ${showGroupAdminEditFields.value}');

    _loadUserProfile();
  }

  /// Case 4: Admin viewing/approving specialist profile from approval page
  /// Case 5: Admin viewing specialist profile from specialist detail page
  /// Case 6: Admin viewing patient profile
  void _handleViewingAnotherProfile() {
    logger.controller('--- CASE: Viewing Another User Profile ---');
    logger.controller('Target userId: ${userId.value}');

    showHeaderTitles.value = true; // Show header with back button and title

    switch (openedFrom.value) {
      case AppRoutes.specialistApproval:
        logger.controller('Context: Specialist Approval Page');
        pageTitle.value = 'Specialist Profile';
        editSpecialist.value = true; // Show all specialist professional fields
        canEditProfessionalFields.value = true; // Admin CAN edit professional fields
        openFromApproval.value = true; // Show Approve/Reject buttons
        showGroupAdminEditFields.value = true; // Show commission fields
        showScheduleSection.value = true; // Show schedule section
        canEditSchedule.value = true; // Admin can edit specialist schedule
        logger.controller(
            'editSpecialist: true (viewing specialist for approval)');
        logger
            .controller('openFromApproval: true (show approve/reject buttons)');
        _loadSpecialistDetails(); // Load specialist data from API
        break;

      case AppRoutes.specialistView:
        logger.controller('Context: Specialist View Profile Page');
        pageTitle.value = 'Specialist Profile';
        editSpecialist.value = true; // Show all specialist professional fields
        canEditProfessionalFields.value = roleManager.isAdmin; // Admin can edit, patient cannot
        openFromApproval.value = false; // No approve/reject buttons
        showGroupAdminEditFields.value = false; // Hide commission fields
        showScheduleSection.value = true; // Show schedule section
        if (roleManager.isAdmin) {
          canEditSchedule.value =
              true; // Admin viewing specialist, no editing
        } else {
          canEditSchedule.value = false; // Patient viewing specialist, no edit
        }
        logger.controller('editSpecialist: true (viewing specialist details)');
        logger.controller('openFromApproval: false (read-only view)');
        _loadSpecialistDetails();
        break;

      default:
        logger.controller('Context: Patient Profile View (default case)');
        pageTitle.value = 'Patient Profile';
        editSpecialist.value = false; // Patient has no professional fields
        openFromApproval.value = false;
        showGroupAdminEditFields.value = false;
        logger.controller('editSpecialist: false (patient profile)');
        _loadSpecialistDetails(); // Generic load for patient
    }
  }

  @override
  void onClose() {
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    phoneTextEditingController.dispose();
    genderTextEditingController.dispose();
    dobTextEditingController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();

    // Dispose professional field controllers
    professionController.dispose();
    experienceController.dispose();
    degreeController.dispose();
    licenseController.dispose();
    bioController.dispose();

    // Dispose commission field controller
    commissionValueController.dispose();

    super.onClose();
  }

  // ==================== METHODS ====================
  Future<void> _loadUserProfile() async {
    logger.controller('Loading user profile');

    final result = await executeApiCall<UserEntity>(
      () async {
        return await getUserUseCase.execute();
      },
      onSuccess: () {
        logger.controller('Successfully loaded user profile');
      },
      onError: (errorMessage) {
        logger.error('Error loading user profile: $errorMessage');
        _setDefaultUserData();
      },
    );

    if (result != null) {
      _populateFormWithUserData(result);
      userEntity.value = result;
    } else {
      _setDefaultUserData();
    }
  }

  Future<void> _loadSpecialistDetails() async {
    if (userId.value == 0) {
      logger.error('No specialist ID provided');
      _showErrorSnackbar('Error', 'Specialist ID is required');
      return;
    }

    logger
        .controller('Loading specialist details for user ID: ${userId.value}');

    final result = await executeApiCall<UserEntity>(
      () async {
        logger.controller(
            'Calling getSpecialistByIdUseCase.execute(${userId.value})');
        final userData = await getSpecialistByIdUseCase.execute(userId.value);
        logger.controller(
            'getSpecialistByIdUseCase returned: ${userData != null ? "UserEntity" : "null"}');
        return userData;
      },
      onSuccess: () {
        logger.controller('✅ Successfully loaded specialist profile');
      },
      onError: (errorMessage) {
        logger.error('❌ Error loading specialist profile: $errorMessage');
      },
    );

    logger.controller(
        'After executeApiCall - result is: ${result != null ? "NOT null" : "NULL"}');

    if (result != null) {
      userEntity.value = result;
      logger.controller(
          'UserEntity set - Name: ${result.name}, Email: ${result.email}');
      logger.controller('Doctor Info available: ${result.doctorInfo != null}');
      if (result.doctorInfo != null) {
        logger
            .controller('Specialization: ${result.doctorInfo!.specialization}');
        logger.controller('Experience: ${result.doctorInfo!.experience}');
        logger.controller('Degree: ${result.doctorInfo!.degree}');
      }

      _populateFormWithUserData(result);
      logger.controller('Form populated for specialist: ${result.name}');
    } else {
      logger.warning('No specialist data found - result is null');
      _setDefaultUserData();
    }
  }

  /// Populate form fields with user data from API
  void _populateFormWithUserData(UserEntity userEntity) {
    final user = userEntity;
    logger.controller('Starting to populate form fields');

    nameTextEditingController.text = user.name;
    emailTextEditingController.text = user.email;
    phoneTextEditingController.text = user.phone ?? '';

    logger.controller(
        'Set basic fields - Name: ${user.name}, Email: ${user.email}, Phone: ${user.phone}');

    // Convert relative image URL to full URL
    profileImageUrl.value = ImageUrlUtils().getFullImageUrl(user.imageUrl);

    // Get gender and other info from patientInfo if available
    if (user.patientInfo != null) {
      genderTextEditingController.text = user.patientInfo!.gender ?? '';
      dobTextEditingController.text = user.patientInfo!.dob ?? '';

      // Set gender observable
      selectedGender.value = user.patientInfo!.gender ?? '';

      // Parse and set date components if available
      if (user.patientInfo!.dob != null && user.patientInfo!.dob!.isNotEmpty) {
        _parseDateOfBirth(user.patientInfo!.dob!);
      }
    } else if (user.doctorInfo != null) {
      logger.controller('Populating doctor info fields');

      genderTextEditingController.text = user.doctorInfo!.gender ?? '';
      dobTextEditingController.text = user.doctorInfo!.dob ?? '';

      // Set gender observable
      selectedGender.value = user.doctorInfo!.gender ?? '';

      //Set Selected Languages
      selectedLanguages.value =
          user.languages?.map((lang) => lang.language).toList() ?? [];
      logger.controller('Languages set: ${selectedLanguages.length} languages');

      //Set Profession
      if (user.doctorInfo!.specialization != null) {
        final spec = availableProfessions.firstWhere(
            (prof) =>
                getProfessionDisplayName(prof).toLowerCase() ==
                user.doctorInfo!.specialization!.toLowerCase(),
            orElse: () => SpecialistType.therapist);
        selectedProfession.value = spec;
        professionController.text = getProfessionDisplayName(spec);
        logger
            .controller('Profession set to: ${getProfessionDisplayName(spec)}');
      }

      //Set Experience
      experienceController.text = user.doctorInfo!.experience?.toString() ?? '';
      logger.controller('Experience set to: ${experienceController.text}');

      //Set Degree
      degreeController.text = user.doctorInfo!.degree ?? '';
      logger.controller('Degree set to: ${degreeController.text}');

      //Set License
      licenseController.text = user.doctorInfo!.licenseNo ?? '';
      logger.controller('License set to: ${licenseController.text}');

      //Set Bio
      // bioController.text = user.doctorInfo!.bio ?? '';

      //Set Commission
      selectedCommissionType.value =
          user.doctorInfo!.commissionType?.capitalizeFirstOnly() ??
              'Percentage (%)';
      commissionValueController.text =
          user.doctorInfo?.commissionValue?.toString() ?? '';

      //set Age Groups and Areas of Expertise if available
      if (user.questionnaires != null && user.questionnaires!.isNotEmpty) {
        for (final questionnaire in user.questionnaires!) {
          final key = questionnaire.key?.toLowerCase() ?? '';

          if (key.contains('age_group_prefer')) {
            final answers = questionnaire.answers;

            if (answers.isNotEmpty) {
              selectedAgeGroups.value = availableAgeGroups.where((ageGroup) {
                final displayName =
                    getAgeGroupDisplayName(ageGroup).toLowerCase();
                return answers
                    .any((a) => displayName.contains(a.toLowerCase().trim()));
              }).toList();
            }
          } else if (key.contains('help_support')) {
            final answers = questionnaire.answers;

            if (answers.isNotEmpty) {
              selectedAreasOfExpertise.value =
                  availableAreasOfExpertise.where((expertise) {
                final displayName = getAreaOfExpertiseDisplayName(expertise)
                    .toLowerCase()
                    .trim();

                return answers.any((a) {
                  final normalizedAnswer = a.toLowerCase().trim();
                  return displayName == normalizedAnswer ||
                      displayName.contains(normalizedAnswer);
                });
              }).toList();
            }
          }
        }
      }

      // Parse and set date components if available
      if (user.doctorInfo!.dob != null && user.doctorInfo!.dob!.isNotEmpty) {
        _parseDateOfBirth(user.doctorInfo!.dob!);
      }

      // Populate schedule data from availableTimes
      logger.controller(
          'Checking availableTimes: isNull=${user.availableTimes == null}, isEmpty=${user.availableTimes?.isEmpty ?? true}, count=${user.availableTimes?.length ?? 0}');

      if (user.availableTimes != null && user.availableTimes!.isNotEmpty) {
        logger.controller(
            'Populating schedule data from ${user.availableTimes!.length} available times');

        // Print raw available times data from API
        for (int i = 0; i < user.availableTimes!.length; i++) {
          final availableTime = user.availableTimes![i];
          logger.controller(
              'AvailableTime[$i]: id=${availableTime.id}, weekday=${availableTime.weekday}, startTime=${availableTime.startTime}, endTime=${availableTime.endTime}, sessionDuration=${availableTime.sessionDuration}, status=${availableTime.status}');
        }

        scheduleData.clear();

        for (final availableTime in user.availableTimes!) {
          if (availableTime.weekday != null &&
              availableTime.startTime != null &&
              availableTime.endTime != null) {
            // Normalize day name to full format (Mon -> Monday, mon -> Monday, etc.)
            final day = _normalizeDayName(availableTime.weekday!);

            logger.controller(
                'API weekday: "${availableTime.weekday}" normalized to: "$day"');

            // Convert 24-hour format to 12-hour format for display
            final startTime12 =
                _convertTo12HourFormat(availableTime.startTime!);
            final endTime12 = _convertTo12HourFormat(availableTime.endTime!);
            final timeSlot = '$startTime12 - $endTime12';

            if (!scheduleData.containsKey(day)) {
              scheduleData[day] = [];
            }

            if (!scheduleData[day]!.contains(timeSlot)) {
              scheduleData[day]!.add(timeSlot);
            }
          }
        }

        scheduleData.refresh();
        logger.controller(
            'Schedule data populated with ${scheduleData.length} days');
        logger.controller('Full schedule data: ${scheduleData.toString()}');

        // Print each day's schedule
        scheduleData.forEach((day, timeSlots) {
          logger.controller('$day: ${timeSlots.join(", ")}');
        });
      } else {
        logger.warning(
            'No available times found in API response - availableTimes is ${user.availableTimes == null ? "null" : "empty"}');
      }
    } else {
      // Set default values if no patient info
      genderTextEditingController.text = '';
      dobTextEditingController.text = '';
      selectedGender.value = '';
    }

    logger.controller('Populated form with user data: ${user.name}');
  }

  /// Helper method to capitalize first letter of a string
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Normalize day name to full format (e.g., "mon" -> "Monday", "monday" -> "Monday")
  String _normalizeDayName(String dayName) {
    String lowerDay = dayName.toLowerCase().trim();

    // Map of abbreviated and full day names to standardized full names
    Map<String, String> dayMap = {
      'mon': 'Monday',
      'monday': 'Monday',
      'tue': 'Tuesday',
      'tuesday': 'Tuesday',
      'wed': 'Wednesday',
      'wednesday': 'Wednesday',
      'thu': 'Thursday',
      'thursday': 'Thursday',
      'fri': 'Friday',
      'friday': 'Friday',
      'sat': 'Saturday',
      'saturday': 'Saturday',
      'sun': 'Sunday',
      'sunday': 'Sunday',
    };

    return dayMap[lowerDay] ?? _capitalizeFirstLetter(dayName);
  }

  /// Convert 24-hour time format to 12-hour format
  /// Example: "14:00:00" -> "2:00 PM", "09:30:00" -> "9:30 AM"
  String _convertTo12HourFormat(String time24) {
    try {
      // Remove seconds if present (e.g., "14:00:00" -> "14:00")
      String timePart = time24.split(':').take(2).join(':');

      // Split hours and minutes
      List<String> parts = timePart.split(':');
      if (parts.length != 2)
        return time24; // Return original if format is unexpected

      int hour = int.parse(parts[0]);
      String minute = parts[1];

      // Determine AM/PM
      String period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      if (hour == 0) {
        hour = 12; // Midnight case
      } else if (hour > 12) {
        hour = hour - 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      logger.error('Error converting time format: $e');
      return time24; // Return original time if conversion fails
    }
  }

  /// Convert 12-hour time format to 24-hour format for API
  /// Example: "2:00 PM" -> "14:00", "9:30 AM" -> "09:30"
  String _convertTo24HourFormat(String time12) {
    try {
      // Parse the time string (e.g., "2:00 PM")
      String timePart = time12.trim();

      // Extract AM/PM
      bool isPM = timePart.toUpperCase().contains('PM');

      // Remove AM/PM and trim
      String cleanTime = timePart
          .replaceAll(RegExp(r'[AP]M', caseSensitive: false), '')
          .trim();

      // Split hours and minutes
      List<String> parts = cleanTime.split(':');
      if (parts.length != 2)
        return time12; // Return original if format is unexpected

      int hour = int.parse(parts[0]);
      String minute = parts[1];

      // Convert to 24-hour format
      if (isPM && hour != 12) {
        hour += 12;
      } else if (!isPM && hour == 12) {
        hour = 0; // Midnight case
      }

      return '${hour.toString().padLeft(2, '0')}:$minute';
    } catch (e) {
      logger.error('Error converting time format: $e');
      return time12; // Return original time if conversion fails
    }
  }

  /// Convert schedule data to AvailableTimeSlot list for API
  List<AvailableTimeSlot> _buildAvailableTimesFromSchedule(
      String sessionDuration) {
    List<AvailableTimeSlot> availableTimes = [];

    scheduleData.forEach((day, timeSlots) {
      if (timeSlots.isNotEmpty) {
        // Parse the first time slot (format: "10:00 AM - 2:00 PM")
        String firstTimeSlot = timeSlots.first;
        List<String> times = firstTimeSlot.split(' - ');

        if (times.length == 2) {
          String startTime12 = times[0].trim();
          String endTime12 = times[1].trim();

          // Convert to 24-hour format with seconds
          String startTime24 = _convertTo24HourFormat(startTime12);
          String endTime24 = _convertTo24HourFormat(endTime12);

          // Add seconds if not present (API expects "HH:MM:SS" format)
          if (!startTime24.contains(':00', startTime24.length - 3)) {
            startTime24 = '$startTime24:00';
          }
          if (!endTime24.contains(':00', endTime24.length - 3)) {
            endTime24 = '$endTime24:00';
          }

          // Convert full day name to abbreviated format for API (Monday -> Mon)
          String abbreviatedDay = _abbreviateDayName(day);

          availableTimes.add(AvailableTimeSlot(
            weekday: abbreviatedDay,
            sessionDuration: sessionDuration,
            status: 'available',
            startTime: startTime24,
            endTime: endTime24,
          ));
        }
      }
    });

    return availableTimes;
  }

  /// Convert full day name to abbreviated format for API
  /// Example: "Monday" -> "Mon", "Tuesday" -> "Tue"
  String _abbreviateDayName(String fullDay) {
    Map<String, String> abbreviations = {
      'Monday': 'Mon',
      'Tuesday': 'Tue',
      'Wednesday': 'Wed',
      'Thursday': 'Thu',
      'Friday': 'Fri',
      'Saturday': 'Sat',
      'Sunday': 'Sun',
    };

    return abbreviations[fullDay] ?? fullDay.substring(0, 3);
  }

  /// Parse date of birth string and set individual components
  void _parseDateOfBirth(String dateOfBirth) {
    try {
      // Handle different date formats
      if (dateOfBirth.contains('/')) {
        // Format: DD/MM/YYYY
        List<String> parts = dateOfBirth.split('/');
        if (parts.length == 3) {
          // Pad day and month with leading zeros to match dropdown format
          selectedDay.value = parts[0].padLeft(2, '0');
          selectedMonth.value = parts[1].padLeft(2, '0');
          selectedYear.value = parts[2];

          // Update the controllers
          dayController.text = selectedDay.value;
          monthController.text = selectedMonth.value;
          yearController.text = selectedYear.value;
        }
      } else if (dateOfBirth.contains('-')) {
        // Format: YYYY-DD-MM (API format) or DD-MM-YYYY
        List<String> parts = dateOfBirth.split('-');
        if (parts.length == 3) {
          if (parts[0].length == 4) {
            // YYYY-DD-MM format (API format)
            // Pad day and month with leading zeros to match dropdown format
            selectedYear.value = parts[0];
            selectedDay.value = parts[1].padLeft(2, '0');
            selectedMonth.value = parts[2].padLeft(2, '0');

            dayController.text = selectedDay.value;
            monthController.text = selectedMonth.value;
            yearController.text = selectedYear.value;
          } else {
            // DD-MM-YYYY format
            // Pad day and month with leading zeros to match dropdown format
            selectedDay.value = parts[0].padLeft(2, '0');
            selectedMonth.value = parts[1].padLeft(2, '0');
            selectedYear.value = parts[2];

            dayController.text = selectedDay.value;
            monthController.text = selectedMonth.value;
            yearController.text = selectedYear.value;
          }
        }
      } else {
        logger.warning('Unknown date format: $dateOfBirth');
      }
    } catch (e) {
      logger.error('Error parsing date: $e');
    }
  }

  /// Set default user data if API fails or returns no data
  void _setDefaultUserData() {
    // Pre-fill with default/placeholder data
    nameTextEditingController.text = '';
    emailTextEditingController.text = '';
    phoneTextEditingController.text = '';
    genderTextEditingController.text = '';
    dobTextEditingController.text = '';

    // Set initial values for observables
    selectedGender.value = '';
    selectedDay.value = '';
    selectedMonth.value = '';
    selectedYear.value = '';

    logger.controller('Set default user data');
  }

  void goBack() {
    Get.back();
  }

  /// Captures profile image using camera and uploads to server
  Future<void> onChangeProfileImage() async {
    try {
      logger.controller('Opening camera for profile image capture');

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image == null) {
        logger.controller('User cancelled image capture');
        return;
      }

      logger.controller('Profile image captured: ${image.path}');

      // Update UI with local file path
      profileImageUrl.value = image.path;
      selectedImageFile.value = File(image.path);

      // Upload file to server
      await fileUpload(selectedImageFile.value!);
    } catch (e) {
      logger.error('Error capturing profile image: $e');

      _showErrorSnackbar(
        'Error',
        'Failed to capture image. Please try again.',
      );
    }
  }

  /// Handles date of birth selection
  void onSelectDateOfBirth() {
    logger.controller('Date of birth field tapped');
    // Date picker logic is handled in the UI layer
  }

  /// Uploads profile image file to server
  Future<void> fileUpload(File file) async {
    logger.controller('Starting file upload: ${file.path}');

    final request = UploadFileParams(
      file: file,
      directory: 'profile',
    );

    final result = await executeApiCall<FileEntity?>(
      () => uploadFileUseCase.execute(request),
      onSuccess: () {
        logger.controller('File uploaded successfully');
      },
      onError: (errorMessage) {
        logger.error('Failed to upload file: $errorMessage');
      },
    );

    // Store the uploaded file entity
    if (result != null) {
      uploadFileEntity.value = result;
      logger.controller('File entity stored with ID: ${result.id}');
    }
  }

  /// Saves profile changes to the server
  Future<void> onSaveProfile() async {
    if (!_validateForm()) {
      logger.warning('Form validation failed');
      return;
    }

    logger.controller('Starting profile update');

    // Build request based on user type and available data
    final request = _buildUpdateRequest();

    logger.controller('Update request for user: ${request.name}');

    // Call the API using executeApiCall pattern
    final bool isEditingOwnProfile = userId.value == 0;

    // Admin updating another user's doctor profile should use adminUpdateProfileUseCase
    final bool useAdminUpdate = roleManager.isAdmin && !isEditingOwnProfile && editSpecialist.value;

    if (useAdminUpdate) {
      final result = await executeApiCall<UserEntity?>(
        () => adminUpdateProfileUseCase.execute(request),
        onSuccess: () {
          logger.controller('Admin update (doctor) succeeded');
          // _showSuccessSnackbar('Profile', 'Updated successfully');
        },
        onError: (errorMessage) {
          logger.error('Failed to update profile (admin doctor): $errorMessage');
        },
      );

      if (result != null) {
        Get.back();
      }
    } else {
      // Regular update flow (own profile or admin updating patient or non-doctor)
      final result = await executeApiCall<UpdateProfileEntity?>(
        () => updateProfileUseCase.execute(request),
        onSuccess: () {
          logger.controller('Profile updated successfully');
          // _showSuccessSnackbar('Profile', 'Updated successfully');
        },
        onError: (errorMessage) {
          logger.error('Failed to update profile: $errorMessage');
        },
      );

      if (result != null) {
        Get.back();
      }
    }

    // Navigation handled per-flow above when update succeeds
  }

  /// Builds update request based on user type and editing context
  /// Handles three scenarios:
  /// 1. User editing their own profile (userId == 0)
  /// 2. Admin editing another user's profile (userId != 0)
  /// 3. User editing a specialist/doctor profile
  UpdateProfileRequest _buildUpdateRequest() {
    final isDoctor = user?.doctorInfo != null;
    final isPatient = user?.patientInfo != null;
    final isEditingOwnProfile = userId.value == 0;

    // If admin is editing a specialist/doctor profile (userId != 0 and editSpecialist == true)
    if (editSpecialist.value && !isEditingOwnProfile && isDoctor) {
      logger.controller('Building request for admin editing specialist profile');
      
      // Build available times from schedule if schedule data exists
      List<AvailableTimeSlot>? availableTimes;
      if (scheduleData.isNotEmpty && showGroupAdminEditFields.value) {
        // Extract session duration value (e.g., "30 min" -> "30")
        String durationValue =
            sessionDuration.value.replaceAll(' min', '').trim();
        availableTimes = _buildAvailableTimesFromSchedule(durationValue);
        logger.controller(
            'Built ${availableTimes.length} available time slots from schedule');
      }

      // Build questionnaires from selected age groups and areas of expertise
      List<QuestionnaireItem>? questionnaires = _buildQuestionnaires();

      return UpdateProfileRequest(
        userId: userId.value,
        name: nameTextEditingController.text.trim(),
        phone: phoneTextEditingController.text.trim(),
        email: emailTextEditingController.text.trim(),
        gender: selectedGender.value.isNotEmpty ? selectedGender.value : null,
        dob: _formatDateForApi(),
        age: _calculateAge(),
        fileId: uploadFile?.id,
        completed: 1,
        // Doctor-specific fields
        specialization: selectedProfession.value != null
            ? getProfessionDisplayName(selectedProfession.value!)
            : null,
        experience: experience.isNotEmpty ? int.tryParse(experience) : null,
        degree: degree.isNotEmpty ? degree : null,
        licenseNo: license.isNotEmpty ? license : null,
        bio: bio.isNotEmpty ? bio : null,
        languages: selectedLanguages.isNotEmpty ? selectedLanguages : null,
        commisionType: selectedCommissionType.value.isNotEmpty
            ? selectedCommissionType.value.toLowerCase()
            : null,
        commisionValue:
            commissionValue.trim().isNotEmpty ? commissionValue.trim() : null,
        availableTimes: availableTimes,
        questionnaires: questionnaires,
      );
    }

    // If editing own profile
    if (isEditingOwnProfile) {
      if (isDoctor) {
        // Specialist/Doctor editing their own profile
        logger.controller('Building request for specialist/doctor editing own profile');

        // Build available times from schedule if schedule data exists
        List<AvailableTimeSlot>? availableTimes;
        if (scheduleData.isNotEmpty && showGroupAdminEditFields.value) {
          // Extract session duration value (e.g., "30 min" -> "30")
          String durationValue =
              sessionDuration.value.replaceAll(' min', '').trim();
          availableTimes = _buildAvailableTimesFromSchedule(durationValue);
          logger.controller(
              'Built ${availableTimes.length} available time slots from schedule');
        }

        // Build questionnaires from selected age groups and areas of expertise
        List<QuestionnaireItem>? questionnaires = _buildQuestionnaires();

        return UpdateProfileRequest(
          name: nameTextEditingController.text.trim(),
          phone: phoneTextEditingController.text.trim(),
          email: emailTextEditingController.text.trim(),
          gender: selectedGender.value.isNotEmpty ? selectedGender.value : null,
          dob: _formatDateForApi(),
          age: _calculateAge(),
          fileId: uploadFile?.id,
          completed: 1,
          // Doctor-specific fields
          specialization: selectedProfession.value != null
              ? getProfessionDisplayName(selectedProfession.value!)
              : null,
          experience: experience.isNotEmpty ? int.tryParse(experience) : null,
          degree: degree.isNotEmpty ? degree : null,
          licenseNo: license.isNotEmpty ? license : null,
          bio: bio.isNotEmpty ? bio : null,
          languages: selectedLanguages.isNotEmpty ? selectedLanguages : null,
          commisionType: selectedCommissionType.value.isNotEmpty
              ? selectedCommissionType.value.toLowerCase()
              : null,
          commisionValue:
              commissionValue.trim().isNotEmpty ? commissionValue.trim() : null,
          availableTimes: availableTimes,
          questionnaires: questionnaires,
        );
      } else if (isPatient) {
        // Patient editing their own profile
        logger.controller('Building request for patient editing own profile');
        return UpdateProfileRequest(
          name: nameTextEditingController.text.trim(),
          phone: phoneTextEditingController.text.trim(),
          email: emailTextEditingController.text.trim(),
          gender: selectedGender.value.isNotEmpty ? selectedGender.value : null,
          dob: _formatDateForApi(),
          age: _calculateAge(),
          fileId: uploadFile?.id,
          completed: 1,
        );
      } else {
        // Admin editing their own profile (no doctor/patient info)
        logger.controller(
            'Building request for admin editing own profile (no gender/DOB/completed)');
        return UpdateProfileRequest(
          name: nameTextEditingController.text.trim(),
          email: emailTextEditingController.text.trim(),
          phone: phoneTextEditingController.text.trim(),
          fileId: uploadFile?.id,
        );
      }
    } else {
      // Admin editing another user's profile (patient)
      if (isPatient) {
        logger.controller('Building request for admin editing patient profile');
        return UpdateProfileRequest(
          userId: userId.value,
          name: nameTextEditingController.text.trim(),
          phone: phoneTextEditingController.text.trim(),
          email: emailTextEditingController.text.trim(),
          gender: selectedGender.value.isNotEmpty ? selectedGender.value : null,
          dob: _formatDateForApi(),
          age: _calculateAge(),
          fileId: uploadFile?.id,
          completed: 1,
        );
      } else {
        // Default: treat as patient profile
        logger.controller('Building request for patient profile (default case)');
        return UpdateProfileRequest(
          userId: userId.value,
          name: nameTextEditingController.text.trim(),
          phone: phoneTextEditingController.text.trim(),
          email: emailTextEditingController.text.trim(),
          gender: selectedGender.value.isNotEmpty ? selectedGender.value : null,
          dob: _formatDateForApi(),
          age: _calculateAge(),
          fileId: uploadFile?.id,
          completed: 1,
        );
      }
    }
  }

  /// Build questionnaires list from selected age groups and areas of expertise
  List<QuestionnaireItem>? _buildQuestionnaires() {
    final questionnaires = <QuestionnaireItem>[];

    // Age group preference questionnaire
    if (selectedAgeGroups.isNotEmpty) {
      final ageGroupAnswers = selectedAgeGroups
          .map((ageGroup) => getAgeGroupDisplayName(ageGroup))
          .toList();

      questionnaires.add(QuestionnaireItem(
        question: "What age group(s) do you prefer your clients to belong to?",
        options: availableAgeGroups
            .map((ageGroup) => getAgeGroupDisplayName(ageGroup))
            .toList(),
        answer: ageGroupAnswers,
        key: "age_group_prefer",
      ));

      logger.controller(
          'Built age group questionnaire with ${ageGroupAnswers.length} selections');
    }

    // Areas of expertise questionnaire
    if (selectedAreasOfExpertise.isNotEmpty) {
      final expertiseAnswers = selectedAreasOfExpertise
          .map((expertise) => getAreaOfExpertiseDisplayName(expertise))
          .toList();

      questionnaires.add(QuestionnaireItem(
        question:
            "Which areas of expertise would you like to provide assistance in?",
        options: availableAreasOfExpertise
            .map((expertise) => getAreaOfExpertiseDisplayName(expertise))
            .toList(),
        answer: expertiseAnswers,
        key: "help_support",
      ));

      logger.controller(
          'Built expertise questionnaire with ${expertiseAnswers.length} selections');
    }

    return questionnaires.isNotEmpty ? questionnaires : null;
  }

  String? _formatDateForApi() {
    if (selectedDay.value.isNotEmpty &&
        selectedMonth.value.isNotEmpty &&
        selectedYear.value.isNotEmpty) {
      try {
        // Format as YYYY-DD-MM for API
        int day = int.parse(selectedDay.value);
        int month = int.parse(selectedMonth.value);
        int year = int.parse(selectedYear.value);

        return '${year.toString()}-${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}';
      } catch (e) {
        if (kDebugMode) {
          print('EditProfileController - Error formatting date: $e');
        }
      }
    }

    // Fallback: try to use the dobTextEditingController value if available
    if (dobTextEditingController.text.isNotEmpty) {
      return dobTextEditingController.text;
    }

    return null;
  }

  int? _calculateAge() {
    if (selectedDay.value.isNotEmpty &&
        selectedMonth.value.isNotEmpty &&
        selectedYear.value.isNotEmpty) {
      try {
        int day = int.parse(selectedDay.value);
        int month = int.parse(selectedMonth.value);
        int year = int.parse(selectedYear.value);

        DateTime birthDate = DateTime(year, month, day);
        DateTime now = DateTime.now();

        int age = now.year - birthDate.year;

        // Check if birthday has occurred this year
        if (now.month < birthDate.month ||
            (now.month == birthDate.month && now.day < birthDate.day)) {
          age--;
        }

        return age;
      } catch (e) {
        logger.error('Error calculating age: $e');
      }
    }
    return null;
  }

  bool _validateForm() {
    bool isValid = true;

    // Clear previous errors
    clearAllErrors();

    // Validate name
    String? nameValidation = InputValidator.validateName(name);
    if (nameValidation != null) {
      nameError.value = nameValidation;
      isValid = false;
    }

    // Validate email
    String? emailValidation = InputValidator.validateEmail(email);
    if (emailValidation != null) {
      emailError.value = emailValidation;
      isValid = false;
    }

    // Validate phone
    String? phoneValidation = InputValidator.validatePhone(phone);
    if (phoneValidation != null) {
      phoneError.value = phoneValidation;
      isValid = false;
    }

    // Optional: Validate gender (uncommented for completeness)
    if (selectedGender.value.isNotEmpty) {
      // If gender is provided, ensure it's a valid value
      List<String> validGenders = ['male', 'female', 'other'];
      if (!validGenders.contains(selectedGender.value.toLowerCase())) {
        genderError.value = 'Please select a valid gender';
        isValid = false;
      }
    }

    // Optional: Validate date of birth if provided
    if (selectedDay.value.isNotEmpty ||
        selectedMonth.value.isNotEmpty ||
        selectedYear.value.isNotEmpty) {
      // If any date component is provided, ensure all are provided
      if (selectedDay.value.isEmpty ||
          selectedMonth.value.isEmpty ||
          selectedYear.value.isEmpty) {
        dobError.value = 'Please complete the date of birth';
        isValid = false;
      } else {
        // Validate that the date values are reasonable
        try {
          int day = int.parse(selectedDay.value);
          int month = int.parse(selectedMonth.value);
          int year = int.parse(selectedYear.value);

          if (day < 1 || day > 31) {
            dobError.value = 'Invalid day';
            isValid = false;
          } else if (month < 1 || month > 12) {
            dobError.value = 'Invalid month';
            isValid = false;
          } else if (year < 1900 || year > DateTime.now().year) {
            dobError.value = 'Invalid year';
            isValid = false;
          } else {
            // Check if the date is valid (e.g., not February 30)
            try {
              DateTime(year, month, day);
            } catch (e) {
              dobError.value = 'Invalid date';
              isValid = false;
            }
          }
        } catch (e) {
          dobError.value = 'Please enter valid numbers';
          isValid = false;
        }
      }
    }

    return isValid;
  }

  void clearAllErrors() {
    nameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    genderError.value = null;
    dobError.value = null;
  }

  void clearNameError() {
    nameError.value = null;
  }

  void clearEmailError() {
    emailError.value = null;
  }

  void clearPhoneError() {
    phoneError.value = null;
  }

  void clearGenderError() {
    genderError.value = null;
  }

  void clearDobError() {
    dobError.value = null;
  }

  /// Updates specialist status (approve/reject)
  Future<void> onStatusUpdate(String status) async {
    logger.controller('Updating specialist status to: $status');

    // Build available times from schedule data
    List<AvailableTimeSlot>? availableTimes;
    if (scheduleData.isNotEmpty) {
      // Extract session duration value (e.g., "30 min" -> "30")
      String durationValue =
          sessionDuration.value.replaceAll(' min', '').trim();
      availableTimes = _buildAvailableTimesFromSchedule(durationValue);
      logger.controller(
          'Built ${availableTimes.length} available time slots from schedule');
    }

    // Build questionnaires from selected age groups and areas of expertise
    List<QuestionnaireItem>? questionnaires = _buildQuestionnaires();

    final request = UpdateProfileRequest(
      userId: getUserId,
      name: name,
      phone: phone,
      email: email,
      completed: 1,
      fileId: uploadFileEntity.value?.id,
      age: _calculateAge(),
      experience: experience.isNotEmpty ? int.tryParse(experience) : null,
      specialization: selectedProfession.value != null
          ? getProfessionDisplayName(selectedProfession.value!)
          : null,
      degree: degree.isNotEmpty ? degree : null,
      licenseNo: license.isNotEmpty ? license : null,
      bio: bio.isNotEmpty ? bio : null,
      languages: selectedLanguages,
      gender: gender,
      dob: dateOfBirth,
      commisionType: selectedCommissionType.value.toLowerCase(),
      commisionValue:
          commissionValue.trim().isNotEmpty ? commissionValue.trim() : null,
      status: status,
      availableTimes: availableTimes,
      questionnaires: questionnaires,
    );

    final result = await executeApiCall<UserEntity?>(
      () => adminUpdateProfileUseCase.execute(request),
      onSuccess: () {
        logger.controller('Specialist status updated successfully to: $status');
      },
      onError: (errorMessage) {
        logger.error('Error updating specialist status: $errorMessage');
      },
    );

    // Only navigate back and show success if the update was successful
    if (result != null) {
      // _showSuccessSnackbar('Update Profile', 'Specialist $status successfully.');
      goBack();
    }
  }

  /// Helper method to show error snackbar
  /// Safely checks if overlay context is available before showing snackbar
  void _showErrorSnackbar(String title, String message) {
    // Check if we still have a valid overlay context
    // This prevents crash when showing error after user has navigated away
    try {
      if (Get.overlayContext != null) {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 3),
        );
      } else {
        logger.warning(
            'Cannot show error snackbar: No overlay context available (user likely navigated away)');
      }
    } catch (e) {
      logger.error('Error showing error snackbar: $e');
    }
  }

  /// Helper method to show success snackbar
  /// Safely checks if overlay context is available before showing snackbar
  void _showSuccessSnackbar(String title, String message) {
    // Check if we still have a valid overlay context
    // This prevents crash when upload completes after user has navigated away
    try {
      if (Get.overlayContext != null) {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.toastSuccessBorder,
          colorText: AppColors.white,
          isDismissible: true,
          duration: const Duration(seconds: 3),
        );
      } else {
        logger.warning(
            'Cannot show snackbar: No overlay context available (user likely navigated away)');
      }
    } catch (e) {
      logger.error('Error showing snackbar: $e');
    }
  }
}
