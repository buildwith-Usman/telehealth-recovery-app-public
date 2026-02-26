import 'package:recovery_consultation_app/data/api/response/file_response.dart';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';

class FileMapper {
  static FileEntity toFileEntity(
    FileData response,
  ) {
    return FileEntity(
      id: response.id ?? 0,
      fileName: response.fileName,
      fileExtension: response.fileExtension,
      mimeType: response.mimeType,
      size: response.size.toString(),
      url: response.url,
      temp: response.temp
    );
  }
}
