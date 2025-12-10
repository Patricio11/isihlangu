import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    print('🚀 Shield App starting on ${kIsWeb ? 'Web' : 'Mobile'}...');
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
    const ProviderScope(
      child: ShieldApp(),
    ),
  );
}

class ShieldApp extends ConsumerWidget {
  const ShieldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
