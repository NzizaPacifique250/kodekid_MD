import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, String>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<String> {
  ThemeNotifier() : super('system') {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await PreferencesService.getThemeMode();
    state = theme;
  }

  Future<void> setTheme(String theme) async {
    await PreferencesService.setThemeMode(theme);
    state = theme;
  }
}

final soundProvider = StateNotifierProvider<SoundNotifier, bool>((ref) {
  return SoundNotifier();
});

class SoundNotifier extends StateNotifier<bool> {
  SoundNotifier() : super(true) {
    _loadSound();
  }

  Future<void> _loadSound() async {
    final sound = await PreferencesService.getSoundEnabled();
    state = sound;
  }

  Future<void> toggleSound() async {
    final newValue = !state;
    await PreferencesService.setSoundEnabled(newValue);
    state = newValue;
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, bool>((ref) {
  return NotificationsNotifier();
});

class NotificationsNotifier extends StateNotifier<bool> {
  NotificationsNotifier() : super(true) {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await PreferencesService.getNotificationsEnabled();
    state = notifications;
  }

  Future<void> toggleNotifications() async {
    final newValue = !state;
    await PreferencesService.setNotificationsEnabled(newValue);
    state = newValue;
  }
}

final autoSaveProvider = StateNotifierProvider<AutoSaveNotifier, bool>((ref) {
  return AutoSaveNotifier();
});

class AutoSaveNotifier extends StateNotifier<bool> {
  AutoSaveNotifier() : super(true) {
    _loadAutoSave();
  }

  Future<void> _loadAutoSave() async {
    final autoSave = await PreferencesService.getAutoSaveEnabled();
    state = autoSave;
  }

  Future<void> toggleAutoSave() async {
    final newValue = !state;
    await PreferencesService.setAutoSaveEnabled(newValue);
    state = newValue;
  }
}