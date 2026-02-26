import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/app_constant.dart';

extension DoubleExtension on double {
  /// 0% - 10%
  String toPercent({int fractionDigits = 2}) {
    return this == 0.0 ? '0%' : '${toStringAsFixed(fractionDigits)}%';
  }
}

extension CurrencyFormatExtension on double? {
  String toCurrency({required String symbol, String locale = 'en_GB'}) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
    );
    return this != null ? currencyFormat.format(this) : '£0.00';
  }
}

/// DateTime Extension
extension DateTimeX on DateTime {
  /// Get date with year, month, day
  DateTime get getDate => DateTime(year, month, day);

  /// Get week day
  DateTime getWeekDay(int subtractDays) =>
      subtract(Duration(days: weekday - subtractDays)).getDate;

  /// Get last months
  DateTime subtractMonths(int months) => DateTime(year, month - months, day);

  String toDayOfWeek() {
    return DateFormat('EEEE, d MMM, yyyy').format(this);
  }

  String toFileName() {
    return DateFormat('dd/MM/yy').format(this).replaceAll('/', '');
  }

  String toPdfDate() {
    try {
      return DateFormat('dd/MM/yyyy').format(this);
    } catch (_) {
      return '';
    }
  }

  String toPdfDateTime() {
    try {
      return DateFormat('dd/MM/yyyy h:mm').format(this);
    } catch (_) {
      return '';
    }
  }

  String toTime() {
    return DateFormat('hh:mm a').format(this);
  }

  String toDateString({String format = ConstantsDateTime.defaultDateFormat}) {
    return DateFormat(format).format(this);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameDateAtMinute(DateTime other) {
    return year == other.year &&
        month == other.month &&
        day == other.day &&
        hour == other.hour &&
        minute == other.minute;
  }

  bool isToday() {
    final diff = difference(DateTime.now());
    return diff.inDays == 0;
  }

  bool isAfterToday() {
    final diff = DateTime.now().difference(this);
    return diff.inDays > 0;
  }

  bool isAfterOrToday() {
    final diff = difference(DateTime.now());
    return diff.inDays >= 0;
  }
}

extension NavigationExtension on State {
  void pushRoute(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

extension NavigatorExtention on BuildContext {
  Future<T?> pushRoute<T>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (context) => page));

  void pop([dynamic value]) => Navigator.of(this).pop(value);

  void showSnackBarWithText(String text) => ScaffoldMessenger.of(this)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

extension DateUtils on DateTime {
  String dateToStringWithFormat({String format = 'y-M-d'}) {
    return DateFormat(format).format(this);
  }
}

extension StringX on String {
  String removeComma() {
    return replaceAll(',', '');
  }

  DateTime strToDateTime() {
    return DateFormat('yyyy-MM-dd hh:mm a').parse(this);
  }

  DateTime toStrFromServerDateTime() {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(this);
  }

  DateTime toDate({String format = 'dd-MM-yyyy'}) {
    return DateFormat(format).parse(this);
  }

  DateTime toDateTime() {
    return DateTime.parse(this);
  }

  int getHour() {
    return int.parse(substring(0, 2));
  }

  int getMinute() {
    return int.parse(substring(3, 5));
  }

  String toServerDateTime() {
    try {
      final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      final DateFormat outputFormat = DateFormat('yyyy-MM-ddTHH:mm:ss.000Z');

      final DateTime dateTime = inputFormat.parse(this);
      final String isoDate = outputFormat.format(dateTime);

      return isoDate;
    } catch (e) {
      throw Exception('Invalid date format: Please use dd/MM/yyyy');
    }
  }
}

extension StringPaddingExtension on String {
  String toPaddedString({int length = 2}) {
    return toString().padLeft(length, '0');
  }
}
