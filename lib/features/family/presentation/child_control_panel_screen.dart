import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/animated_mesh_gradient.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/data/fake_family_data.dart';
import '../../../core/data/fake_transactions.dart';

/// Child Control Panel Screen
/// ROADMAP: Task 1.15.4 - Child Control Panel (THE CORE FEATURE)
/// Allows parents to manage child's permissions, limits, and settings
class ChildControlPanelScreen extends StatefulWidget {
  final String childId;

  const ChildControlPanelScreen({
    super.key,
    required this.childId,
  });

  @override
  State<ChildControlPanelScreen> createState() => _ChildControlPanelScreenState();
}

class _ChildControlPanelScreenState extends State<ChildControlPanelScreen> {
  late FamilyMember child;
  late FamilyMemberPermissions permissions;

  @override
  void initState() {
    super.initState();
    final member = FakeFamilyData.getMemberById(widget.childId);
    if (member == null || member.role != 'child') {
      // Invalid child ID - will show error in build
      child = FakeFamilyData.child1;
      permissions = child.permissions;
    } else {
      child = member;
      permissions = member.permissions;
    }
  }

  void _updatePermissions(FamilyMemberPermissions newPermissions) {
    setState(() {
      permissions = newPermissions;
    });
    HapticService.lightImpact();
    // TODO: Save to backend
  }

  void _toggleCardFreeze() {
    HapticService.mediumImpact();
    _updatePermissions(permissions.copyWith(
      cardFrozen: !permissions.cardFrozen,
    ));
    CustomToast.showSuccess(
      context,
      permissions.cardFrozen ? 'Card unfrozen' : 'Card frozen',
    );
  }

  void _showFreezeConfirmation() {
    HapticService.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.glassSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          permissions.cardFrozen ? 'Unfreeze Card?' : 'Freeze Card?',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          permissions.cardFrozen
              ? 'This will allow ${child.name} to make payments again.'
              : 'This will prevent ${child.name} from making any payments.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticService.lightImpact();
              context.pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _toggleCardFreeze();
            },
            child: Text(
              permissions.cardFrozen ? 'Unfreeze' : 'Freeze',
              style: TextStyle(
                color: permissions.cardFrozen ? AppColors.success : AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final childTransactions = FakeTransactions.getTransactions(isDuressMode: false).take(5).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('${child.name}\'s Controls'),
      ),
      body: StaticGradientBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Top spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              // Child Info Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            gradient: AppColors.successGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              child.avatar,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                child.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${child.age} years old',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Balance: R ${child.balance.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0, duration: 400.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              // Emergency Freeze Button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassButton(
                    onPressed: _showFreezeConfirmation,
                    width: double.infinity,
                    height: 56,
                    gradient: permissions.cardFrozen
                        ? AppColors.successGradient
                        : const LinearGradient(
                            colors: [AppColors.danger, Color(0xFFE74C3C)],
                          ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          permissions.cardFrozen
                              ? Icons.check_circle_rounded
                              : Icons.ac_unit_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          permissions.cardFrozen ? 'Unfreeze Card' : 'Freeze Card',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 100.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Permissions Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Permissions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),

              // Permissions Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _PermissionToggle(
                          icon: Icons.payment_rounded,
                          title: 'Can Make Payments',
                          subtitle: 'Allow transactions and purchases',
                          value: permissions.canMakePayments,
                          onChanged: (value) => _updatePermissions(
                            permissions.copyWith(canMakePayments: value),
                          ),
                        ),
                        const Divider(height: 32),
                        _PermissionToggle(
                          icon: Icons.visibility_rounded,
                          title: 'View Full Balance',
                          subtitle: 'Show complete account balance',
                          value: permissions.canViewFullBalance,
                          onChanged: (value) => _updatePermissions(
                            permissions.copyWith(canViewFullBalance: value),
                          ),
                        ),
                        const Divider(height: 32),
                        _PermissionToggle(
                          icon: Icons.shopping_cart_rounded,
                          title: 'Online Purchases',
                          subtitle: 'Allow online shopping',
                          value: permissions.onlinePurchases,
                          onChanged: (value) => _updatePermissions(
                            permissions.copyWith(onlinePurchases: value),
                          ),
                        ),
                        const Divider(height: 32),
                        _PermissionToggle(
                          icon: Icons.atm_rounded,
                          title: 'ATM Withdrawals',
                          subtitle: 'Allow cash withdrawals',
                          value: permissions.atmWithdrawals,
                          onChanged: (value) => _updatePermissions(
                            permissions.copyWith(atmWithdrawals: value),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 300.ms)
                      .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 300.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Spending Limits Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Spending Limits',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 400.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),

              // Spending Limits Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _SpendingLimitSlider(
                          icon: Icons.calendar_today_rounded,
                          title: 'Daily Limit',
                          value: permissions.dailyLimit,
                          min: 0,
                          max: 500,
                          divisions: 50,
                          onChanged: (value) => _updatePermissions(
                            permissions.copyWith(dailyLimit: value),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _SpendingLimitSlider(
                          icon: Icons.receipt_long_rounded,
                          title: 'Per Transaction Limit',
                          value: permissions.perTransactionLimit,
                          min: 0,
                          max: 250,
                          divisions: 50,
                          onChanged: (value) => _updatePermissions(
                            permissions.copyWith(perTransactionLimit: value),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 500.ms)
                      .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 500.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Notification Settings Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Notification Settings',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 600.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),

              // Notification Settings Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _PermissionToggle(
                          icon: Icons.notifications_active_rounded,
                          title: 'Notify on All Transactions',
                          subtitle: 'Get alerts for every purchase',
                          value: permissions.notifyAll,
                          onChanged: (value) => _updatePermissions(
                            permissions.copyWith(notifyAll: value),
                          ),
                        ),
                        const Divider(height: 32),
                        _PermissionToggle(
                          icon: Icons.warning_rounded,
                          title: 'Large Transaction Alerts',
                          subtitle: 'Only notify for large purchases',
                          value: permissions.notifyLargeTransactions,
                          onChanged: permissions.notifyAll
                              ? null
                              : (value) => _updatePermissions(
                                    permissions.copyWith(notifyLargeTransactions: value),
                                  ),
                        ),
                        if (!permissions.notifyAll && permissions.notifyLargeTransactions) ...[
                          const SizedBox(height: 24),
                          _SpendingLimitSlider(
                            icon: Icons.attach_money_rounded,
                            title: 'Alert Threshold',
                            value: permissions.largeTransactionThreshold,
                            min: 10,
                            max: 200,
                            divisions: 38,
                            onChanged: (value) => _updatePermissions(
                              permissions.copyWith(largeTransactionThreshold: value),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 700.ms)
                      .slideY(begin: 0.1, end: 0, duration: 400.ms, delay: 700.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Recent Transactions Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Transactions',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          HapticService.lightImpact();
                          // TODO: Navigate to child's full transaction history
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 800.ms),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),

              // Transactions List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final transaction = childTransactions[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 12,
                      ),
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: transaction.isPositive
                                    ? AppColors.success.withValues(alpha: 0.15)
                                    : AppColors.danger.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                transaction.isPositive
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                color: transaction.isPositive
                                    ? AppColors.success
                                    : AppColors.danger,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.title,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    transaction.category ?? transaction.subtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${transaction.isPositive ? '+' : '-'}R ${transaction.amount.toStringAsFixed(2)}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: transaction.isPositive
                                    ? AppColors.success
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: (900 + (index * 50)).ms)
                          .slideX(
                            begin: -0.1,
                            end: 0,
                            duration: 400.ms,
                            delay: (900 + (index * 50)).ms,
                          ),
                    );
                  },
                  childCount: childTransactions.length,
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // Bottom padding
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Permission Toggle Widget
class _PermissionToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _PermissionToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onChanged == null;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: value && !isDisabled
                ? AppColors.primary.withValues(alpha: 0.15)
                : AppColors.textTertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: value && !isDisabled ? AppColors.primary : AppColors.textTertiary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: isDisabled ? AppColors.textTertiary : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: isDisabled
              ? null
              : (newValue) {
                  HapticService.lightImpact();
                  onChanged?.call(newValue);
                },
          activeTrackColor: AppColors.primary,
        ),
      ],
    );
  }
}

/// Spending Limit Slider Widget
class _SpendingLimitSlider extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SpendingLimitSlider({
    required this.icon,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              'R ${value.toStringAsFixed(0)}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.textTertiary.withValues(alpha: 0.2),
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: (newValue) {
              HapticService.lightImpact();
              onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }
}
