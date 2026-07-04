import 'dart:ui';

abstract interface class LocaleRepository {
  Future<Locale?> getSavedLocale();
  Future<void> saveLocale(Locale locale);
}
