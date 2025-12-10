# Visual Specification: LoginScreen

## Screen Layout

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│                                     │
│              ┌───┐                  │ ← Logo (100px circle)
│              │ 🛡️ │                  │   Teal gradient + glow
│              └───┘                  │
│                                     │
│           S H I E L D               │ ← Title (Bold, 8px spacing)
│         Secure Banking              │ ← Subtitle (Gray)
│                                     │
│                                     │
│                                     │
│              ┌───┐                  │ ← Biometric Icon (80px)
│              │ 👆 │                  │   Glass circle
│              └───┘                  │
│                                     │
│         Enter your PIN              │ ← Instruction text
│                                     │
│        ○ ○ ○ ○ ○ ○                 │ ← PIN Dots (6)
│                                     │   Glow teal when filled
│        [Error Message]              │ ← Error (if any)
│                                     │
│                                     │
│      ┌───┐ ┌───┐ ┌───┐            │
│      │ 1 │ │ 2 │ │ 3 │            │
│      └───┘ └───┘ └───┘            │
│      ┌───┐ ┌───┐ ┌───┐            │ ← Keypad (Glass circles)
│      │ 4 │ │ 5 │ │ 6 │            │   80px diameter
│      └───┘ └───┘ └───┘            │
│      ┌───┐ ┌───┐ ┌───┐            │
│      │ 7 │ │ 8 │ │ 9 │            │
│      └───┘ └───┘ └───┘            │
│      ┌───┐ ┌───┐ ┌───┐            │
│      │   │ │ 0 │ │ ⌫ │            │
│      └───┘ └───┘ └───┘            │
│                                     │
│       👆 Use Biometrics             │ ← Optional biometric
│                                     │
└─────────────────────────────────────┘
```

## Color Values

### Background Gradient (Animated)
- Base: `#0F172A` (Deep Slate Blue)
- Secondary: `#1E293B`
- Animated blobs: Teal at 5% opacity, moving in circular paths

### Components

**Logo**
- Background: Linear gradient `#2DD4BF → #14B8A6`
- Icon: White `#FFFFFF`
- Shadow: Teal glow, 20px blur, 30% opacity

**Title "SHIELD"**
- Color: `#F8FAFC` (White)
- Font: Outfit Bold
- Letter spacing: 8px

**Subtitle "Secure Banking"**
- Color: `#94A3B8` (Tertiary gray)
- Font: Outfit Medium
- Letter spacing: 2px

**PIN Dots (Unfilled)**
- Border: `#FFFFFF` at 12% opacity
- Background: Transparent
- Size: 16px diameter
- Border width: 2px

**PIN Dots (Filled)**
- Background: `#2DD4BF` (Teal)
- Border: `#2DD4BF` (Teal)
- Shadow: Teal glow, 12px blur, 50% opacity
- Size: 16px diameter
- Border width: 2px

**PIN Dots (Error)**
- Background: `#FF453A` (Red)
- Border: `#FF453A` (Red)
- Animation: Shake (400ms)

**Keypad Buttons**
- Background: `#FFFFFF` at 8% opacity with 10px blur
- Border: `#FFFFFF` at 12% opacity, 1px
- Text: `#F8FAFC` (White)
- Size: 80px diameter
- Font: Outfit Medium
- Text size: 32px

**Delete Button**
- Same as keypad buttons
- Icon: Backspace (outline)
- Icon color: `#CBD5E1` (Secondary gray)
- Icon size: 28px

## Animation Timeline

### Initial Load (Sequential)
1. **0ms**: Background gradient starts animating
2. **0-800ms**: Logo fades in + scales up (ease-out-back curve)
3. **200-1000ms**: Title "SHIELD" fades in + slides up
4. **300-1100ms**: Subtitle fades in + slides up
5. **400-1000ms**: Biometric icon fades in + scales
6. **500-1100ms**: "Enter your PIN" text fades in + slides up
7. **600-1200ms**: PIN dots fade in + slide up
8. **200-800ms**: Keypad fades in + slides up (entire grid)
9. **800-1400ms**: Biometric button fades in

### Interaction Animations

**Digit Pressed**
- Button: Material ripple (white 10% opacity)
- Dot: Scales from 0.8 to 1.0 in 200ms
- Dot: Background and border fade from transparent to teal in 200ms
- Dot: Glow appears in 200ms

**Delete Pressed**
- Button: Material ripple
- Dot: Scales from 1.0 to 0.8 in 200ms
- Dot: Background and border fade from teal to transparent in 200ms
- Dot: Glow disappears in 200ms

**PIN Complete (Correct)**
- Dots: Hold glow
- Screen: Fade out entire login screen (300ms)
- Navigation: Slide to HomeScreen (CupertinoPageTransition, 300ms)

**PIN Complete (Incorrect)**
- All dots: Turn red in 100ms
- All dots: Shake animation (400ms, ±10px)
- Error text: Fade in below dots (200ms)
- After 1000ms: Dots clear one by one from right to left (50ms each)
- Error text: Fade out (200ms)

## Measurements

### Spacing
- Screen padding: 24px horizontal
- Logo to title: 48px
- Title to subtitle: 8px
- Subtitle to biometric icon: 48px (flexible spacer)
- Biometric icon to instruction: 32px
- Instruction to dots: 24px
- Dots to error message: 16px
- Error message height: 24px (reserved space)
- Keypad to biometric button: 32px
- Biometric button to bottom: 48px

### Keypad Grid
- Button size: 80px × 80px
- Horizontal gap: 24px (12px padding each side)
- Vertical gap: 16px
- Grid total width: ~280px
- Grid total height: ~360px

### PIN Dots
- Dot size: 16px diameter
- Dot spacing: 16px between centers (8px gap)
- Total width: ~120px

## Responsive Behavior

### Small Screens (<375px height)
- Reduce top spacer
- Logo size: 80px (from 100px)
- Reduce gaps between sections by 25%

### Large Screens (>800px height)
- Add more spacing in flexible spacers
- Keep component sizes the same
- Center everything vertically

### Landscape Mode (Not Recommended)
- Currently locked to portrait
- Future: Consider horizontal keypad layout

## Accessibility

### Touch Targets
- Keypad buttons: 80×80px (exceeds 44×44 minimum) ✓
- PIN dots: Not interactive (visual only)
- Biometric button: 44×44px minimum ✓

### Text Contrast
- White on dark slate: 15.5:1 (AAA) ✓
- Teal on dark slate: 4.8:1 (AA+) ✓
- Secondary gray on dark slate: 7.2:1 (AAA) ✓

### Haptic Feedback (Future)
- Light impact on digit press
- Medium impact on delete
- Success/error impact on validation

## States

### Initial State
- 0 dots filled
- No error message
- All buttons enabled

### Typing State (1-5 digits)
- N dots filled
- No error message
- All buttons enabled
- Delete button enabled only if digits > 0

### Validating State (6 digits)
- 6 dots filled
- Validation runs automatically
- Brief moment before success/error

### Error State
- 6 dots red
- Error message visible
- Shake animation
- Buttons disabled during animation
- Auto-clear after 1 second

### Success State
- 6 dots teal
- No error message
- Fade out + navigate

## Security Features

### Visual Stealth
- Both PINs look identical during entry
- No indication of PIN type
- No "panic mode" visual cues
- Same animation timing for both

### Error Handling
- Generic error message ("Incorrect PIN")
- No indication of which PIN is expected
- Auto-clear prevents analysis
- No attempt counter visible (logged internally)

## Platform Consistency

### iOS
- Uses CupertinoPageTransition
- Light haptic feedback (if implemented)
- Respects safe areas

### Android
- Uses Material ripple effects
- Haptic feedback on supported devices
- Respects system navigation

---

**Implementation Status**: Complete ✅
**File**: [login_screen.dart](lib/features/auth/presentation/login_screen.dart)
