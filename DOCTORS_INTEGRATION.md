## PatientHomeController - Paginated Doctors Integration

The `PatientHomeController` now includes functionality to fetch top 5 therapists and 5 psychiatrists using the paginated doctors API.

### New Features Added

#### 1. Reactive Variables
- `topTherapists`: List of top 5 therapists
- `topPsychiatrists`: List of top 5 psychiatrists
- `loadingTherapists`: Loading state for therapists
- `loadingPsychiatrists`: Loading state for psychiatrists

#### 2. Methods Available

##### Data Loading
- `refreshDoctorsData()`: Refresh both therapists and psychiatrists
- `refreshTherapists()`: Refresh only therapists
- `refreshPsychiatrists()`: Refresh only psychiatrists

##### Navigation
- `navigateToDoctorDetail(DoctorEntity doctor)`: Navigate to doctor detail page

##### Helper Methods
- `getDoctorDisplayName(DoctorEntity doctor)`: Get formatted doctor name
- `getDoctorSpecialization(DoctorEntity doctor)`: Get doctor specialization
- `getDoctorExperience(DoctorEntity doctor)`: Get formatted experience string
- `getDoctorRating(DoctorEntity doctor)`: Get calculated average rating
- `getDoctorLanguages(DoctorEntity doctor)`: Get comma-separated languages

### Usage in UI

```dart
// In your widget build method
Widget build(BuildContext context) {
  final controller = Get.find<PatientHomeController>();
  
  return Obx(() {
    if (controller.loadingTherapists) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: controller.topTherapists.length,
      itemBuilder: (context, index) {
        final therapist = controller.topTherapists[index];
        return ListTile(
          title: Text(controller.getDoctorDisplayName(therapist)),
          subtitle: Text(
            '${controller.getDoctorSpecialization(therapist)} • '
            '${controller.getDoctorExperience(therapist)}'
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.amber),
              Text('${controller.getDoctorRating(therapist).toStringAsFixed(1)}'),
            ],
          ),
          onTap: () => controller.navigateToDoctorDetail(therapist),
        );
      },
    );
  });
}
```

### Data Structure

Each `DoctorEntity` includes:
- Basic info: id, name, email, phone
- Profile: profileImageId
- Doctor info: specialization, experience, degree, license
- Languages: userLanguages list
- Reviews: reviews list for rating calculation

### API Integration

The controller automatically:
1. Loads user data on initialization
2. Fetches top 5 therapists (specialization: 'therapist')
3. Fetches top 5 psychiatrists (specialization: 'psychiatrist')
4. Handles loading states and errors
5. Provides reactive updates to the UI

### Error Handling

- API errors are logged and handled gracefully
- Empty states are managed (empty lists on failure)
- Loading states prevent UI flickering
- Retry mechanism available through refresh methods