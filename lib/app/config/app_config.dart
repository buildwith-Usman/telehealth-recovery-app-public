import '../../di/client_module.dart';
import '../environments/environment.dart';
import '../services/app_storage.dart';

// App Configurations
mixin AppConfigType {
  /// Base domain
  late String baseUrl;

  /// Access token
  String? accessToken;

  /// Access token
  String? userName;

  /// Access token
  String? userEmail;

  /// User id
  int? userId;
}

class AppConfig with AppConfigType, ClientModule {
  static final AppConfig shared = AppConfig._instance();
  final _appStorage = AppStorage.instance;

  factory AppConfig({required Environment env}) {
    shared.env = env;
    return shared;
  }

  AppConfig._instance();

  Environment? env;

  @override
  String get baseUrl => env?.baseDomain ?? '';

  @override
  String? get accessToken {
    return _appStorage.accessToken != null
        ? "Bearer ${_appStorage.accessToken}"
        : null;
  }

  @override
  int get userId => _appStorage.userId ?? 0;

  @override
  String? get userName => _appStorage.userName;

  @override
  String? get userEmail => _appStorage.userEmail;
}
