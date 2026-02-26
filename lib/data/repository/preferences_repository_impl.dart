import 'package:recovery_consultation_app/app/services/app_storage.dart';
import 'package:recovery_consultation_app/domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final AppStorage _appStorage;

  PreferencesRepositoryImpl({AppStorage? appStorage}) 
      : _appStorage = appStorage ?? AppStorage.instance;

  @override
  Future<void> setHasOnboarding(bool value) async {
    await _appStorage.setHasOnboarding(value);
  }

  @override
  Future<bool?> getHasOnboarding() async {
    return _appStorage.hasOnboardingBool;
  }

  @override
  Future<void> setAccessToken(String token) async {
    await _appStorage.setAccessToken(token);
  }

  @override
  Future<String?> getAccessToken() async {
    return _appStorage.accessToken;
  }

  @override
  Future<void> clearPreferences() async {
    _appStorage.clearGetStorage();
  }
}
