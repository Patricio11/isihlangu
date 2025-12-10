# Shield - Setup & Run Guide

## Quick Start

### 1. Install Dependencies
```bash
cd "c:\Users\patri\OneDrive\Desktop\Moblie App\shield"
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Test the App

**Safe Mode (Full Access)**:
- Enter PIN: `1234`
- Expected: High balance (R 12,450.50), all features enabled

**Duress Mode (Restricted)**:
- Enter PIN: `9999`
- Expected: Low balance (R 150.00), some features disabled, "Silent Alert Sent" toast

---

## Project Structure

```
shield/
├── lib/
│   ├── core/
│   │   ├── data/
│   │   │   └── fake_transactions.dart       # Mock transaction data
│   │   ├── navigation/
│   │   │   ├── app_router.dart              # GoRouter configuration
│   │   │   └── main_scaffold.dart           # Main app scaffold with nav bar
│   │   ├── theme/
│   │   │   ├── app_colors.dart              # Color palette
│   │   │   └── app_theme.dart               # Theme configuration
│   │   └── widgets/
│   │       ├── animated_mesh_gradient.dart  # Animated background
│   │       ├── floating_nav_bar.dart        # Bottom navigation
│   │       └── glass_container.dart         # Glass morphism widgets
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── domain/
│   │   │   │   ├── auth_state.dart          # Auth state model
│   │   │   │   └── user_session.dart        # Session/scope model
│   │   │   ├── providers/
│   │   │   │   ├── auth_provider.dart       # Auth state management
│   │   │   │   └── session_provider.dart    # Session management
│   │   │   └── presentation/
│   │   │       ├── login_screen.dart        # Login UI
│   │   │       └── widgets/
│   │   │           ├── pin_dots.dart        # PIN dots indicator
│   │   │           └── pin_keypad.dart      # PIN keypad
│   │   │
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       ├── home_screen.dart         # Home dashboard
│   │   │       └── widgets/
│   │   │           ├── gyroscope_balance_card.dart  # Tilting card
│   │   │           ├── pulse_indicator.dart         # Shield status
│   │   │           └── transaction_list.dart        # Transaction feed
│   │   │
│   │   ├── payment/
│   │   │   └── presentation/
│   │   │       ├── pay_screen.dart          # Payment screen
│   │   │       └── widgets/
│   │   │           └── slide_to_pay.dart    # Slide to pay widget
│   │   │
│   │   └── safety/
│   │       └── presentation/
│   │           ├── safety_screen.dart       # Safety center
│   │           └── widgets/
│   │               └── radar_widget.dart    # Radar animation
│   │
│   └── main.dart                            # App entry point
│
└── pubspec.yaml                             # Dependencies
```

---

## Features Overview

### 1. Login Screen
- **4-digit PIN entry**
- **Animated mesh gradient background**
- **Glass morphism keypad**
- **Biometric icon (visual only)**

**Test PINs**:
- `1234` → Safe Mode (Admin scope)
- `9999` → Duress Mode (Restricted scope)

### 2. Home Screen
- **Gyroscope-tilting balance card**
- **Pulsing shield status indicator**
- **Staggered transaction list**
- **4 action buttons**: Pay, Top Up, Freeze, More

**Safe Mode Data**:
- Balance: R 12,450.50
- Transactions: 8 items
- All buttons enabled

**Duress Mode Data**:
- Balance: R 150.00
- Transactions: 3 items
- Top Up & Freeze disabled

### 3. Pay Screen
- **Large amount input**
- **Frequent contacts picker**
- **Slide-to-pay confirmation**
- **Payment success animation**

### 4. Safety Screen
- **Animated radar display**
- **Security toggles** (Ghost Mode, Location Broadcast)
- **Configuration options** (Duress PIN, Trusted Contacts, Emergency Triggers)
- **Admin-only access** (restricted in duress mode)

### 5. Navigation
- **Floating glass bottom nav bar**
- **4 tabs**: Home, Pay, Activity, Safety
- **Smart routing with GoRouter**
- **Authentication guards**

---

## Key Technologies

### State Management
- **Riverpod 2.4+** - Reactive state management
- Session-based scope system (Admin/Restricted)

### Navigation
- **GoRouter 13.0+** - Declarative routing
- Authentication guards
- Deep linking ready

### UI/Animations
- **flutter_animate 4.5+** - Staggered entrance animations
- **glassmorphism 3.0+** - Frosted glass effects
- **sensors_plus 4.0+** - Gyroscope-based card tilt

### Design
- **google_fonts 6.1+** - Outfit typography
- **intl 0.19+** - Currency formatting

---

## Development Commands

### Run app
```bash
flutter run
```

### Run in release mode
```bash
flutter run --release
```

### Clean build
```bash
flutter clean
flutter pub get
flutter run
```

### Check for issues
```bash
flutter doctor
```

---

## Architecture Notes

### Phase 1: Current Implementation (Mock Data)
- PIN validation happens client-side (INSECURE - for UI development only)
- Mock session creation
- Hardcoded transaction data
- Test-only silent alert toast

### Phase 2: Production Implementation (Supabase)
- PIN sent to Supabase Edge Function
- Backend validates and returns session token with scope claim
- Client never knows which PIN was entered
- Real-time data sync
- Silent server-side alerts

---

## Security Considerations

### Current Phase 1 (Development):
⚠️ **DO NOT USE IN PRODUCTION** - PINs are hardcoded client-side

### Future Phase 2 (Production):
✅ Zero-trust architecture
✅ Backend-only PIN validation
✅ Timing attack mitigation
✅ Silent failure modes
✅ Encrypted session tokens

---

## Troubleshooting

### Issue: "Waiting for another flutter command"
```bash
# Windows
taskkill /F /IM dart.exe

# Mac/Linux
killall -9 dart
```

### Issue: Dependencies not installing
```bash
flutter clean
flutter pub get
```

### Issue: Gyroscope not working
- Gyroscope requires a physical device (won't work in simulator)
- Card will remain flat if gyroscope is unavailable

### Issue: Hot reload not working
- Press `R` (capital R) for full restart instead of `r`

---

## Screens Preview

### Login Screen
- PIN entry: 4 dots
- Animated gradient background
- Glass keypad with 10 buttons (0-9 + delete)

### Home Screen (Safe Mode)
- Balance card with gyroscope tilt
- Green pulsing shield indicator
- 8 transaction items with staggered animation
- All 4 action buttons enabled

### Home Screen (Duress Mode)
- Desaturated balance card
- Gray shield indicator (inactive)
- 3 minimal transaction items
- Top Up & Freeze buttons disabled

### Pay Screen
- Large R amount input
- 5 frequent contacts with avatar rings
- Slide-to-pay bar at bottom
- Payment success dialog

### Safety Screen (Admin)
- Animated radar with sweep line
- Active status indicator
- 2 toggle switches
- 3 configuration tiles

### Safety Screen (Restricted)
- Lock icon
- "Access Restricted" message
- No access to settings

---

## Next Steps (Phase 2)

1. Set up Supabase project
2. Create Edge Function for PIN validation
3. Implement database schema
4. Add real-time listeners
5. Remove client-side PIN logic
6. Test timing attack mitigation

---

**Phase 1: Complete** ✅
**Ready for Supabase Integration** 🚀

For detailed completion notes, see [PHASE1_COMPLETE.md](PHASE1_COMPLETE.md)
