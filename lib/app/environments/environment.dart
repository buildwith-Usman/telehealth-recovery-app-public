import 'package:recovery_consultation_app/app/environments/production_env.dart';
import 'package:recovery_consultation_app/app/environments/development_env.dart';

class Environment {
  static const String dev = 'DEV';
  static const String liv = 'LIV';

  /// Prod environment
  factory Environment.production() {
    return ProductionEnv.env();
  }

  /// Dev environment
  factory Environment.development() {
    return DevelopmentEnv.env();
  }

  static Environment getConfigEnvironment(String env) {
    switch (env.toUpperCase()) {
      case dev:
        return Environment.development();
        case liv:
        return Environment.production();
      default:
        return Environment.production();
    }
  }

  Environment({
    required this.envName,
    required this.baseDomain
  });

  final String envName;
  final String baseDomain;
}
