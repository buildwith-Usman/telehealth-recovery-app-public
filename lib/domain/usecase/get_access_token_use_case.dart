import 'package:recovery_consultation_app/domain/repositories/preferences_repository.dart';
import 'base_usecase.dart';

class GetAccessTokenUseCase implements NoParamUseCase<String?> {
  final PreferencesRepository repository;

  GetAccessTokenUseCase({required this.repository});

  @override
  Future<String?> execute() async {
    final token = await repository.getAccessToken();
    // Add "Bearer " prefix if token exists, like AppConfig was doing
    return token != null ? "Bearer $token" : null;
  }
}
