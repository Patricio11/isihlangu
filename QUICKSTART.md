# Quick Start Guide

## Project Status: LoginScreen Complete ✅

### What's Been Built

#### 1. Core Design System
- [app_colors.dart](lib/core/theme/app_colors.dart) - Complete color palette with gradients and glows
- [app_theme.dart](lib/core/theme/app_theme.dart) - ThemeData with Outfit font family

#### 2. Reusable Components
- [glass_container.dart](lib/core/widgets/glass_container.dart) - Glass morphism widgets:
  - `GlassContainer` - Basic frosted glass container
  - `GlassButton` - Flat neon gradient button
  - `CircularGlassButton` - Round action button
  - `GlassCard` - Card with optional glow
- [animated_mesh_gradient.dart](lib/core/widgets/animated_mesh_gradient.dart) - Moving background gradient

#### 3. Authentication Feature
- [auth_state.dart](lib/features/auth/domain/auth_state.dart) - State model
- [auth_provider.dart](lib/features/auth/providers/auth_provider.dart) - Riverpod state management
- [login_screen.dart](lib/features/auth/presentation/login_screen.dart) - Main login UI
- [pin_dots.dart](lib/features/auth/presentation/widgets/pin_dots.dart) - 6-dot indicator
- [pin_keypad.dart](lib/features/auth/presentation/widgets/pin_keypad.dart) - Glass keypad

#### 4. App Entry Point
- [main.dart](lib/main.dart) - App initialization

## File Structure

```
shield/
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart       ← Color palette & gradients
│   │   │   └── app_theme.dart        ← ThemeData configuration
│   │   └── widgets/
│   │       ├── glass_container.dart  ← Reusable glass components
│   │       └── animated_mesh_gradient.dart ← Animated backgrounds
│   │
│   ├── features/
│   │   └── auth/
│   │       ├── domain/
│   │       │   └── auth_state.dart        ← State model
│   │       ├── providers/
│   │       │   └── auth_provider.dart     ← Riverpod provider
│   │       └── presentation/
│   │           ├── login_screen.dart      ← Main screen
│   │           └── widgets/
│   │               ├── pin_dots.dart      ← PIN indicator
│   │               └── pin_keypad.dart    ← Keypad widget
│   │
│   └── main.dart                      ← App entry point
│
├── pubspec.yaml                       ← Dependencies
├── README.md                          ← Project overview
├── DESIGN_GUIDE.md                    ← Visual design system
└── QUICKSTART.md                      ← This file
```

## How to Run

1. **Install dependencies**:
```bash
cd "c:\Users\patri\OneDrive\Desktop\Moblie App\shield"
flutter pub get
```

2. **Run the app**:
```bash
flutter run
```

3. **Test the login**:
   - Real PIN: `123456`
   - Panic PIN: `654321`

## Visual Preview

When you run the app, you'll see:

1. **Animated mesh gradient background** - Subtle moving blobs
2. **Shield logo** - Circular gradient with icon, fades in with scale
3. **"SHIELD" title** - Bold, wide letter spacing
4. **Biometric icon** - Fingerprint in glass circle
5. **6 PIN dots** - Glow teal as you type
6. **Glass keypad** - 3x4 grid of frosted buttons
7. **Biometric button** - Alternative auth method (TODO)

## Key Features

### Stealth Security
- Both PINs look identical during entry
- No visual indication of which PIN type
- Auto-validation when 6 digits entered
- Brief error message, then auto-clear

### Animations
- Logo: Fade in + scale (800ms)
- Title: Fade in + slide up (800ms, 200ms delay)
- Dots: Fade in + slide up (600ms, 600ms delay)
- Keypad: Fade in + slide up (600ms, 200ms delay)
- Each row staggers by 100ms

### Glass Morphism
- 10px backdrop blur
- 8% white background
- 12% white border
- Soft shadows
- NO button shadows (flat design)

## Next Steps

To continue building the app, create:

### HomeScreen Components
1. **Top Bar** with greeting and shield status
2. **Balance Card** with blur effect and optional gyroscope tilt
3. **Action Buttons** using `CircularGlassButton`:
   - Pay
   - Top Up
   - Freeze
   - More
4. **Activity Feed** with dark tiles

### Navigation
1. Set up `GoRouter` for navigation
2. Create a floating glass bottom nav bar
3. Wire up authentication flow

### PayScreen
1. Large amount input field
2. Contact picker (horizontal scroll)
3. Slide-to-pay widget

### SafetyScreen
1. Radar-style UI
2. Toggle switches for features
3. Map widget for location
4. Admin access control

## Common Patterns

### Creating a Glass Surface
```dart
GlassContainer(
  padding: const EdgeInsets.all(20),
  child: YourContent(),
)
```

### Creating a Primary Button
```dart
GlassButton.primary(
  onPressed: () => doSomething(),
  child: const Text('Button Text'),
)
```

### Creating a Circular Action Button
```dart
CircularGlassButton(
  icon: Icons.payment,
  label: 'Pay',
  onPressed: () => navigateToPay(),
)
```

### Adding Entrance Animation
```dart
YourWidget()
  .animate()
  .fadeIn(duration: 600.ms)
  .slideY(begin: 0.2, end: 0, duration: 600.ms)
```

## Development Tips

1. **Hot Reload**: Press `r` in the terminal to hot reload
2. **Hot Restart**: Press `R` to hot restart
3. **Debug Mode**: The app runs in debug mode by default
4. **Device Selection**: Use `flutter devices` to list available devices

## Troubleshooting

### If you see "Waiting for another flutter command to release the startup lock"
```bash
taskkill /F /IM dart.exe
```

### If dependencies fail to install
```bash
flutter clean
flutter pub get
```

### If you see render errors
- Check that all required packages are in pubspec.yaml
- Ensure Flutter SDK is up to date: `flutter upgrade`

## Security Notes

The current PIN implementation is for DEVELOPMENT ONLY:
- Hardcoded PINs in [auth_provider.dart:10-11](lib/features/auth/providers/auth_provider.dart#L10-L11)
- TODO: Implement secure storage (flutter_secure_storage)
- TODO: Add biometric authentication (local_auth)
- TODO: Add rate limiting for failed attempts
- TODO: Add session management

## Resources

- **Design Guide**: See [DESIGN_GUIDE.md](DESIGN_GUIDE.md) for visual system
- **README**: See [README.md](README.md) for project overview
- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod Docs**: https://riverpod.dev

---

**Status**: LoginScreen complete. Ready to build HomeScreen next!
