# API Implementation Structure

This document provides a comprehensive overview of how APIs are implemented in this Flutter application following **Clean Architecture** principles.

## Architecture Overview

The application follows a **3-layer Clean Architecture** pattern:

```
┌─────────────────────────────────────┐
│   PRESENTATION LAYER                │
│   (Controllers, Pages, Widgets)     │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   DOMAIN LAYER                      │
│   (Use Cases, Entities, Repositories)│
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│   DATA LAYER                        │
│   (Repositories, Data Sources, API) │
└─────────────────────────────────────┘
```

## Complete API Flow

### Flow Diagram

```
Controller
    │
    ├─► executeApiCall() [BaseController]
    │       │
    │       ├─► Sets loading state
    │       ├─► Clears errors
    │       └─► Wraps use case call
    │
    ▼
Use Case (Domain Layer)
    │
    ├─► ParamUseCase<T, Params> or NoParamUseCase<T>
    │       │
    │       └─► execute(params) → Returns Entity
    │
    ▼
Repository Interface (Domain Layer)
    │
    ├─► Abstract interface defining contract
    │
    ▼
Repository Implementation (Data Layer)
    │
    ├─► Implements domain repository interface
    ├─► Calls Data Source
    ├─► Maps API Response → Domain Entity
    └─► Handles errors (BaseErrorResponse → BaseErrorEntity)
    │
    ▼
Data Source Interface (Data Layer)
    │
    ├─► Abstract interface
    │
    ▼
Data Source Implementation (Data Layer)
    │
    ├─► Calls API Client
    ├─► Handles DioException
    └─► Converts to BaseErrorResponse
    │
    ▼
API Client (Data Layer)
    │
    ├─► Retrofit-generated HTTP client
    ├─► Uses Dio for HTTP requests
    ├─► Interceptors for auth, logging
    └─► Returns BaseResponse<T>
```

## Layer-by-Layer Breakdown

### 1. **API Client Layer** (`lib/data/api/api_client/`)

**Purpose**: Direct HTTP communication with backend

**Key Files**:
- `api_client_type.dart` - Retrofit API interface
- `api_client.dart` - Factory for creating API client instances
- `interceptor/base_query_interceptor.dart` - Handles auth tokens, refresh logic

**Example**:
```dart
@retrofit.RestApi()
abstract class APIClientType {
  factory APIClientType(Dio dio, {String baseUrl}) = _APIClientType;

  @retrofit.POST('/api/add-reviews')
  Future<BaseResponse<ReviewResponse>> addReview(
    @retrofit.Body() AddReviewRequest request,
  );
}
```

**Features**:
- Uses **Retrofit** for type-safe API definitions
- **Dio** for HTTP client functionality
- Automatic JSON serialization/deserialization
- Base URL and interceptors configured centrally

**Response Types**:
- `BaseResponse<T>` - Single object response
- `BasePagingResponse<T>` - Paginated list response
- `BaseListResponse<T>` - Simple list response

---

### 2. **Request Models** (`lib/data/api/request/`)

**Purpose**: Define request payloads sent to API

**Example**:
```dart
@JsonSerializable()
class AddReviewRequest {
  final int receiverId;
  final int rating;
  final int appointmentId;
  final String? message;
  
  AddReviewRequest({
    required this.receiverId,
    required this.rating,
    required this.appointmentId,
    this.message,
  });
  
  // JSON serialization methods...
}
```

**Features**:
- Uses `json_serializable` for automatic JSON conversion
- Clear field naming (camelCase in Dart, snake_case in JSON)
- Validation can be added here

---

### 3. **Response Models** (`lib/data/api/response/`)

**Purpose**: Define API response structures

**Example**:
```dart
@JsonSerializable()
class ReviewResponse {
  final int id;
  final int senderId;
  final int receiverId;
  final int rating;
  final String? message;
  final int? appointmentId;
  final String? createdAt;
  final String? updatedAt;
  
  // JSON deserialization...
}
```

**Base Response Wrapper**:
```dart
class BaseResponse<T> {
  final String? message;
  final T? data;
  final dynamic errors;
  
  // Handles: { "message": "...", "data": {...}, "errors": {...} }
}
```

---

### 4. **Data Source Layer** (`lib/data/datasource/`)

**Purpose**: Abstract data fetching, handles network errors

**Interface** (`review_datasource.dart`):
```dart
abstract class ReviewDatasource {
  Future<ReviewResponse?> addReview(AddReviewRequest request);
}
```

**Implementation** (`review_datasource_impl.dart`):
```dart
class ReviewDatasourceImpl implements ReviewDatasource {
  final APIClientType apiClient;

  @override
  Future<ReviewResponse?> addReview(AddReviewRequest request) async {
    try {
      final response = await apiClient.addReview(request);
      return response.data; // Extract data from BaseResponse
    } on DioException catch (error) {
      // Convert DioException to BaseErrorResponse
      throw BaseErrorResponse.fromDioException(error);
    }
  }
}
```

**Error Handling**:
- Catches `DioException` from Dio
- Converts to `BaseErrorResponse` using `BaseErrorResponse.fromDioException()`
- Handles: network errors, timeouts, HTTP errors (4xx, 5xx)

---

### 5. **Mapper Layer** (`lib/data/mapper/`)

**Purpose**: Convert API Response Models → Domain Entities

**Example** (`review_mapper.dart`):
```dart
class ReviewMapper {
  static DoctorReviewEntity toReviewEntity(ReviewResponse response) {
    return DoctorReviewEntity(
      id: response.id,
      userId: response.receiverId,
      reviewerId: response.senderId,
      rating: response.rating,
      review: response.message,
      appointmentId: response.appointmentId?.toString(),
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }
}
```

**Exception Mapper** (`exception_mapper.dart`):
```dart
class ExceptionMapper {
  static BaseErrorEntity toBaseErrorEntity(BaseErrorResponse error) {
    return BaseErrorEntity(
      statusCode: error.statusCode ?? 400,
      message: error.statusMessage ?? 'Unknown Error',
      errorCode: error.errorCode,
    );
  }
}
```

---

### 6. **Repository Layer**

**Domain Interface** (`lib/domain/repositories/review_repository.dart`):
```dart
abstract class ReviewRepository {
  Future<DoctorReviewEntity?> addReview(AddReviewRequest request);
}
```

**Implementation** (`lib/data/repository/review_repository_impl.dart`):
```dart
class ReviewRepositoryImpl extends ReviewRepository {
  final ReviewDatasource reviewDatasource;

  @override
  Future<DoctorReviewEntity?> addReview(AddReviewRequest request) async {
    try {
      final response = await reviewDatasource.addReview(request);
      if (response == null) {
        throw BaseErrorEntity.noData();
      }
      // Map API response to domain entity
      return ReviewMapper.toReviewEntity(response);
    } on BaseErrorResponse catch (error) {
      // Convert data layer error to domain error
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }
}
```

**Responsibilities**:
- Calls data source
- Maps responses to domain entities
- Converts data layer errors to domain errors
- Can add business logic validation

---

### 7. **Use Case Layer** (`lib/domain/usecase/`)

**Purpose**: Encapsulate business logic for specific operations

**Base Interfaces**:
```dart
abstract class ParamUseCase<Type, Params> {
  Future<Type> execute(Params params);
}

abstract class NoParamUseCase<Type> {
  Future<Type> execute();
}
```

**Example** (`add_review_use_case.dart`):
```dart
class AddReviewUseCase implements ParamUseCase<DoctorReviewEntity?, AddReviewRequest> {
  final ReviewRepository repository;

  AddReviewUseCase({required this.repository});

  @override
  Future<DoctorReviewEntity?> execute(AddReviewRequest request) async {
    return await repository.addReview(request);
  }
}
```

**Features**:
- Simple delegation to repository (can add validation/business logic)
- Single responsibility per use case
- Testable in isolation

---

### 8. **Controller Layer** (`lib/presentation/`)

**Base Controller** (`lib/app/controllers/base_controller.dart`):
```dart
abstract class BaseController extends GetxController {
  final isLoading = false.obs;
  final _generalError = RxnString();

  Future<T?> executeApiCall<T>(
    Future<T?> Function() apiCall, {
    VoidCallback? onSuccess,
    Function(String message)? onError,
  }) async {
    try {
      setLoading(true);
      clearGeneralError();
      
      final result = await apiCall();
      
      if (result != null) {
        setLoading(false);
        onSuccess?.call();
      }
      
      return result;
    } on BaseErrorEntity catch (error) {
      setLoading(false);
      _generalError.value = error.message;
      onError?.call(error.message);
      return null;
    } catch (e) {
      setLoading(false);
      const message = "An unexpected error occurred";
      _generalError.value = message;
      onError?.call(message);
      return null;
    } finally {
      setLoading(false);
    }
  }
}
```

**Controller Usage Example**:
```dart
class PatientHomeController extends BaseController {
  final AddReviewUseCase addReviewUseCase;

  Future<void> submitReview({
    required int receiverId,
    required int rating,
    required int appointmentId,
    String? message,
  }) async {
    final request = AddReviewRequest(
      receiverId: receiverId,
      rating: rating,
      appointmentId: appointmentId,
      message: message,
    );

    final result = await executeApiCall<DoctorReviewEntity?>(
      () => addReviewUseCase.execute(request),
      onSuccess: () {
        logger.method('✅ Review submitted successfully');
      },
      onError: (errorMessage) {
        logger.method('⚠️ Failed to submit review: $errorMessage');
      },
    );

    if (result != null) {
      // Handle success
    }
  }
}
```

**Features**:
- Automatic loading state management
- Centralized error handling
- Reactive state with GetX observables
- Performance logging

---

## Error Handling Flow

### Error Propagation Path

```
DioException (Network/HTTP Error)
    │
    ▼
BaseErrorResponse (Data Layer)
    │
    ▼
BaseErrorEntity (Domain Layer)
    │
    ▼
Controller Error Handling (Presentation Layer)
    │
    ├─► generalError.value = error.message
    ├─► onError callback
    └─► UI displays error
```

### Error Types

**BaseErrorResponse** (Data Layer):
- Network errors (connection timeout, no internet)
- HTTP errors (400, 401, 404, 422, 500, etc.)
- Timeout errors
- Request cancellation

**BaseErrorEntity** (Domain Layer):
- Standardized error representation
- Factory methods: `noNetworkError()`, `serverError()`, `unauthorizedError()`, etc.
- Status codes and messages

---

## Dependency Injection

**Location**: `lib/di/`

**Structure**:
```dart
// Repository Module
mixin RepositoryModule {
  ReviewRepository get reviewRepository => ReviewRepositoryImpl(
    reviewDatasource: reviewDatasource,
  );
}

// Use Case Module
mixin UseCaseModule on RepositoryModule {
  AddReviewUseCase get addReviewUseCase {
    return AddReviewUseCase(repository: reviewRepository);
  }
}

// Controller Binding
class ReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PatientHomeController(
      addReviewUseCase: Get.find(),
    ));
  }
}
```

---

## Key Patterns & Best Practices

### 1. **Separation of Concerns**
- Each layer has a single responsibility
- Domain layer is independent of data layer
- Presentation layer depends on domain, not data

### 2. **Error Handling**
- Errors are converted at layer boundaries
- Domain layer uses `BaseErrorEntity`
- Data layer uses `BaseErrorResponse`
- Controllers catch `BaseErrorEntity`

### 3. **Loading States**
- Managed centrally in `BaseController`
- Reactive with GetX observables
- Automatically shown/hidden via `BaseStatefulPage`

### 4. **Type Safety**
- Strong typing throughout
- Generic use cases (`ParamUseCase<T, Params>`)
- Nullable returns for error cases

### 5. **Testing**
- Each layer can be tested independently
- Use interfaces for easy mocking
- Domain layer has no external dependencies

---

## Example: Complete API Implementation

### Adding a New API Endpoint

**Step 1**: Define API endpoint in `api_client_type.dart`
```dart
@retrofit.GET('/api/new-endpoint')
Future<BaseResponse<NewResponse>> getNewData({
  @retrofit.Query('param') String? param,
});
```

**Step 2**: Create request/response models
```dart
// request/new_request.dart
class NewRequest { ... }

// response/new_response.dart
class NewResponse { ... }
```

**Step 3**: Create data source
```dart
// datasource/new/new_datasource.dart
abstract class NewDatasource {
  Future<NewResponse?> getNewData(String? param);
}

// datasource/new/new_datasource_impl.dart
class NewDatasourceImpl implements NewDatasource {
  final APIClientType apiClient;
  
  @override
  Future<NewResponse?> getNewData(String? param) async {
    try {
      final response = await apiClient.getNewData(param: param);
      return response.data;
    } on DioException catch (error) {
      throw BaseErrorResponse.fromDioException(error);
    }
  }
}
```

**Step 4**: Create mapper
```dart
// mapper/new_mapper.dart
class NewMapper {
  static NewEntity toEntity(NewResponse response) {
    return NewEntity(...);
  }
}
```

**Step 5**: Create repository
```dart
// domain/repositories/new_repository.dart
abstract class NewRepository {
  Future<NewEntity?> getNewData(String? param);
}

// data/repository/new_repository_impl.dart
class NewRepositoryImpl extends NewRepository {
  final NewDatasource datasource;
  
  @override
  Future<NewEntity?> getNewData(String? param) async {
    try {
      final response = await datasource.getNewData(param);
      if (response == null) throw BaseErrorEntity.noData();
      return NewMapper.toEntity(response);
    } on BaseErrorResponse catch (error) {
      throw ExceptionMapper.toBaseErrorEntity(error);
    }
  }
}
```

**Step 6**: Create use case
```dart
// domain/usecase/get_new_data_use_case.dart
class GetNewDataUseCase implements ParamUseCase<NewEntity?, String> {
  final NewRepository repository;
  
  @override
  Future<NewEntity?> execute(String param) async {
    return await repository.getNewData(param);
  }
}
```

**Step 7**: Use in controller
```dart
class MyController extends BaseController {
  final GetNewDataUseCase getNewDataUseCase;
  
  Future<void> loadData() async {
    final result = await executeApiCall<NewEntity?>(
      () => getNewDataUseCase.execute('param'),
      onSuccess: () => logger.method('✅ Data loaded'),
      onError: (msg) => logger.error('❌ Error: $msg'),
    );
    
    if (result != null) {
      // Use result
    }
  }
}
```

---

## File Structure Summary

```
lib/
├── data/
│   ├── api/
│   │   ├── api_client/
│   │   │   ├── api_client_type.dart      # Retrofit API definitions
│   │   │   └── interceptor/              # Auth, logging interceptors
│   │   ├── request/                      # Request models
│   │   └── response/                     # Response models
│   ├── datasource/                       # Data source interfaces & impls
│   ├── mapper/                           # API → Domain mappers
│   └── repository/                       # Repository implementations
│
├── domain/
│   ├── entity/                           # Domain entities (business objects)
│   ├── repositories/                     # Repository interfaces
│   └── usecase/                          # Use cases
│
└── presentation/
    └── [feature]/                        # Controllers, pages, widgets
        └── [feature]_controller.dart     # Uses use cases via executeApiCall
```

---

## Key Takeaways

1. **Clean Architecture**: Clear separation between layers
2. **Dependency Rule**: Inner layers don't depend on outer layers
3. **Error Handling**: Errors converted at layer boundaries
4. **Type Safety**: Strong typing throughout the stack
5. **Testability**: Each layer can be tested independently
6. **Reusability**: Use cases and repositories are reusable
7. **Maintainability**: Changes in one layer don't affect others

---

## Common Patterns

### GET Request with Query Parameters
```dart
@retrofit.GET('/api/endpoint')
Future<BaseResponse<Response>> getData({
  @retrofit.Query('param1') String? param1,
  @retrofit.Query('param2') int? param2,
});
```

### POST Request with Body
```dart
@retrofit.POST('/api/endpoint')
Future<BaseResponse<Response>> postData(
  @retrofit.Body() Request request,
);
```

### Paginated Response
```dart
@retrofit.GET('/api/endpoint')
Future<BasePagingResponse<ItemResponse>> getPaginatedData({
  @retrofit.Query('page') int? page,
  @retrofit.Query('limit') int? limit,
});
```

---

This structure ensures maintainable, testable, and scalable API implementations following industry best practices.
