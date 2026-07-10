import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Drives [MaterialApp.themeMode] for the whole app.
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  /// Turn system off and force light or dark.
  void setDarkMode(bool enabled) {
    emit(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  /// Switch position for a settings toggle.
  static bool isDarkActive(BuildContext context, ThemeMode mode) {
    return switch (mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
  }
}
