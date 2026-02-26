# Match Doctors List API Implementation

This implementation provides a complete clean architecture solution for the `match-doctors-list` API endpoint using the Specialist Data Source and Repository pattern.

## Architecture Overview

The implementation follows the clean architecture pattern with clear separation between layers:

```
Presentation Layer
    ↓
Domain Layer (Use Cases + Entities)
    ↓  
Data Layer (Repositories + Data Sources + API)
```

## API Endpoint

**GET** `/api/match-doctors-list`

**Headers:**
- `Authorization: Bearer {token}`
- `Accept: application/json`

## Implementation Structure

### 1. Data Layer

#### API Response Models
- **`MatchDoctorsListResponse`** - Main response container
- **`DoctorUserResponse`** - Individual doctor data
- **`DoctorInfoDetailsResponse`** - Doctor's professional info
- **`UserLanguageResponse`** - Doctor's languages
- **`UserQuestionnaireResponse`** - Doctor's questionnaire responses

Located in: `lib/data/api/response/match_doctors_list_response.dart`

#### Data Source
- **`SpecialistDatasource`** - Abstract interface
- **`SpecialistDatasourceImpl`** - Concrete implementation

Located in: `lib/data/datasource/specialist/`

#### Repository Implementation
- **`SpecialistRepositoryImpl`** - Implements domain repository interface

Located in: `lib/data/repository/specialist_repository_impl.dart`

#### Mapper
- **`MatchDoctorsListMapper`** - Converts API responses to domain entities

Located in: `lib/data/mapper/match_doctors_list_mapper.dart`

### 2. Domain Layer

#### Entities
- **`MatchDoctorsListEntity`** - Main business object
- **`DoctorUserEntity`** - Doctor business object  
- **`DoctorInfoDetailsEntity`** - Doctor professional details
- **`UserLanguageEntity`** - Language business object
- **`UserQuestionnaireEntity`** - Questionnaire business object

Located in: `lib/domain/entity/match_doctors_list_entity.dart`

#### Repository Interface
- **`SpecialistRepository`** - Abstract repository interface

Located in: `lib/domain/repositories/specialist_repository.dart`

#### Use Case
- **`GetMatchDoctorsListUseCase`** - Business logic for fetching and filtering doctors

Located in: `lib/domain/usecase/get_match_doctors_list_use_case.dart`

**Features:**
- Filter by specialization
- Filter by experience range
- Filter by gender
- Get verified doctors only
- Sort by experience
- Error handling

### 3. Presentation Layer (Example)

#### Controller Example
- **`MatchTherapistController`** - Example controller showing usage

Located in: `lib/presentation/match_therapist/match_therapist_controller_example.dart`

**Features:**
- Load matched doctors from API
- Apply filters (specialization, gender, experience)
- Convert to UI models (`SpecialistItem`)
- Handle errors and loading states

#### Binding Example
- **`MatchTherapistBindingExample`** - Dependency injection setup

Located in: `lib/presentation/match_therapist/match_therapist_binding_example.dart`

## Usage Example

### 1. Basic Usage in Controller

```dart
class YourController extends GetxController {
  YourController({required this.getMatchDoctorsListUseCase});
  
  final GetMatchDoctorsListUseCase getMatchDoctorsListUseCase;
  
  Future<void> loadDoctors() async {
    try {
      final result = await getMatchDoctorsListUseCase();
      // Handle successful result
      final doctors = result.doctors ?? [];
      print('Loaded ${doctors.length} doctors');
    } on BaseErrorEntity catch (error) {
      // Handle API error
      print('Error: ${error.message}');
    }
  }
}
```

### 2. Using Filters

```dart
// Filter doctors by specialization
final therapists = getMatchDoctorsListUseCase.filterDoctorsBySpecialization(
  result, 
  'therapist'
);

// Filter by experience range
final experiencedDoctors = getMatchDoctorsListUseCase.filterDoctorsByExperience(
  result, 
  5, // min years
  15 // max years
);

// Get only verified doctors
final verifiedDoctors = getMatchDoctorsListUseCase.getVerifiedDoctors(result);

// Sort by experience (most experienced first)
final sortedDoctors = getMatchDoctorsListUseCase.sortDoctorsByExperience(result);
```

### 3. Converting to UI Models

```dart
// Convert to SpecialistItem for existing UI components
SpecialistItem convertToSpecialistItem(DoctorUserEntity doctor) {
  return SpecialistItem(
    name: doctor.name ?? 'Unknown Doctor',
    profession: doctor.doctorInfo?.specialization ?? 'Specialist',
    credentials: doctor.doctorInfo?.qualification ?? '',
    experience: doctor.doctorInfo?.experience ?? '0 Years',
    rating: 4.5, // Default since not in API
    imageUrl: doctor.profileImage,
    onTap: () => onDoctorTap(doctor),
  );
}
```

### 4. Dependency Injection Setup

```dart
class YourBinding extends Bindings 
    with ClientModule, DatasourceModule, RepositoryModule, ConfigModule {
  @override
  void dependencies() {
    Get.lazyPut(() => YourController(
      getMatchDoctorsListUseCase: GetMatchDoctorsListUseCase(
        repository: specialistRepository,
      ),
    ));
  }
}
```

## API Response Structure

The API returns doctors with the following structure:

```json
{
  "message": "Success",
  "data": {
    "doctors": [
      {
        "id": 1,
        "name": "Dr. John Smith",
        "email": "john@example.com",
        "phone": "+1234567890",
        "type": "doctor",
        "is_verified": true,
        "profile_image": "https://example.com/image.jpg",
        "doctor_info": {
          "specialization": "therapist",
          "experience": "5 Years",
          "qualification": "PhD Psychology",
          "gender": "male",
          "age": 35,
          "approved": true
        },
        "user_languages": [
          {
            "language": "English"
          }
        ],
        "user_questionnaires": [
          {
            "key": "age_group_prefer",
            "answer": "Teen,Adult"
          }
        ]
      }
    ]
  }
}
```

## Error Handling

The implementation includes comprehensive error handling:

- **API Errors**: Mapped to `BaseErrorEntity` with proper error messages
- **Network Errors**: Handled by the base HTTP client
- **Validation Errors**: Use case validates data and provides meaningful errors
- **Null Safety**: All models are null-safe with proper defaults

## Features

### Use Case Features
- ✅ Fetch matched doctors list
- ✅ Filter by specialization
- ✅ Filter by experience range  
- ✅ Filter by gender
- ✅ Get verified doctors only
- ✅ Sort by experience
- ✅ Comprehensive error handling

### Controller Features (Example)
- ✅ Loading states management
- ✅ Filter application
- ✅ UI model conversion
- ✅ Error display
- ✅ Reactive updates

## Dependencies

The implementation is integrated with the existing dependency injection system:

- ✅ `DatasourceModule` - Includes `SpecialistDatasource`
- ✅ `RepositoryModule` - Includes `SpecialistRepository`  
- ✅ JSON serialization with `build_runner`
- ✅ Error handling with existing `BaseErrorEntity`

## Next Steps

To use this implementation in your app:

1. **Update your API client** - The `APIClientType` already includes the new endpoint
2. **Create your controller** - Use the example as a starting point
3. **Set up binding** - Use dependency injection for the use case
4. **Create your UI** - Use the existing `SpecialistCard` components
5. **Handle navigation** - Implement doctor detail and appointment booking flows

## Testing

Consider adding tests for:
- Use case filtering logic
- Repository error handling  
- Controller state management
- API response parsing
