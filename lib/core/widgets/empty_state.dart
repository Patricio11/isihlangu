import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// Empty State Widget
/// Displays friendly empty states with icons and messages
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.iconColor,
  });

  /// No transactions empty state
  factory EmptyState.noTransactions({
    required BuildContext context,
    VoidCallback? onAddTransaction,
  }) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'No Transactions Yet',
      message: 'Your first transaction will appear here',
      iconColor: context.colors.primary,
      action: onAddTransaction != null
          ? ElevatedButton.icon(
              onPressed: onAddTransaction,
              icon: const Icon(Icons.add),
              label: const Text('Make a Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
            )
          : null,
    );
  }

  /// No contacts empty state
  factory EmptyState.noContacts({
    required BuildContext context,
    VoidCallback? onAddContact,
  }) {
    return EmptyState(
      icon: Icons.people_outline,
      title: 'No Contacts',
      message: 'Add your first trusted contact to get started',
      iconColor: context.colors.info,
      action: onAddContact != null
          ? ElevatedButton.icon(
              onPressed: onAddContact,
              icon: const Icon(Icons.person_add),
              label: const Text('Add Contact'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
              ),
            )
          : null,
    );
  }

  /// No tasks empty state (child view)
  factory EmptyState.noTasks(BuildContext context) {
    return EmptyState(
      icon: Icons.check_circle_outline,
      title: 'No Chores Available',
      message: 'Check back later for new tasks',
      iconColor: context.colors.success,
    );
  }

  /// All caught up (notifications)
  factory EmptyState.allCaughtUp(BuildContext context) {
    return EmptyState(
      icon: Icons.notifications_none,
      title: 'All Caught Up!',
      message: 'You have no new notifications',
      iconColor: context.colors.primary,
    );
  }

  /// Search no results
  factory EmptyState.noResults({
    required BuildContext context,
    String? query,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: query != null
          ? 'No results for "$query"'
          : 'Try adjusting your search',
      iconColor: context.colors.textTertiary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color: (iconColor ?? context.colors.textTertiary).withAlpha(128),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 200.ms),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 400.ms),
            if (action != null) ...[
              const SizedBox(height: 32),
              action!
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 600.ms),
            ],
          ],
        ),
      ),
    );
  }
}
