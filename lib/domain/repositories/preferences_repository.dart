abstract class PreferencesRepository {

  Future<void> setHasOnboarding(bool value);

  Future<bool?> getHasOnboarding();

  Future<void> setAccessToken(String token);

  Future<String?> getAccessToken();

  Future<void> clearPreferences();

}
