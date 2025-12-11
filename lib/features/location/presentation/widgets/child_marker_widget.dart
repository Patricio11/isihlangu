import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/family_member_location.dart';

/// Child Marker Widget
/// ROADMAP: Task 1.16 - Family Live Map
/// Animated marker showing child location with avatar and pulse effect
class ChildMarkerWidget extends StatelessWidget {
  final FamilyMemberLocation location;
  final VoidCallback? onTap;

  const ChildMarkerWidget({
    super.key,
    required this.location,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final markerColor = location.isMoving
        ? AppColors.info
        : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar marker with animated pulse effect
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer pulse ring (animated)
              if (location.isConnected)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: markerColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      duration: 2000.ms,
                    )
                    .fadeOut(
                      duration: 2000.ms,
                    ),

              // Inner avatar circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: markerColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: markerColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    location.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Offline indicator
              if (!location.isConnected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),

              // Low battery indicator
              if (location.batteryLevel < 0.2 && location.isConnected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.battery_alert,
                      size: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          // Name label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              location.memberName.split(' ').first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pulse Ring Widget
/// Reusable animated pulse effect for markers
class PulseRing extends StatelessWidget {
  final Color color;
  final double size;
  final Duration duration;

  const PulseRing({
    super.key,
    required this.color,
    this.size = 60,
    this.duration = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .scale(
          begin: const Offset(0.7, 0.7),
          duration: duration,
        )
        .fadeOut(
          duration: duration,
        );
  }
}
