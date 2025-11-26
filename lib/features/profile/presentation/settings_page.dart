import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/services/preferences_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _autoSaveEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notifications = await PreferencesService.areNotificationsEnabled();
    final sound = await PreferencesService.isSoundEnabled();
    final autoSave = await PreferencesService.isAutoSaveEnabled();
    
    if (mounted) {
      setState(() {
        _notificationsEnabled = notifications;
        _soundEnabled = sound;
        _autoSaveEnabled = autoSave;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.bodyText(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSettingsSection(
            'Notifications',
            [
              _buildSwitchTile(
                'Push Notifications',
                'Receive notifications about new lessons and updates',
                _notificationsEnabled,
                (value) async {
                  await PreferencesService.setNotificationsEnabled(value);
                  setState(() => _notificationsEnabled = value);
                },
              ),
              _buildSwitchTile(
                'Sound',
                'Play sounds for notifications and interactions',
                _soundEnabled,
                (value) async {
                  await PreferencesService.setSoundEnabled(value);
                  setState(() => _soundEnabled = value);
                },
              ),
              _buildSwitchTile(
                'Auto-Save Progress',
                'Automatically save your lesson progress',
                _autoSaveEnabled,
                (value) async {
                  await PreferencesService.setAutoSaveEnabled(value);
                  setState(() => _autoSaveEnabled = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildSettingsSection(
            'Appearance',
            [
              Builder(builder: (context) {
                final themeProvider = context.watch<ThemeProvider>();
                return _buildSwitchTile(
                  'Dark Mode',
                  'Switch to dark theme',
                  themeProvider.isDarkMode,
                  (value) async {
                    await PreferencesService.setDarkMode(value);
                    themeProvider.toggleTheme(value);
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: 32),
          _buildSettingsSection(
            'Account',
            [
              _buildSettingsTile(
                'Change Password',
                'Update your account password',
                Icons.lock_outline,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Change password feature coming soon!')),
                  );
                },
              ),
              _buildSettingsTile(
                'Privacy Policy',
                'Read our privacy policy',
                Icons.privacy_tip_outlined,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Privacy policy feature coming soon!')),
                  );
                },
              ),
              _buildSettingsTile(
                'Terms of Service',
                'Read our terms of service',
                Icons.description_outlined,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Terms of service feature coming soon!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyText(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyText(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyText(
                    fontSize: 14,
                  ).copyWith(color: AppColors.darkGrey.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.lightBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.lightBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyText(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyText(
                          fontSize: 14,
                        ).copyWith(color: AppColors.darkGrey.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.lightGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
