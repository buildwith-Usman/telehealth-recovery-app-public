import 'package:recovery_consultation_app/domain/entity/base_entity.dart';

class FileEntity extends BaseEntity {
  final String? fileName;
  final String? fileExtension;
  final String? mimeType;
  final String? size;
  final String? path;
  final String? url;
  final int? temp;

  const FileEntity({
    required super.id,
    this.fileName,
    this.fileExtension,
    this.mimeType,
    this.size,
    this.path,
    this.url,
    this.temp,
    super.createdAt,
    super.updatedAt,
  });

  @override
  String toString() {
    return 'QuestioniareItemEntityEntity(id: $id, fileName: $fileName, extension: $fileExtension, mimeType: $mimeType, answers: $url, key: $size, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
