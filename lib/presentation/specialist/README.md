# Specialist Home Module

This module contains the specialist dashboard home page that mirrors the patient home page design but with specialist-specific content and functionality.

## Files Created

### 1. `specialist_home_page.dart`
- **Purpose**: Main specialist dashboard page
- **Structure**: Identical to patient home page with specialist-specific content
- **Features**:
  - Specialist profile header with greeting
  - Search functionality for patients
  - Today's appointments sliding banner
  - Recent patients horizontal list
  - Upcoming appointments horizontal list
  - Custom patient cards with status indicators

### 2. `specialist_home_controller.dart`
- **Purpose**: Controller for specialist dashboard logic
- **Features**:
  - Navigation to patient details
  - Navigation to patients list
  - Navigation to appointments calendar
  - Appointment management methods

### 3. `specialist_home_binding.dart`
- **Purpose**: GetX binding for dependency injection
- **Dependencies**: SpecialistHomeController

## Key Components

### SpecialistHomePage
- Uses exact same layout structure as patient HomePage
- Customized content for specialist workflow:
  - "Ready to help your patients today?" greeting
  - Patient search instead of specialist search
  - Appointment banners showing patient appointments
  - Patient cards showing recent and upcoming patients

### PatientItem Model
```dart
class PatientItem {
  final String name;
  final String condition;
  final String lastSession;
  final String status; // 'Ongoing', 'Scheduled', 'Completed'
  final String imageUrl;
  final VoidCallback onTap;
}
```

### PatientCard Widget
- Custom card widget for displaying patient information
- Features:
  - Patient avatar and basic info
  - Treatment condition
  - Last session/appointment time
  - Status badge with color coding
  - Action button (View Details/View Appointment)

## Specialist-Specific Features

1. **Appointment Management**: View and manage patient appointments
2. **Patient Tracking**: Track recent patients and upcoming appointments
3. **Quick Actions**: Calendar access and notifications
4. **Status Indicators**: Visual status for patient appointments (Ongoing, Scheduled, Completed)

## Navigation Routes (To Be Added)

The following routes need to be added to the app routing system:
- `/patientDetail` - Patient detail page
- `/patientsList` - Full patients list
- `/appointmentsCalendar` - Appointments calendar
- `/appointmentSession` - Live appointment session
- `/appointmentDetails` - Appointment details view

## Integration

To use this specialist home page:

1. Add the route to your routing system
2. Import and use SpecialistHomeBinding in your route binding
3. Navigate to the specialist home page based on user role

```dart
Get.toNamed('/specialistHome');
```

## Design Consistency

This specialist home page maintains 100% design consistency with the patient home page:
- Same layout structure
- Same spacing and typography
- Same component patterns (headers, lists, cards)
- Same color scheme and styling
- Same navigation patterns

The only differences are the content and specialist-specific functionality, ensuring a consistent user experience across different user roles.
