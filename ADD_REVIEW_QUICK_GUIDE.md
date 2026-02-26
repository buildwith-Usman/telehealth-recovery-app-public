# Add Review API - Quick Integration Guide

## What Was Implemented

A complete **add review/rating** API integration following the **Clean Architecture** pattern in your codebase.

---

## Files Overview

### New Files Created (6):

1. **`lib/data/api/request/add_review_request.dart`**
   - JSON-serializable request model for the API
   - Fields: `receiverId`, `rating`, `appointmentId`, `message`

2. **`lib/data/datasource/review/review_datasource.dart`**
   - Abstract interface for review data operations
   - Single method: `addReview(AddReviewRequest)`

3. **`lib/data/datasource/review/review_datasource_impl.dart`**
   - Concrete implementation of `ReviewDatasource`
   - Calls `apiClient.addReview()` and handles DioException

4. **`lib/domain/repositories/review_repository.dart`**
   - Abstract repository interface for domain layer
   - Single method: `addReview(AddReviewRequest)`

5. **`lib/data/repository/review_repository_impl.dart`**
   - Repository implementation
   - Delegates to datasource + maps response using `ReviewMapper`

6. **`lib/domain/usecase/add_review_use_case.dart`**
   - Domain use case for submitting reviews
   - Executes via repository

### Modified Files (7):

1. **`lib/data/api/api_client/api_client_type.dart`**
   - Added import: `add_review_request.dart`, `review_response.dart`
   - Added endpoint: `@retrofit.POST('/api/add-reviews') addReview(...)`

2. **`lib/di/datasource_module.dart`**
   - Added import: `review_datasource.dart`, `review_datasource_impl.dart`
   - Added getter: `reviewDatasource` → `ReviewDatasourceImpl`

3. **`lib/di/repository_module.dart`**
   - Added import: `review_repository.dart`, `review_repository_impl.dart`
   - Added getter: `reviewRepository` → `ReviewRepositoryImpl`

4. **`lib/di/usecase_module.dart`**
   - Added import: `add_review_use_case.dart`
   - Added getter: `addReviewUseCase` → `AddReviewUseCase`

5. **`lib/presentation/patient_home/patient_home_controller.dart`**
   - Added import: `AddReviewUseCase`, `AddReviewRequest`
   - Injected `addReviewUseCase` in constructor
   - Added `_submitReview()` method to handle API call
   - Updated `_showPostCallRatingDialog()` to call `_submitReview()` on submission

6. **`lib/presentation/patient_home/patient_home_binding.dart`**
   - Injected `addReviewUseCase` in `PatientHomeController` dependency

7. **`lib/presentation/video_call/video_call_controller.dart`**
   - Updated `_navigatePatientAfterCall()` to include `receiverId` (doctor ID) in post-call data

---

## Architecture Diagram

```
Rating Bottom Sheet (UI)
         ↓ (onSubmit: rating, message)
PatientHomeController._submitReview()
         ↓
AddReviewUseCase.execute(AddReviewRequest)
         ↓
ReviewRepository.addReview(request)
         ↓
ReviewDatasource.addReview(request)
         ↓
APIClientType.addReview(request)
         ↓
POST /api/add-reviews
         ↓
ReviewResponse (with sender_id, receiver_id, etc.)
         ↓
ReviewMapper.toReviewEntity()
         ↓
DoctorReviewEntity (domain model)
         ↓
Success/Error Snackbar to User
```

---

## Key Methods

### 1. **Submit Review** (PatientHomeController)
```dart
Future<void> _submitReview({
  required int receiverId,     // Doctor ID
  required int rating,         // 1-5 stars
  required int appointmentId,  // Appointment ID
  String? message,             // Optional review text
}) async { ... }
```

### 2. **Show Rating Dialog** (PatientHomeController)
```dart
Future<void> _showPostCallRatingDialog(Map<String, dynamic> data) async {
  await showRatingBottomSheet(
    Get.context!,
    onSubmitRating: (rating, review) async {
      await _submitReview(
        receiverId: data['receiverId'],
        rating: rating,
        appointmentId: data['appointmentId'],
        message: review,
      );
    },
  );
}
```

### 3. **Post-Call Navigation** (VideoCallController)
```dart
Future<void> _navigatePatientAfterCall() async {
  final postCallData = {
    'showRating': true,
    'doctorName': participantName,
    'docutorImageUrl': participantImageUrl,
    'appointmentId': int.tryParse(appointmentId) ?? 0,
    'receiverId': _appointment?.docUserId ?? 0,  // ← Doctor ID
  };
  Get.offAllNamed(AppRoutes.navScreen, arguments: postCallData);
}
```

---

## End-to-End Flow

### Scenario: Patient calls doctor, then rates after call ends

1. **Video Call Ends**
   - Patient or specialist clicks "End Call" button
   - VideoCallController prepares post-call data with `showRating: true`
   - Navigates to NavScreen with arguments

2. **Home Screen Loads**
   - NavController stores post-call data in `_postCallData`
   - PatientHomeController detects `showRating == true` in `_checkAndShowPostCallDialog()`
   - Rating bottom sheet auto-shows after 800ms delay

3. **Patient Rates**
   - User enters 1-5 star rating
   - User optionally enters review text
   - Clicks "Submit"

4. **API Call**
   - `onSubmitRating` callback triggers
   - `_submitReview()` creates `AddReviewRequest` with:
     ```json
     {
       "receiver_id": 11,
       "rating": 5,
       "appointment_id": 1,
       "message": "Great doctor!"
     }
     ```
   - `addReviewUseCase.execute(request)` called

5. **Backend Processing**
   - API endpoint `/api/add-reviews` receives request
   - Server saves review to database
   - Returns review response with server-generated ID and timestamps

6. **Success Feedback**
   - Response mapped to `DoctorReviewEntity`
   - Green success snackbar shows "Thank you for your feedback!"
   - Post-call data cleared from NavController

---

## Testing Checklist

- [ ] Start a video call (patient)
- [ ] End the call
- [ ] Rating bottom sheet appears on home screen
- [ ] Select rating (1-5 stars)
- [ ] Optionally enter review message
- [ ] Click "Submit"
- [ ] Check logs for `_submitReview()` debug output
- [ ] Verify success snackbar appears
- [ ] Check API response in network tab
- [ ] Confirm review saved in backend database
- [ ] Second call → verify new rating doesn't interfere

---

## Environment Setup

### Required Dependencies (Already in pubspec.yaml)
- `retrofit` - HTTP client code generation
- `json_annotation` - JSON serialization
- `get` - State management & navigation
- `dio` - HTTP client

### Build Command
```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `add_review_request.g.dart` - JSON serialization
- `api_client_type.g.dart` - Retrofit code (updated with new endpoint)

---

## Error Handling

All layers include error handling:

1. **Data Source**: Catches `DioException` → converts to `BaseErrorResponse`
2. **Repository**: Catches `BaseErrorResponse` → converts to `BaseErrorEntity`
3. **Use Case**: Throws errors up to controller
4. **Controller**: Catches errors → shows snackbar to user

### Error Snackbar Example
```dart
Get.snackbar(
  'Error',
  'Failed to submit review: Network error',
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.red,
  colorText: Colors.white,
);
```

---

## Next Steps (Optional Enhancements)

1. **Edit Review**: Add ability to update existing review
2. **Delete Review**: Allow users to remove reviews
3. **Validation**: Add client-side rating validation before submit
4. **Optimistic Update**: Show review immediately before API returns
5. **Analytics**: Track review submission metrics
6. **Notifications**: Notify doctor when they receive a new review

---

## Troubleshooting

### Build Issues
- Run `flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs`
- Check that `ReviewResponse` model exists (it does)

### Runtime Issues
- Ensure `docUserId` is passed from VideoCallController
- Check NavController receives post-call data correctly
- Verify PatientHomeController binding injects use case

### API Issues
- Verify endpoint URL is `/api/add-reviews` (not `/api/add-reviews/` with trailing slash)
- Check request body matches API spec
- Confirm auth token is included in headers (handled by Dio interceptor)

---

## Documentation References

- See `ADD_REVIEW_IMPLEMENTATION.md` for detailed architecture
- API curl in `ADD_REVIEW_IMPLEMENTATION.md` for endpoint details
- Clean Architecture pattern: `lib/data`, `lib/domain`, `lib/presentation`
