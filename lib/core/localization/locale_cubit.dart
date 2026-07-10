import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'locale_constants.dart';
import 'locale_repository.dart';

class LocaleCubit extends Cubit<Locale> {
  final LocaleRepository _repository;

  LocaleCubit(this._repository) : super(AppLocaleConstants.defaultLocale);

  Future<void> loadSavedLocale() async {
    final saved = await _repository.getSavedLocale();
    if (saved != null) {
      emit(saved);
    } else {
      final platformLocale = PlatformDispatcher.instance.locale;
      // Check if platform locale is one of the supported locales
      final isSupported = AppLocaleConstants.supportedLocales.any(
        (l) => l.languageCode == platformLocale.languageCode,
      );
      if (isSupported) {
        emit(Locale(platformLocale.languageCode));
      } else {
        emit(AppLocaleConstants.defaultLocale);
      }
    }
  }

  Future<void> changeLocale(Locale locale) async {
    await _repository.saveLocale(locale);
    emit(locale);
  }
}
