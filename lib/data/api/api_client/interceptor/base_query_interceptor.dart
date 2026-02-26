import 'dart:io';
import 'package:dio/dio.dart';

import '../../../../di/config_module.dart';


class BaseQueryInterceptor extends InterceptorsWrapper with ConfigModule {
  static const _bearer = 'Bearer';
  static const _contentType = 'content-type';
  static const _applicationJson = 'application/json';
  static const _authorization = 'Authorization';

  /// Base domain
  String get baseUrl => appConfig.baseUrl;

  /// Access token
  String? get accessToken => appConfig.accessToken;

  /// User id
  int? get userId => appConfig.userId;

  /// Expect response json
  final bool expectResponseJson;

  /// Ignore token
  final bool ignoreToken;

  /// Ignore connection
  final bool ignoreConnection;

  /// Dio
  final Dio dio;

  BaseQueryInterceptor({
    required this.dio,
    this.expectResponseJson = false,
    this.ignoreConnection = false,
    this.ignoreToken = false,
  });

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!ignoreToken && accessToken != null) {
      options.headers.addAll(<String, String>{_authorization: '$accessToken'});
    }
    return super.onRequest(options.copyWith(baseUrl: baseUrl), handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    final isInValidAuthResponse = await _isInValidAuthenticationResponse(response);
    if (isInValidAuthResponse) {
      final requestOptions = response.requestOptions;
      final newAccessToken = await _getRefreshToken();
      if (newAccessToken != null) {
        dio.options.headers[_authorization] = '$_bearer $newAccessToken';
        final newResponse = await dio.request<dynamic>(
          requestOptions.path,
          options: Options(extra: requestOptions.extra, method: requestOptions.method),
          cancelToken: requestOptions.cancelToken,
          onReceiveProgress: requestOptions.onReceiveProgress,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );
        if (newResponse.statusCode != HttpStatus.unauthorized) {
          return super.onResponse(newResponse, handler);
        } else {
          throw DioException(
            requestOptions: newResponse.requestOptions,
            response: newResponse,
            type: DioExceptionType.badResponse,
            error: 'Invalid token or current token is expired. Please try logging in again!',
          );
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Cannot obtain the refresh token',
        );
      }
    }
    if (!isResponseOkButNoContent(response) && expectResponseJson) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: 'Response format is not a json response',
      );
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If ignoreToken is true (like for login), don't try to refresh tokens
    if (ignoreToken || !err.shouldRetry || err.badRequest) {
      return super.onError(err, handler);
    }
    final requestOptions = err.requestOptions;
    final newAccessToken = await _getRefreshToken();
    if (newAccessToken != null) {
      dio.options.headers[_authorization] = '$_bearer $newAccessToken';
      try {
        final response = await dio.request<dynamic>(
          requestOptions.path,
          options: Options(extra: requestOptions.extra, method: requestOptions.method),
          cancelToken: requestOptions.cancelToken,
          onReceiveProgress: requestOptions.onReceiveProgress,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
        );
        if (response.statusCode != HttpStatus.unauthorized &&
            response.statusCode != HttpStatus.badRequest) {
          // In some cases, the badRequest status is using for another logic.
          return handler.resolve(response);
        } else {
          return super.onError(err, handler);
        }
      } on DioException catch (error) {
        return super.onError(error, handler);
      }
    } else {
      return super.onError(err, handler);
    }
  }

  bool isResponseOkButNoContent(Response response) => response.statusCode == HttpStatus.noContent;

  bool? isResponseHeaderTypeJson(Map<String, List<String>> headerMap) {
    return headerMap[_contentType]
        ?.firstWhere((element) => element.contains(_applicationJson), orElse: () => '')
        .contains(_applicationJson);
  }

  Future<bool> _isInValidAuthenticationResponse(Response? response) async {
    return response?.statusCode == HttpStatus.unauthorized ||
        response?.statusCode == HttpStatus.forbidden;
  }

  Future<String?> _getRefreshToken() async {
    const newToken = '';
    return newToken;
  }
}

extension on DioException {
  bool get shouldRetry => response?.statusCode == HttpStatus.unauthorized;

  bool get badRequest => response?.statusCode == HttpStatus.badRequest;
}
