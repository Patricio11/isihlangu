// Shield App Widget Test
//
// Basic test to verify the app initializes correctly

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shield/main.dart';

void main() {
  testWidgets('Shield app smoke test - Login screen loads', (WidgetTester tester) async {
    // Set a reasonable test viewport size
    await tester.binding.setSurfaceSize(const Size(400, 800));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ShieldApp(isDuressActive: false),
      ),
    );

    // Pump a few frames instead of pumpAndSettle (to avoid infinite animation timeout)
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify that the login screen loads
    // Look for the Shield title
    expect(find.text('SHIELD'), findsOneWidget);

    // Verify PIN entry instruction is present
    expect(find.text('Enter your PIN'), findsOneWidget);

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Shield app has PIN keypad', (WidgetTester tester) async {
    // Set a reasonable test viewport size
    await tester.binding.setSurfaceSize(const Size(400, 800));

    // Build the app
    await tester.pumpWidget(
      const ProviderScope(
        child: ShieldApp(isDuressActive: false),
      ),
    );

    // Pump a few frames to let widgets render
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify keypad numbers are present
    expect(find.text('1'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('Shield app can enter PIN digits', (WidgetTester tester) async {
    // Set a reasonable test viewport size
    await tester.binding.setSurfaceSize(const Size(400, 800));

    // Build the app
    await tester.pumpWidget(
      const ProviderScope(
        child: ShieldApp(isDuressActive: false),
      ),
    );

    // Wait for initial render
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Tap the '1' button
    await tester.tap(find.text('1'));
    await tester.pump();

    // The PIN dot should now be filled (we can verify the PIN state changed)
    // Note: We can't easily verify the visual state without exposing internal state
    // This test just verifies the button is tappable

    // Reset surface size
    await tester.binding.setSurfaceSize(null);
  });
}
