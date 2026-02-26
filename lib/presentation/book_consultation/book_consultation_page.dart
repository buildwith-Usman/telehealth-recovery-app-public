import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recovery_consultation_app/domain/entity/doctor_info_entity.dart';
import 'package:recovery_consultation_app/domain/models/profile_card_item.dart';
import 'package:recovery_consultation_app/presentation/widgets/cards/base_horizontal_profile_card.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/app_icon.dart';
import '../../app/services/base_stateful_page.dart';
import '../../app/utils/sizes.dart';
import '../widgets/app_text.dart';
import '../widgets/button/custom_navigation_button.dart';
import '../widgets/button/primary_button.dart';
import '../widgets/common/recovery_app_bar.dart';
import 'book_consultation_controller.dart';

class BookConsultationPage extends BaseStatefulPage<BookConsultationController> {
  const BookConsultationPage({super.key});

  @override
  BaseStatefulPageState<BookConsultationController> createState() =>
      _BookConsultationPageState();
}

class _BookConsultationPageState
    extends BaseStatefulPageState<BookConsultationController> {

  @override
  RecoveryAppBar? buildAppBar() {
    return RecoveryAppBar.simple(
      title: 'Book Consultation',
      showBackButton: true,
      onBackPressed: () => widget.controller.goBack(),
    );
  }

  @override
  Widget? buildBottomBar() {
    return _buildBottomActionBar();
  }

  @override
  Widget buildPageContent(BuildContext context) {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return _buildLoadingState();
      }

      // Check if specialist data is loaded
      if (widget.controller.specialist.value == null) {
        return _buildLoadingState();
      }

      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSpecialistCard(_getSpecialistDetails()),
            gapH24,
            _buildDateSelection(),
            gapH24,
            _buildTimeSlotSelection(),
            gapH24,
            _buildPricingInfo(),
            gapH24,
          ],
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          gapH20,
          AppText.primary(
            'Loading consultation details...',
            fontFamily: FontFamilyType.inter,
            fontSize: 16,
            fontWeight: FontWeightType.medium,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          final hasTimeSlots = widget.controller.availableTimeSlots.isNotEmpty;
          final hasSelectedSlot =
              widget.controller.selectedTimeSlot.value.isNotEmpty;
          final isEnabled = hasTimeSlots &&
              hasSelectedSlot &&
              !widget.controller.isBooking.value;

          return PrimaryButton(
            title: widget.controller.isBooking.value
                ? 'Booking...'
                : 'Confirm Booking',
            height: 55,
            radius: 8,
            color: isEnabled ? AppColors.primary : AppColors.lightGrey,
            textColor: isEnabled ? AppColors.white : AppColors.textSecondary,
            fontWeight: FontWeightType.semiBold,
            showIcon: true,
            iconWidget: AppIcon.rightArrowIcon.widget(
              width: 10,
              height: 10,
              color: isEnabled ? AppColors.white : AppColors.textSecondary,
            ),
            onPressed: isEnabled
                ? () {
                    widget.controller.bookConsultation();
                  }
                : () {
                    // Show message when button is disabled
                    if (!hasTimeSlots) {
                      Get.snackbar(
                        'No Time Slots',
                        'Please select a date with available time slots',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.accent,
                        colorText: AppColors.white,
                      );
                    } else if (!hasSelectedSlot) {
                      Get.snackbar(
                        'No Time Selected',
                        'Please select a time slot to continue',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.accent,
                        colorText: AppColors.white,
                      );
                    }
                  },
          );
        }),
      ),
    );
  }

  ProfileCardItem _getSpecialistDetails() {
    // Access selectedDate.value to trigger rebuild when date changes
    // ignore: unused_local_variable
    final _ = widget.controller.selectedDate.value;

    return ProfileCardItem(
      name: widget.controller.specialistName,
      profession: widget.controller.specialistProfession,
      degree: widget.controller.specialistCredentials,
      experience: widget.controller.specialistExperience,
      rating: widget.controller.specialistRating,
      noOfRatings: '12',
      timeAvailability: widget.controller.timeAvailability,
      imageUrl: widget.controller.specialistImageUrl,
      doctorInfo: DoctorInfoEntity(
        id: 1,
        userId: 123,
        specialization: widget.controller.specialistProfession,
        degree: widget.controller.specialistCredentials,
      ),
      viewProfileCardButton: false,
    );
  }

  Widget _buildSpecialistCard(ProfileCardItem specialist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: BaseHorizontalProfileCard(
        item: specialist,
      ),
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Select a date and time slot for your consultation',
          fontSize: 16,
          fontFamily: FontFamilyType.inter,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.black,
        ),
        gapH12,
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Custom Header with navigation and dropdowns
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.lightDivider,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Left navigation button
                    CustomNavigationButton(
                      type: NavigationButtonType.previous,
                      onPressed: () => _navigateMonth(-1),
                      isFilled: true,
                      filledColor: AppColors.whiteLight,
                      iconColor: AppColors.primary,
                      size: 40,
                      iconSize: 18,
                      showBorder: false,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Month dropdown
                          GestureDetector(
                            onTap: _showMonthDropdown,
                            child: Container(
                              height: 40,
                              width: 75,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.whiteLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Obx(() => AppText.primary(
                                          _getMonthName(widget.controller
                                              .selectedDate.value.month),
                                          fontSize: 14,
                                          fontWeight: FontWeightType.medium,
                                          color: AppColors.textPrimary,
                                        )),
                                    Positioned(
                                      right: -12,
                                      bottom: 0,
                                      child: AppIcon.dropdownIcon.widget(
                                        width: 8,
                                        height: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          gapW12,
                          // Year dropdown
                          GestureDetector(
                            onTap: _showYearDropdown,
                            child: Container(
                              height: 40,
                              width: 75,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.whiteLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Obx(() => AppText.primary(
                                          widget.controller.selectedDate.value
                                              .year
                                              .toString(),
                                          fontSize: 14,
                                          fontWeight: FontWeightType.medium,
                                          color: AppColors.textPrimary,
                                        )),
                                    Positioned(
                                      right: -12,
                                      bottom: 2,
                                      child: AppIcon.dropdownIcon.widget(
                                        width: 8,
                                        height: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right navigation button
                    CustomNavigationButton(
                      type: NavigationButtonType.next,
                      onPressed: () => _navigateMonth(1),
                      isFilled: true,
                      filledColor: AppColors.whiteLight,
                      iconColor: AppColors.primary,
                      size: 40,
                      iconSize: 18,
                      showBorder: false,
                    ),
                  ],
                ),
              ),
              // Calendar view
              _buildSwipeableCalendar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.primary(
          'Available Time Slots',
          fontSize: 16,
          fontWeight: FontWeightType.semiBold,
          color: AppColors.textPrimary,
        ),
        gapH4,
        AppText.primary(
          widget.controller.formattedDate,
          fontSize: 14,
          fontWeight: FontWeightType.medium,
          color: AppColors.textSecondary,
        ),
        gapH12,
        Obx(() {
          // Check if there are any available time slots
          if (widget.controller.availableTimeSlots.isEmpty) {
            return _buildEmptyTimeSlotsState();
          }

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.controller.availableTimeSlots.map((timeSlot) {
              final isSelected =
                  widget.controller.selectedTimeSlot.value == timeSlot;
              return GestureDetector(
                onTap: () => widget.controller.selectTimeSlot(timeSlot),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.lightGrey,
                      width: 1,
                    ),
                  ),
                  child: AppText.primary(
                    timeSlot,
                    fontSize: 14,
                    fontWeight: FontWeightType.medium,
                    color:
                        isSelected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyTimeSlotsState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.lightGrey,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          AppIcon.sessionClock.widget(width: 24,height: 24),
          gapH16,
          AppText.primary(
            'No Available Time Slots',
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.textPrimary,
            textAlign: TextAlign.center,
          ),
          gapH8,
          AppText.primary(
            'The specialist has no available slots for this date.\nPlease select another date.',
            fontSize: 14,
            fontWeight: FontWeightType.regular,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Video call icon on the left
          AppIcon.videoCallIcon.widget(
            width: 16,
            height: 16,
          ),
          gapW12,
          // Per Video Session Price in the center
          Expanded(
            child: Center(
              child: AppText.primary(
                'Per Video Session Price',
                fontSize: 16,
                fontWeight: FontWeightType.medium,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          // Price on the right
          AppText.primary(
            widget.controller.formattedFee,
            fontSize: 16,
            fontWeight: FontWeightType.semiBold,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeableCalendar() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Detect swipe direction based on velocity
        if (details.primaryVelocity! > 0) {
          // Swipe right - go to previous month
          _navigateMonth(-1);
        } else if (details.primaryVelocity! < 0) {
          // Swipe left - go to next month
          _navigateMonth(1);
        }
      },
      child: _buildCustomCalendar(),
    );
  }

  Widget _buildCustomCalendar() {
    return Obx(() {
      final currentDate = widget.controller.selectedDate.value;
      final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
      final lastDayOfMonth =
          DateTime(currentDate.year, currentDate.month + 1, 0);
      final firstWeekday = firstDayOfMonth.weekday;
      final daysInMonth = lastDayOfMonth.day;

      // Calculate days from previous month to show
      final daysFromPrevMonth = firstWeekday == 7 ? 0 : firstWeekday;
      final totalCells = ((daysInMonth + daysFromPrevMonth) / 7).ceil() * 7;

      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Weekday headers
            Row(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map((day) => Expanded(
                        child: Center(
                          child: AppText.primary(
                            day,
                            fontSize: 14,
                            fontWeight: FontWeightType.semiBold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            gapH16,
            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                int day;
                bool isCurrentMonth = true;
                bool isToday = false;
                bool isSelected = false;
                bool isPastDate = false;

                if (index < daysFromPrevMonth) {
                  // Previous month days
                  final prevMonth =
                      DateTime(currentDate.year, currentDate.month - 1, 0);
                  day = prevMonth.day - (daysFromPrevMonth - index - 1);
                  isCurrentMonth = false;
                } else if (index - daysFromPrevMonth >= daysInMonth) {
                  // Next month days
                  day = index - daysFromPrevMonth - daysInMonth + 1;
                  isCurrentMonth = false;
                } else {
                  // Current month days
                  day = index - daysFromPrevMonth + 1;
                  final date =
                      DateTime(currentDate.year, currentDate.month, day);
                  isToday = _isSameDay(date, DateTime.now());
                  isSelected =
                      _isSameDay(date, widget.controller.selectedDate.value);
                  isPastDate = false;
                }

                return _buildCalendarDay(
                  day: day,
                  isCurrentMonth: isCurrentMonth,
                  isToday: isToday,
                  isSelected: isSelected,
                  isPastDate: isPastDate,
                  onTap: isCurrentMonth
                      ? () {
                          final selectedDate = DateTime(
                              currentDate.year, currentDate.month, day);
                          widget.controller.selectDate(selectedDate);
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCalendarDay({
    required int day,
    required bool isCurrentMonth,
    required bool isToday,
    required bool isSelected,
    required bool isPastDate,
    VoidCallback? onTap,
  }) {
    Color backgroundColor = Colors.transparent;
    Color textColor = AppColors.textPrimary;
    FontWeightType fontWeight = FontWeightType.regular;

    if (isSelected) {
      backgroundColor = AppColors.primary;
      textColor = AppColors.white;
      fontWeight = FontWeightType.semiBold;
    } else if (isToday) {
      backgroundColor = AppColors.primary.withValues(alpha: 0.1);
      textColor = AppColors.primary;
      fontWeight = FontWeightType.semiBold;
    } else if (!isCurrentMonth) {
      textColor = AppColors.textSecondary.withValues(alpha: 0.5);
    } else if (isPastDate) {
      textColor = AppColors.textSecondary.withValues(alpha: 0.5);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: AppColors.primary, width: 1)
              : null,
        ),
        child: Center(
          child: AppText.primary(
            day.toString(),
            fontSize: 14,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Calendar navigation and dropdown methods
  void _navigateMonth(int direction) {
    final currentDate = widget.controller.selectedDate.value;
    final newDate = DateTime(
      currentDate.year,
      currentDate.month + direction,
      1,
    );

    final minDate = DateTime(2020, 1, 1);
    final maxDate = DateTime(2030, 12, 31);

    if (newDate.isAfter(minDate) && newDate.isBefore(maxDate)) {
      widget.controller.selectDate(newDate);
    }
  }

  void _showMonthDropdown() {
    final currentDate = widget.controller.selectedDate.value;
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

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppText.primary(
              'Select Month',
              fontSize: 18,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
            ),
            gapH20,
            Expanded(
              child: ListView.builder(
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index];
                  final isSelected = index + 1 == currentDate.month;

                  return ListTile(
                    title: AppText.primary(
                      month,
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeightType.semiBold
                          : FontWeightType.regular,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    onTap: () {
                      final newDate = DateTime(
                        currentDate.year,
                        index + 1,
                        currentDate.day,
                      );
                      widget.controller.selectDate(newDate);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showYearDropdown() {
    final currentDate = widget.controller.selectedDate.value;
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => currentYear + index);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppText.primary(
              'Select Year',
              fontSize: 18,
              fontWeight: FontWeightType.semiBold,
              color: AppColors.textPrimary,
            ),
            gapH20,
            Expanded(
              child: ListView.builder(
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  final isSelected = year == currentDate.year;

                  return ListTile(
                    title: AppText.primary(
                      year.toString(),
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeightType.semiBold
                          : FontWeightType.regular,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    onTap: () {
                      final newDate = DateTime(
                        year,
                        currentDate.month,
                        currentDate.day,
                      );
                      widget.controller.selectDate(newDate);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
