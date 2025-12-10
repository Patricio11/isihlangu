# SHIELD (ISIHLANGU) - DESIGN-FIRST ROADMAP
**Strategy:** "Frontend First." Build the Ferrari body before putting in the engine.
**Goal:** Create a visually stunning, award-winning UI with mock data to prove the UX concept.

---

## PHASE 1: THE "AWARD-WINNING" UI ✅ COMPLETE
*Goal: A fully interactive app with hardcoded data. It looks real, but logic is mocked.*
*Status: COMPLETED - 2025-12-09*

### Task 1.1: The Design System (The "DNA") ✅
- [x] Install `flutter_animate`, `glassmorphism`, `google_fonts` (Outfit), `lottie`, `gap`, `sensors_plus`, `intl`.
- [x] Create `AppTheme` class: Define the "Deep Slate" background and "Neon Teal" gradients.
- [x] Build the **"GlassContainer"** reusable widget (frosted blur effect).
- [x] Build the **"NeonButton"** reusable widgets (glows on press).

**Deliverables:**
- `lib/core/theme/app_colors.dart` - Complete color palette with gradients and glows
- `lib/core/theme/app_theme.dart` - ThemeData with Outfit font family
- `lib/core/widgets/glass_container.dart` - Glass morphism components (GlassContainer, GlassButton, CircularGlassButton, GlassCard)
- `lib/core/widgets/animated_mesh_gradient.dart` - Animated background gradient

### Task 1.2: The "Stealth" Login Screen ✅
- [x] Build a biometric-style login page.
- [x] **Animation:** Create the "Mesh Gradient" background that moves slowly (breathing effect).
- [x] **Interaction:** Build the PIN pad.
    - *Mock Logic:* If PIN '1234' → Go to Home (Safe). If PIN '9999' → Go to Home (Duress).
    - *Visual:* Ensure the transition is identical for both.
- [x] **Security:** Session-based scope system (Admin/Restricted) prepared for Phase 2.

**Deliverables:**
- `lib/features/auth/presentation/login_screen.dart` - Main login UI with animations
- `lib/features/auth/presentation/widgets/pin_dots.dart` - 4-dot PIN indicator with glow
- `lib/features/auth/presentation/widgets/pin_keypad.dart` - Glass-style keypad
- `lib/features/auth/domain/auth_state.dart` - Authentication state model
- `lib/features/auth/domain/user_session.dart` - Session model with scope (Admin/Restricted)
- `lib/features/auth/providers/auth_provider.dart` - Auth state management
- `lib/features/auth/providers/session_provider.dart` - Session management

**Test PINs:**
- `1234` → Safe Mode (Admin scope, full access)
- `9999` → Duress Mode (Restricted scope, fake balance)

### Task 1.3: The Home Dashboard (The "Wow" Factor) ✅
- [x] Build the **"Gyroscope Card"**: The credit card tilts slightly as you move the phone.
- [x] Build the **"Pulse Indicator"**: A glowing green ring around the shield icon.
- [x] Build the **"Staggered List"**: Transaction history slides in one-by-one.
- [x] **Mock Data:** Create a `fake_transactions.dart` file to populate the list.
- [x] **Circular Action Buttons:** Pay, Top Up, Freeze, More.
- [x] **Greeting Header:** Time-based greeting with user name.

**Deliverables:**
- `lib/features/home/presentation/home_screen.dart` - Main dashboard
- `lib/features/home/presentation/widgets/gyroscope_balance_card.dart` - Tilting balance card
- `lib/features/home/presentation/widgets/pulse_indicator.dart` - Animated shield status
- `lib/features/home/presentation/widgets/transaction_list.dart` - Transaction feed with stagger
- `lib/core/data/fake_transactions.dart` - Mock transaction data (separate for Safe/Duress)

**Data:**
- Safe Mode: R 12,450.50 balance | 8 transactions
- Duress Mode: R 150.00 balance | 3 transactions

### Task 1.4: The "Panic" UX ✅
- [x] **The Transition:** When logging in with '9999', show restricted UI.
- [x] **The Trap:** Show a fake balance (R 150.00).
- [x] **The Trigger:** Show a "Silent Alert Sent" toast message (only for testing).
- [x] **Feature Restrictions:** Disable Top Up and Freeze buttons in Duress Mode.
- [x] **Safety Center:** Show "Access Restricted" for duress users.

**Security Implementation:**
- Zero-trust client architecture foundation
- Session scope determines access level
- Identical visual feedback for both PINs
- Ready for backend integration

---

## BONUS: ADDITIONAL SCREENS BUILT IN PHASE 1 ✅

### PayScreen - "Slide to Pay" Widget ✅
- [x] Create the "Slide to Pay" widget (iPhone-style confirmation).
- [x] Large centered amount input.
- [x] Frequent contacts horizontal scroll.
- [x] Payment success animation.
- [x] Mock balance update.

**Deliverables:**
- `lib/features/payment/presentation/pay_screen.dart` - Payment flow
- `lib/features/payment/presentation/widgets/slide_to_pay.dart` - Slide-to-pay confirmation

### SafetyScreen - Radar Aesthetic ✅
- [x] Animated radar scanner with sweeping line.
- [x] Security toggles (Ghost Mode, Location Broadcast).
- [x] Configuration tiles (Duress PIN Setup, Trusted Contacts, Emergency Triggers).
- [x] Admin-only access control.

**Deliverables:**
- `lib/features/safety/presentation/safety_screen.dart` - Safety center
- `lib/features/safety/presentation/widgets/radar_widget.dart` - Animated radar

### Navigation System ✅
- [x] **GoRouter** implementation with authentication guards.
- [x] **Floating Glass Bottom Nav Bar** with 4 tabs.
- [x] Auto-redirect based on authentication state.
- [x] Shell route architecture.

**Deliverables:**
- `lib/core/navigation/app_router.dart` - GoRouter configuration
- `lib/core/navigation/main_scaffold.dart` - Main scaffold with nav bar
- `lib/core/widgets/floating_nav_bar.dart` - Floating bottom navigation

---

# PHASE 1 EXPANSION: ADDITIONAL FEATURES
*Copy and paste this section after your existing "BONUS: ADDITIONAL SCREENS" section*
*All features use mock/hardcoded data - no backend required*

---

## PHASE 1.5: UX POLISH & PREMIUM FEATURES ✅ COMPLETE
*Goal: Elevate the app from "good" to "award-winning" with micro-interactions and essential screens.*
*Status: COMPLETED - 2025-12-10*

### Task 1.5: Micro-Interactions & Feedback Systems ✅
- [x] **Haptic Feedback Patterns:**
    - [x] Light tap on keypad press.
    - [x] Success pattern (double pulse) on successful login.
    - [x] Warning pattern (three short) on wrong PIN.
    - [x] *Note:* Identical haptics for Safe/Duress login (no tells).
- [x] **Pull-to-Refresh Animation:**
    - [x] Custom shield icon that fills up as you pull.
    - [x] Fake 1.5s delay to simulate "syncing".
    - [x] Randomly add a new mock transaction on refresh.
- [x] **Shimmer Loading States:**
    - [x] Balance card skeleton loader.
    - [x] Transaction list skeleton (3 placeholder rows).
    - [x] Profile avatar shimmer.
- [x] **Toast Notifications:**
    - [x] Success toast (green glow, checkmark icon).
    - [x] Error toast (red glow, X icon).
    - [x] Info toast (teal glow, info icon).
    - [x] Custom "Silent Alert Sent" toast (duress only - testing).

**Deliverables:**
- `lib/core/utils/haptics.dart` - HapticService with pattern methods
- `lib/core/widgets/shield_refresh_indicator.dart` - Custom pull-to-refresh
- `lib/core/widgets/shimmer_loader.dart` - Skeleton loading components
- `lib/core/widgets/custom_toast.dart` - Styled toast notifications

---

### Task 1.6: Empty, Error & Edge Case States ✅
- [x] **Empty States (with illustrations):**
    - [x] No transactions yet - "Your first transaction will appear here"
    - [x] No contacts - "Add your first trusted contact"
    - [x] No tasks - "No chores available" (child view)
- [x] **Error States:**
    - [x] Network error screen (offline illustration).
    - [x] "Something went wrong" with retry button.
    - [x] Session expired prompt.
- [x] **Loading States:**
    - [x] Full-screen loader with animated shield.
    - [x] Button loading state (spinner replaces text).
    - [x] Inline loading for list items.

**Deliverables:**
- `lib/core/widgets/empty_state.dart` - Reusable empty state with icon/text
- `lib/core/widgets/error_state.dart` - Error display with retry action
- `lib/core/widgets/loading_overlay.dart` - Full-screen loading
- `lib/core/illustrations/` - SVG/Lottie illustrations folder

**Mock Behavior:**
- Toggle empty states via debug menu
- Simulate errors with special PIN `0000`

---

### Task 1.7: Onboarding & First-Time User Experience ✅
- [x] **Splash Screen:**
    - [x] Animated shield logo (Lottie).
    - [x] Gradient background fade-in.
    - [x] 2-second display then auto-navigate.
- [x] **Onboarding Carousel (3 slides):**
    - [x] Slide 1: "Your Money, Protected" - Shield animation
    - [x] Slide 2: "Family Finance Made Simple" - Family illustration
    - [x] Slide 3: "Duress Protection" - Lock/stealth illustration
    - [x] Skip button + progress dots.
    - [x] "Get Started" on final slide.
- [x] **PIN Setup Flow:**
    - [x] "Create your PIN" screen.
    - [x] "Confirm your PIN" screen.
    - [x] PIN strength indicator (4 dots light up).
    - [x] *Mock:* Store PIN in SharedPreferences for demo.
- [x] **Duress PIN Education:**
    - [x] "Set up your Duress PIN" screen.
    - [x] Animated explainer: "If forced to open your app..."
    - [x] Warning: "Never share this PIN with anyone."

**Deliverables:**
- `lib/features/onboarding/presentation/splash_screen.dart` - Animated splash
- `lib/features/onboarding/presentation/onboarding_screen.dart` - Carousel
- `lib/features/onboarding/presentation/pin_setup_screen.dart` - PIN creation
- `lib/features/onboarding/presentation/duress_education_screen.dart` - Duress explainer
- `lib/features/onboarding/presentation/widgets/onboarding_page.dart` - Single carousel page
- `lib/features/onboarding/providers/onboarding_provider.dart` - Track completion state

**Mock Data:**
- `isFirstLaunch` flag in SharedPreferences
- Skip onboarding with debug gesture (5 taps on logo)

---

### Task 1.8: Profile & Settings Screen ✅
- [x] **Profile Header:**
    - [x] Avatar with gradient border (initials fallback).
    - [x] User name and family role badge ("Parent" / "Child").
    - [x] Member since date.
- [x] **Account Settings:**
    - [x] Change PIN (mock flow).
    - [x] Change Duress PIN (mock flow).
    - [x] Biometric toggle (UI only).
    - [x] Notification preferences (UI only).
- [x] **App Settings:**
    - [x] Theme toggle (System-based light/dark mode implemented).
    - [x] Language selector (English, Zulu, Afrikaans - UI only).
    - [x] Currency format (R 1,000.00 vs R1000.00).
- [x] **Security Section:**
    - [x] Active sessions list (mock: "iPhone 15 Pro - This device").
    - [x] "Log out all devices" button.
    - [x] Privacy policy link.
    - [x] Terms of service link.
- [x] **Danger Zone:**
    - [x] "Delete Account" button (shows confirmation modal only).
    - [x] "Reset App" for testing.
- [x] **Debug Menu (Dev Only):**
    - [x] Toggle between Safe/Duress mode.
    - [x] Reset onboarding.
    - [x] Clear all local data.
    - [x] Show mock data stats.

**Deliverables:**
- `lib/features/profile/presentation/profile_screen.dart` - Main profile
- `lib/features/profile/presentation/settings_screen.dart` - App settings
- `lib/features/profile/presentation/security_settings_screen.dart` - Security options
- `lib/features/profile/presentation/widgets/profile_header.dart` - Avatar + info
- `lib/features/profile/presentation/widgets/settings_tile.dart` - Reusable setting row
- `lib/core/providers/settings_provider.dart` - Local settings state

**Mock Data:**
- `fake_user_profile.dart` - Name: "Thabo Molefe", Role: Parent, Since: "March 2024"

---

### Task 1.9: Card Management Screen ✅
- [x] **Card Display:**
    - [x] Full card view with flip animation (tap to reveal CVV).
    - [x] Card number with copy button (masked: •••• •••• •••• 4521).
    - [x] Expiry date and cardholder name.
- [x] **Card Actions:**
    - [x] Freeze/Unfreeze card toggle with animation.
    - [x] Report lost/stolen (mock confirmation).
    - [x] Order replacement card (mock flow).
- [x] **Card Limits:**
    - [x] Daily spend limit slider (R500 - R10,000).
    - [x] ATM withdrawal limit slider.
    - [x] Online purchases toggle.
    - [x] International transactions toggle.
- [x] **Virtual Card:**
    - [x] "Generate Virtual Card" button.
    - [x] Display temporary card number.
    - [x] 24-hour expiry countdown.

**Deliverables:**
- `lib/features/card/presentation/card_screen.dart` - Card management
- `lib/features/card/presentation/widgets/flip_card.dart` - 3D flip animation
- `lib/features/card/presentation/widgets/card_limit_slider.dart` - Limit controls
- `lib/features/card/presentation/widgets/virtual_card_generator.dart` - Temp card
- `lib/core/data/fake_card_data.dart` - Mock card details

**Mock Data:**
- Card Number: •••• •••• •••• 4521
- CVV: 847
- Expiry: 09/27
- Cardholder: THABO MOLEFE

---

### Task 1.10: Transaction Details Screen ✅
- [x] **Transaction Header:**
    - [x] Large merchant logo (or initial fallback).
    - [x] Amount with color (green for income, red for expense).
    - [x] Status badge (Completed, Pending, Failed).
- [x] **Transaction Details:**
    - [x] Date and time.
    - [x] Category with icon.
    - [x] Reference number.
    - [x] Location (if available).
- [x] **Actions:**
    - [x] "Report Issue" button.
    - [x] "Add Note" (mock - saves locally).
    - [x] "Categorize" dropdown.
    - [x] Share receipt (mock share sheet).
- [x] **Related Transactions:**
    - [x] "You've spent R450 at Woolworths this month".
    - [x] Mini chart showing spending at this merchant.

**Deliverables:**
- `lib/features/transactions/presentation/transaction_detail_screen.dart`
- `lib/features/transactions/presentation/widgets/merchant_header.dart`
- `lib/features/transactions/presentation/widgets/transaction_timeline.dart`
- `lib/features/transactions/presentation/widgets/spending_mini_chart.dart`

**Navigation:**
- Tap any transaction in list → Slide-up detail screen

---

### Task 1.11: Notifications Screen ✅
- [x] **Notification Types:**
    - [x] Transaction alert (with amount and merchant).
    - [x] Security alert (new login, PIN change).
    - [x] Task completed (child finished chore).
    - [x] Low balance warning.
    - [x] Promotional (new features).
- [x] **Notification UI:**
    - [x] Grouped by date (Today, Yesterday, This Week).
    - [x] Unread indicator (teal dot).
    - [x] Swipe to dismiss.
    - [x] "Mark all as read" action.
- [x] **Empty State:**
    - [x] "All caught up!" with checkmark animation.

**Deliverables:**
- `lib/features/notifications/presentation/notifications_screen.dart`
- `lib/features/notifications/presentation/widgets/notification_card.dart`
- `lib/features/notifications/presentation/widgets/notification_group.dart`
- `lib/features/notifications/providers/notifications_provider.dart`
- `lib/core/data/fake_notifications.dart` - 10 mock notifications

**Mock Data:**
- 5 unread notifications
- Mix of transaction, security, and promo types

---

### Task 1.12: Accessibility & Inclusivity ✅
- [x] **Screen Reader Support:**
    - [x] Semantic labels on all buttons.
    - [x] Meaningful image descriptions.
    - [x] Announce balance changes.
- [x] **Visual Accessibility:**
    - [x] Minimum touch target size (48x48).
    - [x] Sufficient color contrast (WCAG AA).
    - [x] No color-only indicators (always icon + color).
- [x] **Text Scaling:**
    - [x] Support system font size up to 200%.
    - [x] Test all screens at max scale.
- [x] **Motion Sensitivity:**
    - [x] Respect "Reduce Motion" system setting.
    - [x] Provide static alternatives to animations.

**Deliverables:**
- `lib/core/accessibility/semantics_helper.dart` - Semantic label utilities
- Update all existing widgets with accessibility properties
- `lib/core/providers/accessibility_provider.dart` - Motion/contrast settings

---

### Task 1.13: Quick Actions & Shortcuts ⏭️ DEFERRED
*Platform-specific features deferred to Phase 2*
- [ ] **Home Screen Quick Actions (Long-press app icon):**
    - [ ] "Pay Someone" → Open PayScreen
    - [ ] "Check Balance" → Open Home (shows balance toast)
    - [ ] "Emergency" → Open Safety Center
- [ ] **In-App Shortcuts:**
    - [ ] Double-tap balance to copy amount.
    - [ ] Long-press transaction for quick actions.
    - [ ] Shake to freeze card (with confirmation).
- [ ] **Widgets (iOS/Android):**
    - [ ] Balance widget (shows "R 12,450.50" or "R 200" in duress).
    - [ ] Quick pay widget.

*Note: Basic quick actions already implemented via action buttons on home screen*

**Deliverables:**
- `lib/core/shortcuts/app_shortcuts.dart` - Quick action handlers
- `lib/core/shortcuts/shake_detector.dart` - Shake gesture detection
- iOS/Android widget implementation files

---

### Task 1.14: Advanced Animations & Polish ✅
- [x] **Screen Transitions:**
    - [x] Shared element transitions (card → detail).
    - [x] Hero animations for avatars.
    - [x] Slide-up modals with drag-to-dismiss.
- [x] **Celebration Animations:**
    - [x] Confetti on first transaction.
    - [x] Sparkle effect on savings goal reached.
    - [x] Shield pulse on successful security action.
- [x] **Ambient Animations:**
    - [x] Subtle gradient shift on home screen.
    - [x] Floating particles in background (very subtle).
    - [x] Breathing glow on shield icon.

*Note: Core animations implemented via flutter_animate package. All screens have fade-in, slide-in, and stagger animations.*

**Deliverables:**
- `lib/core/animations/page_transitions.dart` - Custom transitions
- `lib/core/animations/celebration_overlay.dart` - Confetti/sparkle
- `lib/core/animations/ambient_particles.dart` - Background effects

---

# TASK 1.15: ROLE-BASED SCREENS (MVP - PARENT CONTROL FOCUS)
*Add this section to Phase 1.5 after Task 1.14*
*Focus: Parent visibility & control over children's accounts*
*All screens use mock data - role switching via Debug Menu*

---

## MVP Core Features Only

**What we're building:**
- ✅ Parent can see all family members
- ✅ Parent can control child permissions
- ✅ Parent can view child transactions
- ✅ Parent gets alerts on child activity
- ✅ Child sees simplified dashboard (existing home screen, restricted)

**What we're NOT building (Phase 3+):**
- ❌ Tasks/Bounties system
- ❌ Savings goals gamification
- ❌ Money request flow
- ❌ Allowance scheduling

---

## Role System (Simplified)

| Role | Description | PIN |
|------|-------------|-----|
| **Parent** | Family controller | `1234` |
| **Child** | Controlled account | `5678` |
| **Duress** | Either role, restricted | `9999` |

---

### Task 1.15.1: Role Selection (Onboarding Addition)
- [ ] **Role Selection Screen:**
    - [ ] "I'm a Parent" → Parent setup flow
    - [ ] "I'm joining my family" → Child flow (enter family code)
    - [ ] Simple toggle or two large buttons
- [ ] **Parent: Create Family:**
    - [ ] Enter family name
    - [ ] Generate Family Code (mock: "SHIELD-7X4K")
    - [ ] "Share this code" with copy button
- [ ] **Child: Join Family:**
    - [ ] Enter Family Code input
    - [ ] Mock validation → Auto-approve after 2s

**Deliverables:**
- `lib/features/onboarding/presentation/role_selection_screen.dart`
- `lib/features/onboarding/presentation/create_family_screen.dart`
- `lib/features/onboarding/presentation/join_family_screen.dart`

**Mock Data:**
- Family Name: "The Molefe Family"
- Family Code: "SHIELD-7X4K"

---

### Task 1.15.2: Parent Dashboard
- [ ] **Parent Home Screen:**
    - [ ] Own balance card (existing gyroscope card)
    - [ ] **Family Overview Section (NEW):**
        - [ ] Horizontal scroll of family member mini-cards
        - [ ] Each shows: Avatar, Name, Balance
        - [ ] Tap → Goes to Child Control Panel
    - [ ] **Recent Family Activity:**
        - [ ] Toggle: "My Activity" / "Family"
        - [ ] Shows children's transactions in family view
    - [ ] Existing quick actions remain

**Deliverables:**
- `lib/features/home/presentation/parent_home_screen.dart`
- `lib/features/home/presentation/widgets/family_overview_section.dart`
- `lib/features/home/presentation/widgets/family_member_mini_card.dart`

**Mock Data (Molefe Family):**
```
Parent: Thabo Molefe - R 12,450.50
Child 1: Lesedi Molefe (14) - R 350.00
Child 2: Amogelang Molefe (10) - R 125.00
```

---

### Task 1.15.3: Family Members Screen
- [ ] **Family List:**
    - [ ] Parent card at top (marked "You")
    - [ ] Children listed below
    - [ ] Each card shows: Avatar, Name, Balance, Last active
    - [ ] Tap child → Child Control Panel
- [ ] **Add Member:**
    - [ ] Show family code prominently
    - [ ] "Share Code" button
    - [ ] Simple and clean

**Deliverables:**
- `lib/features/family/presentation/family_members_screen.dart`
- `lib/features/family/presentation/widgets/family_member_card.dart`
- `lib/features/family/presentation/widgets/add_member_section.dart`
- `lib/core/data/fake_family_data.dart`

**Navigation:**
- Add "Family" tab to Parent's bottom nav

---

### Task 1.15.4: Child Control Panel (THE CORE FEATURE)
*This is where parents control their children's account - the key selling point*

- [ ] **Child Header:**
    - [ ] Avatar and name
    - [ ] Current balance display
    - [ ] "Last active 5 mins ago"
- [ ] **Permission Toggles:**
    - [ ] `can_make_payments` - "Can send money" (toggle)
    - [ ] `can_view_full_balance` - "Can see full balance" (toggle)
    - [ ] `online_purchases` - "Online purchases allowed" (toggle)
    - [ ] `atm_withdrawals` - "ATM withdrawals allowed" (toggle)
- [ ] **Spending Limits:**
    - [ ] Daily limit slider (R0 - R500)
    - [ ] Per-transaction limit slider (R0 - R200)
- [ ] **Notifications:**
    - [ ] "Notify me of all transactions" (toggle)
    - [ ] "Notify on large transactions" (toggle + threshold)
- [ ] **View Transactions:**
    - [ ] "View Activity" button → Child's transaction list
- [ ] **Emergency Actions:**
    - [ ] "Freeze Card" button (instant toggle)
    - [ ] Red styling, confirmation required

**Deliverables:**
- `lib/features/family/presentation/child_control_screen.dart`
- `lib/features/family/presentation/widgets/permission_toggle.dart`
- `lib/features/family/presentation/widgets/limit_slider.dart`
- `lib/features/family/presentation/widgets/emergency_actions.dart`
- `lib/features/family/presentation/child_activity_screen.dart`

**Mock Data (Lesedi's Settings):**
```
can_make_payments: true
daily_limit: R150
per_transaction_limit: R100
online_purchases: true
atm_withdrawals: false
notify_all: true
card_frozen: false
```

---

### Task 1.15.5: Child View (Minimal Changes)
*Child uses existing HomeScreen with restrictions applied*

- [ ] **Restrictions Based on Permissions:**
    - [ ] If `can_make_payments` false → Disable Pay button
    - [ ] If `can_view_full_balance` false → Show "R •••••" instead
    - [ ] Show "Card Frozen" banner if parent froze card
- [ ] **No Family Tab:**
    - [ ] Child bottom nav: Home | Pay | Safety | Profile (4 tabs)
    - [ ] No access to family management
- [ ] **Simplified View:**
    - [ ] Child sees only their own transactions
    - [ ] No family activity toggle

**Deliverables:**
- Update `lib/features/home/presentation/home_screen.dart` to check permissions
- `lib/features/home/presentation/widgets/restricted_balance_card.dart`
- `lib/features/home/presentation/widgets/card_frozen_banner.dart`

---

### Task 1.15.6: Parent Notifications (Activity Alerts)
- [ ] **Notification Types:**
    - [ ] "Lesedi spent R45 at Woolworths" - Transaction
    - [ ] "Amogelang's card was declined" - Alert
    - [ ] "New device login: Lesedi" - Security
- [ ] **In Existing Notifications Screen:**
    - [ ] Add family notifications to the feed
    - [ ] Badge shows family member avatar
    - [ ] Tap → Option to view child's control panel

**Deliverables:**
- Update `lib/features/notifications/presentation/notifications_screen.dart`
- `lib/features/notifications/presentation/widgets/family_notification_card.dart`
- Update `lib/core/data/fake_notifications.dart` with family alerts

**Mock Notifications (add 5):**
```
- "Lesedi spent R45 at Woolworths" - 1h ago
- "Amogelang spent R15 at Tuck Shop" - 3h ago
- "Lesedi's transaction declined (limit exceeded)" - Yesterday
- "New login from Lesedi's phone" - Yesterday
- "Amogelang's balance is low (R25)" - 2 days ago
```

---

### Task 1.15.7: Role-Based Navigation
- [ ] **Parent Bottom Nav (5 tabs):**
    - [ ] Home | Family | Pay | Safety | Profile
- [ ] **Child Bottom Nav (4 tabs):**
    - [ ] Home | Pay | Safety | Profile
- [ ] **Navigation Provider:**
    - [ ] Check role from session
    - [ ] Return appropriate nav items
- [ ] **Route Guards:**
    - [ ] Block `/family/*` routes for children
    - [ ] Redirect to home with toast: "Parents only"
- [ ] **Debug Menu:**
    - [ ] Add "Switch Role" toggle
    - [ ] Add "Switch Child" selector

**Deliverables:**
- `lib/core/navigation/role_based_nav.dart`
- `lib/core/navigation/guards/role_guard.dart`
- `lib/core/providers/role_provider.dart`
- Update `lib/core/navigation/app_router.dart`

**Test PINs:**
```
1234 → Parent (Thabo) - Safe Mode - 5 tabs
5678 → Child (Lesedi) - Safe Mode - 4 tabs
4321 → Child (Amogelang) - Safe Mode - 4 tabs  
9999 → Current Role - Duress Mode
```

---

## 📊 MVP TASK 1.15 STATISTICS

**New Screens:** 7
**New Widgets:** 12
**Updated Screens:** 3
**Mock Data Files:** 2
**Estimated Duration:** 1 week

---

## 📁 FILE STRUCTURE (MVP Addition)

```
lib/
├── core/
│   ├── data/
│   │   ├── fake_transactions.dart ✅
│   │   ├── fake_family_data.dart         # NEW
│   │   └── fake_notifications.dart       # UPDATE (add family alerts)
│   ├── navigation/
│   │   ├── app_router.dart ✅            # UPDATE
│   │   ├── role_based_nav.dart           # NEW
│   │   └── guards/
│   │       └── role_guard.dart           # NEW
│   └── providers/
│       └── role_provider.dart            # NEW
├── features/
│   ├── home/
│   │   └── presentation/
│   │       ├── home_screen.dart ✅       # UPDATE (permission checks)
│   │       ├── parent_home_screen.dart   # NEW
│   │       └── widgets/
│   │           ├── family_overview_section.dart    # NEW
│   │           ├── family_member_mini_card.dart    # NEW
│   │           ├── restricted_balance_card.dart    # NEW
│   │           └── card_frozen_banner.dart         # NEW
│   ├── family/                           # NEW FEATURE
│   │   └── presentation/
│   │       ├── family_members_screen.dart
│   │       ├── child_control_screen.dart
│   │       ├── child_activity_screen.dart
│   │       └── widgets/
│   │           ├── family_member_card.dart
│   │           ├── permission_toggle.dart
│   │           ├── limit_slider.dart
│   │           ├── add_member_section.dart
│   │           └── emergency_actions.dart
│   ├── notifications/
│   │   └── presentation/
│   │       ├── notifications_screen.dart # UPDATE
│   │       └── widgets/
│   │           └── family_notification_card.dart   # NEW
│   └── onboarding/
│       └── presentation/
│           ├── role_selection_screen.dart    # NEW
│           ├── create_family_screen.dart     # NEW
│           └── join_family_screen.dart       # NEW
```

---

## ✅ MVP COMPLETION CHECKLIST

**Onboarding:**
- [ ] Role selection works
- [ ] Create family generates code
- [ ] Join family accepts code

**Parent Features:**
- [ ] Parent dashboard shows family members
- [ ] Family members screen lists all
- [ ] Child control panel has all toggles
- [ ] Can view child's transactions
- [ ] Emergency freeze button works

**Child Features:**
- [ ] Permission restrictions apply
- [ ] Hidden balance when restricted
- [ ] Frozen card banner shows
- [ ] Cannot access family screens

**Navigation:**
- [ ] Parent sees 5 tabs
- [ ] Child sees 4 tabs
- [ ] Route guards block children
- [ ] Debug menu switches roles

---

## 🎯 MVP SELLING POINTS DEMONSTRATED

With this minimal build, you can demo:

1. **"As a parent, I can see what my children are spending"**
   → Family overview + child transaction history

2. **"I can control their spending limits instantly"**
   → Child control panel with sliders

3. **"I can freeze their card in an emergency"**
   → Emergency actions section

4. **"I get notified of all their activity"**
   → Family notifications

5. **"The duress PIN works for both parent and child"**
   → 9999 shows fake data for either role

This is your **core value proposition** - everything else (tasks, savings, allowances) is Phase 3 enhancement.

---

**Priority:** HIGH
**Duration:** ~1 week
**Add after:** Task 1.14

---

## PHASE 1.5 BONUS: ADDITIONAL MOCK SCREENS

### WalletScreen - Multi-Wallet View
- [ ] **Wallet Cards:**
    - [ ] Main Wallet (primary balance).
    - [ ] Lunch Money (child's school wallet).
    - [ ] Savings Pot (goals-based saving).
- [ ] **Wallet Interactions:**
    - [ ] Tap to expand wallet details.
    - [ ] "Move Money" between wallets.
    - [ ] Create new savings pot.
- [ ] **Savings Goals:**
    - [ ] Visual progress bar (0-100%).
    - [ ] Target amount and deadline.
    - [ ] "Add Money" quick action.

**Deliverables:**
- `lib/features/wallet/presentation/wallet_screen.dart`
- `lib/features/wallet/presentation/widgets/wallet_card.dart`
- `lib/features/wallet/presentation/widgets/savings_pot.dart`
- `lib/features/wallet/presentation/widgets/move_money_sheet.dart`
- `lib/core/data/fake_wallets.dart`

**Mock Data:**
- Main Wallet: R 12,450.50
- Lunch Money: R 250.00
- Savings (New Bike): R 1,200.00 / R 3,500.00 (34%)

---

### StatisticsScreen - Spending Insights
- [ ] **Spending Overview:**
    - [ ] Pie chart by category (Groceries, Entertainment, Transport, etc.).
    - [ ] This month vs last month comparison.
    - [ ] Daily average spend.
- [ ] **Category Breakdown:**
    - [ ] Tap category to see transactions.
    - [ ] Budget vs actual per category.
    - [ ] Top merchants list.
- [ ] **Trends:**
    - [ ] Weekly spending bar chart.
    - [ ] "You spent 20% less than last week" insight.
    - [ ] Projected month-end balance.

**Deliverables:**
- `lib/features/statistics/presentation/statistics_screen.dart`
- `lib/features/statistics/presentation/widgets/spending_pie_chart.dart`
- `lib/features/statistics/presentation/widgets/category_list.dart`
- `lib/features/statistics/presentation/widgets/weekly_chart.dart`
- `lib/features/statistics/presentation/widgets/insight_card.dart`

**Mock Data:**
- 6 spending categories with percentages
- 4 weeks of daily spending data
- 3 insight messages

---

### ContactsScreen - Beneficiary Management
- [ ] **Contact List:**
    - [ ] Alphabetical grouping with sticky headers.
    - [ ] Search/filter bar.
    - [ ] Avatar with gradient fallback.
- [ ] **Contact Card:**
    - [ ] Name, bank, account number (masked).
    - [ ] Last payment date and amount.
    - [ ] Favorite toggle (star).
- [ ] **Add Contact Flow:**
    - [ ] Manual entry form.
    - [ ] Scan to pay (QR scanner UI - mock).
    - [ ] Recent recipients suggestion.

**Deliverables:**
- `lib/features/contacts/presentation/contacts_screen.dart`
- `lib/features/contacts/presentation/widgets/contact_card.dart`
- `lib/features/contacts/presentation/add_contact_screen.dart`
- `lib/features/contacts/presentation/widgets/qr_scanner_mock.dart`
- `lib/core/data/fake_contacts.dart` - 8 mock contacts

**Mock Data:**
- 8 contacts with SA bank details
- 3 marked as favorites
- Include "Mom", "Dad", "Woolworths", "MTN Airtime"

---

### HelpScreen - Support & FAQ
- [ ] **Help Topics:**
    - [ ] Searchable FAQ list.
    - [ ] Expandable accordion answers.
    - [ ] Category filtering (Account, Payments, Security).
- [ ] **Contact Support:**
    - [ ] "Chat with us" button (opens mock chat).
    - [ ] "Call us" with phone number.
    - [ ] "Email us" with mailto link.
- [ ] **Guides:**
    - [ ] "How Duress PIN Works" walkthrough.
    - [ ] "Setting Up Family Accounts" guide.
    - [ ] "Card Security Tips" article.

**Deliverables:**
- `lib/features/help/presentation/help_screen.dart`
- `lib/features/help/presentation/faq_screen.dart`
- `lib/features/help/presentation/widgets/faq_accordion.dart`
- `lib/features/help/presentation/mock_chat_screen.dart`
- `lib/core/data/fake_faqs.dart` - 15 FAQ items

---

## 📊 PHASE 1.5 STATISTICS (When Complete)

**New Tasks:** 14
**New Screens:** 10+
**New Widgets:** 40+
**Estimated Duration:** 2-3 weeks

---

## 📁 UPDATED FILE STRUCTURE

```
lib/
├── core/
│   ├── accessibility/
│   │   └── semantics_helper.dart
│   ├── animations/
│   │   ├── page_transitions.dart
│   │   ├── celebration_overlay.dart
│   │   └── ambient_particles.dart
│   ├── data/
│   │   ├── fake_transactions.dart ✅
│   │   ├── fake_wallets.dart
│   │   ├── fake_contacts.dart
│   │   ├── fake_notifications.dart
│   │   ├── fake_faqs.dart
│   │   ├── fake_card_data.dart
│   │   └── fake_user_profile.dart
│   ├── illustrations/
│   │   ├── empty_transactions.svg
│   │   ├── error_network.svg
│   │   └── onboarding_*.svg
│   ├── providers/
│   │   ├── settings_provider.dart
│   │   └── accessibility_provider.dart
│   ├── shortcuts/
│   │   ├── app_shortcuts.dart
│   │   └── shake_detector.dart
│   ├── utils/
│   │   └── haptics.dart
│   └── widgets/
│       ├── glass_container.dart ✅
│       ├── animated_mesh_gradient.dart ✅
│       ├── floating_nav_bar.dart ✅
│       ├── shield_refresh_indicator.dart
│       ├── shimmer_loader.dart
│       ├── custom_toast.dart
│       ├── empty_state.dart
│       ├── error_state.dart
│       └── loading_overlay.dart
├── features/
│   ├── auth/ ✅
│   ├── home/ ✅
│   ├── payment/ ✅
│   ├── safety/ ✅
│   ├── card/
│   │   └── presentation/
│   │       ├── card_screen.dart
│   │       └── widgets/
│   ├── contacts/
│   │   └── presentation/
│   │       ├── contacts_screen.dart
│   │       ├── add_contact_screen.dart
│   │       └── widgets/
│   ├── help/
│   │   └── presentation/
│   │       ├── help_screen.dart
│   │       ├── faq_screen.dart
│   │       └── widgets/
│   ├── notifications/
│   │   └── presentation/
│   │       ├── notifications_screen.dart
│   │       └── widgets/
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── splash_screen.dart
│   │       ├── onboarding_screen.dart
│   │       ├── pin_setup_screen.dart
│   │       └── duress_education_screen.dart
│   ├── profile/
│   │   └── presentation/
│   │       ├── profile_screen.dart
│   │       ├── settings_screen.dart
│   │       └── widgets/
│   ├── statistics/
│   │   └── presentation/
│   │       ├── statistics_screen.dart
│   │       └── widgets/
│   ├── transactions/
│   │   └── presentation/
│   │       ├── transaction_detail_screen.dart
│   │       └── widgets/
│   └── wallet/
│       └── presentation/
│           ├── wallet_screen.dart
│           └── widgets/
```

---

## ✅ PHASE 1.5 COMPLETION CHECKLIST

- [x] All micro-interactions implemented
- [x] All empty/error states designed
- [x] Onboarding flow complete
- [x] Profile & settings functional
- [x] Card management screen built
- [x] Transaction details navigable
- [x] Notifications screen populated
- [x] Accessibility audit passed
- [x] All new screens use mock data only
- [x] Debug menu allows testing all states
- [x] **BONUS:** System-based light/dark theme support

---

**PHASE 1.5 STATISTICS:**
**Completion Date:** 2025-12-10
**Tasks Completed:** 13 of 14 (93%)
**New Screens:** 7 (Card, Transaction Details, Notifications, Profile, Settings, Onboarding, Splash)
**New Widgets:** 35+
**New Features:**
- ✅ Haptic feedback system
- ✅ Custom toast notifications
- ✅ Shimmer loading states
- ✅ Pull-to-refresh
- ✅ Empty/error states
- ✅ 3D flip card animation
- ✅ Transaction details with actions
- ✅ Notification system with filtering
- ✅ Accessibility helpers
- ✅ System-based light/dark themes
- ⏭️ Platform-specific shortcuts (deferred to Phase 2)

**Status:** COMPLETE ✅
**Priority:** Ready for Phase 2

---
## PHASE 2: WIRING THE BRAIN (Weeks 3-4)
*Goal: Connect Supabase, implement Role-Based Security, and build the Database.*
*Status: READY TO START*

### Task 2.1: Supabase & Role Architecture
- [ ] Set up Supabase project.
- [ ] **Define Roles:** Implement `System Admin`, `Parent` (Controller), and `Peer` (User) roles.
- [ ] **Create Schema:**
    - [ ] `profiles`: Extends auth with `role` and `family_id`.
    - [ ] `families`: Groups users together.
    - [ ] `peer_permissions`: The "Toggle" table for parent controls.
    - [ ] `wallets`: Supports multi-wallet types (Main, Lunch, Savings).
    - [ ] `tasks`: The "Gig Economy" table.

### Task 2.2: The Security Logic (Edge Functions)
- [ ] Implement `validate_pin` Edge Function (Check PIN → Return Session Token + Scope).
- [ ] **Row Level Security (RLS):**
    - [ ] *Parent Policy:* Can view/edit all data within `family_id`.
    - [ ] *Peer Policy:* Can only view own data (unless permissions allow otherwise).
    - [ ] *Duress Policy:* If `session_scope == restricted`, return "Fake Wallet" data.
- [ ] Implement Timing Attack Mitigation (Artificial Jitter).

### Task 2.3: Realtime State Management
- [ ] Connect `Riverpod` to Supabase Streams.
- [ ] Sync Balance and Transaction History in real-time.

---

## PHASE 3: THE FAMILY ECONOMY (Weeks 5-6)
*Goal: Implement the "Parent Control" and "Gig Economy" features.*

### Task 3.1: The Parent "Control Panel"
- [ ] Build the **Peer Settings Screen** (Parent View).
- [ ] Implement Toggles:
    - [ ] `can_view_balance` (Show/Hide Piggy Bank).
    - [ ] `enable_tasks` (Unlock Chores).
    - [ ] `enable_loans` (Unlock Borrowing).
    - [ ] `lunch_mode` (Geo-fencing prep).
- [ ] **Logic:** Updating these toggles instantly updates the `peer_permissions` table.

### Task 3.2: The Gig Economy (Tasks & Bounties)
- [ ] **Parent UI:** "Create Bounty" screen (Title, Reward, Assignee).
- [ ] **Peer UI:** "Job Board" screen (List of available chores).
- [ ] **Logic:**
    - [ ] Peer clicks "Claim Task".
    - [ ] Peer clicks "Mark Complete" (Uploads photo).
    - [ ] Parent clicks "Approve" → **Trigger Transaction** (Move money from Parent Wallet to Child Wallet).

---

## PHASE 4: THE INTEGRATIONS & CARD LOGIC (Weeks 7-8)
*Goal: Connect to Real Banking APIs and Implement the "Unlock-to-Pay" Security.*

### Task 4.1: Vendor Selection & Integration
- [ ] **Due Diligence:** Evaluate APIs for Programmable Banking.
    - *Candidate A:* **Root (RootCode)** - Best for scriptable transaction logic.
    - *Candidate B:* **Stitch / Ukheshe** - Strong for card issuing and virtual wallets.
- [ ] Set up Sandbox Environment with chosen vendor.

### Task 4.2: The "Unlock-to-Pay" Logic (Core Security Feature)
*The physical/virtual card remains "Frozen" (Limit: R0.00) by default. It only unlocks via App PIN.*

- [ ] **Step 1: Default State Implementation**
    - [ ] Configure card issuer to set hard limit to R0.00 by default.
    - [ ] Ensure any transaction attempted without unlocking is instantly declined.

- [ ] **Step 2: The "Safe Unlock" Flow (PIN 1234)**
    - [ ] **User Action:** Enter PIN `1234` in App.
    - [ ] **Edge Function:** `unlock_card_safe()`
        - [ ] Increases Card Limit to Available Balance (or user-set daily limit).
        - [ ] Sets a **2-minute Timer**.
        - [ ] **UI:** Shows "Ready to Tap" countdown timer.
    - [ ] **After 2 Mins:** Function auto-resets Limit to R0.00.

- [ ] **Step 3: The "Duress Unlock" Flow (PIN 9999)**
    - [ ] **User Action:** Enter PIN `9999` in App.
    - [ ] **Edge Function:** `unlock_card_duress()`
        - [ ] Increases Card Limit to **R150.00 ONLY** (Lunch Money).
        - [ ] **Triggers Silent Alarm** (GPS + Push Notification to Parent).
        - [ ] **UI:** Shows "Ready to Tap" timer (Identical visual to Safe Mode).
        - [ ] **Scenario:** If user buys lunch (R50) → Approved. If user tries to buy TV (R5000) → Declined ("Insufficient Funds").

### Task 4.3: Location Intelligence (Lunch Mode)
- [ ] Add Google Maps widget to "Safety Center".
- [ ] **Geo-Fencing Logic:**
    - [ ] Define "School Zone" radius.
    - [ ] *Integration:* If using Root, inject logic: `if (transaction.location != school_zone) return decline;`
---

## PHASE 5: POLISH & SECURITY (Week 9+)
- [ ] Biometric Auth (FaceID/Fingerprint).
- [ ] Code Obfuscation & Penetration Testing.
- [ ] Beta testing with real families.
- [ ] Submit to App Stores.

---

## 📊 PHASE 1 STATISTICS
**Completion Date:** 2025-12-09
**Files Created:** 30+
**Screens Built:** 4
**Status:** COMPLETE ✅

**Current Phase:** PHASE 2 - Database & Roles
**Project Status:** EXPANDING SCOPE (Family Features Added) 🚀

**What's Next:**
⏭️ Supabase backend integration
⏭️ Edge Function for PIN validation
⏭️ Real-time data sync
⏭️ Production security implementation

---

## 📚 DOCUMENTATION

- [PHASE1_COMPLETE.md](PHASE1_COMPLETE.md) - Detailed Phase 1 completion report
- [SETUP.md](SETUP.md) - Setup and run guide
- [DESIGN_GUIDE.md](DESIGN_GUIDE.md) - Visual design system
- [README.md](README.md) - Project overview

---

**Current Phase:** PHASE 1 ✅ COMPLETE
**Next Phase:** PHASE 2 - Supabase Integration
**Project Status:** ON TRACK 🚀
