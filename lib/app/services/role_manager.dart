import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_enum.dart';

class RoleManager extends GetxController {
  static RoleManager get instance => Get.find<RoleManager>();

  final Rx<UserRole?> _currentRole = Rx<UserRole?>(null);
  final Rx<SpecialistType?> _currentSpecialistType = Rx<SpecialistType?>(null);

  UserRole? get currentRole => _currentRole.value;
  SpecialistType? get currentSpecialistType => _currentSpecialistType.value;

  // Basic role checks
  bool get isPatient => _currentRole.value == UserRole.patient;
  bool get isSpecialist => _currentRole.value == UserRole.doctor;
  bool get isAdmin => _currentRole.value == UserRole.admin;

  // Specialist sub-type checks
  bool get isTherapist =>
      isSpecialist && _currentSpecialistType.value == SpecialistType.therapist;
  bool get isPsychiatrist =>
      isSpecialist &&
      _currentSpecialistType.value == SpecialistType.psychiatrist;

  @override
  void onInit() {
    super.onInit();
    _loadRole();
  }

  // Set role (for patient and admin)
  Future<void> setRole(UserRole role) async {
    _currentRole.value = role;
    if (role != UserRole.doctor) {
      _currentSpecialistType.value =
          null; // Clear specialist type if not specialist
    }
    await _saveToStorage();
  }

  // Set specialist role with specific type
  Future<void> setSpecialistRole(SpecialistType specialistType) async {
    _currentRole.value = UserRole.doctor;
    _currentSpecialistType.value = specialistType;
    await _saveToStorage();
  }

  // Clear role (logout)
  Future<void> clearRole() async {
    _currentRole.value = null;
    _currentSpecialistType.value = null;
    await _clearStorage();
  }

  // Storage methods
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentRole.value != null) {
      await prefs.setString('user_role', _currentRole.value!.name);
    }
    if (_currentSpecialistType.value != null) {
      await prefs.setString(
          'specialist_type', _currentSpecialistType.value!.name);
    } else {
      await prefs.remove('specialist_type');
    }
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();

    // Load main role
    final roleString = prefs.getString('user_role');
    if (roleString != null) {
      _currentRole.value = UserRole.values.firstWhere(
        (role) => role.name == roleString,
        orElse: () => UserRole.patient,
      );
    }

    // Load specialist type if user is a specialist
    if (_currentRole.value == UserRole.doctor) {
      final specialistTypeString = prefs.getString('specialist_type');
      if (specialistTypeString != null) {
        _currentSpecialistType.value = SpecialistType.values.firstWhere(
          (type) => type.name == specialistTypeString,
          orElse: () => SpecialistType.therapist,
        );
      }
    }
  }

  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role');
    await prefs.remove('specialist_type');
  }
}
