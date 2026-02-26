import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../entity/error_entity.dart';

/// Response model for image upload
class ImageUploadResponse {
  final String? imageUrl;
  final String? fileName;
  final int? fileSize;
  final String message;
  final bool success;

  ImageUploadResponse({
    this.imageUrl,
    this.fileName,
    this.fileSize,
    required this.message,
    required this.success,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      imageUrl: json['image_url'] ?? json['url'],
      fileName: json['file_name'] ?? json['name'],
      fileSize: json['file_size'] ?? json['size'],
      message: json['message'] ?? 'Upload completed',
      success: json['success'] ?? true,
    );
  }
}

/// Progress callback for upload tracking
typedef UploadProgressCallback = void Function(double progress);

/// Repository interface for image uploads
abstract class ImageUploadRepository {
  Future<ImageUploadResponse> uploadProfileImage(
    File imageFile, {
    UploadProgressCallback? onProgress,
  });

  Future<ImageUploadResponse> uploadDocumentImage(
    File imageFile, {
    String? documentType,
    UploadProgressCallback? onProgress,
  });

  Future<List<ImageUploadResponse>> uploadMultipleImages(
    List<File> imageFiles, {
    UploadProgressCallback? onProgress,
  });

  Future<bool> deleteImage(String imageUrl);
}

/// Implementation of ImageUploadRepository
class ImageUploadRepositoryImpl implements ImageUploadRepository {
  final http.Client _client;
  final String _baseUrl;
  final String _authToken;

  ImageUploadRepositoryImpl({
    required http.Client client,
    required String baseUrl,
    required String authToken,
  })  : _client = client,
        _baseUrl = baseUrl,
        _authToken = authToken;

  @override
  Future<ImageUploadResponse> uploadProfileImage(
    File imageFile, {
    UploadProgressCallback? onProgress,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/upload/profile-image'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $_authToken',
        'Accept': 'application/json',
      });

      // Add file
      final fileStream = http.ByteStream(imageFile.openRead());
      final fileLength = await imageFile.length();
      final multipartFile = http.MultipartFile(
        'profile_image',
        fileStream,
        fileLength,
        filename: basename(imageFile.path),
      );
      
      request.files.add(multipartFile);

      // Send request with progress tracking
      final streamedResponse = await _client.send(request);
      
      // Track progress if callback provided
      if (onProgress != null) {
        _trackProgress(streamedResponse, onProgress);
      }

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = 
            json.decode(response.body) as Map<String, dynamic>;
        return ImageUploadResponse.fromJson(responseData['data'] ?? responseData);
      } else {
        throw BaseErrorEntity(
          message: 'Failed to upload profile image: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is BaseErrorEntity) rethrow;
      throw BaseErrorEntity(
        message: 'Upload failed: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<ImageUploadResponse> uploadDocumentImage(
    File imageFile, {
    String? documentType,
    UploadProgressCallback? onProgress,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/upload/document'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $_authToken',
        'Accept': 'application/json',
      });

      // Add file
      final fileStream = http.ByteStream(imageFile.openRead());
      final fileLength = await imageFile.length();
      final multipartFile = http.MultipartFile(
        'document_image',
        fileStream,
        fileLength,
        filename: basename(imageFile.path),
      );
      
      request.files.add(multipartFile);

      // Add document type if provided
      if (documentType != null) {
        request.fields['document_type'] = documentType;
      }

      // Send request
      final streamedResponse = await _client.send(request);
      
      // Track progress if callback provided
      if (onProgress != null) {
        _trackProgress(streamedResponse, onProgress);
      }

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = 
            json.decode(response.body) as Map<String, dynamic>;
        return ImageUploadResponse.fromJson(responseData['data'] ?? responseData);
      } else {
        throw BaseErrorEntity(
          message: 'Failed to upload document: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is BaseErrorEntity) rethrow;
      throw BaseErrorEntity(
        message: 'Upload failed: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<List<ImageUploadResponse>> uploadMultipleImages(
    List<File> imageFiles, {
    UploadProgressCallback? onProgress,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/api/upload/multiple'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $_authToken',
        'Accept': 'application/json',
      });

      // Add files
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        final fileStream = http.ByteStream(imageFile.openRead());
        final fileLength = await imageFile.length();
        final multipartFile = http.MultipartFile(
          'images[]', // Array field name
          fileStream,
          fileLength,
          filename: basename(imageFile.path),
        );
        request.files.add(multipartFile);
      }

      // Send request
      final streamedResponse = await _client.send(request);
      
      // Track progress if callback provided
      if (onProgress != null) {
        _trackProgress(streamedResponse, onProgress);
      }

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = 
            json.decode(response.body) as Map<String, dynamic>;
        
        final List<dynamic> imagesData = responseData['data']['images'] ?? [];
        return imagesData
            .map((imageData) => ImageUploadResponse.fromJson(imageData))
            .toList();
      } else {
        throw BaseErrorEntity(
          message: 'Failed to upload images: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is BaseErrorEntity) rethrow;
      throw BaseErrorEntity(
        message: 'Upload failed: $e',
        statusCode: 500,
      );
    }
  }

  @override
  Future<bool> deleteImage(String imageUrl) async {
    try {
      final response = await _client.delete(
        Uri.parse('$_baseUrl/api/upload/delete'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'image_url': imageUrl}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw BaseErrorEntity(
          message: 'Failed to delete image: ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is BaseErrorEntity) rethrow;
      throw BaseErrorEntity(
        message: 'Delete failed: $e',
        statusCode: 500,
      );
    }
  }

  /// Track upload progress (simplified implementation)
  void _trackProgress(
    http.StreamedResponse response, 
    UploadProgressCallback onProgress,
  ) {
    // Note: Real progress tracking requires custom HTTP implementation
    // This is a simplified version that simulates progress
    int received = 0;
    final total = response.contentLength ?? 100;
    
    response.stream.listen(
      (chunk) {
        received += chunk.length;
        final progress = received / total;
        onProgress(progress.clamp(0.0, 1.0));
      },
      onDone: () => onProgress(1.0),
      onError: (error) => onProgress(0.0),
    );
  }
}

/// Use case for handling image uploads with business logic
class ImageUploadUseCase {
  final ImageUploadRepository _repository;

  ImageUploadUseCase({required ImageUploadRepository repository})
      : _repository = repository;

  /// Upload profile image with validation
  Future<ImageUploadResponse> uploadProfileImage(
    File imageFile, {
    UploadProgressCallback? onProgress,
  }) async {
    // Validate image file
    _validateImageFile(imageFile);

    // Upload to repository
    return await _repository.uploadProfileImage(
      imageFile,
      onProgress: onProgress,
    );
  }

  /// Upload document image with validation
  Future<ImageUploadResponse> uploadDocumentImage(
    File imageFile, {
    String? documentType,
    UploadProgressCallback? onProgress,
  }) async {
    // Validate image file
    _validateImageFile(imageFile);

    // Upload to repository
    return await _repository.uploadDocumentImage(
      imageFile,
      documentType: documentType,
      onProgress: onProgress,
    );
  }

  /// Upload multiple images with validation
  Future<List<ImageUploadResponse>> uploadMultipleImages(
    List<File> imageFiles, {
    UploadProgressCallback? onProgress,
  }) async {
    // Validate all image files
    for (final imageFile in imageFiles) {
      _validateImageFile(imageFile);
    }

    // Upload to repository
    return await _repository.uploadMultipleImages(
      imageFiles,
      onProgress: onProgress,
    );
  }

  /// Delete image
  Future<bool> deleteImage(String imageUrl) async {
    if (imageUrl.isEmpty) {
      throw BaseErrorEntity(
        statusCode: 400,
        message: 'Image URL cannot be empty',
      );
    }

    return await _repository.deleteImage(imageUrl);
  }

  /// Validate image file
  void _validateImageFile(File imageFile) {
    // Check if file exists
    if (!imageFile.existsSync()) {
      throw BaseErrorEntity(
        statusCode: 400,
        message: 'Image file does not exist',
      );
    }

    // Check file size (max 10MB)
    const maxSizeInBytes = 10 * 1024 * 1024;
    final fileSize = imageFile.lengthSync();
    if (fileSize > maxSizeInBytes) {
      throw BaseErrorEntity(
        statusCode: 400,
        message: 'Image size must be less than 10MB',
      );
    }

    // Check file extension
    final allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    final extension = basename(imageFile.path).split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw BaseErrorEntity(
        statusCode: 400,
        message: 'Please select a valid image format (jpg, png, gif, webp)',
      );
    }
  }
}
