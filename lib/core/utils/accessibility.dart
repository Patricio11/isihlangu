import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility Utilities
/// ROADMAP: Task 1.12 - Accessibility Features
/// Provides semantic labels and screen reader support
class AccessibilityHelper {
  /// Announce a message to screen readers
  static void announce(BuildContext context, String message) {
    // Uses SemanticsService to announce to screen readers
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      SemanticsService.tooltip(message);
    }
  }

  /// Create semantic label for currency amounts
  static String currencyLabel(double amount, {bool isPositive = false}) {
    final prefix = isPositive ? 'Received' : 'Spent';
    final absAmount = amount.abs();
    final rand = absAmount.floor();
    final cents = ((absAmount - rand) * 100).round();

    if (cents == 0) {
      return '$prefix $rand rand';
    }
    return '$prefix $rand rand and $cents cents';
  }

  /// Create semantic label for dates
  static String dateLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  /// Create semantic label for transaction type
  static String transactionTypeLabel(String type, String merchant, double amount) {
    final amountLabel = currencyLabel(amount);
    switch (type.toLowerCase()) {
      case 'purchase':
        return 'Purchase at $merchant. $amountLabel';
      case 'received':
        return 'Payment received from $merchant. $amountLabel';
      case 'sent':
        return 'Payment sent to $merchant. $amountLabel';
      case 'refund':
        return 'Refund from $merchant. $amountLabel';
      default:
        return 'Transaction with $merchant. $amountLabel';
    }
  }

  /// Create semantic label for balance
  static String balanceLabel(double balance) {
    final rand = balance.floor();
    final cents = ((balance - rand) * 100).round();

    if (cents == 0) {
      return 'Your balance is $rand rand';
    }
    return 'Your balance is $rand rand and $cents cents';
  }

  /// Create semantic label for notification badge
  static String notificationBadgeLabel(int count) {
    if (count == 0) {
      return 'No new notifications';
    } else if (count == 1) {
      return '1 new notification';
    } else {
      return '$count new notifications';
    }
  }

  /// Create semantic label for card status
  static String cardStatusLabel(bool isFrozen) {
    return isFrozen ? 'Card is frozen' : 'Card is active';
  }

  /// Create semantic label for slider value
  static String sliderLabel(String name, double value, double min, double max) {
    final percentage = ((value - min) / (max - min) * 100).round();
    return '$name set to ${value.round()} rand, which is $percentage percent';
  }

  static String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

/// Semantic wrapper for better accessibility
class SemanticWrapper extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? hint;
  final String? value;
  final bool button;
  final bool header;
  final bool focused;
  final bool enabled;
  final VoidCallback? onTap;

  const SemanticWrapper({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.value,
    this.button = false,
    this.header = false,
    this.focused = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: button,
      header: header,
      focused: focused,
      enabled: enabled,
      onTap: onTap,
      child: child,
    );
  }
}

/// Exclude widget from semantics tree
class SemanticsExclude extends StatelessWidget {
  final Widget child;

  const SemanticsExclude({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(child: child);
  }
}
