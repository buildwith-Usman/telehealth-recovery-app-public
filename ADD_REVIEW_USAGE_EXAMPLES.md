# Add Review API - Usage Examples

## 1. Direct API Call from Controller

```dart
// In PatientHomeController or any controller
final addReviewUseCase = Get.find<AddReviewUseCase>();

final request = AddReviewRequest(
  receiverId: 11,              // Doctor ID
  rating: 5,                   // 1-5 stars
  appointmentId: 1,            // Appointment ID
  message: "Great doctor!",    // Optional review text
);

final result = await addReviewUseCase.execute(request);

if (result != null) {
  print('Review submitted successfully!');
  print('Review ID: ${result.id}');
  print('Rating: ${result.rating} stars');
} else {
  print('Failed to submit review');
}
```

---

## 2. Post-Call Rating Flow (Implemented)

```dart
// In PatientHomeController._showPostCallRatingDialog()

// Rating bottom sheet callback
onSubmitRating: (rating, review) async {
  await _submitReview(
    receiverId: data['receiverId'],       // Extracted from post-call data
    rating: rating,
    appointmentId: data['appointmentId'],
    message: review,
  );
}
```

---

## 3. Video Call Navigation (Implemented)

```dart
// In VideoCallController._navigatePatientAfterCall()

final postCallData = {
  'showRating': true,
  'doctorName': participantName,
  'doctorImageUrl': participantImageUrl,
  'appointmentId': int.tryParse(appointmentId) ?? 0,
  'receiverId': _appointment?.docUserId ?? 0,  // Doctor ID
};

Get.offAllNamed(AppRoutes.navScreen, arguments: postCallData);
```

---

## 4. Manual Binding (in Case of Custom Widget)

If you create a custom widget to submit reviews:

```dart
class ReviewSubmissionWidget extends StatefulWidget {
  final int doctorId;
  final int appointmentId;

  const ReviewSubmissionWidget({
    required this.doctorId,
    required this.appointmentId,
  });

  @override
  State<ReviewSubmissionWidget> createState() => _ReviewSubmissionWidgetState();
}

class _ReviewSubmissionWidgetState extends State<ReviewSubmissionWidget> {
  final addReviewUseCase = Get.find<AddReviewUseCase>();
  
  int selectedRating = 0;
  final reviewController = TextEditingController();

  Future<void> _submitReview() async {
    if (selectedRating == 0) {
      Get.snackbar('Error', 'Please select a rating');
      return;
    }

    final request = AddReviewRequest(
      receiverId: widget.doctorId,
      rating: selectedRating,
      appointmentId: widget.appointmentId,
      message: reviewController.text.isEmpty ? null : reviewController.text,
    );

    try {
      final result = await addReviewUseCase.execute(request);
      if (result != null) {
        Get.snackbar('Success', 'Review submitted!');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit review: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Star rating widget
        RatingBar.builder(
          onRatingUpdate: (rating) => selectedRating = rating.toInt(),
        ),
        // Review text field
        TextField(
          controller: reviewController,
          decoration: InputDecoration(hintText: 'Write your review...'),
          maxLines: 3,
        ),
        // Submit button
        ElevatedButton(
          onPressed: _submitReview,
          child: const Text('Submit Review'),
        ),
      ],
    );
  }
}
```

---

## 5. Test Request/Response Example

### Request
```bash
curl -X POST https://app.therecovery.io/api/add-reviews \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_TOKEN' \
  -d '{
    "receiver_id": 11,
    "rating": 5,
    "appointment_id": 1,
    "message": "Great doctor!"
  }'
```

### Response (Success - 200/201)
```json
{
  "status": "success",
  "data": {
    "id": 2,
    "sender_id": 8,
    "receiver_id": 11,
    "appointment_id": 1,
    "rating": 5,
    "message": "Great doctor!",
    "created_at": "2025-12-24T16:03:26.000000Z",
    "updated_at": "2025-12-24T16:03:26.000000Z"
  }
}
```

### Response (Error)
```json
{
  "status": "error",
  "message": "Validation failed",
  "errors": {
    "receiver_id": ["The receiver id field is required."],
    "rating": ["The rating must be between 1 and 5."]
  }
}
```

---

## 6. DI Resolution Path (For Debugging)

If you want to verify DI wiring:

```dart
// Check if use case is registered
if (Get.isRegistered<AddReviewUseCase>()) {
  print('✅ AddReviewUseCase is registered');
} else {
  print('❌ AddReviewUseCase is NOT registered');
}

// Access via Get.find
final useCase = Get.find<AddReviewUseCase>();
print('Repository: ${useCase.repository}');
print('Datasource: ${useCase.repository.reviewDatasource}');
print('APIClient: ${useCase.repository.reviewDatasource.apiClient}');
```

---

## 7. Advanced: Custom Success/Error Handling

```dart
Future<void> _submitReviewAdvanced() async {
  try {
    // Show loading
    Get.dialog(
      const Dialog(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );

    final request = AddReviewRequest(
      receiverId: 11,
      rating: 5,
      appointmentId: 1,
      message: "Great doctor!",
    );

    final result = await addReviewUseCase.execute(request);

    // Dismiss loading dialog
    Get.back();

    if (result != null) {
      // Success with detailed info
      Get.snackbar(
        'Thank You!',
        'Your review has been submitted',
        icon: const Icon(Icons.check_circle, color: Colors.white),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Log review details
      print('Review submitted:');
      print('  ID: ${result.id}');
      print('  Rating: ${result.rating} stars');
      print('  For: Doctor #${result.userId}');
      print('  Appointment: #${result.appointmentId}');
      print('  Created: ${result.createdAt}');

      // Navigate after delay
      Future.delayed(const Duration(seconds: 2), () {
        Get.back(); // Close rating widget
      });
    } else {
      Get.snackbar(
        'Error',
        'Unable to submit review. Please try again.',
        icon: const Icon(Icons.error, color: Colors.white),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } on Exception catch (e) {
    Get.back(); // Dismiss loading

    Get.snackbar(
      'Failed',
      'Error: ${e.toString()}',
      icon: const Icon(Icons.warning, color: Colors.white),
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}
```

---

## 8. Response Entity Field Mapping

The `ReviewResponse` is mapped to `DoctorReviewEntity` as follows:

| Response Field | Entity Field | Notes |
|---|---|---|
| `id` | `id` | Review unique identifier |
| `sender_id` | `reviewerId` | Patient who left the review |
| `receiver_id` | `userId` | Doctor receiving the review |
| `rating` | `rating` | 1-5 star rating |
| `message` | `review` | Review comment text |
| `appointment_id` | `appointmentId` (String) | Associated appointment |
| `created_at` | `createdAt` | Creation timestamp |
| `updated_at` | `updatedAt` | Last update timestamp |

---

## 9. Common Issues & Solutions

### Issue: "AddReviewUseCase not registered"
**Solution**: Ensure PatientHomeBinding is loaded before accessing the use case.
```dart
// In patient_home_page.dart
Get.lazyPut<PatientHomeBinding>(() => PatientHomeBinding());
```

### Issue: "receiverId is null"
**Solution**: Verify VideoCallController passes `docUserId` in post-call data.
```dart
// Add this debug print
print('Doctor ID: ${_appointment?.docUserId}');
```

### Issue: "Review not saved"
**Solution**: Check network tab and verify:
1. Authorization header is present
2. Request body is valid JSON
3. Receiver ID (doctor) exists
4. Appointment ID exists

### Issue: "Rating shows NaN"
**Solution**: Ensure rating is an integer 1-5 before API call.
```dart
if (rating < 1 || rating > 5) {
  Get.snackbar('Error', 'Rating must be between 1 and 5');
  return;
}
```

---

## 10. Debug Logging

Enable debug mode to see detailed logs:

```dart
// In PatientHomeController._submitReview()
if (kDebugMode) {
  print('PatientHomeController: Submitting review...');
  print('  receiverId: $receiverId');
  print('  rating: $rating');
  print('  appointmentId: $appointmentId');
  print('  message: $message');
}
```

Check console output:
```
I/flutter: 🔍 REVIEW DATASOURCE DEBUG: About to call add review API
I/flutter: 🔍 REVIEW DATASOURCE DEBUG: Request - receiver_id: 11
I/flutter: 🔍 REVIEW DATASOURCE DEBUG: Request - rating: 5
I/flutter: 🔍 REVIEW DATASOURCE DEBUG: Request - appointment_id: 1
I/flutter: 🔍 REVIEW DATASOURCE DEBUG: Request - message: Great doctor!
I/flutter: 🔍 REVIEW DATASOURCE DEBUG: Add review API call completed successfully
I/flutter: PatientHomeController: Review submitted successfully
I/flutter:   Review ID: 2
I/flutter:   Rating: 5
```

---

## Summary

The implementation is **production-ready** and follows clean architecture principles:

✅ **Separation of Concerns** - Each layer has a single responsibility  
✅ **Dependency Injection** - Via GetX with proper module registration  
✅ **Error Handling** - Consistent error mapping across layers  
✅ **Type Safety** - Strong typing with entities, requests, responses  
✅ **Testability** - Easy to mock repositories and data sources  
✅ **Debugging** - Comprehensive logging at each layer  

**Ready to deploy!** 🚀
