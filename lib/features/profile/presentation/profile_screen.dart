import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/fake_user_profile.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../auth/providers/session_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_tile.dart';

/// Profile Screen
/// Main profile screen with user info and quick settings
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider).session;
    final isRestricted = session?.isRestricted ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // Settings Icon
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              HapticService.lightImpact();
              context.push('/settings');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          ProfileHeader(
            name: FakeUserProfile.name,
            initials: FakeUserProfile.initials,
            role: FakeUserProfile.role,
            memberSince: FakeUserProfile.memberSince,
          ),

          const SizedBox(height: 24),

          // Account Section
          const SettingsSectionHeader(title: 'Account'),

          SettingsTile(
            icon: Icons.email_rounded,
            title: 'Email',
            subtitle: FakeUserProfile.email,
            onTap: () {
              CustomToast.showInfo(context, 'Email management coming in Phase 2');
            },
          ),

          SettingsTile(
            icon: Icons.phone_rounded,
            title: 'Phone Number',
            subtitle: FakeUserProfile.phone,
            onTap: () {
              CustomToast.showInfo(context, 'Phone management coming in Phase 2');
            },
          ),

          SettingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Change PIN',
            subtitle: 'Update your security PIN',
            onTap: () {
              CustomToast.showInfo(context, 'PIN change coming in Phase 2');
            },
          ),

          if (!isRestricted)
            SettingsTile(
              icon: Icons.shield_outlined,
              title: 'Change Duress PIN',
              subtitle: 'Update your duress protection PIN',
              iconColor: AppColors.danger,
              onTap: () {
                CustomToast.showInfo(context, 'Duress PIN change coming in Phase 2');
              },
            ),

          // Family Section (Phase 3)
          const SettingsSectionHeader(title: 'Family'),

          SettingsTile(
            icon: Icons.family_restroom_rounded,
            title: FakeUserProfile.familyName,
            subtitle: '${FakeUserProfile.familyMemberCount} members',
            onTap: () {
              CustomToast.showInfo(context, 'Family management coming in Phase 3');
            },
          ),

          // Security Section
          const SettingsSectionHeader(title: 'Security'),

          SettingsTile(
            icon: Icons.devices_rounded,
            title: 'Active Sessions',
            subtitle: 'Manage your logged-in devices',
            onTap: () {
              _showActiveSessionsDialog(context);
            },
          ),

          SettingsTile(
            icon: Icons.shield_rounded,
            title: 'Privacy & Security',
            subtitle: 'Control your data and security',
            onTap: () {
              context.push('/settings');
            },
          ),

          // Support Section
          const SettingsSectionHeader(title: 'Support'),

          SettingsTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'FAQs and contact us',
            onTap: () {
              CustomToast.showInfo(context, 'Help center coming in Phase 1.5');
            },
          ),

          SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About Shield',
            subtitle: 'Version ${FakeUserProfile.appVersion}',
            onTap: () {
              context.push('/onboarding');
            },
          ),

          // Danger Zone
          const SettingsSectionHeader(title: 'Account Actions'),

          SettingsTile(
            icon: Icons.logout_rounded,
            title: 'Log Out',
            subtitle: 'Sign out of your account',
            iconColor: AppColors.danger,
            onTap: () => _showLogoutDialog(context, ref),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Active Sessions',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone_iphone, color: AppColors.primary),
              title: Text(
                FakeUserProfile.currentDevice,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'This device - Active now',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Log Out',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              HapticService.mediumImpact();
              Navigator.of(context).pop();
              ref.read(sessionProvider.notifier).logout();
              context.go('/login');
              CustomToast.showSuccess(context, 'Logged out successfully');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.danger,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
