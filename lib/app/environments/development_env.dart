import 'package:recovery_consultation_app/app/environments/environment.dart';

extension DevelopmentEnv on Environment {
  static Environment env() {
    return Environment(
        envName: 'DEV', baseDomain: 'https://app.therecovery.io');
  }
}
