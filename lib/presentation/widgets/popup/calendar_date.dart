import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';

class ShowCalendar extends StatefulWidget {
  const ShowCalendar({
    required this.selectedDate,
    required this.maximumDate,
    this.startDate,
    required this.onActiveActionPressed,
    super.key,
  });

  /// Selected date
  final DateTime selectedDate;

  /// Maximum date
  final DateTime maximumDate;

  /// pass start date to make sure end date is always greater than start date
  final DateTime? startDate;

  /// Action active
  final Function(DateTime) onActiveActionPressed;

  @override
  State<ShowCalendar> createState() => _ShowCalendarState();
}

class _ShowCalendarState extends State<ShowCalendar>
    with SingleTickerProviderStateMixin {
  /// Controllers
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late PageController _pageController;

  /// Calendar
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  TextStyle get _textStyle => AppText.primary(
        '',
        fontSize: 14,
        color: AppColors.black333,
      ).textStyle!;

  DateTime get _maximumDate => widget.maximumDate;

  @override
  void initState() {
    _selectedDay = widget.selectedDate;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);
    _controller.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: TableCalendar(
        onCalendarCreated: (controller) {
          _pageController = controller;
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        rowHeight: 35,
        daysOfWeekHeight: 35,
        startingDayOfWeek: StartingDayOfWeek.monday,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: _textStyle.copyWith(
            color: AppColors.blackE8E,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: _textStyle.copyWith(
            color: AppColors.blackE8E,
            fontWeight: FontWeight.w600,
          ),
        ),
        calendarStyle: CalendarStyle(
          withinRangeTextStyle: _textStyle,
          defaultTextStyle: _textStyle,
          rangeEndTextStyle: _textStyle,
          rangeStartTextStyle: _textStyle,
          disabledTextStyle: _textStyle.copyWith(
            color: AppColors.blackE8E,
          ),
          selectedTextStyle: _textStyle.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppColors.green9A5,
            shape: BoxShape.rectangle,
          ),
          weekendTextStyle: _textStyle,
          holidayTextStyle: _textStyle,
          todayTextStyle: _textStyle.copyWith(
            color: AppColors.green9A5,
            fontWeight: FontWeight.w700,
          ),
          todayDecoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
          outsideTextStyle: _textStyle.copyWith(
            color: AppColors.blackE8E,
          ),
          weekNumberTextStyle: _textStyle,
        ),
        firstDay: DateTime(2000, 1, 1),
        lastDay: _maximumDate,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        availableGestures: AvailableGestures.horizontalSwipe,
        enabledDayPredicate: (day) {
          if (widget.startDate != null) {
            return day.isAfter(widget.startDate!.subtract(const Duration()));
          }

          return true;
        },
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          // if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            widget.onActiveActionPressed(_selectedDay!);
          });
          // }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
      ),
      // ),
    );
  }
}
