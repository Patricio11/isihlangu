import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_container.dart';

/// Gyroscope Balance Card
/// The card tilts slightly based on device gyroscope for a premium feel
/// ROADMAP: Task 1.3 - The "Gyroscope Card"
class GyroscopeBalanceCard extends StatefulWidget {
  final double balance;
  final bool isRestricted;
  final VoidCallback? onTap;

  const GyroscopeBalanceCard({
    super.key,
    required this.balance,
    this.isRestricted = false,
    this.onTap,
  });

  @override
  State<GyroscopeBalanceCard> createState() => _GyroscopeBalanceCardState();
}

class _GyroscopeBalanceCardState extends State<GyroscopeBalanceCard> {
  StreamSubscription? _gyroSubscription;
  double _rotateX = 0.0;
  double _rotateY = 0.0;

  @override
  void initState() {
    super.initState();
    _startGyroscope();
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    super.dispose();
  }

  void _startGyroscope() {
    // Skip gyroscope on web platform
    if (kIsWeb) {
      debugPrint('Gyroscope disabled on web platform');
      return;
    }

    try {
      // Sample gyroscope data at 20Hz for smooth animation
      _gyroSubscription = gyroscopeEventStream(samplingPeriod: const Duration(milliseconds: 50))
          .listen((GyroscopeEvent event) {
        if (mounted) {
          setState(() {
            // Limit rotation to subtle movement (max ±5 degrees)
            _rotateX = (event.y * 2).clamp(-5.0, 5.0);
            _rotateY = (event.x * 2).clamp(-5.0, 5.0);
          });
        }
      });
    } catch (e) {
      // Gyroscope not available - card will remain flat
      debugPrint('Gyroscope not available: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: 'R ',
      decimalDigits: 2,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(_rotateX * math.pi / 180)
          ..rotateY(_rotateY * math.pi / 180),
        alignment: Alignment.center,
        child: GlassContainer(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          borderRadius: BorderRadius.circular(24),
          boxShadow: widget.isRestricted ? null : context.colors.glowTeal,
          gradient: widget.isRestricted
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.colors.primary.withValues(alpha: 0.1),
                    context.colors.primaryDark.withValues(alpha: 0.05),
                  ],
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Card Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shield,
                        color: widget.isRestricted
                            ? context.colors.textTertiary
                            : context.colors.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Shield Account',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: widget.isRestricted
                              ? context.colors.textTertiary
                              : context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  // Chip indicator
                  Container(
                    width: 40,
                    height: 28,
                    decoration: BoxDecoration(
                      color: context.colors.glassSurface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: context.colors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.contactless,
                        color: widget.isRestricted
                            ? context.colors.textTertiary
                            : context.colors.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(widget.balance),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: widget.isRestricted
                          ? context.colors.textSecondary
                          : context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Card Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACCOUNT NUMBER',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: context.colors.textTertiary,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '**** 4892',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: context.colors.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  if (!widget.isRestricted)
                    Icon(
                      Icons.more_horiz,
                      color: context.colors.textTertiary,
                      size: 24,
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
