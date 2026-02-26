/// Utility class for date-related operations
class DateUtils {
  DateUtils._(); // Private constructor to prevent instantiation

  /// Calculates age from date of birth string
  ///
  /// Supports multiple date formats:
  /// - YYYY-MM-DD (e.g., "1990-05-15")
  /// - DD-MM-YYYY (e.g., "15-05-1990")
  /// - DD/MM/YYYY (e.g., "15/05/1990")
  ///
  /// Returns age in format "X years" or null if date is invalid
  ///
  /// Example:
  /// ```dart
  /// final age = DateUtils.calculateAge("1990-05-15"); // "34 years"
  /// ```
  static String? calculateAge(String dateOfBirth) {
    final birthDate = parseDate(dateOfBirth);

    if (birthDate == null) {
      return null;
    }

    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return '$age years';
  }

  /// Parses a date string into DateTime object
  ///
  /// Supports multiple date formats:
  /// - YYYY-MM-DD
  /// - DD-MM-YYYY
  /// - DD/MM/YYYY
  ///
  /// Returns DateTime object or null if parsing fails
  ///
  /// Example:
  /// ```dart
  /// final date = DateUtils.parseDate("15/05/1990");
  /// ```
  static DateTime? parseDate(String dateString) {
    if (dateString.isEmpty) {
      return null;
    }

    try {
      DateTime? parsedDate;

      if (dateString.contains('-')) {
        final parts = dateString.split('-');
        if (parts.length == 3) {
          int year, month, day;

          if (parts[0].length == 4) {
            // YYYY-MM-DD format
            year = int.parse(parts[0]);
            month = int.parse(parts[1]);
            day = int.parse(parts[2]);
          } else {
            // DD-MM-YYYY format
            day = int.parse(parts[0]);
            month = int.parse(parts[1]);
            year = int.parse(parts[2]);
          }

          parsedDate = DateTime(year, month, day);
        }
      } else if (dateString.contains('/')) {
        // DD/MM/YYYY format
        final parts = dateString.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          parsedDate = DateTime(year, month, day);
        }
      }

      return parsedDate;
    } catch (e) {
      return null;
    }
  }

  /// Formats DateTime to DD/MM/YYYY string
  ///
  /// Example:
  /// ```dart
  /// final formatted = DateUtils.formatDate(DateTime(1990, 5, 15)); // "15/05/1990"
  /// ```
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Formats DateTime to YYYY-MM-DD string
  ///
  /// Example:
  /// ```dart
  /// final formatted = DateUtils.formatDateISO(DateTime(1990, 5, 15)); // "1990-05-15"
  /// ```
  static String formatDateISO(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Checks if a date string is valid
  ///
  /// Example:
  /// ```dart
  /// final isValid = DateUtils.isValidDate("15/05/1990"); // true
  /// ```
  static bool isValidDate(String dateString) {
    return parseDate(dateString) != null;
  }

  /// Calculates age in years as an integer
  ///
  /// Returns null if date is invalid or age cannot be calculated
  ///
  /// Example:
  /// ```dart
  /// final ageInYears = DateUtils.calculateAgeInYears("1990-05-15"); // 34
  /// ```
  static int? calculateAgeInYears(String dateOfBirth) {
    final birthDate = parseDate(dateOfBirth);

    if (birthDate == null) {
      return null;
    }

    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Checks if person is adult (18 years or older)
  ///
  /// Example:
  /// ```dart
  /// final isAdult = DateUtils.isAdult("2010-05-15"); // false
  /// ```
  static bool isAdult(String dateOfBirth, {int adultAge = 18}) {
    final age = calculateAgeInYears(dateOfBirth);
    return age != null && age >= adultAge;
  }

  /// Returns human-readable age description
  ///
  /// Example:
  /// ```dart
  /// final description = DateUtils.getAgeDescription("2023-05-15"); // "1 year"
  /// ```
  static String? getAgeDescription(String dateOfBirth) {
    final age = calculateAgeInYears(dateOfBirth);

    if (age == null) {
      return null;
    }

    if (age == 0) {
      return 'Less than 1 year';
    } else if (age == 1) {
      return '1 year';
    } else {
      return '$age years';
    }
  }
}
