import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService {
  ///Supported language codes
  static const langCodes = ['en'];
  static final locales = [const Locale('en', 'US')];

  static final locale = _getLocalFromLanguage('');

  /// fall back locale is a default locale
  static const fallBackLocale = Locale('en', 'US');

  static final langs =
  LinkedHashMap.from({'en': 'English'});

  static void changeLocale(String langCode) {
    final locale = _getLocalFromLanguage(langCode);
    if (locale != null) {
      Get.updateLocale(locale);
    }
  }

  static Locale? _getLocalFromLanguage(String langCode) {
    var lang = langCode;
    var deviceLocale = Get.deviceLocale;
    if (langCode.isEmpty && deviceLocale != null) {
      lang = deviceLocale.languageCode;
    }
    for (int i = 0; i < langCodes.length; i++) {
      if (lang == langCodes[i]) {
        return locales[i];
      }
    }
    return Get.locale;
  }
}
