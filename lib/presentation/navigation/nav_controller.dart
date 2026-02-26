import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_consultation_app/app/config/app_colors.dart';
import 'package:recovery_consultation_app/app/config/app_icon.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import 'package:recovery_consultation_app/app/services/app_storage.dart';
import 'package:recovery_consultation_app/domain/usecase/add_review_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/create_prescription_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_admin_user_list_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_appointments_list_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_patients_list_use_case.dart';
import 'package:recovery_consultation_app/presentation/admin_patients_list/admin_patients_list_page.dart';
import 'package:recovery_consultation_app/presentation/admin_sessions/admin_sessions_page.dart';
import 'package:recovery_consultation_app/presentation/patient_home/patient_home_controller.dart';
import 'package:recovery_consultation_app/presentation/patient_list/recent_patients_list_page.dart';
import 'package:recovery_consultation_app/presentation/widgets/app_text.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/get_paginated_doctors_list_use_case.dart';
import '../patient_home/patient_home_page.dart';
import '../appointments/appointments_page.dart';
import '../specialist_list/specialist_list_page.dart';
import '../payments/payments_page.dart';
import '../settings/setting_page.dart';
import '../admin/admin_home_page.dart';
import '../admin/admin_home_controller.dart';
import '../specialist/specialist_home_page.dart';
import '../specialist/specialist_home_controller.dart';

class NavController extends GetxController {
  final _currentIndex = 0.obs;
  final _shouldShowNavBar = true.obs;
  
  // Post-call data to display dialogs after navigation
  final Rx<Map<String, dynamic>?> _postCallData = Rx<Map<String, dynamic>?>(null);
  Map<String, dynamic>? get postCallData => _postCallData.value;

  int get currentIndex => _currentIndex.value;
  bool get shouldShowNavBar => _shouldShowNavBar.value;

  // Get role manager instance
  RoleManager get roleManager => RoleManager.instance;

  //Fab Widget
  Widget fabWidget =
      AppIcon.navHome.widget(height: 24, width: 24, color: AppColors.primary);

  @override
  void onInit() {
    super.onInit();
    // Check if post-call data was passed via arguments
    _checkForPostCallData();
    
    // Ensure proper controller registration based on user role
    if (roleManager.isAdmin) {
      fabWidget = AppIcon.navAppointments.widget(height: 24, width: 24);
    } else if (roleManager.isSpecialist) {
      fabWidget = AppIcon.navAppointments.widget(height: 24, width: 24);
    } else {
      fabWidget = AppIcon.navDoctors.widget(height: 24, width: 24);
    }
  }

  /// Check if post-call data was passed via arguments
  void _checkForPostCallData() {
    try {
      final args = Get.arguments;
      if (args is Map<String, dynamic>) {
        if (args.containsKey('showRating') || args.containsKey('showNotes')) {
          _postCallData.value = args;
          if (kDebugMode) {
            print('NavController: Post-call data received: $args');
          }

          // Persist rating data to storage for mandatory submission
          if (args.containsKey('showRating') && args['showRating'] == true) {
            AppStorage.instance.setPendingRatingData(args);
            if (kDebugMode) {
              print('NavController: Persisted rating data to storage');
            }
          }

          // Persist notes data to storage for mandatory submission
          if (args.containsKey('showNotes') && args['showNotes'] == true) {
            AppStorage.instance.setPendingNotesData(args);
            if (kDebugMode) {
              print('NavController: Persisted notes data to storage');
            }
          }

          // Home controller will check and handle showing the dialog in its onInit
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking for post-call data: $e');
      }
    }
  }

  /// Clear post-call data after it's been processed
  void clearPostCallData() {
    _postCallData.value = null;
  }

  // Dynamic pages based on user role
  List<Widget> get pages {
    if (roleManager.isAdmin) {
      // Ensure admin controller is registered
      _ensureAdminControllerRegistered();
      return const [
        AdminHomePage(),
        AdminPatientsListPage(),
        AdminSessionsPage(),
        SpecialistListPage(),
        SettingPage(),
      ];
    } else if (roleManager.isSpecialist) {
      // Ensure specialist controller is registered
      _ensureSpecialistControllerRegistered();
      return const [
        SpecialistHomePage(),
        RecentPatientsListPage(),
        AppointmentsPage(),
        PaymentsPage(),
        SettingPage(),
      ];
    } else {
      // Patient navigation
      _ensurePatientControllerRegistered();
      return const [
        PatientHomePage(),
        AppointmentsPage(),
        SpecialistListPage(),
        PaymentsPage(),
        SettingPage(),
      ];
    }
  }

  // Ensure admin controller is registered when admin pages are accessed
  void _ensureAdminControllerRegistered() {
    if (!Get.isRegistered<AdminHomeController>()) {
      Get.lazyPut<AdminHomeController>(() => AdminHomeController(
        getPaginatedAdminUserListUseCase: Get.find<GetPaginatedAdminUserListUseCase>(),
        getUserUseCase: Get.find<GetUserUseCase>(),
        getPaginatedAppointmentsListUseCase: Get.find<GetPaginatedAppointmentsListUseCase>()
      ));
    }
  }

  // Ensure specialist controller is registered when specialist pages are accessed
  void _ensureSpecialistControllerRegistered() {
    if (!Get.isRegistered<SpecialistHomeController>()) {
      Get.lazyPut<SpecialistHomeController>(() => SpecialistHomeController(
        getUserUseCase: Get.find<GetUserUseCase>(),
        getPaginatedAppointmentsListUseCase: Get.find<GetPaginatedAppointmentsListUseCase>(),
        getPaginatedPatientsListUseCase: Get.find<GetPaginatedPatientsListUseCase>(),
        createPrescriptionUseCase: Get.find<CreatePrescriptionUseCase>(),
      ));
    }
  }

  void _ensurePatientControllerRegistered() {
    if (!Get.isRegistered<PatientHomeController>()) {
      Get.lazyPut<PatientHomeController>(() => PatientHomeController(
            getUserUseCase: Get.find<GetUserUseCase>(),
            getPaginatedDoctorsListUseCase:
                Get.find<GetPaginatedDoctorsListUseCase>(),
                getPaginatedAppointmentsListUseCase:
                Get.find<GetPaginatedAppointmentsListUseCase>(),
            addReviewUseCase: Get.find<AddReviewUseCase>(),    
          ));
    }
  }

  void changeTab(int index) {
    if (index >= 0 && index < pages.length) {
      _currentIndex.value = index;
    }
  }

  void showNavBar() => _shouldShowNavBar.value = true;
  void hideNavBar() => _shouldShowNavBar.value = false;

  // Dynamic navigation items based on user role
  List<BottomBarItem> get navigationItems {
    if (roleManager.isAdmin) {
      return [
        BottomBarItem(
          icon: AppIcon.navHome
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navHome
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Dashboard'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.whiteLight,
        ),
        BottomBarItem(
          icon: AppIcon.navPatients
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navPatients
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Patients'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
        BottomBarItem(
          icon: AppIcon.navDoctors
              .widget(height: 24, width: 24, color: AppColors.white),
          selectedIcon: AppIcon.navDoctors
              .widget(height: 24, width: 24, color: AppColors.white),
          title: const Text(''),
        ),
        BottomBarItem(
          icon: AppIcon.navDoctors
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navDoctors
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Specialists'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
        BottomBarItem(
          icon: AppIcon.navSetting
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navSetting
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Settings'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
      ];
    } else if (roleManager.isSpecialist) {
      return [
        BottomBarItem(
          icon: AppIcon.navHome
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navHome
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Dashboard'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
        BottomBarItem(
          icon: AppIcon.navPatients
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navPatients
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Patients'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
        BottomBarItem(
          icon: AppIcon.navDoctors
              .widget(height: 24, width: 24, color: AppColors.white),
          selectedIcon: AppIcon.navDoctors
              .widget(height: 24, width: 24, color: AppColors.white),
          title: const Text(''),
        ),
        BottomBarItem(
          icon: AppIcon.navPayment
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navPayment
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Earnings'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
        BottomBarItem(
          icon: AppIcon.navSetting
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navSetting
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Settings'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
      ];
    } else {
      // Patient navigation
      return [
        BottomBarItem(
          icon: AppIcon.navHome
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navHome
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: AppText.primary('Home'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
        BottomBarItem(
          icon: AppIcon.navAppointment
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navAppointment
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Appointments'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
        BottomBarItem(
          icon: AppIcon.navDoctors
              .widget(height: 24, width: 24, color: AppColors.white),
          selectedIcon: AppIcon.navDoctors
              .widget(height: 24, width: 24, color: AppColors.white),
          title: const Text(''),
        ),
        BottomBarItem(
          icon: AppIcon.navPayment
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navPayment
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Payments'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
        BottomBarItem(
          icon: AppIcon.navSetting
              .widget(height: 24, width: 24, color: AppColors.whiteLight),
          selectedIcon: AppIcon.navSetting
              .widget(height: 24, width: 24, color: AppColors.primary),
          title: const Text('Settings'),
          selectedColor: AppColors.primary,
          unSelectedColor: AppColors.accent,
        ),
      ];
    }
  }
}
