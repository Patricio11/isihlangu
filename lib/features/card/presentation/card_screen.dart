import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/fake_card_data.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/utils/haptics.dart';
import '../../profile/presentation/widgets/settings_tile.dart';
import 'widgets/flip_card.dart';
import 'widgets/card_limit_slider.dart';

/// Card Management Screen
/// Comprehensive card controls and settings
class CardScreen extends ConsumerStatefulWidget {
  const CardScreen({super.key});

  @override
  ConsumerState<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends ConsumerState<CardScreen> {
  bool _isFrozen = FakeCardData.isFrozen;
  bool _onlinePurchases = FakeCardData.onlinePurchasesEnabled;
  bool _international = FakeCardData.internationalTransactionsEnabled;
  bool _contactless = FakeCardData.contactlessEnabled;

  double _dailyLimit = FakeCardData.dailySpendLimit;
  double _atmLimit = FakeCardData.atmWithdrawalLimit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showCardOptionsMenu(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card display with flip animation
          FlipCard(
            cardNumber: FakeCardData.cardNumber,
            cardholderName: FakeCardData.cardholderName,
            expiryDate: FakeCardData.expiryDate,
            cvv: FakeCardData.cvv,
            cardType: FakeCardData.cardType,
            cardColor: Color(FakeCardData.cardColorValue),
            isFrozen: _isFrozen,
          ),

          const SizedBox(height: 24),

          // Quick actions
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: _isFrozen ? Icons.ac_unit : Icons.lock_outline,
                  label: _isFrozen ? 'Unfreeze' : 'Freeze Card',
                  color: _isFrozen ? AppColors.primary : AppColors.danger,
                  onTap: _toggleFreeze,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.content_copy_rounded,
                  label: 'Copy Number',
                  color: AppColors.info,
                  onTap: _copyCardNumber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Card Limits Section
          const SettingsSectionHeader(title: 'Spending Limits'),

          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CardLimitSlider(
                  title: 'Daily Spend Limit',
                  value: _dailyLimit,
                  min: FakeCardData.minDailyLimit,
                  max: FakeCardData.maxDailyLimit,
                  icon: Icons.shopping_bag_outlined,
                  onChanged: (value) {
                    setState(() => _dailyLimit = value);
                  },
                ),
                const SizedBox(height: 24),
                CardLimitSlider(
                  title: 'ATM Withdrawal Limit',
                  value: _atmLimit,
                  min: FakeCardData.minAtmLimit,
                  max: FakeCardData.maxAtmLimit,
                  icon: Icons.atm_rounded,
                  onChanged: (value) {
                    setState(() => _atmLimit = value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Card Controls Section
          const SettingsSectionHeader(title: 'Card Controls'),

          SettingsToggleTile(
            icon: Icons.shopping_cart_outlined,
            title: 'Online Purchases',
            subtitle: 'Allow online and e-commerce transactions',
            value: _onlinePurchases,
            onChanged: (value) {
              setState(() => _onlinePurchases = value);
              CustomToast.showSuccess(
                context,
                value ? 'Online purchases enabled' : 'Online purchases disabled',
              );
            },
          ),

          SettingsToggleTile(
            icon: Icons.public_rounded,
            title: 'International Transactions',
            subtitle: 'Use card outside South Africa',
            value: _international,
            onChanged: (value) {
              setState(() => _international = value);
              CustomToast.showSuccess(
                context,
                value
                    ? 'International transactions enabled'
                    : 'International transactions disabled',
              );
            },
          ),

          SettingsToggleTile(
            icon: Icons.contactless_rounded,
            title: 'Contactless Payments',
            subtitle: 'Tap to pay functionality',
            value: _contactless,
            onChanged: (value) {
              setState(() => _contactless = value);
              CustomToast.showSuccess(
                context,
                value ? 'Contactless enabled' : 'Contactless disabled',
              );
            },
          ),

          const SizedBox(height: 32),

          // Virtual Card Section
          const SettingsSectionHeader(title: 'Virtual Card'),

          SettingsTile(
            icon: Icons.credit_card_outlined,
            title: 'Generate Virtual Card',
            subtitle: 'Create a temporary card for one-time use',
            iconColor: AppColors.info,
            onTap: () {
              _showVirtualCardDialog(context);
            },
          ),

          const SizedBox(height: 32),

          // Card Actions Section
          const SettingsSectionHeader(title: 'Card Actions'),

          SettingsTile(
            icon: Icons.report_problem_outlined,
            title: 'Report Lost or Stolen',
            subtitle: 'Block card and request replacement',
            iconColor: AppColors.warning,
            onTap: () {
              _showReportDialog(context);
            },
          ),

          SettingsTile(
            icon: Icons.refresh_rounded,
            title: 'Order Replacement Card',
            subtitle: 'Request a new physical card',
            onTap: () {
              CustomToast.showInfo(context, 'Card replacement coming in Phase 2');
            },
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _toggleFreeze() {
    HapticService.mediumImpact();
    setState(() => _isFrozen = !_isFrozen);
    CustomToast.showSuccess(
      context,
      _isFrozen ? 'Card frozen successfully' : 'Card unfrozen successfully',
    );
  }

  void _copyCardNumber() {
    HapticService.mediumImpact();
    Clipboard.setData(const ClipboardData(text: FakeCardData.cardNumberFull));
    CustomToast.showSuccess(context, 'Card number copied');
  }

  void _showCardOptionsMenu(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download_rounded, color: AppColors.primary),
              title: Text(
                'Download Card Statement',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                CustomToast.showInfo(context, 'Statement download coming in Phase 2');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded, color: AppColors.primary),
              title: Text(
                'Advanced Settings',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                CustomToast.showInfo(context, 'Advanced settings coming in Phase 2');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVirtualCardDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Generate Virtual Card',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Create a temporary virtual card that expires after 24 hours. Perfect for one-time online purchases.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              CustomToast.showSuccess(context, 'Virtual card generated!');
              CustomToast.showInfo(context, 'Full feature coming in Phase 2');
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'Report Card',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.danger,
          ),
        ),
        content: Text(
          'This will immediately block your card and prevent all transactions. Are you sure?',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              CustomToast.showWarning(context, 'Card blocked successfully');
              CustomToast.showInfo(context, 'Full feature coming in Phase 2');
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.danger,
            ),
            child: const Text('Report Lost/Stolen'),
          ),
        ],
      ),
    );
  }
}

/// Quick Action Button Widget
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
