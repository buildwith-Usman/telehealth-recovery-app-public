import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/config/app_enum.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/data/api/request/update_profile_request.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/admin_update_profile_use_case.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_admin_user_list_use_case.dart';
import '../../app/controllers/base_controller.dart';

enum ApprovalStatus { all, pending, approved, rejected }

extension ApprovalStatusExtension on ApprovalStatus {
  String get name {
    switch (this) {
      case ApprovalStatus.all:
        return 'all';
      case ApprovalStatus.pending:
        return 'pending';
      case ApprovalStatus.approved:
        return 'approved';
      case ApprovalStatus.rejected:
        return 'rejected';
    }
  }

  String get displayName {
    switch (this) {
      case ApprovalStatus.all:
        return 'All Specialists';
      case ApprovalStatus.pending:
        return 'Pending Approval';
      case ApprovalStatus.approved:
        return 'Approved';
      case ApprovalStatus.rejected:
        return 'Rejected';
    }
  }
}

class SpecialistApprovalController extends BaseController {
  // ==================== DEPENDENCIES ====================
  SpecialistApprovalController({
    required this.getPaginatedAdminUserListUseCase,
    required this.adminUpdateProfileUseCase,
  });

  final GetPaginatedAdminUserListUseCase getPaginatedAdminUserListUseCase;
  final AdminUpdateProfileUseCase adminUpdateProfileUseCase;

  // ==================== REACTIVE VARIABLES ====================
  final Rx<SpecialistType> _selectedSpecialistType =
      SpecialistType.therapist.obs;
  final RxList<UserEntity> _doctors = <UserEntity>[].obs;

  // Pagination variables
  final RxInt _currentPage = 1.obs;
  final RxBool _hasMoreData = true.obs;
  final RxBool _isLoadingMore = false.obs;

  // Action state variables
  final RxSet<int> _approvingSpecialists = <int>{}.obs;
  final RxSet<int> _rejectingSpecialists = <int>{}.obs;

  // ==================== GETTERS ====================
  SpecialistType get selectedSpecialistType => _selectedSpecialistType.value;
  List<UserEntity> get doctors => _doctors.toList();
  bool get hasMoreData => _hasMoreData.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get currentPage => _currentPage.value;

  Set<int> get approvingSpecialists => _approvingSpecialists.toSet();
  Set<int> get rejectingSpecialists => _rejectingSpecialists.toSet();

  @override
  void onReady() {
    super.onReady();
    _loadSpecialists();
  }

  void _loadSpecialists() {
    _currentPage.value = 1;
    _hasMoreData.value = true;
    _loadDoctorsFromAPI();
  }

  void selectSpecialistType(SpecialistType type) {
    _selectedSpecialistType.value = type;
    _loadSpecialists();
  }

  /// Load doctors from API based on selected type
  Future<void> _loadDoctorsFromAPI() async {
    const int limit = 20;
    try {
      _isLoadingMore.value = true;

      final params = GetPaginatedAdminUserListParams(
        specialization: selectedSpecialistType.name,
        type: UserRole.doctor.name,
        page: _currentPage.value,
        limit: limit,
      );

      final result = await executeApiCall<PaginatedListEntity<UserEntity>?>(
        () => getPaginatedAdminUserListUseCase.execute(params),
        onSuccess: () => logger.method('✅ Users fetched successfully'),
        onError: (error) => logger.method("⚠️ Failed to fetch users: $error"),
      );

      // Collect full user objects (no doctorInfo filtering)
      final List<UserEntity> usersFromResponse = <UserEntity>[];

      if (result != null) {
        for (final userWrapper in result.data) {
          usersFromResponse.add(userWrapper);
        }

        if (_currentPage.value == 1) {
          // replace on first page
          _doctors.assignAll(usersFromResponse);
        } else {
          // append on subsequent pages
          _doctors.addAll(usersFromResponse);
        }

        // determine if there's more data — fallback to response length vs limit
        _hasMoreData.value = (result.data.length >= limit);

        logger.controller(
            'Loaded ${usersFromResponse.length} users for ${selectedSpecialistType.name} (page ${_currentPage.value})');
      } else {
        if (_currentPage.value == 1) {
          _doctors.clear();
        }
        _hasMoreData.value = false;
        logger.method('⚠️ No users data received');
      }
    } catch (e, st) {
      logger.method("❌ Error loading users: $e\n$st");
      if (_currentPage.value == 1) {
        _doctors.clear();
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

  /// Update specialist status (approve/reject)
  Future<void> onStatusUpdate(int userId, String status) async {
    logger.controller('Updating specialist status: userId=$userId, status=$status');

    // Track loading state
    if (status == 'approved') {
      _approvingSpecialists.add(userId);
    } else if (status == 'rejected') {
      _rejectingSpecialists.add(userId);
    }

    final request = UpdateProfileRequest(
      userId: userId,
      status: status,
    );

    final result = await executeApiCall<UserEntity?>(
      () => adminUpdateProfileUseCase.execute(request),
      onSuccess: () {
        logger.controller('Specialist status updated successfully');
      },
      onError: (errorMessage) {
        logger.error('Failed to update specialist status: $errorMessage');
      },
    );

    // Clear loading state
    _approvingSpecialists.remove(userId);
    _rejectingSpecialists.remove(userId);

    // Refresh list if successful
    if (result != null) {
      await refreshDoctors();
    }
  }

  /// Check if a specialist is being approved
  bool isApprovingSpecialist(int? doctorId) {
    return doctorId != null && _approvingSpecialists.contains(doctorId);
  }

  /// Check if a specialist is being rejected
  bool isRejectingSpecialist(int? doctorId) {
    return doctorId != null && _rejectingSpecialists.contains(doctorId);
  }

  void navigateToEditProfile(int userId) {
    Get.toNamed(
      AppRoutes.editProfile,
      arguments: {
        Arguments.openedFrom: AppRoutes.specialistApproval,
        Arguments.userId: userId,
      },
    );
  }

  void goBack() {
    Get.back();
  }
}
