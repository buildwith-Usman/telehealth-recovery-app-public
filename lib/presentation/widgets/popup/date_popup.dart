import 'dart:ui';
import 'package:recovery_consultation_app/app/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';
import '../button/round_border_button.dart';
import '../button/primary_button.dart';

class DatePopup extends StatefulWidget {
  const DatePopup({
    required this.selectedDate,
    required this.maximumDate,
    required this.onActiveActionPressed,
    required this.onPassiveActionPressed,
    this.width,
    super.key,
  });

  /// Selected date
  final DateTime selectedDate;

  /// Maximum date
  final DateTime maximumDate;

  final double? width;

  /// Action active
  final Function(DateTime) onActiveActionPressed;

  /// Passive active
  final VoidCallback? onPassiveActionPressed;

  @override
  State<DatePopup> createState() => _DatePopupState();
}

class _DatePopupState extends State<DatePopup>
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

  bool get _disableNextDate {
    return _focusedDay.isSameDate(widget.maximumDate);
  }

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
      child: Center(
        child: SizedBox(
          width: widget.width,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 3.5, sigmaY: 3.5, tileMode: TileMode.clamp),
                child: Container(
                  decoration: const ShapeDecoration(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side:
                          BorderSide(width: 1, color: AppColors.blackE8E),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 16,
                    right: 16,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _calendarHeaderWidget,
                          TableCalendar(
                            onCalendarCreated: (controller) {
                              _pageController = controller;
                            },
                            headerVisible: false,
                            rowHeight: 44,
                            daysOfWeekHeight: 44,
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
                                shape: BoxShape.circle,
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
                            availableGestures:
                                AvailableGestures.horizontalSwipe,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                              }
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
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: RoundBorderButton(
                                  color: AppColors.white,
                                  textColor: AppColors.blackE8E,
                                  onPressed: () async {
                                    await HapticFeedback.lightImpact();
                                    widget.onPassiveActionPressed!();
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  title: "Cancel".tr,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Flexible(
                                flex: 1,
                                child: PrimaryButton(
                                  onPressed: () async {
                                    await HapticFeedback.lightImpact();
                                    widget.onActiveActionPressed(_selectedDay!);
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  title: "Apply".tr,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _calendarHeaderWidget {
    void onLeftChevronTap() {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    void onRightChevronTap() {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    void onTodayTap() {
      setState(() {
        _selectedDay = DateTime.now();
        _focusedDay = DateTime.now();
      });
    }

    return Container(
      height: 56,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              DateFormat('yMMM').format(_focusedDay),
              key: ValueKey<String>(DateFormat('yMMM').format(_focusedDay)),
              style: AppText.primary(
                '',
                fontSize: 20,
                fontWeight: FontWeightType.bold,
              ).textStyle,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Material(
                color: AppColors.white,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  onTap: onLeftChevronTap,
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 15,
                    ),
                  ),
                ),
              ),
              Material(
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: onTodayTap,
                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      child: AppText.primary(
                        "Today".tr,
                        fontWeight: FontWeightType.semiBold,
                        color: AppColors.green8DB,
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                color: AppColors.white,
                child: InkWell(
                  onTap: _disableNextDate ? null : onRightChevronTap,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color:
                          _disableNextDate ? AppColors.grey80 : AppColors.black,
                      size: 15,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
