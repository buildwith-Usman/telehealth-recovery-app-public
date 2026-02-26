import 'package:get/get_utils/src/get_utils/get_utils.dart';

class InputValidator {
  static String? validateName(
    String value, {
    String emptyMessage = 'Name is required',
  }) {
    if (value.trim().isEmpty) return emptyMessage;
    return null;
  }

  static String? validateEmail(
    String value, {
    String invalidMessage = 'Enter a valid email',
  }) {
    if (!GetUtils.isEmail(value.trim())) return invalidMessage;
    return null;
  }

  static String? validatePassword(
    String value, {
    String tooShortMessage = 'Password must be at least 6 characters',
    int minLength = 6,
  }) {
    if (value.length < minLength) return tooShortMessage;
    return null;
  }

  static String? validatePhone(
      String value, {
        String invalidMessage = 'Enter a valid phone number',
      }) {
    if (value.trim().isEmpty || value.length < 10) return invalidMessage;
    return null;
  }

}
