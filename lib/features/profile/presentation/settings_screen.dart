import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/custom_toast.dart';
import 'widgets/settings_tile.dart';

/// Settings Screen
/// Comprehensive app settings and preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Security Section
          const SettingsSectionHeader(title: 'Security'),

          SettingsToggleTile(
            icon: Icons.fingerprint_rounded,
            title: 'Biometric Authentication',
            subtitle: 'Use Face ID or fingerprint to unlock',
            value: settings.biometricEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleBiometric(value);
              CustomToast.showSuccess(
                context,
                value ? 'Biometric enabled' : 'Biometric disabled',
              );
            },
          ),

          // Notifications Section
          const SettingsSectionHeader(title: 'Notifications'),

          SettingsToggleTile(
            icon: Icons.notifications_rounded,
            title: 'Push Notifications',
            subtitle: 'Receive app notifications',
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleNotifications(value);
            },
          ),

          SettingsToggleTile(
            icon: Icons.receipt_rounded,
            title: 'Transaction Alerts',
            subtitle: 'Get notified of all transactions',
            value: settings.transactionAlerts,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleTransactionAlerts(value);
            },
          ),

          SettingsToggleTile(
            icon: Icons.security_rounded,
            title: 'Security Alerts',
            subtitle: 'Important security notifications',
            value: settings.securityAlerts,
            iconColor: AppColors.danger,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).toggleSecurityAlerts(value);
            },
          ),

          // Appearance Section
          const SettingsSectionHeader(title: 'Appearance'),

          SettingsTile(
            icon: Icons.dark_mode_rounded,
            title: 'Theme',
            subtitle: 'Dark Mode (Light mode coming soon)',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Dark',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            onTap: () {
              CustomToast.showInfo(context, 'Light mode coming soon');
            },
          ),

          // Regional Section
          const SettingsSectionHeader(title: 'Regional'),

          SettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            subtitle: _getLanguageName(settings.language),
            onTap: () => _showLanguageDialog(context, ref, settings.language),
          ),

          SettingsTile(
            icon: Icons.attach_money_rounded,
            title: 'Currency Format',
            subtitle: settings.currency == 'spaced' ? 'R 12,450.50' : 'R12450.50',
            onTap: () => _showCurrencyDialog(context, ref, settings.currency),
          ),

          // About Section
          const SettingsSectionHeader(title: 'About'),

          SettingsTile(
            icon: Icons.privacy_tip_rounded,
            title: 'Privacy Policy',
            onTap: () {
              CustomToast.showInfo(context, 'Privacy policy coming soon');
            },
          ),

          SettingsTile(
            icon: Icons.description_rounded,
            title: 'Terms of Service',
            onTap: () {
              CustomToast.showInfo(context, 'Terms of service coming soon');
            },
          ),

          // Developer Section (Debug Only)
          const SettingsSectionHeader(title: 'Developer'),

          SettingsTile(
            icon: Icons.bug_report_rounded,
            title: 'Reset Settings',
            subtitle: 'Reset all settings to default',
            iconColor: AppColors.warning,
            onTap: () => _showResetDialog(context, ref),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'zu':
        return 'isiZulu';
      case 'af':
        return 'Afrikaans';
      default:
        return 'English';
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, String current) {
    final theme = Theme.of(context);
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'zu', 'name': 'isiZulu'},
      {'code': 'af', 'name': 'Afrikaans'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Select Language',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            final isSelected = lang['code'] == current;
            return ListTile(
              title: Text(
                lang['name']!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(settingsProvider.notifier).setLanguage(lang['code']!);
                Navigator.of(context).pop();
                CustomToast.showSuccess(context, 'Language updated to ${lang['name']}');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, WidgetRef ref, String current) {
    final theme = Theme.of(context);
    final formats = [
      {'code': 'spaced', 'name': 'R 12,450.50 (Spaced)'},
      {'code': 'compact', 'name': 'R12450.50 (Compact)'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Currency Format',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: formats.map((format) {
            final isSelected = format['code'] == current;
            return ListTile(
              title: Text(
                format['name']!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                ref.read(settingsProvider.notifier).setCurrencyFormat(format['code']!);
                Navigator.of(context).pop();
                CustomToast.showSuccess(context, 'Currency format updated');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Reset Settings',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'This will reset all settings to their default values. Are you sure?',
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
              ref.read(settingsProvider.notifier).resetSettings();
              Navigator.of(context).pop();
              CustomToast.showSuccess(context, 'Settings reset successfully');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.warning,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
