import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/security/duress_state_manager.dart';
import 'features/auth/providers/session_provider.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    print('🚀 Shield App starting on ${kIsWeb ? 'Web' : 'Mobile'}...');
  }

  // CRITICAL: Check for persistent duress mode (THE TRAP DOOR)
  // This check runs on EVERY app startup, even after device reboot
  // If duress mode is active, it will remain active until parent unlock
  final duressManager = await DuressStateManager.getInstance();
  final isDuressActive = await duressManager.isDuressActive();

  if (kDebugMode && isDuressActive) {
    print('🚨 DURESS MODE DETECTED - App will launch in restricted mode');
    final details = await duressManager.getDuressDetails();
    if (details != null) {
      print('  User: ${details.userId}');
      print('  Duration: ${details.durationMinutes} minutes');
      print('  Location: ${details.location ?? "Unknown"}');
    }
  }

  // Set system UI overlay style (skip for web)
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(AppTheme.lightStatusBar);

    // Set preferred orientations (portrait only for mobile)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(
    ProviderScope(
      child: ShieldApp(isDuressActive: isDuressActive),
    ),
  );
}

class ShieldApp extends ConsumerStatefulWidget {
  final bool isDuressActive;

  const ShieldApp({super.key, required this.isDuressActive});

  @override
  ConsumerState<ShieldApp> createState() => _ShieldAppState();
}

class _ShieldAppState extends ConsumerState<ShieldApp> {
  @override
  void initState() {
    super.initState();

    // CRITICAL: Restore duress session if trap door is active
    if (widget.isDuressActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(sessionProvider.notifier).restoreDuressSession();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('📱 ShieldApp building...');
    }

    // Wrap router access in error handling
    return MaterialApp.router(
      title: 'Shield',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Follow system theme
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        // Add error boundary
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${details.exception}',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (kDebugMode)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        details.stack.toString(),
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ),
                ],
              ),
            ),
          );
        };
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
