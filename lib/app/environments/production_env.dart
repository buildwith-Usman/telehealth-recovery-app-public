import 'package:recovery_consultation_app/app/environments/environment.dart';

extension ProductionEnv on Environment {
  static Environment env() {
    return Environment(
        envName: 'LIV',
        baseDomain:
            'http://recoveryapp.stacksgather.com' // Using same as development for now
        );
  }
}
