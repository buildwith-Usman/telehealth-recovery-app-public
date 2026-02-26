import 'package:recovery_consultation_app/app/services/role_manager.dart';
import '../../app/controllers/base_controller.dart';

class SpecialistReviewController extends BaseController {


  // ==================== DEPENDENCIES ====================

  // ==================== OBSERVABLES ====================

  // ==================== REACTIVE VARIABLES ====================

  // Screen configuration

  //Arguments


  // ==================== GETTERS ====================

  // ==================== HELPER METHODS ====================
 

  // ==================== INITIALIZATION ====================
  RoleManager roleManager = RoleManager.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeScreen();
  }

  // ==================== METHODS ====================

  void _initializeScreen() {
  
  }

}
