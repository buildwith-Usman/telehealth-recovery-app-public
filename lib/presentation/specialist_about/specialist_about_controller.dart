import 'package:get/get.dart';
import 'package:recovery_consultation_app/app/services/role_manager.dart';
import 'package:recovery_consultation_app/presentation/specialist/specialist_view_controller.dart';
import '../../app/controllers/base_controller.dart';

/// Controller for the About tab
/// Delegates data access to the parent SpecialistViewController
class SpecialistAboutController extends BaseController {

  // ==================== DEPENDENCIES ====================
  late final SpecialistViewController _parentController;

  // ==================== GETTERS ====================
  // All getters delegate to parent controller for shared data
  String get patientsCount => _parentController.patientsCount;
  String get experienceDisplay => _parentController.experienceDisplay;
  String get ratingDisplay => _parentController.ratingDisplay;
  String get specialistBio => _parentController.specialistBio;

  // Reviews data
  bool get hasReviews => _parentController.specialist.value?.reviews?.isNotEmpty ?? false;
  List<dynamic> get reviews => _parentController.specialist.value?.reviews ?? [];

  // ==================== INITIALIZATION ====================
  RoleManager roleManager = RoleManager.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeScreen();
  }

  // ==================== METHODS ====================

  void _initializeScreen() {
    // Get parent controller to access shared specialist data
    _parentController = Get.find<SpecialistViewController>();
  }
}
