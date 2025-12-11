import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/widgets/animated_mesh_gradient.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/security/permission_validator.dart';

/// Permission Prime Screen
/// ROADMAP: Phase 1.6 - Task 1.6.4
///
/// Critical onboarding step that requests permissions for evidence collection:
/// - Location: "Always Allow" for GPS tracking during duress
/// - Microphone: For audio evidence recording during duress
///
/// SECURITY DESIGN:
/// These permissions are CRITICAL for evidence collection in duress mode.
/// Without them, Shield cannot provide full protection.
///
/// UI STRATEGY:
/// - Clear explanations of WHY each permission is needed
/// - Emphasis on safety and protection
/// - "Skip for Now" option (permissions requested again later)
/// - Visual indicators of permission status
class PermissionPrimeScreen extends StatefulWidget {
  const PermissionPrimeScreen({super.key});

  @override
  State<PermissionPrimeScreen> createState() => _PermissionPrimeScreenState();
}

class _PermissionPrimeScreenState extends State<PermissionPrimeScreen> {
  PermissionStatus locationStatus = PermissionStatus.notRequested;
  PermissionStatus microphoneStatus = PermissionStatus.notRequested;
  bool isRequestingPermissions = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentPermissions();
  }

  /// Check current permission status
  Future<void> _checkCurrentPermissions() async {
    final validator = PermissionValidator();
    final locationGranted = await validator.hasLocationPermission();
    final microphoneGranted = await validator.hasMicrophonePermission();

    setState(() {
      locationStatus = locationGranted
          ? PermissionStatus.granted
          : PermissionStatus.notRequested;
      microphoneStatus = microphoneGranted
          ? PermissionStatus.granted
          : PermissionStatus.notRequested;
    });
  }

  /// Request location permission
  Future<void> _requestLocationPermission() async {
    HapticService.mediumImpact();

    setState(() {
      isRequestingPermissions = true;
    });

    final validator = PermissionValidator();
    final granted = await validator.requestLocationPermission();

    setState(() {
      locationStatus =
          granted ? PermissionStatus.granted : PermissionStatus.denied;
      isRequestingPermissions = false;
    });

    if (granted) {
      HapticService.lightImpact();
    }
  }

  /// Request microphone permission
  Future<void> _requestMicrophonePermission() async {
    HapticService.mediumImpact();

    setState(() {
      isRequestingPermissions = true;
    });

    final validator = PermissionValidator();
    final granted = await validator.requestMicrophonePermission();

    setState(() {
      microphoneStatus =
          granted ? PermissionStatus.granted : PermissionStatus.denied;
      isRequestingPermissions = false;
    });

    if (granted) {
      HapticService.lightImpact();
    }
  }

  /// Continue to next screen
  void _continue() {
    HapticService.mediumImpact();

    // TODO Phase 2: Navigate to next onboarding step or home
    // For now, go to home
    context.go('/home');
  }

  /// Skip permissions for now
  void _skip() {
    HapticService.lightImpact();

    // Show warning dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.glassSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: context.colors.warning),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Skip Permissions?',
                style: TextStyle(color: context.colors.textPrimary),
              ),
            ),
          ],
        ),
        content: Text(
          'Without these permissions, Shield cannot collect evidence during duress situations. You can enable them later in Settings.',
          style: TextStyle(color: context.colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticService.lightImpact();
              context.pop();
            },
            child: const Text('Go Back'),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              _continue();
            },
            child: Text(
              'Skip Anyway',
              style: TextStyle(
                color: context.colors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get allPermissionsGranted {
    return locationStatus == PermissionStatus.granted &&
        microphoneStatus == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: AnimatedMeshGradient(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    const Spacer(),
                    if (!allPermissionsGranted)
                      TextButton(
                        onPressed: isRequestingPermissions ? null : _skip,
                        child: Text(
                          'Skip for Now',
                          style: TextStyle(color: context.colors.textSecondary),
                        ),
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shield icon
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: context.colors.primaryGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .scale(duration: 600.ms, curve: Curves.elasticOut),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Enable Protection',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 100.ms)
                          .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 600.ms,
                              delay: 100.ms),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'To provide maximum protection during emergencies, Shield needs these permissions:',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 600.ms,
                              delay: 200.ms),

                      const SizedBox(height: 40),

                      // Location Permission Card
                      _PermissionCard(
                        icon: Icons.location_on_rounded,
                        title: 'Location (Always Allow)',
                        description:
                            'Tracks your location during duress situations for evidence and safety monitoring.',
                        importance: 'Critical for Evidence Collection',
                        status: locationStatus,
                        onRequest: _requestLocationPermission,
                        isRequesting: isRequestingPermissions,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 300.ms)
                          .slideX(
                              begin: -0.2,
                              end: 0,
                              duration: 600.ms,
                              delay: 300.ms),

                      const SizedBox(height: 20),

                      // Microphone Permission Card
                      _PermissionCard(
                        icon: Icons.mic_rounded,
                        title: 'Microphone',
                        description:
                            'Records audio evidence during duress situations for legal protection.',
                        importance: 'Critical for Evidence Collection',
                        status: microphoneStatus,
                        onRequest: _requestMicrophonePermission,
                        isRequesting: isRequestingPermissions,
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideX(
                              begin: -0.2,
                              end: 0,
                              duration: 600.ms,
                              delay: 400.ms),

                      const SizedBox(height: 32),

                      // Info Banner
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: context.colors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'These permissions are only used during duress mode to collect evidence for your safety.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 500.ms)
                          .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 600.ms,
                              delay: 500.ms),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: GlassButton.primary(
                  onPressed: isRequestingPermissions ? null : _continue,
                  width: double.infinity,
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (allPermissionsGranted)
                        const Icon(Icons.check_circle_rounded,
                            color: Colors.white),
                      if (allPermissionsGranted) const SizedBox(width: 8),
                      Text(
                        allPermissionsGranted
                            ? 'All Set! Continue'
                            : 'Continue Anyway',
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
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 600.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Permission Card Widget
class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String importance;
  final PermissionStatus status;
  final VoidCallback onRequest;
  final bool isRequesting;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.importance,
    required this.status,
    required this.onRequest,
    required this.isRequesting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isGranted = status == PermissionStatus.granted;
    final isDenied = status == PermissionStatus.denied;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: isGranted
                      ? context.colors.successGradient
                      : context.colors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isGranted ? Icons.check_rounded : icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: context.colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isGranted
                            ? context.colors.success.withValues(alpha: 0.2)
                            : context.colors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isGranted ? 'Granted' : importance,
                        style: TextStyle(
                          color: isGranted ? context.colors.success : context.colors.warning,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),

          if (!isGranted) const SizedBox(height: 16),

          // Action Button
          if (!isGranted)
            SizedBox(
              width: double.infinity,
              child: GlassButton(
                onPressed: isRequesting ? null : onRequest,
                height: 44,
                gradient: isDenied
                    ? LinearGradient(
                        colors: [context.colors.warning, const Color(0xFFFFB74D)])
                    : context.colors.primaryGradient,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isRequesting)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    else
                      Icon(
                        isDenied
                            ? Icons.settings_rounded
                            : Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      isDenied ? 'Open Settings' : 'Grant Permission',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
