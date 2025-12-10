import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_container.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/data/fake_family_data.dart';

/// Join Family Screen
/// ROADMAP: Task 1.15.1 - Role Selection (Child Flow)
/// Allows child to join an existing family using a family code
class JoinFamilyScreen extends StatefulWidget {
  const JoinFamilyScreen({super.key});

  @override
  State<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen> {
  final _familyCodeController = TextEditingController();
  bool _isJoining = false;
  bool _joinedSuccessfully = false;

  @override
  void dispose() {
    _familyCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinFamily() async {
    final code = _familyCodeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      CustomToast.showError(context, 'Please enter a family code');
      return;
    }

    setState(() => _isJoining = true);
    HapticService.mediumImpact();

    // Simulate API call with validation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Validate code (mock validation)
    if (code == FakeFamilyData.familyCode) {
      setState(() {
        _isJoining = false;
        _joinedSuccessfully = true;
      });
      HapticService.success();
      CustomToast.showSuccess(context, 'Successfully joined ${FakeFamilyData.familyName}!');
    } else {
      setState(() => _isJoining = false);
      HapticService.error();
      CustomToast.showError(context, 'Invalid family code. Please try again.');
    }
  }

  void _continue() {
    HapticService.mediumImpact();
    // Navigate to main app (login with child PIN)
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Join Family'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_joinedSuccessfully) ...[
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: AppColors.successGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8), duration: 600.ms),

                const SizedBox(height: 32),

                Text(
                  'Join Your Family',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 12),

                Text(
                  'Enter the family code shared by your parent',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms),

                const SizedBox(height: 48),

                // Family Code Input
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _familyCodeController,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4,
                    ),
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Family Code',
                      hintText: 'SHIELD-XXXX',
                      hintStyle: TextStyle(
                        letterSpacing: 4,
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 600.ms),

                const SizedBox(height: 24),

                // Helper Text
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ask your parent for the family code from their app',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 700.ms),

                const SizedBox(height: 32),

                // Join Button
                GlassButton.primary(
                  onPressed: _isJoining || _familyCodeController.text.trim().isEmpty
                      ? null
                      : _joinFamily,
                  width: double.infinity,
                  height: 56,
                  child: _isJoining
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Join Family',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 800.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 800.ms),
              ] else ...[
                // Success State
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    gradient: AppColors.successGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.5, 0.5), duration: 600.ms),

                const SizedBox(height: 32),

                Text(
                  'Welcome to the Family!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 12),

                Text(
                  'You\'ve successfully joined ${FakeFamilyData.familyName}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms),

                const SizedBox(height: 48),

                // Family Info
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.family_restroom_rounded,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        FakeFamilyData.familyName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${FakeFamilyData.allMembers.length} members',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 600.ms),

                const SizedBox(height: 32),

                // Continue Button
                GlassButton.primary(
                  onPressed: _continue,
                  width: double.infinity,
                  height: 56,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 800.ms)
                    .slideY(begin: 0.1, end: 0, duration: 600.ms, delay: 800.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
