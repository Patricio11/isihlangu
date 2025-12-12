import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../domain/family_member_location.dart';

/// Location Status Card
/// ROADMAP: Task 1.16 - Family Live Map
/// Bottom sheet "Command Center" showing all children with status and quick actions
class LocationStatusCard extends StatelessWidget {
  final List<FamilyMemberLocation> children;
  final FamilyMemberLocation? selectedChild;
  final ValueChanged<FamilyMemberLocation>? onChildSelected;
  final ValueChanged<FamilyMemberLocation>? onNavigate;
  final ValueChanged<FamilyMemberLocation>? onCall;
  final ValueChanged<FamilyMemberLocation>? onSignalAlert;

  const LocationStatusCard({
    super.key,
    required this.children,
    this.selectedChild,
    this.onChildSelected,
    this.onNavigate,
    this.onCall,
    this.onSignalAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.backgroundSecondary,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.textTertiary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.family_restroom_rounded,
                  color: context.colors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Family Command Center',
                  style: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${children.length} ${children.length == 1 ? 'child' : 'children'}',
                  style: TextStyle(
                    color: context.colors.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Horizontal scrollable children list
          SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: children.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final child = children[index];
                final isSelected = selectedChild?.memberId == child.memberId;

                return _ChildStatusCard(
                  location: child,
                  isSelected: isSelected,
                  onTap: () => onChildSelected?.call(child),
                  onNavigate: () => onNavigate?.call(child),
                  onCall: () => onCall?.call(child),
                  onSignalAlert: () => onSignalAlert?.call(child),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOut);
  }
}

/// Child Status Card
/// Individual card showing child's status with quick actions
class _ChildStatusCard extends StatelessWidget {
  final FamilyMemberLocation location;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onNavigate;
  final VoidCallback? onCall;
  final VoidCallback? onSignalAlert;

  const _ChildStatusCard({
    required this.location,
    required this.isSelected,
    this.onTap,
    this.onNavigate,
    this.onCall,
    this.onSignalAlert,
  });

  Color get _statusColor {
    if (!location.isConnected) return AppColors.danger;
    if (location.batteryLevel < 0.2) return AppColors.warning;
    if (location.isMoving) return AppColors.info;
    return AppColors.primary;
  }

  IconData get _statusIcon {
    if (!location.isConnected) return Icons.cloud_off;
    if (location.batteryLevel < 0.2) return Icons.battery_alert;
    if (location.isMoving) return Icons.directions_walk;
    return Icons.check_circle;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        hasGlow: isSelected,
        glowColor: context.colors.primary,
        child: SizedBox(
          width: 160,
          height: 220, // Fixed height to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar and status
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        location.avatar,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Status icon
                  Icon(
                    _statusIcon,
                    color: _statusColor,
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Name
              Text(
                location.memberName,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Location/Address
              Text(
                location.address ?? 'Unknown location',
                style: TextStyle(
                  color: context.colors.textTertiary,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Status indicators
              _StatusRow(
                icon: Icons.battery_charging_full,
                label: '${(location.batteryLevel * 100).toInt()}%',
                color: location.batteryLevel < 0.2
                    ? AppColors.warning
                    : context.colors.textSecondary,
              ),
              const SizedBox(height: 4),
              _StatusRow(
                icon: Icons.access_time,
                label: location.timeSinceUpdate,
                color: context.colors.textSecondary,
              ),
              if (location.isMoving && location.speed != null) ...[
                const SizedBox(height: 4),
                _StatusRow(
                  icon: Icons.speed,
                  label: '${location.speed!.toInt()} km/h',
                  color: AppColors.info,
                ),
              ],

              const Spacer(),

              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _QuickActionButton(
                    icon: Icons.navigation,
                    color: AppColors.info,
                    onTap: onNavigate,
                  ),
                  _QuickActionButton(
                    icon: Icons.phone,
                    color: AppColors.success,
                    onTap: onCall,
                  ),
                  _QuickActionButton(
                    icon: Icons.emergency,
                    color: AppColors.danger,
                    onTap: onSignalAlert,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Status Row Widget
/// Small row showing icon and label for status indicators
class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Quick Action Button
/// Circular button for quick actions (Navigate, Call, Alert)
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color,
        ),
      ),
    );
  }
}
