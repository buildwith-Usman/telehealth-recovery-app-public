import 'package:recovery_consultation_app/domain/repositories/preferences_repository.dart';
import 'base_usecase.dart';

class GetHasOnboardingUseCase implements NoParamUseCase<bool?> {
  final PreferencesRepository repository;

  GetHasOnboardingUseCase({required this.repository});

  @override
  Future<bool?> execute() async {
    return await repository.getHasOnboarding();
  }
}
