import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kodekid/core/services/preferences_service.dart';

void main() {
  group('SharedPreferences Tests', () {
    setUp(() {
      // Clear SharedPreferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('Theme mode can be saved and retrieved', () async {
      // Test setting theme mode
      await PreferencesService.setThemeMode('dark');
      final theme = await PreferencesService.getThemeMode();
      
      expect(theme, equals('dark'));
    });

    test('Sound setting can be toggled', () async {
      // Test sound setting
      await PreferencesService.setSoundEnabled(false);
      final soundEnabled = await PreferencesService.getSoundEnabled();
      
      expect(soundEnabled, isFalse);
    });

    test('Notifications setting persists', () async {
      // Test notifications setting
      await PreferencesService.setNotificationsEnabled(false);
      final notificationsEnabled = await PreferencesService.getNotificationsEnabled();
      
      expect(notificationsEnabled, isFalse);
    });

    test('Auto-save setting works correctly', () async {
      // Test auto-save setting
      await PreferencesService.setAutoSaveEnabled(false);
      final autoSaveEnabled = await PreferencesService.getAutoSaveEnabled();
      
      expect(autoSaveEnabled, isFalse);
    });

    test('Default values are returned when no preference is set', () async {
      // Test default values
      final theme = await PreferencesService.getThemeMode();
      final sound = await PreferencesService.getSoundEnabled();
      final notifications = await PreferencesService.getNotificationsEnabled();
      final autoSave = await PreferencesService.getAutoSaveEnabled();
      
      expect(theme, equals('system'));
      expect(sound, isTrue);
      expect(notifications, isTrue);
      expect(autoSave, isTrue);
    });
  });
}