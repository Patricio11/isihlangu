# Shield Design Guide

## Visual Design DNA

This document explains the visual language and components of Shield.

## Color System

### Background Layers
```dart
AppColors.background           // #0F172A - Main background
AppColors.backgroundSecondary  // #1E293B - Elevated surfaces
AppColors.backgroundTertiary   // #334155 - Highest elevation
```

### Glass Morphism
```dart
AppColors.glassSurface   // White 8% opacity - Main glass surface
AppColors.glassBorder    // White 12% opacity - Glass borders
AppColors.glassHighlight // White 5% opacity  - Subtle highlights
```

### Accent Colors
```dart
// PRIMARY (Success/Safe) - Electric Teal
AppColors.primary      // #2DD4BF
AppColors.primaryLight // #5EEAD4
AppColors.primaryDark  // #14B8A6

// DANGER (Alerts/Warnings) - Neon Red
AppColors.danger       // #FF453A
AppColors.dangerLight  // #FF6961
AppColors.dangerDark   // #DC2626
```

### Text Hierarchy
```dart
AppColors.textPrimary    // #F8FAFC - Headings, important text
AppColors.textSecondary  // #CBD5E1 - Body text
AppColors.textTertiary   // #94A3B8 - Labels, hints
AppColors.textDisabled   // #64748B - Disabled states
```

## Typography

**Font Family**: Google Fonts 'Outfit' (Clean, Geometric)

### Scale
- **Display Large**: Bold, -1.5 letter spacing - Hero text
- **Display Medium**: Bold, -0.5 letter spacing - Large headers
- **Headline Large**: Bold - Section headers
- **Title Large**: Semi-bold - Card titles
- **Body Large**: Regular - Main content
- **Label Large**: Semi-bold, 0.5 letter spacing - Buttons

## Component Anatomy

### GlassContainer
A frosted glass effect container with blur.

**Visual Properties**:
- 10px backdrop blur
- 8% white background
- 12% white border (1px)
- 16px border radius
- Soft shadow (black 10% opacity, 20px blur, 10px offset)

**Usage**:
```dart
GlassContainer(
  padding: EdgeInsets.all(20),
  borderRadius: BorderRadius.circular(16),
  child: Text('Content'),
)
```

### GlassButton
Flat button with neon gradient, NO shadows.

**Visual Properties**:
- Linear gradient (primary → primaryDark)
- 16px border radius
- 32px horizontal, 16px vertical padding
- NO elevation or shadows
- Active state: Slightly darker gradient

**Variants**:
- `GlassButton.primary()` - Teal gradient
- `GlassButton.danger()` - Red gradient

### CircularGlassButton
Round glass button for home screen actions.

**Visual Properties**:
- 70px diameter circle
- Glass surface with border
- Icon colored with primary accent
- Optional label below
- Ripple effect on tap

## Animation Guidelines

### Page Transitions
Use `CupertinoPageTransition` for smooth slide effects:
- Direction: Right to left (forward navigation)
- Duration: 300ms
- Curve: easeInOut

### List Item Entrance
Staggered animation using flutter_animate:
```dart
.animate()
.fadeIn(duration: 600.ms)
.slideY(begin: 0.2, end: 0, duration: 600.ms)
```

### Glow Effects
For active elements (filled PIN dots, active buttons):
```dart
BoxShadow(
  color: AppColors.primary.withOpacity(0.3),
  blurRadius: 20,
  spreadRadius: 0,
)
```

## Screen-Specific Design

### LoginScreen Layout

**Visual Hierarchy** (Top to Bottom):
1. **Logo** (100px circle)
   - Primary gradient background
   - Shield icon (white)
   - Teal glow effect

2. **Title** "SHIELD"
   - 8px letter spacing
   - Fade in + scale animation

3. **Biometric Icon** (80px circle)
   - Glass surface
   - Fingerprint icon (teal)

4. **PIN Dots** (6 dots)
   - 16px diameter
   - 8px horizontal spacing
   - Unfilled: Transparent with border
   - Filled: Teal with glow
   - Error: Red with shake animation

5. **Keypad** (3x4 grid)
   - 80px circle buttons
   - 16px gap between buttons
   - Glass surface
   - Bottom center: Delete button (backspace icon)

**Background**:
- Animated mesh gradient
- 3 radial gradient blobs
- 8-second animation loop
- Teal, dark teal, and blue colors
- Very subtle (3-5% opacity)

### Spacing System
- **XS**: 4px
- **SM**: 8px
- **MD**: 16px
- **LG**: 24px
- **XL**: 32px
- **2XL**: 48px

Use the `gap` package for clean spacing:
```dart
Gap(16) // Instead of SizedBox(height: 16)
```

## Glass Effect Implementation

The glass morphism is achieved through:

1. **BackdropFilter** - Creates the blur effect
2. **Semi-transparent background** - White with low opacity
3. **Border** - Subtle white border for definition
4. **Shadow** - Soft shadow for depth

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    ),
  ),
)
```

## Do's and Don'ts

### DO
✅ Use glass morphism for surfaces
✅ Apply neon gradients to buttons
✅ Use teal for positive actions
✅ Use red sparingly for danger
✅ Animate entrances with stagger
✅ Keep borders rounded (16px)
✅ Use Outfit font consistently

### DON'T
❌ Add drop shadows to buttons
❌ Use solid opaque backgrounds
❌ Mix different border radius values
❌ Use multiple accent colors
❌ Skip animation on new elements
❌ Use default Material design components directly
❌ Add emojis unless requested

## Security Design Principles

1. **Stealth Entry**: PIN entry must look identical for both real and panic PINs
2. **No Visual Feedback**: Don't show which PIN type was entered
3. **Instant Validation**: Validate automatically when 6 digits entered
4. **Error Handling**: Brief error message, auto-clear after 1 second
5. **Biometric Alternative**: Provide fingerprint option without forcing it

## Accessibility

- Minimum touch target: 44x44 pixels (keypad buttons are 80x80)
- Text contrast: AAA rating (white text on dark background)
- Icon size: Minimum 24px, recommended 28px
- Tap feedback: Material ripple effect on all interactive elements

---

**Remember**: Every pixel should serve the brand identity of "secure, premium, stealth banking."
