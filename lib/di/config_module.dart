import '../app/config/app_config.dart';

mixin ConfigModule {
  /// App config
  AppConfigType get appConfig {
    return AppConfig.shared;
  }
}
