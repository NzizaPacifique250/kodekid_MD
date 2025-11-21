import 'package:flutter/material.dart';
// No Riverpod import here — this file provides a `ChangeNotifier` for `provider`.

/// Classic provider ChangeNotifier-based theme provider (for `provider` package).
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

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
    notifyListeners();
  }
}

// Note: Riverpod providers live elsewhere (e.g. `course_provider.dart`).
// This file exposes the classic ChangeNotifier `ThemeProvider` for the
// `provider` package and intentionally does not re-declare a Riverpod
// provider to avoid symbol collisions.
