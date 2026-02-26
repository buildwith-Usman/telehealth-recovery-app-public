# Average Rating Widget - Usage Guide

## Overview

The `AverageRatingWidget` displays rating statistics in a Google Play Store style layout with:
- Overall average rating (large number)
- Star visualization
- Total review count
- Rating breakdown with progress bars (5 to 1 stars)

## Files Created

1. `lib/data/models/rating_statistics.dart` - Data model for rating statistics
2. `lib/presentation/widgets/average_rating_widget.dart` - The widget component

## How to Use

### 1. Create Rating Statistics Data

```dart
import 'package:recovery_consultation_app/data/models/rating_statistics.dart';

// Example with actual data
final ratingStats = RatingStatistics(
  averageRating: 4.5,
  totalReviews: 128,
  fiveStarCount: 85,
  fourStarCount: 30,
  threeStarCount: 8,
  twoStarCount: 3,
  oneStarCount: 2,
);

// Or from JSON (when fetching from API)
final ratingStatsFromApi = RatingStatistics.fromJson(apiResponse);
```

### 2. Use the Widget in Your Page

```dart
import 'package:recovery_consultation_app/presentation/widgets/average_rating_widget.dart';
import 'package:recovery_consultation_app/data/models/rating_statistics.dart';

class SpecialistProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Your rating statistics (from API or controller)
    final ratingStats = RatingStatistics(
      averageRating: 4.5,
      totalReviews: 128,
      fiveStarCount: 85,
      fourStarCount: 30,
      threeStarCount: 8,
      twoStarCount: 3,
      oneStarCount: 2,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ... other widgets

            // Average Rating Widget
            AverageRatingWidget(statistics: ratingStats),

            gapH16,

            // ... individual review cards below
          ],
        ),
      ),
    );
  }
}
```

### 3. Example Integration in Specialist Review Page

Update `lib/presentation/specialist_reviews/specialist_review_page.dart`:

```dart
import 'package:recovery_consultation_app/presentation/widgets/average_rating_widget.dart';
import 'package:recovery_consultation_app/data/models/rating_statistics.dart';

// In _buildReviewsSection():
Widget _buildReviewsSection() {
  // Example statistics (replace with actual data from controller/API)
  final ratingStats = RatingStatistics(
    averageRating: 4.5,
    totalReviews: 128,
    fiveStarCount: 85,
    fourStarCount: 30,
    threeStarCount: 8,
    twoStarCount: 3,
    oneStarCount: 2,
  );

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.primary(
        'Reviews',
        fontSize: 18,
        fontWeight: FontWeightType.semiBold,
        color: AppColors.textPrimary,
      ),
      gapH16,

      // Add the average rating widget here
      AverageRatingWidget(statistics: ratingStats),

      gapH24,

      // Individual review cards below
      const ReviewCard(...),
      // ... more review cards
    ],
  );
}
```

### 4. Integration with GetX Controller

If you're using GetX state management:

```dart
// In your controller
class SpecialistReviewController extends GetxController {
  final Rx<RatingStatistics?> ratingStatistics = Rx<RatingStatistics?>(null);

  @override
  void onInit() {
    super.onInit();
    loadRatingStatistics();
  }

  Future<void> loadRatingStatistics() async {
    try {
      // Fetch from API
      final response = await apiClient.getRatingStatistics(doctorId);
      ratingStatistics.value = RatingStatistics.fromJson(response.data);
    } catch (e) {
      print('Error loading rating statistics: $e');
    }
  }
}

// In your page
class SpecialistReviewPage extends GetView<SpecialistReviewController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = controller.ratingStatistics.value;

      if (stats == null) {
        return CircularProgressIndicator();
      }

      return Column(
        children: [
          AverageRatingWidget(statistics: stats),
          // ... rest of the page
        ],
      );
    });
  }
}
```

## Customization

### Colors
The widget uses your app's existing color scheme:
- Primary text: `AppColors.textPrimary`
- Secondary text: `AppColors.textSecondary`
- Star color: `AppColors.pendingColor` (orange/gold)
- Progress bar background: `AppColors.grey90`

### Sizing
You can wrap the widget in a `Padding` or `Container` to adjust spacing:

```dart
Padding(
  padding: const EdgeInsets.all(20),
  child: AverageRatingWidget(statistics: ratingStats),
)
```

## API Response Format

Expected JSON format from your backend:

```json
{
  "averageRating": 4.5,
  "totalReviews": 128,
  "fiveStarCount": 85,
  "fourStarCount": 30,
  "threeStarCount": 8,
  "twoStarCount": 3,
  "oneStarCount": 2
}
```

## Example Screenshot Layout

```
┌─────────────────────────────────────────┐
│                                         │
│   4.5         5 ★ ████████████░░  85   │
│   ★★★★★       4 ★ ████░░░░░░░░░  30   │
│  128 reviews  3 ★ █░░░░░░░░░░░░   8   │
│               2 ★ ░░░░░░░░░░░░░   3   │
│               1 ★ ░░░░░░░░░░░░░   2   │
│                                         │
└─────────────────────────────────────────┘
```

## Notes

- The widget automatically calculates percentages for progress bars
- Shows half stars for decimal ratings (e.g., 4.5 shows 4.5 stars)
- Responsive design that works on different screen sizes
- Matches your app's existing design system
