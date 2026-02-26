import 'dart:ui';
import 'package:recovery_consultation_app/app/utils/app_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';
import '../button/round_border_button.dart';
import '../button/primary_button.dart';

enum DateTimeMode {
  grid,
  list;
}

class DateTimePopup extends StatefulWidget {
  const DateTimePopup({
    required this.selectedDate,
    required this.maximumDate,
    required this.onActiveActionPressed,
    required this.onPassiveActionPressed,
    required this.onDialogAreShowing,
    super.key,
  });

  /// Selected date
  final DateTime selectedDate;

  /// Maximum date
  final DateTime maximumDate;

  /// Action active
  final Function(DateTime) onActiveActionPressed;

  /// Detect bottom sheet are showing
  final Function(bool) onDialogAreShowing;

  /// Passive active
  final VoidCallback? onPassiveActionPressed;

  @override
  State<DateTimePopup> createState() => _DateTimePopupState();
}

class _DateTimePopupState extends State<DateTimePopup>
    with TickerProviderStateMixin {
  /// Controllers
  late PageController _pageController;
  late TabController _tabController;

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
  late DateTime _initialDateTime;

  /// Segment init index
  var _segmentIndex = 0;

  /// Mode view
  var _modeView = DateTimeMode.grid;

  @override
  void initState() {
    widget.onDialogAreShowing(true);
    _tabController = TabController(length: 2, vsync: this);
    _initialDateTime = widget.selectedDate;
    _selectedDay = widget.selectedDate;
    _focusedDay = widget.selectedDate;
    super.initState();
  }

  @override
  void dispose() {
    widget.onDialogAreShowing(false);
    _tabController.dispose();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 3.5, sigmaY: 3.5, tileMode: TileMode.clamp),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const ShapeDecoration(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: AppColors.blackE8E),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              margin: const EdgeInsets.only(
                bottom: 20,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const ShapeDecoration(
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    height: 52,
                    child: AppBar(
                      elevation: 0,
                      bottom: TabBar(
                        onTap: (int index) {
                          setState(() {
                            _segmentIndex = index;
                          });
                        },
                        indicatorColor: AppColors.green9A5,
                        indicatorWeight: 3,
                        controller: _tabController,
                        tabAlignment: TabAlignment.fill,
                        indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
                        tabs: <Widget>[
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 14,
                                ),
                                const SizedBox(width: 7),
                                AppText.primary((_selectedDay ?? DateTime.now())
                                    .dateToStringWithFormat(
                                        format: 'dd/MM/yyyy'))
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 16,
                                ),
                                const SizedBox(width: 7),
                                AppText.primary((_selectedDay ?? DateTime.now())
                                    .dateToStringWithFormat(format: 'HH:mm'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: AppColors.black0E0,
                  ),
                  if (_segmentIndex == 0) ...[
                    _monthlyCalendarWidget(),
                  ],
                  if (_segmentIndex == 1) ...[
                    _hourlyWidget(),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(16.0).copyWith(top: 32),
                    child: Row(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthlyCalendarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 9),
            child: _calendarHeaderWidget,
          ),
          if (_modeView == DateTimeMode.grid) ...[
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
              availableGestures: AvailableGestures.horizontalSwipe,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = _selectedDay!.copyWith(
                      year: selectedDay.year,
                      month: selectedDay.month,
                      day: selectedDay.day,
                    );
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
          ],
          if (_modeView == DateTimeMode.list) ...[
            SizedBox(
              height: 264,
              child: CupertinoDatePicker(
                initialDateTime: _initialDateTime,
                mode: CupertinoDatePickerMode.monthYear,
                use24hFormat: true,
                maximumDate: _maximumDate,
                minimumDate: DateTime(2000, 1, 1),
                onDateTimeChanged: (DateTime dateTime) {
                  if (!isSameDay(_selectedDay, dateTime)) {
                    setState(() {
                      _selectedDay = _selectedDay!.copyWith(
                        year: dateTime.year,
                        month: dateTime.month,
                      );
                      _focusedDay = dateTime;
                    });
                  }
                },
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _hourlyWidget() {
    return SizedBox(
      height: 300,
      child: CupertinoDatePicker(
        initialDateTime: _initialDateTime,
        mode: CupertinoDatePickerMode.time,
        use24hFormat: true,
        onDateTimeChanged: (DateTime dateTime) {
          setState(() {
            _selectedDay = _selectedDay!.copyWith(
              hour: dateTime.hour,
              minute: dateTime.minute,
            );
            _focusedDay = _focusedDay.copyWith(
              hour: dateTime.hour,
              minute: dateTime.minute,
            );
          });
        },
      ),
    );
  }

  Widget get _calendarHeaderWidget {
    void onLeftChevronTap() {
      if (_modeView == DateTimeMode.list) {
        return;
      }
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    void onRightChevronTap() {
      if (_modeView == DateTimeMode.list) {
        return;
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    void onTodayTap() {
      setState(() {
        _selectedDay = DateTime.now().copyWith(
          hour: _selectedDay?.hour,
          minute: _selectedDay?.minute,
          second: _selectedDay?.second,
        );
        _focusedDay = DateTime.now().copyWith(
          hour: _focusedDay.hour,
          minute: _focusedDay.minute,
          second: _focusedDay.second,
        );
      });
    }

    return Row(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Material(
            color: AppColors.white,
            child: InkWell(
              highlightColor: AppColors.white,
              splashColor: AppColors.white,
              onTap: () async {
                await HapticFeedback.lightImpact();
                setState(() {
                  _modeView = _modeView == DateTimeMode.grid
                      ? DateTimeMode.list
                      : DateTimeMode.grid;
                });
              },
              child: Row(
                children: <Widget>[
                  Text(
                    DateFormat('yMMM').format(_focusedDay),
                    key: ValueKey<String>(
                        DateFormat('yMMM').format(_focusedDay)),
                    style: AppText.primary(
                      '',
                      fontSize: 20,
                      fontWeight: FontWeightType.bold,
                    ).textStyle,
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    _modeView == DateTimeMode.grid
                        ? Icons.keyboard_arrow_right_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        Opacity(
          opacity: _modeView == DateTimeMode.grid ? 1 : 0,
          child: IgnorePointer(
            ignoring: _modeView == DateTimeMode.list,
            child: Row(
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Material(
                    color: AppColors.white,
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
                    onTap: onRightChevronTap,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
