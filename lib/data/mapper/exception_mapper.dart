import '../../domain/entity/error_entity.dart';
import '../api/response/error_response.dart';

class ExceptionMapper {
  static BaseErrorEntity toBaseErrorEntity(BaseErrorResponse error) {
    return BaseErrorEntity(
      statusCode: error.statusCode ?? 400,
      message: error.statusMessage ?? 'Unknown Error',
      errorCode: error.errorCode,
    );
  }
}
