import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/config/app_constant.dart';
import 'package:recovery_consultation_app/app/config/app_routes.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/domain/entity/paginated_list_entity.dart.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_paginated_admin_user_list_use_case.dart';

import '../../app/controllers/base_controller.dart';

class AdminPatientsListController extends BaseController {
  // ==================== DEPENDENCIES ====================
  AdminPatientsListController({required this.getPaginatedAdminUserListUseCase});

  final GetPaginatedAdminUserListUseCase getPaginatedAdminUserListUseCase;

  // ==================== REACTIVE VARIABLES ====================
  var patientList = <ProfileCardItem>[].obs;

  /// Compatibility getters for the UI
  String? get errorMessage => generalError.value;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit();
    loadPatients();
  }

  // ==================== DATA LOADING METHODS ====================
  /// Load patients from API using the use case
  Future<void> loadPatients({int page = 1, int limit = 20}) async {
    _loadPatients(page: page, limit: limit);
  }

  Future<void> _loadPatients({required int page, required int limit}) async {
    final params = GetPaginatedAdminUserListParams(
      type: 'patient',
      page: page,
      limit: limit,
    );

    final result = await executeApiCall<PaginatedListEntity<UserEntity>?>(
      () => getPaginatedAdminUserListUseCase.execute(params),
      onSuccess: () => logger.method('✅ Admin patients fetched successfully'),
      onError: (err) => logger.method('⚠️ Failed to fetch admin patients: $err'),
    );

    if (result != null) {
      final items = result.data.map((u) => ProfileCardItem(
            name: u.name,
            email: u.email,
            imageUrl: u.imageUrl,
            patientInfo: u.patientInfo,
            onTap: () => navigateToPatientDetail(u.id),
          )).toList();

      if (page == 1) {
        patientList.assignAll(items);
      } else {
        patientList.addAll(items);
      }
    }
  }

  void navigateToPatientDetail(int? id) {
    Get.toNamed(AppRoutes.adminPatientDetails, arguments: {Arguments.patientId: id});
  }

  /// Refresh the patients list
  Future<void> refreshPatients() async {
    await loadPatients(page: 1);
  }

  /// Compatibility method for UI
  Future<void> retryLoading() async {
    await refreshPatients();
  }

  // ==================== FILTER METHODS ====================
}
