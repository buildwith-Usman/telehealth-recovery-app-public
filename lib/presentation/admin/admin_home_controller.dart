import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/app/controllers/base_controller.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/entity/appointment_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_review_entity.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_appointments_list_entity.dart';
import 'package:recovery_consultation_app/domain/models/session_data.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_admin_user_list_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_user_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_appointments_list_use_case.dart';

class AdminHomeController extends BaseController {

  // ==================== DEPENDENCIES ====================
  AdminHomeController({
    required this.getPaginatedAdminUserListUseCase,
    required this.getUserUseCase,
    required this.getPaginatedAppointmentsListUseCase,
  });

  final GetPaginatedAdminUserListUseCase getPaginatedAdminUserListUseCase;
  final GetUserUseCase getUserUseCase;
  final GetPaginatedAppointmentsListUseCase getPaginatedAppointmentsListUseCase;


  // Observable data for admin dashboard
  final totalUsers = 1250.obs;
  final activeSessions = 45.obs;
  final pendingApprovals = 8.obs;
  final monthlyRevenue = 25750.0.obs;
  final systemHealthStatus = 'Excellent'.obs;
  var patientList = <ProfileCardItem>[].obs;
  // Top specialists for the horizontal specialists list
  var topSpecialists = <ProfileCardItem>[].obs;
  // Separate appointment lists for upcoming and ongoing
  var upcomingAppointments = <AppointmentEntity>[].obs;
  var ongoingAppointments = <AppointmentEntity>[].obs;
  

  // Logged in user data
  final Rxn<UserEntity> loggedInUser = Rxn<UserEntity>();

  // Loading states
  final isLoadingDashboard = false.obs;
  final isRefreshing = false.obs;
  
  // Pagination variables
  final RxInt _currentPage = 1.obs;
  final RxBool _hasMoreData = true.obs;
  final RxBool _isLoadingMore = false.obs;
  //Patients UI items

  // ==================== GETTERS ====================
  List<ProfileCardItem> get patients => patientList.toList();
  bool get hasMoreData => _hasMoreData.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get currentPage => _currentPage.value;
  UserEntity? get user => loggedInUser.value;

  @override
  void onInit() {
    super.onInit();
    _initializeAdminData();
  }

  void _initializeAdminData() {
    // Initialize admin dashboard data
    _loadLoggedInUser();
    loadDashboardData();
    loadPatients();
    loadUpComingAppointments();
    loadOnGoingAppointments();
    // load top specialists for the horizontal list
    loadTopSpecialists();
  }

  /// Load top specialists for the horizontal specialists list
  Future<void> loadTopSpecialists({int page = 1, int limit = 4}) async {
    try {
      final params = GetPaginatedAdminUserListParams(
        type: UserRole.doctor.name,
        page: page,
        limit: limit,
      );

      final result = await executeApiCall<PaginatedListEntity<UserEntity>?>(
        () => getPaginatedAdminUserListUseCase.execute(params),
        onSuccess: () => logger.method('✅ Specialists fetched successfully'),
        onError: (error) => logger.method('⚠️ Failed to fetch specialists: $error'),
      );

      if (result != null) {
        final items = result.data.map((u) => ProfileCardItem(
              name: u.name,
              profession: u.doctorInfo?.specialization,
              degree: u.doctorInfo?.degree,
              imageUrl: u.imageUrl,
              rating: _computeRatingFromReviews(u.reviews),
              noOfRatings: _computeNumberOfRatings(u.reviews),
              onTap: () => onSpecialistTap(u.id),
            )).toList();

        topSpecialists.assignAll(items);
        logger.controller('Loaded ${items.length} specialists (page $page)');
      } else {
        topSpecialists.clear();
        logger.method('⚠️ No specialists data received');
      }
    } catch (e, st) {
      logger.method('❌ Error loading specialists: $e\n$st');
      topSpecialists.clear();
    }
  }

  /// Compute average rating from reviews (returns null if no valid ratings)
  double? _computeRatingFromReviews(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) return null;

    final validRatings = reviews
        .map((r) => r.rating)
        .whereType<int>()
        .toList();

    if (validRatings.isEmpty) return null;

    final total = validRatings.reduce((a, b) => a + b);
    return total / validRatings.length;
  }

  /// Compute number of valid ratings from reviews (as string) or null
  String? _computeNumberOfRatings(List<DoctorReviewEntity>? reviews) {
    if (reviews == null || reviews.isEmpty) return null;

    final validRatings = reviews
        .map((r) => r.rating)
        .whereType<int>()
        .toList();

    if (validRatings.isEmpty) return null;

    return validRatings.length.toString();
  }

  /// Load logged in user data
  Future<void> _loadLoggedInUser() async {
    logger.controller('Loading logged in user data');

    final result = await executeApiCall<UserEntity>(
      () => getUserUseCase.execute(),
      onSuccess: () {
        logger.controller('Successfully loaded logged in user');
      },
      onError: (errorMessage) {
        logger.error('Error loading logged in user: $errorMessage');
      },
    );

    if (result != null) {
      loggedInUser.value = result;
      logger.controller('Logged in user: ${result.name}');
    } else {
      logger.warning('No user data found');
    }
  }

  Future<void> loadDashboardData() async {
    try {
      isLoadingDashboard.value = true;

      // Simulate API call for admin dashboard data
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API calls
      totalUsers.value = 1250;
      activeSessions.value = 45;
      pendingApprovals.value = 8;
      monthlyRevenue.value = 25750.0;
      systemHealthStatus.value = 'Excellent';

      logger.controller('Dashboard data loaded successfully');
    } catch (e) {
      logger.error('Error loading admin dashboard: $e');
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  Future<void> refreshData() async {
    try {
      isRefreshing.value = true;
      await loadDashboardData();
    } finally {
      isRefreshing.value = false;
    }
  }

    /// Load doctors from API based on selected type
  Future<void> _loadPatientsFromAPI() async {
    const int limit = 5;
    try {
      _isLoadingMore.value = true;

      final params = GetPaginatedAdminUserListParams(
        type: UserRole.patient.name,
        page: _currentPage.value,
        limit: limit,
      );

      final result = await executeApiCall<PaginatedListEntity<UserEntity>?>(
        () => getPaginatedAdminUserListUseCase.execute(params),
        onSuccess: () => logger.method('✅ Users fetched successfully'),
        onError: (error) => logger.method("⚠️ Failed to fetch users: $error"),
      );

      if (result != null) {
        // Map API users directly to UI items
        final items = result.data.map((u) => ProfileCardItem(
              name: u.name,
              imageUrl: u.imageUrl,
              onTap: () => navigateToPatientDetail(u.id),
            )).toList();

        if (_currentPage.value == 1) {
          patientList.assignAll(items);
        } else {
          patientList.addAll(items);
        }

        // determine if there's more data — fallback to response length vs limit
        _hasMoreData.value = (result.data.length >= limit);

        logger.controller('Loaded ${items.length} patients (page ${_currentPage.value})');
      } else {
        if (_currentPage.value == 1) {
          patientList.clear();
        }
        _hasMoreData.value = false;
        logger.method('⚠️ No users data received');
      }
    } catch (e, st) {
      logger.method("❌ Error loading users: $e\n$st");
      if (_currentPage.value == 1) {
        patientList.clear();
      }
      _hasMoreData.value = false;
    } finally {
      _isLoadingMore.value = false;
    }
  }

  void loadPatients() {
    // Reset paging and trigger API load; API results are mapped
    _currentPage.value = 1;
    _hasMoreData.value = true;
    _loadPatientsFromAPI().catchError((e, st) {
      logger.method('⚠️ Failed to load patients for UI: $e\n$st');
    });
  }

  /// Load appointments from API with type filter
  Future<void> _loadAppointmentsFromAPI({required String type}) async {
    const int limit = 3;
    try {
      _isLoadingMore.value = true;

      final params = GetPaginatedAppointmentsListParams(
        type: type,
        page: _currentPage.value,
        limit: limit,
      );

      final result = await executeApiCall<PaginatedAppointmentsListEntity?>(
        () => getPaginatedAppointmentsListUseCase.execute(params),
        onSuccess: () => logger.method('✅ Appointments ($type) fetched successfully'),
        onError: (error) => logger.method("⚠️ Failed to fetch appointments ($type): $error"),
      );

      // Select the appropriate observable based on type
      final targetObservable = type == 'upcoming' ? upcomingAppointments : ongoingAppointments;

      if (result != null && result.appointments != null) {
        if (_currentPage.value == 1) {
          targetObservable.assignAll(result.appointments!);
        } else {
          targetObservable.addAll(result.appointments!);
        }

        // Determine if there's more data — fallback to response length vs limit
        _hasMoreData.value = (result.appointments!.length >= limit);

        logger.controller('Loaded ${result.appointments!.length} $type appointments (page ${_currentPage.value})');
      } else {
        if (_currentPage.value == 1) {
          targetObservable.clear();
        }
        _hasMoreData.value = false;
        logger.method('⚠️ No $type appointments data received');
      }
    } catch (e, st) {
      logger.method("❌ Error loading $type appointments: $e\n$st");
      if (_currentPage.value == 1) {
        final targetObservable = type == 'upcoming' ? upcomingAppointments : ongoingAppointments;
        targetObservable.clear();
      }
      _hasMoreData.value = false;
    } finally {
      _isLoadingMore.value = false;
    }
  }

  /// Load upcoming appointments
  void loadUpComingAppointments() {
    // Reset paging and trigger API load for upcoming appointments
    _currentPage.value = 1;
    _hasMoreData.value = true;
    _loadAppointmentsFromAPI(type: 'upcoming').catchError((e, st) {
      logger.method('⚠️ Failed to load upcoming appointments for UI: $e\n$st');
    });
  }

  /// Load ongoing appointments
  void loadOnGoingAppointments() {
    // Reset paging and trigger API load for ongoing appointments
    _currentPage.value = 1;
    _hasMoreData.value = true;
    _loadAppointmentsFromAPI(type: 'ongoing').catchError((e, st) {
      logger.method('⚠️ Failed to load ongoing appointments for UI: $e\n$st');
    });
  }

  void navigateToPatientDetail(int patientId) {
    Get.toNamed(
      AppRoutes.adminPatientDetails,
      arguments: {Arguments.patientId: patientId},
    );
  }

  void navigateToViewProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  // Quick Actions
  void approveSpecialist(String specialistId) {
    logger.controller('Approving specialist: $specialistId');
    // Update pending approvals count
    if (pendingApprovals.value > 0) {
      pendingApprovals.value--;
    }
  }

  void viewAllUsers() {
    logger.controller('Navigating to user management');
    // Get.toNamed(AppRoutes.userManagement);
  }

  void viewAllSpecialists() {
    logger.controller('Navigating to specialist management');
    // Get.toNamed(AppRoutes.specialistManagement);
  }

  void viewReports() {
    logger.controller('Navigating to reports');
    // Get.toNamed(AppRoutes.reports);
  }

  void handleSupportTickets() {
    logger.controller('Navigating to support tickets');
    // Get.toNamed(AppRoutes.supportTickets);
  }

  void navigateToSpecialistApproval() {
    Get.toNamed(AppRoutes.specialistApproval);
  }

  // Navigation methods

  void navigateToAdminPatientsList() {
    // Navigate to full patients list
    Get.toNamed(AppRoutes.adminPatients);
  }

    void navigateToAdminSpecialistList() {
    // Navigate to full patients list
    Get.toNamed(AppRoutes.specialistList);
  }

  void navigateToAdminSessionPage() {
    // Navigate to full patients list
    Get.toNamed(AppRoutes.adminSessions);
  }

  void onSpecialistTap(int? specialistId) {
    logger.controller('Specialist tapped: $specialistId');

    // Navigate to specialist detail screen with specialist data
    Get.toNamed(
      AppRoutes.specialistView,
      arguments: {Arguments.doctorId: specialistId},
    );
  }

  void navigateToSessionDetails(AdminSessionData session) {
    logger.controller('Session tapped: ${session.id}');

    // Navigate to session detail page
    Get.toNamed(
      AppRoutes.sessionDetails,
      arguments: {
        Arguments.sessionId: session.id,
      },
    );
  }
}
