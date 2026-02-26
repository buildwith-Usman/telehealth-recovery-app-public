import '../data/api/api_client/api_client.dart';
import '../data/api/api_client/api_client_type.dart';

mixin ClientModule {

  /// Default client - injects token
  APIClientType get apiClient => APIClient.apiClient();

  /// Unauthenticated client - does NOT inject token
  APIClientType get unauthenticatedClient => APIClient.apiClient(ignoreToken: true);

}
