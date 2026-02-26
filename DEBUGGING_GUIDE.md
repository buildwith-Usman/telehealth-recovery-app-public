# Book Consultation - Debugging Guide

## Overview
This guide explains how the `_getTimeAvailabilityForToday()` method works and how to debug the entire booking flow.

---

## Method: `_getTimeAvailabilityForToday()`

### Purpose
Shows the overall working hours for the doctor on TODAY in the profile card (e.g., "10:00 AM - 1:00 PM")

### Flow Diagram
```
Start
  ↓
Check if availableTimes exists?
  ↓ No → Return "Available today"
  ↓ Yes
Get today's day name (Monday, Tuesday, etc.)
  ↓
Loop through all availableTimes from API
  ↓
Filter times for today's weekday
  ↓
Any times found for today?
  ↓ No → Return "Not available today"
  ↓ Yes
Get first available time slot
  ↓
Convert startTime & endTime to 12-hour format
  ↓
Return "10:00 AM - 1:00 PM"
```

### Step-by-Step Execution

#### **Step 1: Check if data exists**
```dart
if (specialist.value?.availableTimes == null || specialist.value!.availableTimes!.isEmpty) {
  return 'Available today';
}
```
**What it does:** Checks if the API returned any `available_times` data
**Debug log:** `"No availableTimes data found - returning default message"`

#### **Step 2: Get today's day name**
```dart
final today = DateTime.now();
final todayName = _getDayName(today);
```
**What it does:** Converts current date to day name (Monday-Sunday)
**Debug log:** `"Today is: Monday (2025-12-21 14:30:00.000)"`

#### **Step 3: Print all available times**
```dart
for (var i = 0; i < specialist.value!.availableTimes!.length; i++) {
  final time = specialist.value!.availableTimes![i];
  logger.controller('AvailableTime[$i]: weekday=${time.weekday}, ...');
}
```
**What it does:** Prints ALL available times from API for debugging
**Debug log:** 
```
AvailableTime[0]: weekday=Mon, startTime=10:00:00, endTime=13:00:00, status=available
AvailableTime[1]: weekday=Tue, startTime=11:00:00, endTime=17:00:00, status=available
```

#### **Step 4: Filter for today**
```dart
final todayAvailableTimes = specialist.value!.availableTimes!.where((time) {
  if (time.weekday == null || time.isUnavailable) return false;
  final normalizedDay = _normalizeDayName(time.weekday!);
  return normalizedDay == todayName;
}).toList();
```
**What it does:** 
- Skips null weekdays
- Skips unavailable slots (status != "available")
- Normalizes day names (Mon → Monday, tue → Tuesday)
- Filters only slots matching today

**Debug log:**
```
Skipping time slot: weekday=null, isUnavailable=true
Checking: Mon -> normalized to Monday, matches today? true
Checking: Tue -> normalized to Tuesday, matches today? false
Found 1 available times for Monday
```

#### **Step 5: Check if any found**
```dart
if (todayAvailableTimes.isEmpty) {
  return 'Not available today';
}
```
**What it does:** Returns message if doctor not available today
**Debug log:** `"No available times for today - returning 'Not available today'"`

#### **Step 6: Get first slot**
```dart
final firstSlot = todayAvailableTimes.first;
if (firstSlot.startTime == null || firstSlot.endTime == null) {
  return 'Available today';
}
```
**What it does:** Takes the first matching slot and validates it has times
**Debug log:** `"Using first slot: startTime=10:00:00, endTime=13:00:00"`

#### **Step 7: Format times**
```dart
final startTime12 = _convertTo12HourFormat(firstSlot.startTime!);
final endTime12 = _convertTo12HourFormat(firstSlot.endTime!);
return '$startTime12 - $endTime12';
```
**What it does:** Converts 24-hour to 12-hour format
**Debug log:** `"Final result: 10:00 AM - 1:00 PM"`

---

## Method: `updateTimeSlotsForDate()`

### Purpose
Shows individual bookable time slots for the selected date (below the calendar)

### Flow Diagram
```
User selects a date
  ↓
Get day name from date
  ↓
Check if API timeSlots exists?
  ↓ Yes → Use API timeSlots (shows only free slots)
  ↓ No → Use weeklySchedule (generated from availableTimes)
  ↓
Filter slots for selected day
  ↓
Filter out booked slots (is_booked: true)
  ↓
Convert to 12-hour format
  ↓
Display in UI
```

### API Data Structure

#### available_times (Working Hours)
```json
{
  "id": 10,
  "weekday": "Mon",
  "start_time": "10:00:00",
  "end_time": "13:00:00",
  "session_duration": "30",
  "status": "available"
}
```
**Used for:** Profile card display ("10:00 AM - 1:00 PM")

#### time_slots (Individual Bookable Slots)
```json
{
  "id": 551,
  "weekday": "Mon",
  "slot_start_time": "10:00:00",
  "slot_end_time": "10:30:00",
  "is_booked": false
}
```
**Used for:** Time slot selection below calendar

---

## Complete Data Flow

### 1. Page Loads
```
BookConsultationPage loads
  ↓
BookConsultationController.onInit()
  ↓
_loadSpecialistData() - Fetches doctor info from API
  ↓
API returns:
  - available_times (working hours)
  - time_slots (individual free slots)
  - reviews, doctor_info, etc.
  ↓
specialist.value is populated
  ↓
_updateTimeSlotsFromSpecialist() is called
```

### 2. Profile Card Display
```
ProfileCardItem is built
  ↓
timeAvailability: widget.controller.timeAvailability
  ↓
Calls _getTimeAvailabilityForToday()
  ↓
Returns "10:00 AM - 1:00 PM"
```

### 3. Calendar Date Selection
```
User taps a date
  ↓
selectDate(date) is called
  ↓
updateTimeSlotsForDate(date) is called
  ↓
Filters time_slots for that day where is_booked = false
  ↓
Formats and displays available slots
```

---

## Debug Log Example

When you run the app, you'll see logs like this:

```
[CONTROLLER] === _getTimeAvailabilityForToday START ===
[CONTROLLER] Found 2 available times from API
[CONTROLLER] Today is: Saturday (2025-12-21 14:30:00.000)
[CONTROLLER] AvailableTime[0]: weekday=Mon, startTime=10:00:00, endTime=13:00:00, status=available
[CONTROLLER] AvailableTime[1]: weekday=Tue, startTime=11:00:00, endTime=17:00:00, status=available
[CONTROLLER] Checking: Mon -> normalized to Monday, matches today? false
[CONTROLLER] Checking: Tue -> normalized to Tuesday, matches today? false
[CONTROLLER] Found 0 available times for Saturday
[CONTROLLER] No available times for today - returning "Not available today"
[CONTROLLER] === _getTimeAvailabilityForToday END ===

[CONTROLLER] === updateTimeSlotsForDate START ===
[CONTROLLER] Selected date: 2025-12-23 00:00:00.000
[CONTROLLER] Day name: Monday
[CONTROLLER] Using timeSlots from API (14 total slots)
[CONTROLLER] Slot for Monday: 10:00:00 - 10:30:00, isBooked: false, isAvailable: true
[CONTROLLER] Slot for Monday: 10:30:00 - 11:00:00, isBooked: false, isAvailable: true
[CONTROLLER] Found 6 available slots for Monday
[CONTROLLER] Assigned 6 formatted slots to UI
[CONTROLLER] Final availableTimeSlots count: 6
[CONTROLLER] === updateTimeSlotsForDate END ===
```

---

## Common Issues & Solutions

### Issue 1: Shows "Not available today" when doctor should be available
**Cause:** Today's day name doesn't match any weekday in available_times
**Debug:** Check the normalization - API might send "Monday" but we expect "Mon" or vice versa
**Solution:** Look at the debug log showing "Checking: ... matches today?"

### Issue 2: No time slots showing for selected date
**Cause:** Either no time_slots in API or all are booked
**Debug:** Check log for "Found X available slots for [Day]"
**Solution:** Verify API returns time_slots with is_booked: false

### Issue 3: Shows wrong day's availability
**Cause:** _getDayName() returning wrong day
**Debug:** Check "Today is: [Day]" log
**Solution:** Verify DateTime.weekday mapping (1=Monday, 7=Sunday)

---

## Testing Checklist

- [ ] Profile card shows correct working hours for today
- [ ] If doctor not available today, shows "Not available today"
- [ ] Selecting Monday shows Monday's free slots
- [ ] Selecting Tuesday shows Tuesday's free slots
- [ ] Booked slots (is_booked: true) are filtered out
- [ ] Times are in 12-hour format (10:00 AM not 10:00:00)
- [ ] Empty days show no slots (not error)

---

## API Response Mapping

```
API Response                    →  Entity              →  Display
─────────────────────────────────────────────────────────────────────
available_times.start_time      →  availableTimes      →  Profile card
available_times.end_time           (working hours)        "10:00 AM - 1:00 PM"

time_slots.slot_start_time      →  timeSlots           →  Time slot chips
time_slots.slot_end_time           (bookable slots)       "10:00 AM - 10:30 AM"
time_slots.is_booked                                      (if false, show it)
```

