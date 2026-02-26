import 'dart:io';
import 'package:recovery_consultation_app/domain/entity/file_entity.dart';

import '../repositories/user_repository.dart';
import 'base_usecase.dart';

class UploadFileUseCase implements ParamUseCase<FileEntity?, UploadFileParams> {
  final UserRepository repository;

  UploadFileUseCase({required this.repository});

  @override
  Future<FileEntity?> execute(UploadFileParams params) async {
    final uploadFileEntity = await repository.uploadFile(params.file!, params.directory!);
    return uploadFileEntity;
  }

}

class UploadFileParams {
  final File? file;
  final String? directory;

  UploadFileParams({
    this.file,
    this.directory,
  });


}
