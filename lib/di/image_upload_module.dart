import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../domain/usecase/image_upload_use_case.dart';
import '../app/services/image_upload_service.dart';

/// Dependency injection module for image upload functionality
mixin ImageUploadModule {
  /// HTTP client for image upload
  http.Client get httpClient => Get.find<http.Client>();
  
  /// Base URL for API
  String get baseUrl => 'https://api.yourapp.com'; // Replace with actual URL
  
  /// Auth token (should come from auth service)
  String get authToken => 'your-auth-token'; // Replace with actual token getter

  /// Image upload repository
  ImageUploadRepository get imageUploadRepository => Get.find<ImageUploadRepository>(
    tag: 'imageUploadRepository',
  );

  /// Image upload use case
  ImageUploadUseCase get imageUploadUseCase => Get.find<ImageUploadUseCase>(
    tag: 'imageUploadUseCase',
  );

  /// Register image upload dependencies
  void registerImageUploadDependencies() {
    // Register ImageUploadService as singleton
    if (!Get.isRegistered<ImageUploadService>()) {
      Get.put<ImageUploadService>(ImageUploadService(), permanent: true);
    }

    // Register ImageUploadRepository
    if (!Get.isRegistered<ImageUploadRepository>(tag: 'imageUploadRepository')) {
      Get.put<ImageUploadRepository>(
        ImageUploadRepositoryImpl(
          client: httpClient,
          baseUrl: baseUrl,
          authToken: authToken,
        ),
        tag: 'imageUploadRepository',
        permanent: true,
      );
    }

    // Register ImageUploadUseCase
    if (!Get.isRegistered<ImageUploadUseCase>(tag: 'imageUploadUseCase')) {
      Get.put<ImageUploadUseCase>(
        ImageUploadUseCase(repository: imageUploadRepository),
        tag: 'imageUploadUseCase',
        permanent: true,
      );
    }
  }
}
