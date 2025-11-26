import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

/// Classic provider ChangeNotifier-based theme provider (for `provider` package).
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadThemePreference() async {
    _isDarkMode = await PreferencesService.isDarkMode();
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      );

  void toggleTheme([bool? value]) {
    _isDarkMode = value ?? !_isDarkMode;
    PreferencesService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}

// Note: Riverpod providers live elsewhere (e.g. `course_provider.dart`).
// This file exposes the classic ChangeNotifier `ThemeProvider` for the
// `provider` package and intentionally does not re-declare a Riverpod
// provider to avoid symbol collisions.
