import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/entity/time_slot_entity.dart';
import 'package:recovery_consultation_app/domain/entity/user_entity.dart';
import 'package:recovery_consultation_app/domain/usecase/get_specialist_by_id_use_case.dart';
import '../../app/config/app_constant.dart';
import '../../app/config/app_routes.dart';
import '../../app/controllers/base_controller.dart';

class BookConsultationController extends BaseController {
  // ==================== DEPENDENCIES ====================
  final GetUserDetailByIdUseCase getSpecialistByIdUseCase;

  BookConsultationController({required this.getSpecialistByIdUseCase});

  // ==================== ARGUMENTS ====================
  late int specialistId;

  // ==================== SPECIALIST DATA ====================
  final Rx<UserEntity?> specialist = Rx<UserEntity?>(null);

  // Computed properties from specialist entity
  String get specialistName => specialist.value?.name ?? '';
  String get specialistProfession =>
      specialist.value?.doctorInfo?.specialization ?? '';
  String get specialistCredentials => specialist.value?.doctorInfo?.degree ?? '';
  String get specialistExperience =>
      specialist.value?.doctorInfo?.experience ?? '0 Years';
  double get specialistRating => _calculateRating();
  String get specialistImageUrl => specialist.value?.imageUrl ?? '';
  double get consultationFee => 3000.0; // TODO: Get from API when available

  // Get overall time availability for selected date (e.g., "9:00 AM - 12:00 PM")
  String get timeAvailability => _getTimeAvailabilityForSelectedDate();

  // ==================== OBSERVABLES ====================
  @override
  var isLoading = false.obs;
  var isBooking = false.obs;

  // Date and time selection
  var selectedDate = DateTime.now().obs;
  var selectedTimeSlot = ''.obs;
  var selectedTimeSlotId = Rxn<int>(); // Selected time slot ID from API
  var availableTimeSlots = <String>[].obs;
  var availableTimeSlotEntities = <TimeSlotEntity>[].obs; // Store actual slot entities
  var consultationType = 'Video Call'.obs; // Video Call, Audio Call, In-Person

  // Specialist's weekly schedule (generated from API availableTimes)
  final weeklySchedule = <String, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _loadSpecialistData();
  }

  void _getArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    specialistId = args[Arguments.doctorId] ?? 1;
  }

  /// Load specialist data from API
  Future<void> _loadSpecialistData() async {
    final result = await executeApiCall<UserEntity>(
      () => getSpecialistByIdUseCase.execute(specialistId),
      onSuccess: () {
        logger.controller('Successfully loaded specialist with ID: $specialistId');
      },
      onError: (errorMessage) {
        logger.error('Error loading specialist: $errorMessage');
      },
    );

    if (result != null) {
      specialist.value = result;
      // Update time slots based on specialist's availability (AFTER setting specialist.value)
      _updateTimeSlotsFromSpecialist();
    }
  }

  /// Update time slots from specialist's available times
  void _updateTimeSlotsFromSpecialist() {
    if (specialist.value?.availableTimes != null &&
        specialist.value!.availableTimes!.isNotEmpty) {
      // Convert API availableTimes to weeklySchedule format
      final schedule = _convertAvailableTimesToWeeklySchedule();
      weeklySchedule.assignAll(schedule);
      logger.controller('Converted API available times to weekly schedule with ${weeklySchedule.length} days');
    } else {
      logger.controller('No available times from API - specialist has no available times set');
      weeklySchedule.clear();
    }

    // Always update time slots for current selected date after loading specialist data
    updateTimeSlotsForDate(selectedDate.value);
    logger.controller('Updated time slots for current date: ${selectedDate.value}');
  }

  /// Convert specialist's availableTimes from API to weeklySchedule format
  Map<String, List<String>> _convertAvailableTimesToWeeklySchedule() {
    final Map<String, List<String>> schedule = {};

    for (final availableTime in specialist.value!.availableTimes!) {
      // Skip if essential data is missing or status is unavailable
      if (availableTime.weekday == null ||
          availableTime.startTime == null ||
          availableTime.endTime == null ||
          availableTime.isUnavailable) {
        continue;
      }

      // Normalize day name (Mon -> Monday, mon -> Monday, etc.)
      final day = _normalizeDayName(availableTime.weekday!);

      // Generate time slots based on session duration
      final slots = _generateTimeSlots(
        availableTime.startTime!,
        availableTime.endTime!,
        availableTime.sessionDurationMinutes ?? 30, // Default 30 minutes
      );

      // Add slots to the schedule
      if (!schedule.containsKey(day)) {
        schedule[day] = [];
      }
      schedule[day]!.addAll(slots);
    }

    // Ensure all days exist in the schedule (even if empty)
    for (final day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']) {
      if (!schedule.containsKey(day)) {
        schedule[day] = [];
      }
    }

    return schedule;
  }

  /// Normalize day name to full format (Mon -> Monday, mon -> Monday, etc.)
  String _normalizeDayName(String dayName) {
    final lowerDay = dayName.toLowerCase().trim();

    const dayMap = {
      'mon': 'Monday',
      'monday': 'Monday',
      'tue': 'Tuesday',
      'tuesday': 'Tuesday',
      'wed': 'Wednesday',
      'wednesday': 'Wednesday',
      'thu': 'Thursday',
      'thursday': 'Thursday',
      'fri': 'Friday',
      'friday': 'Friday',
      'sat': 'Saturday',
      'saturday': 'Saturday',
      'sun': 'Sunday',
      'sunday': 'Sunday',
    };

    return dayMap[lowerDay] ?? _capitalizeFirstLetter(dayName);
  }

  /// Capitalize first letter of a string
  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Generate time slots between start and end time based on session duration
  List<String> _generateTimeSlots(String startTime, String endTime, int sessionDurationMinutes) {
    final List<String> slots = [];

    try {
      // Parse start and end times (format: "HH:mm" or "HH:mm:ss")
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');

      if (startParts.length < 2 || endParts.length < 2) {
        return slots; // Return empty if invalid format
      }

      final startHour = int.parse(startParts[0]);
      final startMinute = int.parse(startParts[1]);
      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);

      // Create DateTime objects for calculation
      final startDateTime = DateTime(2024, 1, 1, startHour, startMinute);
      final endDateTime = DateTime(2024, 1, 1, endHour, endMinute);

      // Generate slots
      DateTime currentSlotStart = startDateTime;

      while (currentSlotStart.isBefore(endDateTime)) {
        final currentSlotEnd = currentSlotStart.add(Duration(minutes: sessionDurationMinutes));

        // Don't add slot if it extends beyond end time
        if (currentSlotEnd.isAfter(endDateTime)) {
          break;
        }

        // Convert to 12-hour format for display
        final startTime12 = _convertTo12HourFormat('${currentSlotStart.hour.toString().padLeft(2, '0')}:${currentSlotStart.minute.toString().padLeft(2, '0')}');
        final endTime12 = _convertTo12HourFormat('${currentSlotEnd.hour.toString().padLeft(2, '0')}:${currentSlotEnd.minute.toString().padLeft(2, '0')}');

        slots.add('$startTime12 - $endTime12');

        // Move to next slot
        currentSlotStart = currentSlotEnd;
      }
    } catch (e) {
      logger.error('Error generating time slots: $e');
    }

    return slots;
  }

  /// Convert 24-hour format time to 12-hour format with AM/PM
  String _convertTo12HourFormat(String time24) {
    try {
      // Remove seconds if present (e.g., "14:00:00" -> "14:00")
      final timePart = time24.split(':').take(2).join(':');

      // Split hours and minutes
      final parts = timePart.split(':');
      if (parts.length != 2) return time24; // Return original if format is unexpected

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      // Determine AM/PM
      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      if (hour == 0) {
        hour = 12; // Midnight case
      } else if (hour > 12) {
        hour = hour - 12;
      }

      return '$hour:$minute $period';
    } catch (e) {
      logger.error('Error converting time format: $e');
      return time24; // Return original on error
    }
  }

  /// Calculate rating from reviews
  double _calculateRating() {
    final reviews = specialist.value?.reviews;
    if (reviews == null || reviews.isEmpty) return 0.0;

    final validRatings = reviews
        .map((r) => r.rating)
        .where((rating) => rating != null && rating > 0)
        .cast<int>()
        .toList();

    if (validRatings.isEmpty) return 0.0;

    final average = validRatings.reduce((a, b) => a + b) / validRatings.length;
    return double.parse(average.toStringAsFixed(1));
  }

  /// Get time availability for selected date from API (e.g., "9:00 AM - 12:00 PM")
  String _getTimeAvailabilityForSelectedDate() {
    logger.controller('=== _getTimeAvailabilityForSelectedDate START ===');

    // Step 1: Check if availableTimes data exists
    if (specialist.value?.availableTimes == null ||
        specialist.value!.availableTimes!.isEmpty) {
      logger.controller('No availableTimes data found - returning default message');
      return 'Available today';
    }

    logger.controller('Found ${specialist.value!.availableTimes!.length} available times from API');

    // Step 2: Get selected date's day name (Monday, Tuesday, etc.)
    final selectedDayName = _getDayName(selectedDate.value);
    logger.controller('Selected date: ${selectedDate.value.toString()}');
    logger.controller('Selected day: $selectedDayName');

    // Step 3: Print all available times from API for debugging (only first time)
    if (selectedDate.value == DateTime.now() || selectedDate.value.day == DateTime.now().day) {
      for (var i = 0; i < specialist.value!.availableTimes!.length; i++) {
        final time = specialist.value!.availableTimes![i];
        logger.controller('AvailableTime[$i]: weekday=${time.weekday}, startTime=${time.startTime}, endTime=${time.endTime}, status=${time.status}');
      }
    }

    // Step 4: Filter available times for selected day
    final dayAvailableTimes = specialist.value!.availableTimes!.where((time) {
      if (time.weekday == null || time.isUnavailable) {
        return false;
      }
      final normalizedDay = _normalizeDayName(time.weekday!);
      final matches = normalizedDay == selectedDayName;
      return matches;
    }).toList();

    logger.controller('Found ${dayAvailableTimes.length} available times for $selectedDayName');

    // Step 5: Check if any times found for selected day
    if (dayAvailableTimes.isEmpty) {
      logger.controller('No available times for $selectedDayName - returning "Not available"');
      return 'Not available on $selectedDayName';
    }

    // Step 6: Get the first available time slot for selected day
    final firstSlot = dayAvailableTimes.first;
    logger.controller('Using first slot: startTime=${firstSlot.startTime}, endTime=${firstSlot.endTime}');

    if (firstSlot.startTime == null || firstSlot.endTime == null) {
      logger.controller('First slot has null times - returning default message');
      return 'Available';
    }

    // Step 7: Convert to 12-hour format
    final startTime12 = _convertTo12HourFormat(firstSlot.startTime!);
    final endTime12 = _convertTo12HourFormat(firstSlot.endTime!);

    final result = '$startTime12 - $endTime12';
    logger.controller('Final result: $result');
    logger.controller('=== _getTimeAvailabilityForSelectedDate END ===');

    return result;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedTimeSlot.value = ''; // Reset time slot when date changes
    updateTimeSlotsForDate(date); // Update time slots for selected date
  }
  
  /// Update available time slots based on selected date
  /// Uses timeSlots from API (if available) or falls back to weeklySchedule
  void updateTimeSlotsForDate(DateTime date) {
    logger.controller('=== updateTimeSlotsForDate START ===');
    logger.controller('Selected date: ${date.toString()}');

    final dayName = _getDayName(date);
    logger.controller('Day name: $dayName');

    // Try to get slots from API timeSlots first
    if (specialist.value?.timeSlots != null && specialist.value!.timeSlots!.isNotEmpty) {
      logger.controller('Using timeSlots from API (${specialist.value!.timeSlots!.length} total slots)');

      // Filter slots for the selected day that are not booked
      final daySlots = specialist.value!.timeSlots!.where((slot) {
        if (slot.weekday == null) return false;
        final normalizedDay = _normalizeDayName(slot.weekday!);
        final matches = normalizedDay == dayName;
        final isAvailable = slot.isAvailable; // !slot.isBooked

        if (matches) {
          logger.controller('Slot for $dayName: ${slot.slotStartTime} - ${slot.slotEndTime}, isBooked: ${slot.isBooked}, isAvailable: $isAvailable');
        }

        return matches && isAvailable;
      }).toList();

      logger.controller('Found ${daySlots.length} available slots for $dayName');

      // Store the actual TimeSlotEntity objects for ID tracking
      availableTimeSlotEntities.assignAll(daySlots);
      logger.controller('Stored ${daySlots.length} slot entities for ID tracking');

      // Convert to formatted strings for display
      final formattedSlots = daySlots.map((slot) {
        final start = _convertTo12HourFormat(slot.slotStartTime ?? '');
        final end = _convertTo12HourFormat(slot.slotEndTime ?? '');
        return '$start - $end';
      }).toList();

      availableTimeSlots.assignAll(formattedSlots);
      logger.controller('Assigned ${formattedSlots.length} formatted slots to UI');
    } else {
      // Fallback to weeklySchedule (generated from availableTimes)
      logger.controller('No API timeSlots found, using weeklySchedule fallback');
      final slotsForDay = weeklySchedule[dayName] ?? [];
      logger.controller('Found ${slotsForDay.length} slots in weeklySchedule for $dayName');
      availableTimeSlots.assignAll(slotsForDay);

      // Clear slot entities when using fallback (no IDs available)
      availableTimeSlotEntities.clear();
      logger.controller('Cleared slot entities (using weeklySchedule fallback)');
    }

    logger.controller('Final availableTimeSlots count: ${availableTimeSlots.length}');
    logger.controller('=== updateTimeSlotsForDate END ===');
  }
  // Get day name from date
  String _getDayName(DateTime date) {
    const dayNames = [
      'Monday',    // 1
      'Tuesday',   // 2
      'Wednesday', // 3
      'Thursday',  // 4
      'Friday',    // 5
      'Saturday',  // 6
      'Sunday',    // 7
    ];
    return dayNames[date.weekday - 1];
  }
  
  // Check if specialist is available on selected date
  bool get isSpecialistAvailable => availableTimeSlots.isNotEmpty;
  
  // Check if specialist is available on a specific date
  bool isAvailableOnDate(DateTime date) {
    final dayName = _getDayName(date);
    final slotsForDay = weeklySchedule[dayName] ?? [];
    return slotsForDay.isNotEmpty;
  }
  
  // Get working days for the specialist
  List<String> get workingDays {
    return weeklySchedule.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => entry.key)
        .toList();
  }

  void selectTimeSlot(String timeSlot) {
    selectedTimeSlot.value = timeSlot;

    // Find the matching TimeSlotEntity to get its ID
    if (availableTimeSlotEntities.isNotEmpty) {
      try {
        final matchingSlot = availableTimeSlotEntities.firstWhere(
          (entity) {
            // Format the entity's time to match the display format
            final start = _convertTo12HourFormat(entity.slotStartTime ?? '');
            final end = _convertTo12HourFormat(entity.slotEndTime ?? '');
            final formattedSlot = '$start - $end';
            return formattedSlot == timeSlot;
          },
        );

        selectedTimeSlotId.value = matchingSlot.id;
        logger.controller('Selected time slot ID: ${matchingSlot.id} for time: $timeSlot');
      } catch (e) {
        // No matching entity found - this happens when using weeklySchedule fallback
        selectedTimeSlotId.value = null;
        logger.controller('No time slot ID found for: $timeSlot (using weeklySchedule)');
      }
    } else {
      // No entities available - using weeklySchedule fallback
      selectedTimeSlotId.value = null;
      logger.controller('No time slot entities available (using weeklySchedule)');
    }
  }

  /// Book consultation and navigate to payment summary
  /// Only passes booking-specific data - PaymentSummary will fetch specialist data
  void bookConsultation() async {
    // Validate that date and time are selected
    if (selectedTimeSlot.value.isEmpty) {
      Get.snackbar(
        'Selection Required',
        'Please select a time slot for your consultation.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isBooking.value = true;

    try {
      // Simulate booking API call
      await Future.delayed(const Duration(milliseconds: 1000));

      logger.controller('=== Booking Consultation ===');
      logger.controller('Specialist ID: $specialistId');
      logger.controller('Time Slot ID: ${selectedTimeSlotId.value ?? "N/A (using weeklySchedule)"}');
      logger.controller('Date: ${selectedDate.value.toString().split(' ')[0]}');
      logger.controller('Time: ${selectedTimeSlot.value}');
      logger.controller('Type: Video Call');
      logger.controller('Fee: PKR ${consultationFee.toStringAsFixed(0)}');

      // Navigate to payment summary screen
      // Pass ONLY booking data - let PaymentSummary fetch specialist data from API
      Get.toNamed(AppRoutes.paymentSummary, arguments: {
        Arguments.doctorId: specialistId,
        Arguments.timeSlotId: selectedTimeSlotId.value, // Pass selected slot ID for booking
        Arguments.consultationDate: selectedDate.value.toString().split(' ')[0],
        Arguments.consultationTime: selectedTimeSlot.value,
        Arguments.consultationType: 'Video Call',
        Arguments.consultationFee: consultationFee,
        Arguments.currency: 'PKR',
      });
    } catch (e) {
      logger.error('Booking error: $e');

      Get.snackbar(
        'Booking Failed',
        'Unable to book consultation. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isBooking.value = false;
    }
  }

  void goBack() {
    Get.back();
  }

  // Getters for formatted display
  String get formattedDate {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final date = selectedDate.value;
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String get formattedFee {
    return 'PKR ${consultationFee.toStringAsFixed(0)}'; // Use actual consultation fee
  }

  List<String> get consultationTypes =>
      ['Video Call']; // Focused on video consultations only
}
