import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_repository.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  final SharedPreferences _prefs;
  static const _localeKey = 'app_locale_language_code';

  LocaleRepositoryImpl(this._prefs);

  @override
  Future<Locale?> getSavedLocale() async {
    final languageCode = _prefs.getString(_localeKey);
    if (languageCode == null) return null;
    return Locale(languageCode);
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.languageCode);
  }
}
