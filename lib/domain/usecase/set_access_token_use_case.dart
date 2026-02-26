import 'package:recovery_consultation_app/domain/repositories/preferences_repository.dart';
import 'base_usecase.dart';

class SetAccessTokenUseCase implements ParamUseCase<void, String> {
  final PreferencesRepository repository;

  SetAccessTokenUseCase({required this.repository});

  @override
  Future<void> execute(String token) async {
    await repository.setAccessToken(token);
  }
}
