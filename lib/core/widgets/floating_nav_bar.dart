import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'glass_container.dart';

/// Floating Glass Bottom Navigation Bar
/// Floats above the screen content with glass morphism effect
/// ROADMAP Task 1.15.7: Role-Based Navigation
class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isRestricted;
  final bool isParent;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isRestricted = false,
    this.isParent = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: isParent
              ? _buildParentNavItems()
              : _buildChildNavItems(),
        ),
      ),
    );
  }

  // Parent: Home | Family | Pay | Safety | Activity (5 tabs)
  List<Widget> _buildParentNavItems() {
    return [
      _NavBarItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
        isActive: currentIndex == 0,
        onTap: () => onTap(0),
      ),
      _NavBarItem(
        icon: Icons.family_restroom_outlined,
        activeIcon: Icons.family_restroom,
        label: 'Family',
        isActive: currentIndex == 1,
        onTap: () => onTap(1),
      ),
      _NavBarItem(
        icon: Icons.payment_outlined,
        activeIcon: Icons.payment,
        label: 'Pay',
        isActive: currentIndex == 2,
        onTap: () => onTap(2),
        isDisabled: isRestricted,
      ),
      _NavBarItem(
        icon: Icons.shield_outlined,
        activeIcon: Icons.shield,
        label: 'Safety',
        isActive: currentIndex == 3,
        onTap: () => onTap(3),
        isHighlight: !isRestricted,
      ),
      _NavBarItem(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        label: 'Activity',
        isActive: currentIndex == 4,
        onTap: () => onTap(4),
      ),
    ];
  }

  // Child: Home | Pay | Safety | Activity (4 tabs)
  List<Widget> _buildChildNavItems() {
    return [
      _NavBarItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
        isActive: currentIndex == 0,
        onTap: () => onTap(0),
      ),
      _NavBarItem(
        icon: Icons.payment_outlined,
        activeIcon: Icons.payment,
        label: 'Pay',
        isActive: currentIndex == 1,
        onTap: () => onTap(1),
        isDisabled: isRestricted,
      ),
      _NavBarItem(
        icon: Icons.shield_outlined,
        activeIcon: Icons.shield,
        label: 'Safety',
        isActive: currentIndex == 2,
        onTap: () => onTap(2),
        isHighlight: !isRestricted,
      ),
      _NavBarItem(
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        label: 'Activity',
        isActive: currentIndex == 3,
        onTap: () => onTap(3),
      ),
    ];
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDisabled;
  final bool isHighlight;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isDisabled = false,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getColor() {
      if (isDisabled) return context.colors.textTertiary;
      if (isActive) return context.colors.primary;
      if (isHighlight) return context.colors.success;
      return context.colors.textSecondary;
    }

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? context.colors.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isActive ? activeIcon : icon,
                    color: getColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: getColor(),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
