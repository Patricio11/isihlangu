# Shield - Security-Focused Banking App

**A dark-mode fintech application for South Africa with advanced security features.**

**Phase 1: COMPLETE ✅** | [View Roadmap](SHIELD_DEV_ROADMAP.md) | [Setup Guide](SETUP.md)

---

## 🎯 Project Overview

Shield (Isihlangu) is a "Safety-First" banking app with a revolutionary **Dual-Identity Architecture** designed to protect users in duress/kidnapping scenarios.

### The Core Concept

1. **Safe Mode**: User enters Real PIN (1234) → Full banking access
2. **Duress Mode**: User enters Panic PIN (9999) → Simulates low-balance account + Silent GPS alerts + Locks real funds

**Security by Stealth**: Both modes look identical - attackers cannot tell which mode is active.

---

## ✅ What's Been Built (Phase 1 Complete)

### 4 Core Screens

#### 1. LoginScreen - Stealth Authentication
- 4-digit PIN entry with animated mesh gradient
- Glass morphism keypad
- Identical UI for both PIN types (security by stealth)
- **Test PINs**: `1234` (Safe) | `9999` (Duress)

#### 2. HomeScreen - Premium Dashboard
- **Gyroscope-tilting balance card** (moves with phone)
- **Pulsing shield status indicator** (green = active)
- **Staggered transaction feed** (slides in one-by-one)
- **4 circular action buttons**: Pay, Top Up, Freeze, More
- **Different data per mode**:
  - Safe Mode: R 12,450.50 | 8 transactions
  - Duress Mode: R 150.00 | 3 transactions

#### 3. PayScreen - Secure Payments
- Large centered amount input
- Frequent contacts picker with avatar rings
- **iPhone-style "Slide to Pay"** confirmation
- Payment success animation

#### 4. SafetyScreen - Security Center
- **Animated radar scanner** with sweeping line
- Security toggles (Ghost Mode, Location Broadcast)
- Configuration options (Duress PIN, Trusted Contacts, Alerts)
- **Admin-only access** (restricted in duress mode)

### Navigation System
- **GoRouter** with authentication guards
- **Floating glass bottom nav bar**
- Auto-redirect based on auth state
- 4 tabs: Home, Pay, Activity, Safety

---

## 🔒 Security Architecture

### Zero-Trust Client (Phase 2 Ready)

**Current (Phase 1 - Mock)**:
```dart
// INSECURE - for UI development only
if (pin == '1234') { /* Safe mode */ }
```

**Production (Phase 2 - Supabase)**:
```dart
// PIN sent to Edge Function
// Backend returns session token with 'scope' claim
// Client NEVER knows which PIN was entered
```

### Critical Security Features
✅ **Session-based scopes** (Admin/Restricted)
✅ **Identical visual feedback** for both PINs
✅ **Silent failure** in duress mode
✅ **Timing attack mitigation** (prepared)

---

## 📱 Quick Start

### Installation
```bash
cd "c:\Users\patri\OneDrive\Desktop\Moblie App\shield"
flutter pub get
flutter run
```

### Test the App
- **Safe Mode**: Enter PIN `1234`
  - See R 12,450.50 balance
  - All features enabled
  - 8 transaction items

- **Duress Mode**: Enter PIN `9999`
  - See R 150.00 fake balance
  - Restricted features (Top Up, Freeze disabled)
  - 3 minimal transactions
  - "Silent Alert Sent" toast (test mode only)

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── data/
│   │   └── fake_transactions.dart         # Mock data (Safe/Duress)
│   ├── navigation/
│   │   ├── app_router.dart                # GoRouter config
│   │   └── main_scaffold.dart             # Main scaffold + nav bar
│   ├── theme/
│   │   ├── app_colors.dart                # Color palette + gradients
│   │   └── app_theme.dart                 # ThemeData (Outfit font)
│   └── widgets/
│       ├── animated_mesh_gradient.dart    # Animated background
│       ├── floating_nav_bar.dart          # Bottom navigation
│       └── glass_container.dart           # Glass morphism widgets
│
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── auth_state.dart            # Auth state model
│   │   │   └── user_session.dart          # Session with scope
│   │   ├── providers/
│   │   │   ├── auth_provider.dart         # Auth management
│   │   │   └── session_provider.dart      # Session management
│   │   └── presentation/
│   │       ├── login_screen.dart          # Login UI
│   │       └── widgets/
│   │           ├── pin_dots.dart          # 4-dot indicator
│   │           └── pin_keypad.dart        # Glass keypad
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── home_screen.dart           # Dashboard
│   │       └── widgets/
│   │           ├── gyroscope_balance_card.dart  # Tilting card
│   │           ├── pulse_indicator.dart         # Shield status
│   │           └── transaction_list.dart        # Transaction feed
│   │
│   ├── payment/
│   │   └── presentation/
│   │       ├── pay_screen.dart            # Payment screen
│   │       └── widgets/
│   │           └── slide_to_pay.dart      # Slide-to-pay widget
│   │
│   └── safety/
│       └── presentation/
│           ├── safety_screen.dart         # Safety center
│           └── widgets/
│               └── radar_widget.dart      # Radar animation
│
└── main.dart                              # App entry point
```

---

## 🎨 Design System

### Color Palette
- **Background**: Deep Slate Blue `#0F172A`
- **Glass Surface**: White 8% opacity + 10px blur
- **Primary Accent**: Electric Teal `#2DD4BF` (Safe/Success)
- **Danger Accent**: Neon Red `#FF453A` (Alerts)
- **Typography**: Google Fonts 'Outfit' (Clean, geometric)

### Visual Identity
- **Glass morphism** with frosted blur effects
- **Flat neon gradients** (no button shadows)
- **Staggered animations** (fadeIn + slideY)
- **Gyroscope interactions** (card tilt)
- **Pulsing indicators** (shield status)
- **Radar effects** (safety screen)

### Reusable Components

```dart
// Glass Container
GlassContainer(
  padding: EdgeInsets.all(20),
  child: YourWidget(),
)

// Primary Button
GlassButton.primary(
  onPressed: () {},
  child: Text('Button'),
)

// Circular Action Button
CircularGlassButton(
  icon: Icons.payment,
  label: 'Pay',
  onPressed: () {},
)
```

---

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter 3.0+
- **State Management**: Riverpod 2.4+ (Controller-Service-Repository)
- **Navigation**: GoRouter 13.0+
- **Animations**: flutter_animate 4.5+
- **UI Effects**: glassmorphism 3.0+, sensors_plus 4.0+
- **Typography**: google_fonts 6.1+ (Outfit)
- **Formatting**: intl 0.19+

### Backend (Phase 2)
- **Database**: Supabase (PostgreSQL)
- **Auth**: Supabase Auth with Edge Functions
- **Payments**: Stitch API (South African Open Banking)
- **Maps**: Google Maps Flutter SDK

---

## 📊 Phase 1 Statistics

**Completion Date**: 2025-12-09
**Files Created**: 30+
**Screens Built**: 4 (Login, Home, Pay, Safety)
**Lines of Code**: ~3,500+
**Dependencies**: 11

### Deliverables
- ✅ Production-quality UI
- ✅ Security architecture foundation
- ✅ Mock data and state management
- ✅ Full navigation flow
- ✅ Dual-identity UX (Safe/Duress)

---

## 🚀 Next Phase: Supabase Integration

### Phase 2 Tasks (Weeks 3-4)
- [ ] Set up Supabase project
- [ ] Create database schema
- [ ] **Implement Edge Function for Dual-PIN validation**
- [ ] Add timing attack mitigation
- [ ] Remove client-side PIN logic
- [ ] Real-time data sync with Riverpod

### Critical Security Requirements
- ✅ **Zero-Trust Client**: Client never knows which PIN
- ✅ **Timing Attack Mitigation**: Identical response times
- ✅ **Silent Failure**: No error messages in duress mode

---

## 📚 Documentation

- [SHIELD_DEV_ROADMAP.md](SHIELD_DEV_ROADMAP.md) - Full development roadmap
- [PHASE1_COMPLETE.md](PHASE1_COMPLETE.md) - Phase 1 completion report
- [SETUP.md](SETUP.md) - Detailed setup and run guide
- [DESIGN_GUIDE.md](DESIGN_GUIDE.md) - Visual design system
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide

---

## 🏗️ Architecture

Following **Clean Architecture** with **Zero-Trust Security**:

### Layers
- **Domain**: Business logic and models
- **Providers**: State management (Riverpod)
- **Presentation**: UI screens and widgets

### Security Principles
1. **Zero-Trust Client**: Backend determines PIN validity
2. **Session Scopes**: Admin vs Restricted access
3. **Silent Degradation**: No visible errors in duress mode
4. **Timing Safety**: Artificial jitter prevents timing attacks

---

## 🎯 Key Features

### Dual-Identity System
- **Safe Mode**: Full access, real balance, all features
- **Duress Mode**: Fake balance, restricted features, silent alerts
- **Stealth UX**: Indistinguishable during PIN entry

### Premium UI/UX
- Gyroscope-based card tilt
- Glass morphism effects
- Staggered entrance animations
- Pulsing status indicators
- Radar scanner aesthetic
- Slide-to-pay confirmation

### Security Features
- Zero-trust architecture
- Session-based scopes
- Silent failure modes
- Identical visual feedback
- Admin-only safety controls

---

## ⚠️ Security Notes

### Phase 1 (Current - Development)
⚠️ **DO NOT USE IN PRODUCTION**
- PINs are hardcoded client-side
- Mock session creation
- Test-only alert messages

### Phase 2 (Production)
✅ Backend-only PIN validation
✅ Supabase Edge Functions
✅ Encrypted session tokens
✅ Real-time security monitoring

---

## 🤝 Contributing

This is a security-focused app. Contributions must:
1. Maintain dark mode aesthetic
2. Follow established design system
3. Preserve security architecture
4. Include smooth animations
5. Use glass morphism effects
6. **Never** compromise the zero-trust model

---

## 📄 License

Private - Security-focused banking application

---

## 🎉 Status

**Phase 1**: ✅ COMPLETE
**Phase 2**: 🚀 READY TO START

For setup instructions, see [SETUP.md](SETUP.md)
For roadmap details, see [SHIELD_DEV_ROADMAP.md](SHIELD_DEV_ROADMAP.md)
