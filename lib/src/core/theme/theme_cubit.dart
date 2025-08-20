import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supervisor/src/core/di/dependency_injection.dart';

part 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences _sharedPreferences = getIt<SharedPreferences>();
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.system)) {
    // Load the saved theme state during initialization
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final String? themeModeString = _sharedPreferences.getString(_themeKey);

    // If no theme is saved (first time app launch), use system theme
    if (themeModeString == null) {
      emit(ThemeState(themeMode: ThemeMode.system));
      return;
    }

    ThemeMode themeMode;

    if (themeModeString == ThemeMode.dark.toString()) {
      themeMode = ThemeMode.dark;
    } else if (themeModeString == ThemeMode.system.toString()) {
      themeMode = ThemeMode.system;
    } else {
      themeMode = ThemeMode.light;
    }

    emit(ThemeState(themeMode: themeMode));
  }

  void toggleTheme() {
    ThemeMode newThemeMode;

    if (state.themeMode == ThemeMode.light) {
      newThemeMode = ThemeMode.dark;
    } else if (state.themeMode == ThemeMode.dark) {
      newThemeMode = ThemeMode.system;
    } else {
      newThemeMode = ThemeMode.light;
    }

    _sharedPreferences.setString(_themeKey, newThemeMode.toString());
    emit(ThemeState(themeMode: newThemeMode));
  }

  void setThemeMode(ThemeMode themeMode) {
    if (state.themeMode != themeMode) {
      _sharedPreferences.setString(_themeKey, themeMode.toString());
      emit(ThemeState(themeMode: themeMode));
    }
  }

  bool get isDarkMode =>
      state.themeMode == ThemeMode.dark ||
      (state.themeMode == ThemeMode.system &&
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark);
}
