
import 'package:easy_localization/easy_localization.dart';

extension StringExtensions on String {
  String? getFirstAlphabet() {
    // Use regular expression to find the first alphabet character
    RegExp alphabetRegExp = RegExp(r'[A-Za-z]');
    Match? match = alphabetRegExp.firstMatch(this);

    // If a match is found, return the first alphabet character, otherwise return null
    return match?.group(0);
  }
}

extension DateParsing on String? {
  DateTime parseToDate() {
    if (this != null && this!.isNotEmpty) {
      return DateTime.parse(this!);
    } else {
      return DateTime.now();
    }
  }
}

extension StringCleaner on String {
  String cleanText() {
    return split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .join(', ');
  }
}

extension StringInitials on String {
  String getInitials() {
    List<String> parts = trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      String first = parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
      String last = parts[0].length > 1 ? parts[0][parts[0].length - 1].toUpperCase() : '';
      return first + last;
    } else {
      String first = parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
      String second = parts[1].isNotEmpty ? parts[1][0].toUpperCase() : '';
      return first + second;
    }
  }
}

extension DateFormatting on String {
  /// Converts "yyyy-MM-dd" string to "MMM d, y" format (e.g., "May 3, 2025")
  String toFormattedDate() {
    try {
      final date = DateTime.parse(this);
      return DateFormat('MMM d, y').format(date);
    } catch (e) {
      return this; // fallback if parsing fails
    }
  }

  String toFormattedDateWithSlash() {
    try {
      final date = DateTime.parse(this);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return this; // fallback if parsing fails
    }
  }
}

extension StringCasingExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}




