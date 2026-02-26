import 'package:recovery_consultation_app/domain/repositories/preferences_repository.dart';
import 'base_usecase.dart';

class SetHasOnboardingUseCase implements ParamUseCase<void, bool> {
  final PreferencesRepository repository;

  SetHasOnboardingUseCase({required this.repository});

  @override
  Future<void> execute(bool hasCompleted) async {
    await repository.setHasOnboarding(hasCompleted);
  }
}
