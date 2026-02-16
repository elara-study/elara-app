import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for app locale (language) - persisted via SharedPreferences.
class LocaleController extends GetxController {
  static const _localeKey = 'app_locale';

  final Rx<Locale> _locale = const Locale('ar').obs;
  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_localeKey);
      if (code != null) {
        _locale.value = Locale(code);
        Get.updateLocale(Locale(code));
      }
    } catch (_) {}
  }

  /// Switch to Arabic.
  Future<void> setArabic() async {
    _locale.value = const Locale('ar');
    Get.updateLocale(const Locale('ar'));
    await _saveLocale('ar');
  }

  /// Switch to English.
  Future<void> setEnglish() async {
    _locale.value = const Locale('en');
    Get.updateLocale(const Locale('en'));
    await _saveLocale('en');
  }

  /// Toggle between Arabic and English.
  Future<void> toggleLocale() async {
    final isAr = _locale.value.languageCode == 'ar';
    if (isAr) {
      await setEnglish();
    } else {
      await setArabic();
    }
  }

  bool get isArabic => _locale.value.languageCode == 'ar';

  Future<void> _saveLocale(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, code);
    } catch (_) {}
  }
}
