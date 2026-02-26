import 'package:dio/dio.dart';

import '../../../app/config/app_config.dart';
import 'api_client_type.dart';
import 'interceptor/base_query_interceptor.dart';
import 'interceptor/curl_log.dart';

class APIClient {
  static APIClientType apiClient({
    bool disableRequestBodyLogging = false,
    bool ignoreToken = false,
    bool ignoreConnection = false,
  }) {
    final dio = Dio();
    
    // Set the base URL on the Dio instance itself
    final appConfig = AppConfig.shared;
    dio.options.baseUrl = appConfig.baseUrl;
    
    dio.interceptors.add(CurlLogInterceptor());
    dio.interceptors.add(BaseQueryInterceptor(
      dio: dio,
      ignoreConnection: ignoreConnection,
      ignoreToken: ignoreToken,
    ));
    
    // Pass empty string to APIClientType since Dio already has the base URL
    return APIClientType(dio, baseUrl: '');
  }
}
