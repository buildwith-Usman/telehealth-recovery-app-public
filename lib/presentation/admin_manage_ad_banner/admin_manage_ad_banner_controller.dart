import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/config/app_constant.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';
import '../../data/api/request/update_ad_banner_request.dart';
import '../../domain/usecase/get_ad_banners_use_case.dart';
import '../../domain/usecase/update_ad_banner_use_case.dart';

class AdBannerModel {
  final String id;
  final String title;
  final String startDate; // Formatted for display: "MMM d, yyyy"
  final String endDate; // Formatted for display: "MMM d, yyyy"
  final String startDateRaw; // Raw ISO format for editing
  final String? endDateRaw; // Raw ISO format for editing
  final bool isActive;
  final String? imageUrl;

  AdBannerModel({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.startDateRaw,
    this.endDateRaw,
    required this.isActive,
    this.imageUrl,
  });

  AdBannerModel copyWith({
    String? id,
    String? title,
    String? startDate,
    String? endDate,
    String? startDateRaw,
    String? endDateRaw,
    bool? isActive,
    String? imageUrl,
  }) {
    return AdBannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startDateRaw: startDateRaw ?? this.startDateRaw,
      endDateRaw: endDateRaw ?? this.endDateRaw,
      isActive: isActive ?? this.isActive,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class AdminManageAdBannerController extends BaseController {
  AdminManageAdBannerController({
    required this.getAdBannersUseCase,
    required this.updateAdBannerUseCase,
  });

  final GetAdBannersUseCase getAdBannersUseCase;
  final UpdateAdBannerUseCase updateAdBannerUseCase;
  final adBanners = <AdBannerModel>[].obs;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchAdBanners();
  }

  Future<void> fetchAdBanners() async {
    final result = await executeApiCall(
      () => getAdBannersUseCase.execute(
        GetAdBannersParams(
          limit: 100, // Fetch up to 100 banners
          page: 1,
        ),
      ),
      onSuccess: () {
        logger.method('✅ Ad banners fetched successfully');
      },
      onError: (errorMessage) {
        logger.error('❌ Failed to fetch ad banners: $errorMessage');
        this.errorMessage = errorMessage;
      },
    );

    if (result != null) {
      // Map entities to view models
      adBanners.value = result.data.map((entity) {
        return AdBannerModel(
          id: entity.id.toString(),
          title: entity.title,
          startDate: _formatDate(entity.startDate),
          endDate: entity.endDate != null ? _formatDate(entity.endDate!) : 'No end date',
          startDateRaw: entity.startDate,
          endDateRaw: entity.endDate,
          isActive: entity.isActive,
          imageUrl: entity.imageUrl,
        );
      }).toList();
    }
  }

  /// Helper method to format date string
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  Future<void> refreshAdBanners() async {
    await fetchAdBanners();
  }

  void editBanner(AdBannerModel banner) {
    // Navigate to edit page with banner data
    Get.toNamed(
      AppRoutes.adminAdBannerCreationPage,
      arguments: {Arguments.banner: banner, Arguments.isEdit: true},
    );
  }

  Future<void> toggleBannerStatus(String bannerId) async {
    try {
      final index = adBanners.indexWhere((banner) => banner.id == bannerId);
      if (index == -1) {
        logger.error('Banner not found with ID: $bannerId');
        return;
      }

      final banner = adBanners[index];
      final newStatus = !banner.isActive;
      final id = int.tryParse(bannerId);

      if (id == null) {
        logger.error('Invalid banner ID: $bannerId');
        return;
      }

      logger.method('🔄 Toggling banner status - ID: $bannerId, New status: $newStatus');

      // Create update request with only status change
      final request = UpdateAdBannerRequest(
        status: newStatus ? 'active' : 'inactive',
      );

      // Call API to update banner status
      final result = await executeApiCall(
        () => updateAdBannerUseCase.execute(
          UpdateAdBannerParams(
            id: id,
            request: request,
          ),
        ),
        onSuccess: () {
          logger.method('✅ Banner status updated successfully');
        },
        onError: (errorMessage) {
          logger.error('❌ Failed to update banner status: $errorMessage');
          this.errorMessage = errorMessage;
        },
      );

      if (result != null) {
        await fetchAdBanners();
        logger.method('✅ Banner status toggled successfully');
      }
    } catch (e) {
      logger.error('❌ Unexpected error toggling banner status: $e');
      errorMessage = e.toString();
    }
  }
}
