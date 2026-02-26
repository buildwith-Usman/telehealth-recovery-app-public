import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Standardized error response class for API error handling
class BaseErrorResponse implements Exception {
  const BaseErrorResponse({
    this.statusCode,
    this.statusMessage,
    this.errorCode,
    this.details,
  });

  /// The HTTP status code for the response
  final int? statusCode;

  /// The error message from the server or a fallback message
  final String? statusMessage;

  /// API-specific error code for categorizing errors
  final String? errorCode;

  /// Additional error details or context
  final Map<String, dynamic>? details;

  // ==================== FACTORY CONSTRUCTORS ====================

  /// Creates an unknown error response with default values
  factory BaseErrorResponse.unknownError() => const BaseErrorResponse(
        statusCode: 400,
        statusMessage: 'Server Error',
      );

  /// Creates a network connectivity error response
  factory BaseErrorResponse.networkError() => const BaseErrorResponse(
        statusCode: 0,
        statusMessage: 'Network connectivity error',
        errorCode: 'NETWORK_ERROR',
      );

  /// Creates a timeout error response
  factory BaseErrorResponse.timeoutError() => const BaseErrorResponse(
        statusCode: 408,
        statusMessage: 'Request timeout',
        errorCode: 'TIMEOUT_ERROR',
      );

  /// Creates a server error response for 5xx status codes
  factory BaseErrorResponse.serverError([int? statusCode]) => BaseErrorResponse(
        statusCode: statusCode ?? 500,
        statusMessage: 'Internal server error',
        errorCode: 'SERVER_ERROR',
      );

  /// Creates an authorization error response
  factory BaseErrorResponse.unauthorizedError() => const BaseErrorResponse(
        statusCode: 401,
        statusMessage: 'Unauthorized access',
        errorCode: 'UNAUTHORIZED',
      );

  /// Primary factory for converting DioException to BaseErrorResponse
  factory BaseErrorResponse.fromDioException(DioException exception) {
    debugPrint("🔍 BaseErrorResponse: Processing DioException");
    debugPrint("🔍 BaseErrorResponse: Exception type: ${exception.type}");
    debugPrint("🔍 BaseErrorResponse: Status code: ${exception.response?.statusCode}");
    debugPrint("🔍 BaseErrorResponse: Response data: ${exception.response?.data}");
    debugPrint("🔍 BaseErrorResponse: Error message: ${exception.message}");
    
    // Handle different DioException types
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        debugPrint("⏰ BaseErrorResponse: Timeout error detected");
        return BaseErrorResponse.timeoutError();

      case DioExceptionType.connectionError:
        debugPrint("🌐 BaseErrorResponse: Connection error detected");
        return BaseErrorResponse.networkError();

      case DioExceptionType.badResponse:
        debugPrint("🔍 BaseErrorResponse: Bad response detected - processing HTTP error");
        return BaseErrorResponse._handleBadResponse(exception);

      case DioExceptionType.cancel:
        debugPrint("⏹️ BaseErrorResponse: Request cancelled");
        return const BaseErrorResponse(
          statusCode: 499,
          statusMessage: 'Request cancelled',
          errorCode: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.unknown:
      default:
        debugPrint("❓ BaseErrorResponse: Unknown error detected");
        return BaseErrorResponse._handleUnknownError(exception);
    }
  }

  /// Handles HTTP response errors (4xx, 5xx status codes)
  static BaseErrorResponse _handleBadResponse(DioException exception) {
    final statusCode = exception.response?.statusCode ?? 400;
    final responseData = exception.response?.data;

    debugPrint("🔍 BaseErrorResponse: Processing HTTP $statusCode error");
    debugPrint("🔍 BaseErrorResponse: Response data: $responseData");
    
    // Log specific status codes for common issues
    switch (statusCode) {
      case 401:
        debugPrint("🔒 BaseErrorResponse: Unauthorized - Invalid credentials or expired token");
        break;
      case 403:
        debugPrint("🚫 BaseErrorResponse: Forbidden - Access denied");
        break;
      case 404:
        debugPrint("🔍 BaseErrorResponse: Not Found - Resource does not exist");
        break;
      case 422:
        debugPrint("📝 BaseErrorResponse: Validation Error - Invalid input data");
        break;
      case 500:
        debugPrint("💥 BaseErrorResponse: Internal Server Error");
        break;
      default:
        if (statusCode >= 500) {
          debugPrint("🔥 BaseErrorResponse: Server Error ($statusCode)");
        } else if (statusCode >= 400) {
          debugPrint("⚠️ BaseErrorResponse: Client Error ($statusCode)");
        }
    }

    try {
      if (responseData is Map<String, dynamic>) {
        final message = _extractMessage(responseData);
        final errorCode = _extractErrorCode(responseData);
        debugPrint("📋 BaseErrorResponse: Extracted message: '$message'");
        debugPrint("📋 BaseErrorResponse: Extracted error code: '$errorCode'");
        
        return BaseErrorResponse(
          statusCode: statusCode,
          statusMessage: message,
          errorCode: errorCode,
          details: responseData,
        );
      }
    } catch (e) {
      debugPrint("❌ BaseErrorResponse: Failed to parse response data: $e");
      // Fallback if response parsing fails
    }

    final defaultMessage = _getDefaultMessage(statusCode);
    final defaultCode = _getDefaultErrorCode(statusCode);
    debugPrint("📋 BaseErrorResponse: Using default message: '$defaultMessage'");
    debugPrint("📋 BaseErrorResponse: Using default error code: '$defaultCode'");

    return BaseErrorResponse(
      statusCode: statusCode,
      statusMessage:
          exception.response?.statusMessage ?? defaultMessage,
      errorCode: defaultCode,
    );
  }

  /// Handles unknown or unexpected errors
  static BaseErrorResponse _handleUnknownError(DioException exception) {
    return BaseErrorResponse(
      statusCode: exception.response?.statusCode ?? 0,
      statusMessage: exception.message ?? 'An unexpected error occurred',
      errorCode: 'UNKNOWN_ERROR',
      details: {'originalError': exception.toString()},
    );
  }

  /// Extracts error message from response data with multiple fallback strategies
  static String _extractMessage(Map<String, dynamic> data) {
    // Try different common message field names
    final messageKeys = [
      'error',
      'errors',
      'message',
      'detail',
      'msg'
    ];

    for (final key in messageKeys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return 'Unknown Error';
  }

  /// Extracts error code from response data
  static String? _extractErrorCode(Map<String, dynamic> data) {
    final codeKeys = ['errorCode', 'code', 'error_code'];

    for (final key in codeKeys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  /// Provides default error messages based on HTTP status codes
  static String _getDefaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Validation Error';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';
      default:
        return statusCode >= 500 ? 'Server Error' : 'Client Error';
    }
  }

  /// Provides default error codes based on HTTP status codes
  static String _getDefaultErrorCode(int statusCode) {
    if (statusCode >= 500) {
      return 'SERVER_ERROR';
    } else if (statusCode >= 400) {
      return 'CLIENT_ERROR';
    }
    return 'UNKNOWN_ERROR';
  }

  // ==================== LEGACY COMPATIBILITY ====================

  /// Legacy method - use fromDioException instead
  @Deprecated('Use fromDioException instead')
  factory BaseErrorResponse.handleErrorResponse(DioException exception) {
    return BaseErrorResponse.fromDioException(exception);
  }

  // ==================== UTILITY METHODS ====================

  /// Returns true if this is a network-related error
  bool get isNetworkError => statusCode == 0;

  /// Returns true if this is a server error (5xx)
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Returns true if this is a client error (4xx)
  bool get isClientError =>
      statusCode != null && statusCode! >= 400 && statusCode! < 500;

  /// Returns true if this is an authorization error
  bool get isAuthError => statusCode == 401 || statusCode == 403;

  @override
  String toString() {
    return 'BaseErrorResponse(statusCode: $statusCode, statusMessage: $statusMessage, errorCode: $errorCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseErrorResponse &&
        other.statusCode == statusCode &&
        other.statusMessage == statusMessage &&
        other.errorCode == errorCode;
  }

  @override
  int get hashCode => Object.hash(statusCode, statusMessage, errorCode);
}
