import 'package:flutter/material.dart';

class AppLanguage {
  final Locale locale;
  final String name;
  final String nativeName;

  const AppLanguage({
    required this.locale,
    required this.name,
    required this.nativeName,
  });
}

class AppLocaleConstants {
  static const defaultLocale = Locale('en');

  static const List<AppLanguage> supportedLanguages = [
    AppLanguage(
      locale: Locale('en'),
      name: 'English',
      nativeName: 'English',
    ),
    AppLanguage(
      locale: Locale('ar'),
      name: 'Arabic',
      nativeName: 'العربية',
    ),
  ];

  static List<Locale> get supportedLocales =>
      supportedLanguages.map((l) => l.locale).toList();
}
