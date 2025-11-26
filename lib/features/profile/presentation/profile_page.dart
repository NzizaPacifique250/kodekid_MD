import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/kodekid_logo.dart';
import '../../../core/widgets/persistent_bottom_nav.dart';
import '../../../routes/app_routes.dart';
import '../providers/user_profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: const KodeKidLogo(),
            ),
            
            const SizedBox(height: 40),
            
            // Profile Avatar
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.lightBlue.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lightBlue,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: AppColors.lightBlue,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // User Name and Email
            userProfileAsync.when(
              data: (profile) => Column(
                children: [
                  Text(
                    profile?.name ?? 'User',
                    style: AppTextStyles.bodyText(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile?.email ?? 'user@kodekid.com',
                    style: AppTextStyles.bodyText(
                      fontSize: 16,
                    ).copyWith(color: AppColors.darkGrey.withOpacity(0.6)),
                  ),
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(
                'Error loading profile',
                style: AppTextStyles.bodyText(fontSize: 16),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Profile Options
            _buildProfileOption(
              context,
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editProfile);
              },
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.helpSupport);
              },
            ),
            
            _buildProfileOption(
              context,
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.logout);
              },
              isDestructive: true,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const PersistentBottomNav(),
    );
  }

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.lightGrey.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? AppColors.orange.withOpacity(0.1)
                        : AppColors.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive
                        ? AppColors.orange
                        : AppColors.lightBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyText(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ).copyWith(
                      color: isDestructive
                          ? AppColors.orange
                          : AppColors.darkGrey,
                    ),
                  ),
                ),
                Icon(
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

