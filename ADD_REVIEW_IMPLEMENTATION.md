# Add Review/Rating API Implementation

## Overview
This implementation follows the **Clean Architecture** pattern: **API Client → Data Source → Repository → Mapper → Use Case → Controller**.

The `add-reviews` API endpoint allows patients to submit ratings and reviews for doctors after a consultation.

## API Details

**Endpoint**: `POST /api/add-reviews`

**Request Body**:
```json
{
  "receiver_id": 11,
  "rating": 5,
  "appointment_id": 1,
  "message": "Great doctor!"
}
```

**Response**:
```json
{
  "sender_id": 8,
  "receiver_id": 11,
  "appointment_id": 1,
  "rating": 5,
  "message": "Great doctor!",
  "updated_at": "2025-12-24T16:03:26.000000Z",
  "created_at": "2025-12-24T16:03:26.000000Z",
  "id": 2
}
```

---

## Implementation Layers

### 1. **API Client** (`lib/data/api/api_client/api_client_type.dart`)
```dart
@retrofit.POST('/api/add-reviews')
Future<BaseResponse<ReviewResponse>> addReview(
  @retrofit.Body() AddReviewRequest request,
);
```

### 2. **Request Model** (`lib/data/api/request/add_review_request.dart`)
```dart
@JsonSerializable()
class AddReviewRequest {
  final int receiverId;
  final int rating;
  final int appointmentId;
  final String? message;
  
  // JSON serialization...
}
```

### 3. **Response Model** (`lib/data/api/response/review_response.dart`)
Already exists and maps:
- `sender_id` → senderId
- `receiver_id` → receiverId
- `appointment_id` → appointmentId
- `message` → message (review text)
- `rating` → rating

### 4. **Data Source** 
**Interface** (`lib/data/datasource/review/review_datasource.dart`):
```dart
abstract class ReviewDatasource {
  Future<ReviewResponse?> addReview(AddReviewRequest request);
}
```

**Implementation** (`lib/data/datasource/review/review_datasource_impl.dart`):
- Calls `apiClient.addReview(request)`
- Handles `DioException` and converts to `BaseErrorResponse`
- Includes debug logging

### 5. **Mapper** (`lib/data/mapper/review_mapper.dart`)
Already exists and converts `ReviewResponse` to `DoctorReviewEntity`:
```dart
static DoctorReviewEntity toReviewEntity(ReviewResponse response) {
  return DoctorReviewEntity(
    id: response.id,
    userId: response.receiverId,      // doctor ID
    reviewerId: response.senderId,    // patient ID
    rating: response.rating,
    review: response.message,
    appointmentId: response.appointmentId?.toString(),
    createdAt: response.createdAt,
    updatedAt: response.updatedAt,
  );
}
```

### 6. **Repository**
**Interface** (`lib/domain/repositories/review_repository.dart`):
```dart
abstract class ReviewRepository {
  Future<DoctorReviewEntity?> addReview(AddReviewRequest request);
}
```

**Implementation** (`lib/data/repository/review_repository_impl.dart`):
- Delegates to `ReviewDatasource`
- Maps response using `ReviewMapper`
- Handles errors and converts to `BaseErrorEntity`

### 7. **Use Case** (`lib/domain/usecase/add_review_use_case.dart`)
```dart
class AddReviewUseCase 
    implements ParamUseCase<DoctorReviewEntity?, AddReviewRequest> {
  final ReviewRepository repository;

  @override
  Future<DoctorReviewEntity?> execute(AddReviewRequest request) async {
    return await repository.addReview(request);
  }
}
```

### 8. **Dependency Injection**

**DatasourceModule** (`lib/di/datasource_module.dart`):
```dart
ReviewDatasource get reviewDatasource {
  return ReviewDatasourceImpl(apiClient: apiClient);
}
```

**RepositoryModule** (`lib/di/repository_module.dart`):
```dart
ReviewRepository get reviewRepository {
  return ReviewRepositoryImpl(reviewDatasource: reviewDatasource);
}
```

**UseCaseModule** (`lib/di/usecase_module.dart`):
```dart
AddReviewUseCase get addReviewUseCase {
  return AddReviewUseCase(repository: reviewRepository);
}
```

### 9. **Controller Integration** (`lib/presentation/patient_home/patient_home_controller.dart`)

**Constructor**:
```dart
PatientHomeController({
  required this.getUserUseCase,
  required this.getPaginatedDoctorsListUseCase,
  required this.getPaginatedAppointmentsListUseCase,
  required this.addReviewUseCase,  // NEW
});
```

**Submit Review Method**:
```dart
Future<void> _submitReview({
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
    onSuccess: () => logger.method('✅ Review submitted successfully'),
    onError: (error) => logger.method('⚠️ Failed to submit review: $error'),
  );

  if (result != null) {
    Get.snackbar('Success', 'Thank you for your feedback!', ...);
  } else {
    Get.snackbar('Error', 'Failed to submit review...', ...);
  }
}
```

**Rating Bottom Sheet Integration**:
```dart
await showRatingBottomSheet(
  Get.context!,
  doctorName: data['doctorName'] ?? '',
  doctorImageUrl: data['doctorImageUrl'],
  onSubmitRating: (rating, review) async {
    await _submitReview(
      receiverId: data['receiverId'],      // doctor ID
      rating: rating,
      appointmentId: data['appointmentId'],
      message: review,
    );
  },
);
```

### 10. **Binding** (`lib/presentation/patient_home/patient_home_binding.dart`)
```dart
Get.lazyPut<PatientHomeController>(
  () => PatientHomeController(
    getUserUseCase: getUserUseCase,
    getPaginatedDoctorsListUseCase: getPaginatedDoctorsListUseCase,
    getPaginatedAppointmentsListUseCase: getPaginatedAppointmentsListUseCase,
    addReviewUseCase: addReviewUseCase,  // NEW
  ),
);
```

### 11. **Video Call Flow** (`lib/presentation/video_call/video_call_controller.dart`)

When ending a call, pass doctor ID in post-call data:
```dart
Future<void> _navigatePatientAfterCall() async {
  final postCallData = {
    'showRating': true,
    'doctorName': participantName,
    'doctorImageUrl': participantImageUrl.isNotEmpty ? participantImageUrl : null,
    'appointmentId': int.tryParse(appointmentId) ?? 0,
    'receiverId': _appointment?.docUserId ?? 0,  // Doctor ID
  };

  Get.offAllNamed(AppRoutes.navScreen, arguments: postCallData);
}
```

---

## Data Flow

1. **User ends video call** → Video call controller prepares post-call data including `docUserId`
2. **Navigation to home** → Data passed via `Get.arguments`
3. **Home controller detects data** → Shows rating bottom sheet with post-call context
4. **User submits rating** → `onSubmitRating` callback triggered
5. **Controller executes use case** → `addReviewUseCase.execute(request)`
6. **Use case calls repository** → Repository delegates to data source
7. **Data source calls API** → `POST /api/add-reviews`
8. **Response mapped** → `ReviewResponse` → `DoctorReviewEntity`
9. **Success/error handling** → Shows snackbar to user

---

## Files Created/Modified

### Created Files:
- ✅ `lib/data/api/request/add_review_request.dart`
- ✅ `lib/data/datasource/review/review_datasource.dart`
- ✅ `lib/data/datasource/review/review_datasource_impl.dart`
- ✅ `lib/domain/repositories/review_repository.dart`
- ✅ `lib/data/repository/review_repository_impl.dart`
- ✅ `lib/domain/usecase/add_review_use_case.dart`

### Modified Files:
- ✅ `lib/data/api/api_client/api_client_type.dart` - Added `addReview` endpoint
- ✅ `lib/di/datasource_module.dart` - Added review datasource
- ✅ `lib/di/repository_module.dart` - Added review repository
- ✅ `lib/di/usecase_module.dart` - Added review use case
- ✅ `lib/presentation/patient_home/patient_home_controller.dart` - Added review submission logic
- ✅ `lib/presentation/patient_home/patient_home_binding.dart` - Injected use case
- ✅ `lib/presentation/video_call/video_call_controller.dart` - Pass doctor ID in post-call data

---

## Usage Example

After a video call ends:
1. Rating bottom sheet auto-shows on patient home screen
2. User enters rating (1-5 stars) and optional review message
3. Clicks "Submit"
4. API call triggered with:
   ```json
   {
     "receiver_id": 11,
     "rating": 5,
     "appointment_id": 1,
     "message": "Great doctor!"
   }
   ```
5. Success message shown to user
6. Review saved to database

---

## Testing Checklist

- [ ] Review request created with correct fields
- [ ] API client endpoint added and generated
- [ ] Data source calls API and handles errors
- [ ] Mapper correctly converts response to entity
- [ ] Repository delegates and wraps errors
- [ ] Use case executes via repository
- [ ] Controller injects and uses use case
- [ ] Post-call data includes doctor ID
- [ ] Bottom sheet submission triggers review API call
- [ ] Success/error snackbars display correctly
- [ ] Rating persists in database
