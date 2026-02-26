class BaseErrorEntity {
  BaseErrorEntity({
    required this.statusCode,
    required this.message,
    this.errorCode,
  });

  final int statusCode;
  final String message;
  final String? errorCode;

  // Common error factory constructors
  factory BaseErrorEntity.noNetworkError() => BaseErrorEntity(
      statusCode: 0,
      message: 'You will need an internet connection to continue.');

  factory BaseErrorEntity.noData() =>
      BaseErrorEntity(statusCode: 1, message: 'No data.');

  factory BaseErrorEntity.serverError() =>
      BaseErrorEntity(statusCode: 500, message: 'Internal server error.');

  factory BaseErrorEntity.unauthorizedError() =>
      BaseErrorEntity(statusCode: 401, message: 'Unauthorized access.');

  factory BaseErrorEntity.forbiddenError() =>
      BaseErrorEntity(statusCode: 403, message: 'Access forbidden.');

  factory BaseErrorEntity.notFoundError() =>
      BaseErrorEntity(statusCode: 404, message: 'Resource not found.');

  factory BaseErrorEntity.validationError(String message) =>
      BaseErrorEntity(statusCode: 422, message: message);

  factory BaseErrorEntity.unknownError() =>
      BaseErrorEntity(statusCode: -1, message: 'Unknown Error');

  @override
  String toString() => 'BaseErrorEntity(statusCode: $statusCode, message: $message, errorCode: $errorCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseErrorEntity &&
          runtimeType == other.runtimeType &&
          statusCode == other.statusCode &&
          message == other.message &&
          errorCode == other.errorCode;

  @override
  int get hashCode => statusCode.hashCode ^ message.hashCode ^ errorCode.hashCode;
}
