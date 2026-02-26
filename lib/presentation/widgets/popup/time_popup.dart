import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../app/config/app_colors.dart';
import '../app_text.dart';
import '../button/round_border_button.dart';
import '../button/primary_button.dart';

class TimePopup extends StatefulWidget {
  const TimePopup({
    required this.title,
    required this.selectedTime,
    required this.onActiveActionPressed,
    required this.onPassiveActionPressed,
    required this.onDialogAreShowing,
    super.key,
  });

  /// Title
  final String title;

  /// Selected date
  final DateTime selectedTime;

  /// Action active
  final Function(DateTime) onActiveActionPressed;

  /// Detect bottom sheet are showing
  final Function(bool) onDialogAreShowing;

  /// Passive active
  final VoidCallback? onPassiveActionPressed;

  @override
  State<TimePopup> createState() => _TimePopupState();
}

class _TimePopupState extends State<TimePopup> with TickerProviderStateMixin {
  /// Controllers
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  /// Calendar
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedTime;

  @override
  void initState() {
    widget.onDialogAreShowing(true);
    _selectedTime = widget.selectedTime;
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
  void dispose() {
    widget.onDialogAreShowing(false);
    _controller.dispose();
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
          child: ScaleTransition(
            scale: _scaleAnimation,
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
                      alignment: Alignment.center,
                      child: AppText.primary(
                        widget.title,
                        fontSize: 16,
                        fontWeight: FontWeightType.semiBold,
                      ),
                    ),
                    Container(
                      height: 1,
                      color: AppColors.black0E0,
                    ),
                    // Hour Widget
                    _hourlyWidget(),
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
                                widget.onActiveActionPressed(_selectedTime!);
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
      ),
    );
  }

  Widget _hourlyWidget() {
    return SizedBox(
      height: 300,
      child: CupertinoDatePicker(
        initialDateTime: _selectedTime,
        mode: CupertinoDatePickerMode.time,
        use24hFormat: true,
        onDateTimeChanged: (DateTime dateTime) {
          setState(() {
            _selectedTime = _selectedTime!.copyWith(
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
}
