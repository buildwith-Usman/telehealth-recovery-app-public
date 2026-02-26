import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../config/app_enum.dart';

enum AppStorageKey {
  hasOnboarding,
  baseUrl,
  accessToken,
  userId,
  userName,
  userEmail,
  refreshToken,
  userRole,
  pendingRatingData,
  pendingNotesData,
}

class AppStorage {
  AppStorage._();

  static final instance = AppStorage._();
  final _box = GetStorage();

  Future<void> ensureInitialized() async {
    await GetStorage.init();
  }

  String? get hasOnboarding {
    return _box.read(AppStorageKey.hasOnboarding.name);
  }

  /// Get hasOnboarding as bool - properly typed
  bool? get hasOnboardingBool {
    final value = _box.read(AppStorageKey.hasOnboarding.name);
    if (value == null) return null;
    
    // Handle both bool and string types for backward compatibility
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value == 'true';
    }
    
    return null;
  }

  Future<void> setHasOnboarding(bool value) async {
    await _box.write(AppStorageKey.hasOnboarding.name, value);
  }

  // Base domain
  String? get baseUrl {
    return _box.read(AppStorageKey.baseUrl.name);
  }

  Future<void> setBaseUrl(String value) async {
    await _box.write(AppStorageKey.baseUrl.name, value);
  }

  // Access token
  String? get accessToken {
    return _box.read(AppStorageKey.accessToken.name);
  }

  Future<void> setAccessToken(String value) async {
    await _box.write(AppStorageKey.accessToken.name, value);
  }

  // User id
  int? get userId {
    return _box.read(AppStorageKey.userId.name);
  }

  Future<void> setUserId(int value) async {
    await _box.write(AppStorageKey.userId.name, value);
  }

  String? get userName {
    return _box.read(AppStorageKey.userName.name);
  }

  Future<void> setUserName(String value) async {
    await _box.write(AppStorageKey.userName.name, value);
  }

  String? get userEmail {
    return _box.read(AppStorageKey.userEmail.name);
  }

  Future<void> setUserEmail(String value) async {
    await _box.write(AppStorageKey.userEmail.name, value);
  }

  // Refresh token
  String? get refreshToken {
    return _box.read(AppStorageKey.refreshToken.name);
  }

  Future<void> setRefreshToken(String value) async {
    await _box.write(AppStorageKey.refreshToken.name, value);
  }

  Future<void> setupAppConfig({
    required String baseUrl,
    required int userId,
  }) async {
    await AppStorage.instance.setBaseUrl(baseUrl);
    await AppStorage.instance.setUserId(userId);
  }

  // setup config for token
  Future<void> setupAppConfigForToken({
    required String baseUrl,
  }) async {
    await AppStorage.instance.setBaseUrl(baseUrl);
  }

  UserRole? get userRole {
    final roleString = _box.read(AppStorageKey.userRole.name);
    if (roleString == null) return null;
    return UserRole.values.firstWhereOrNull((e) => e.name == roleString);
  }

  Future<void> setUserRole(UserRole role) async {
    await _box.write(AppStorageKey.userRole.name, role.name);
  }

  // Pending rating data
  Map<String, dynamic>? get pendingRatingData {
    final data = _box.read(AppStorageKey.pendingRatingData.name);
    if (data == null) return null;
    return Map<String, dynamic>.from(data as Map);
  }

  Future<void> setPendingRatingData(Map<String, dynamic> data) async {
    await _box.write(AppStorageKey.pendingRatingData.name, data);
  }

  Future<void> clearPendingRatingData() async {
    await _box.remove(AppStorageKey.pendingRatingData.name);
  }

  // Pending notes data
  Map<String, dynamic>? get pendingNotesData {
    final data = _box.read(AppStorageKey.pendingNotesData.name);
    if (data == null) return null;
    return Map<String, dynamic>.from(data as Map);
  }

  Future<void> setPendingNotesData(Map<String, dynamic> data) async {
    await _box.write(AppStorageKey.pendingNotesData.name, data);
  }

  Future<void> clearPendingNotesData() async {
    await _box.remove(AppStorageKey.pendingNotesData.name);
  }

  void clearGetStorage() {
    final box = GetStorage();
    box.erase(); // This clears all key-value pairs
  }
}
