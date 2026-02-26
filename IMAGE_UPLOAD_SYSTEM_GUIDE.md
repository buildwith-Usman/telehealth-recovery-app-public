# 🖼️ Robust & Reusable Image Upload System

This documentation provides a complete guide for using the robust and reusable image upload system across different screens in your Recovery Consultation Mobile App.

## 📋 Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Core Components](#core-components)
3. [Quick Start Guide](#quick-start-guide)
4. [Usage Examples](#usage-examples)
5. [API Integration](#api-integration)
6. [Customization Options](#customization-options)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

## 🏗️ Architecture Overview

The image upload system follows a clean, modular architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────┐ │
│  │  UI Widgets     │  │   Controllers    │  │   Bindings  │ │
│  │  - ImageUpload  │  │  - with Mixin    │  │  - DI Setup │ │
│  │    Widget       │  │  - BaseController│  │             │ │
│  └─────────────────┘  └──────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                           │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────┐ │
│  │   Use Cases     │  │    Entities      │  │  Repository │ │
│  │ - ImageUpload   │  │ - ImageUpload    │  │  Interface  │ │
│  │   UseCase       │  │   Response       │  │             │ │
│  └─────────────────┘  └──────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                  │
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────────┐  ┌──────────────────┐  ┌─────────────┐ │
│  │  Repository     │  │   Services       │  │   Mixins    │ │
│  │  Implementation │  │ - ImageUpload    │  │ - ImageUpload│ │
│  │                 │  │   Service        │  │   Mixin      │ │
│  └─────────────────┘  └──────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🧩 Core Components

### 1. ImageUploadService (Singleton Service)
- **Location**: `lib/app/services/image_upload_service.dart`
- **Purpose**: Centralized service for all image upload operations
- **Features**:
  - Camera & gallery access with permissions
  - Bottom sheet selection UI
  - Image compression & optimization
  - Error handling & user feedback

### 2. ImageUploadMixin (Reusable Mixin)
- **Location**: `lib/app/mixins/image_upload_mixin.dart`
- **Purpose**: Provides image upload functionality to any controller
- **Features**:
  - Reactive observables for selected images
  - Pre-configured settings for different use cases
  - Validation & error handling
  - Single & multiple image selection

### 3. ImageUploadWidget (UI Components)
- **Location**: `lib/app/widgets/image_upload_widget.dart`
- **Purpose**: Reusable UI components for image display and selection
- **Components**:
  - `ImageUploadWidget`: Single image display with edit functionality
  - `MultiImageUploadWidget`: Grid view for multiple images
  - `ImageUploadProgress`: Upload progress indicator

### 4. ImageUploadRepository & UseCase (API Integration)
- **Location**: `lib/domain/usecase/image_upload_use_case.dart`
- **Purpose**: Backend API integration for actual image uploads
- **Features**:
  - Multipart form data upload
  - Progress tracking
  - Multiple upload endpoints (profile, documents, gallery)

## 🚀 Quick Start Guide

### Step 1: Add Dependencies to Your Controller

```dart
class YourController extends BaseController with ImageUploadMixin {
  YourController({
    required this.imageUploadUseCase,
  });

  final ImageUploadUseCase imageUploadUseCase;

  // Your existing code...
}
```

### Step 2: Set Up Dependency Injection

```dart
class YourBinding extends Bindings with ImageUploadModule {
  @override
  void dependencies() {
    // Register image upload dependencies
    registerImageUploadDependencies();
    
    // Register your controller
    Get.lazyPut(() => YourController(
      imageUploadUseCase: imageUploadUseCase,
    ));
  }
}
```

### Step 3: Use in Your UI

```dart
class YourPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<YourController>();
    
    return Scaffold(
      body: Column(
        children: [
          // Single image upload
          Obx(() => ImageUploadWidget(
            imageFile: controller.selectedImage.value,
            onTap: () => controller.showImagePicker(),
            isLoading: controller.isImageProcessing.value,
          )),
          
          // Multiple image upload
          Obx(() => MultiImageUploadWidget(
            imageFiles: controller.selectedImages,
            onAddImage: () => controller.pickMultipleFromGallery(),
            onRemoveImage: (index) => controller.removeImageAt(index),
          )),
        ],
      ),
    );
  }
}
```

## 💡 Usage Examples

### Profile Image Upload
```dart
class ProfileController extends BaseController with ImageUploadMixin {
  Future<void> updateProfileImage() async {
    await showImagePickerWithConfig(
      ImageUploadMixin.createProfileImageConfig(),
      (imageFile) {
        if (imageFile != null) {
          // Handle selected image
          uploadProfileImage(imageFile);
        }
      },
    );
  }
}
```

### Document Verification
```dart
class DocumentController extends BaseController with ImageUploadMixin {
  final RxMap<String, File> documents = <String, File>{}.obs;
  
  Future<void> selectDocument(String documentType) async {
    await showImagePickerWithConfig(
      ImageUploadMixin.createDocumentImageConfig(),
      (imageFile) {
        if (imageFile != null) {
          documents[documentType] = imageFile;
        }
      },
    );
  }
}
```

### Chat Image Attachment
```dart
class ChatController extends BaseController with ImageUploadMixin {
  Future<void> attachImage() async {
    await showImagePickerWithConfig(
      const ImageUploadConfig(
        title: 'Attach Image',
        maxWidth: 1080,
        maxHeight: 1080,
      ),
      (imageFile) => sendMessageWithImage(imageFile),
    );
  }
}
```

## 🔗 API Integration

### Upload Profile Image
```dart
Future<void> uploadProfileImage() async {
  if (!hasSelectedImage) return;
  
  try {
    final response = await imageUploadUseCase.uploadProfileImage(
      selectedImage.value!,
      onProgress: (progress) {
        // Update UI with progress
        uploadProgress.value = progress;
      },
    );
    
    if (response.success) {
      // Handle successful upload
      profileImageUrl.value = response.imageUrl!;
    }
  } catch (e) {
    // Handle error
    ImageUploadService.to.showErrorSnackbar('Upload failed');
  }
}
```

### Backend Endpoints
The system expects these API endpoints:

```
POST /api/upload/profile-image  - Profile image upload
POST /api/upload/document       - Document upload  
POST /api/upload/multiple       - Multiple images upload
DELETE /api/upload/delete       - Delete uploaded image
```

## 🎨 Customization Options

### Custom Image Upload Configuration
```dart
const customConfig = ImageUploadConfig(
  maxWidth: 1200,           // Max image width
  maxHeight: 1200,          // Max image height
  imageQuality: 85,         // Compression quality (0-100)
  title: 'Custom Title',    // Bottom sheet title
  showRemoveOption: true,   // Show remove button
  cameraText: 'Take Photo', // Custom button text
  galleryText: 'Choose',    // Custom button text
);
```

### Custom UI Styling
```dart
ImageUploadWidget(
  size: 150,                           // Widget size
  shape: BoxShape.rectangle,           // Circle or rectangle
  borderRadius: BorderRadius.circular(12),
  editIconColor: Colors.white,
  editIconBackground: Colors.blue,
  boxShadow: [/* custom shadows */],
)
```

## 📝 Best Practices

### 1. **Use Appropriate Configurations**
```dart
// Profile images - small, high quality
ImageUploadMixin.createProfileImageConfig()

// Documents - larger, higher quality
ImageUploadMixin.createDocumentImageConfig()  

// Gallery - medium size, lower quality for multiple
ImageUploadMixin.createGalleryImageConfig()
```

### 2. **Handle Errors Gracefully**
```dart
try {
  await uploadImage();
} catch (e) {
  if (e is BaseErrorEntity) {
    // Handle API errors with user-friendly messages
    ImageUploadService.to.showErrorSnackbar(e.message);
  } else {
    // Handle unexpected errors
    ImageUploadService.to.showErrorSnackbar('Something went wrong');
  }
}
```

### 3. **Provide Visual Feedback**
```dart
Obx(() => ImageUploadWidget(
  isLoading: controller.isImageProcessing.value,
  onTap: controller.isImageProcessing.value ? null : controller.showImagePicker,
))
```

### 4. **Validate Images**
```dart
bool validateImage(File imageFile) {
  return controller.validateImageFile(imageFile);
}
```

## 🛠️ Troubleshooting

### Common Issues & Solutions

#### 1. **Permission Denied**
- **Problem**: Camera/gallery access denied
- **Solution**: The system automatically handles permission requests and shows settings dialog for permanently denied permissions

#### 2. **Image Too Large**
- **Problem**: Selected image exceeds size limits
- **Solution**: Adjust `maxWidth`, `maxHeight`, and `imageQuality` in `ImageUploadConfig`

#### 3. **Upload Fails**
- **Problem**: Network errors or server issues
- **Solution**: Implement retry logic and check network connectivity

#### 4. **Memory Issues**
- **Problem**: Large images cause memory problems
- **Solution**: Use appropriate compression settings and dispose of images properly

### Debug Information
Enable debug logging:
```dart
if (kDebugMode) {
  print('Image upload debug info...');
}
```

## 📊 Performance Considerations

### Image Optimization
- **Compression**: Default 80% quality reduces file size significantly
- **Resizing**: Max dimensions prevent oversized uploads
- **Format**: JPEG for photos, PNG for graphics with transparency

### Memory Management
- **Dispose**: Controllers properly dispose of image observables
- **Caching**: Network images are cached automatically
- **File Cleanup**: Temporary files are handled by the system

## 🧪 Testing

### Unit Tests
```dart
test('should validate image file correctly', () {
  final controller = TestController();
  final validFile = File('test_image.jpg');
  
  expect(controller.validateImageFile(validFile), isTrue);
});
```

### Integration Tests
```dart
testWidgets('should show image picker on tap', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byType(ImageUploadWidget));
  await tester.pumpAndSettle();
  
  expect(find.text('Select Image'), findsOneWidget);
});
```

## 🔄 Migration from Existing Code

### Replace Existing Image Upload Code
1. **Remove** old image picker implementations
2. **Add** `ImageUploadMixin` to your controllers  
3. **Replace** custom UI with `ImageUploadWidget`
4. **Update** API calls to use `ImageUploadUseCase`

### Example Migration
```dart
// OLD CODE
class OldController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  
  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    // Manual handling...
  }
}

// NEW CODE  
class NewController extends BaseController with ImageUploadMixin {
  Future<void> pickImage() async {
    await showImagePicker(
      onImageSelected: (file) {
        // Automatic handling with validation & feedback
      },
    );
  }
}
```

---

## 🎯 Summary

This robust image upload system provides:

✅ **Reusable Components** - Use across multiple screens with minimal setup
✅ **Clean Architecture** - Proper separation of concerns and testability  
✅ **Rich Features** - Permissions, validation, progress tracking, error handling
✅ **Customizable** - Flexible configuration for different use cases
✅ **Production Ready** - Comprehensive error handling and edge case coverage
✅ **Well Documented** - Clear examples and best practices

The system is designed to be **developer-friendly**, **maintainable**, and **scalable** for your Recovery Consultation Mobile App's growing image upload needs.
