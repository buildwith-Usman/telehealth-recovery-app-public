import 'package:json_annotation/json_annotation.dart';
import 'package:recovery_consultation_app/app/config/app_config.dart';

part 'file_response.g.dart';

@JsonSerializable()
class FileResponse {
  @JsonKey(name: 'file')
  final FileData? file;

  const FileResponse({this.file});

  factory FileResponse.fromJson(Map<String, dynamic> json) =>
      _$FileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileResponseToJson(this);
}

@JsonSerializable()
class FileData {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'file_name')
  final String? fileName;

  @JsonKey(name: 'extension')
  final String? fileExtension;

  @JsonKey(name: 'mime_type')
  final String? mimeType;

  // 👇 Accepts either int or string for size
  @JsonKey(name: 'size', fromJson: _sizeFromJson, toJson: _sizeToJson)
  final int? size;

  @JsonKey(name: 'path')
  final String? path;

  @JsonKey(name: 'url')
  final String? url;

  // 👇 Handles null or missing temp field
  @JsonKey(name: 'temp')
  final int? temp;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  const FileData({
    this.id,
    this.fileName,
    this.fileExtension,
    this.mimeType,
    this.size,
    this.path,
    this.url,
    this.temp,
    this.createdAt,
    this.updatedAt,
  });

  factory FileData.fromJson(Map<String, dynamic> json) =>
      _$FileDataFromJson(json);

  Map<String, dynamic> toJson() => _$FileDataToJson(this);

  // ----------- Custom Type Handling -----------

  static int? _sizeFromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static dynamic _sizeToJson(int? value) => value;

  // ----------- Helper Getters -----------

  bool get isTemporary => temp == 1;

  String getFullUrl({String? baseUrl}) {
    if (url == null || url!.isEmpty) return '';

    if (url!.startsWith('http')) return url!;

    String base = baseUrl ?? AppConfig.shared.baseUrl;

    if (base.isNotEmpty && !base.endsWith('/')) {
      base = '$base/';
    }

    String path = url!.startsWith('/') ? url!.substring(1) : url!;
    return base.isNotEmpty ? '$base$path' : url!;
  }

  String get formattedSize {
    final bytes = size;
    if (bytes == null) return 'Unknown size';

    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  bool get isImage => mimeType?.startsWith('image/') ?? false;

  bool get isDocument {
    final docExtensions = ['pdf', 'doc', 'docx', 'txt', 'rtf'];
    final docMimeTypes = [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'text/plain',
      'application/rtf'
    ];

    return docMimeTypes.contains(mimeType) ||
        docExtensions.contains(fileExtension?.toLowerCase());
  }
}
