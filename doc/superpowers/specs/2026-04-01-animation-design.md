# Animation System Design

**Date:** 2026-04-01
**Status:** Approved
**Type:** User Feedback Animation System

---

## Overview

Add minimal Flutter-style animation system for user feedback in TUI widgets:
- Focus/unfocus color transitions
- Button press/release animations
- Checkbox/radio selection animations

**Duration:** 100-200ms (minimal, non-distracting)
**Type:** Color-only transitions (TUI constraint)

---

## Architecture

### New Files

```
lib/src/animation/
├── animation.dart              # Animation<T>, AnimationStatus
├── animation_controller.dart   # AnimationController
├── tween.dart                  # Tween<T>, ColorTween
├── curved_animation.dart       # CurvedAnimation
└── curves.dart                 # Curve, Curves
```

### Class Hierarchy

```
Animation<T> (abstract)
    └── AnimationController
            └── CurvedAnimation (wraps controller)

Tween<T> (abstract)
    └── ColorTween
```

---

## Component Details

### 1. Animation<T> (animation.dart)

Abstract base class for all animations.

```dart
abstract class Animation<T> {
  T get value;
  
  void addListener(VoidCallback listener);
  void removeListener(VoidCallback listener);
  
  void addStatusListener(AnimationStatusListener listener);
  void removeStatusListener(AnimationStatusListener listener);
  
  AnimationStatus get status;
  bool get isDismissed => status == AnimationStatus.dismissed;
  bool get isCompleted => status == AnimationStatus.completed;
}
```

### 2. AnimationStatus (animation.dart)

```dart
enum AnimationStatus {
  dismissed,  // At lowerBound, stopped
  forward,    // Animating toward upperBound
  reverse,    // Animating toward lowerBound
  completed,  // At upperBound, stopped
}
```

### 3. AnimationController (animation_controller.dart)

Manages animation timeline from 0.0 to 1.0.

**Constructor:**
```dart
class AnimationController extends Animation<double> {
  AnimationController({
    Duration duration = Duration.zero,
    double initialValue = 0.0,
    double lowerBound = 0.0,
    double upperBound = 1.0,
  });
}
```

**Note:** No `vsync` parameter - uses `SchedulerBinding.instance` directly.

**Methods:**
```dart
void forward({double? from});   // Animate from current → upperBound
void reverse({double? from});   // Animate from current → lowerBound
void stop();                    // Stop at current position
void reset();                   // Jump to lowerBound
void dispose();                 // Cleanup listeners, stop timer
```

**Internal Implementation:**
- Records `_startTime` on `forward()`/`reverse()`
- Calls `SchedulerBinding.instance.scheduleFrame()`
- On each frame, calculates elapsed time, updates `_value`
- Notifies listeners when value changes

### 4. Tween<T> (tween.dart)

Abstract interpolation class.

```dart
abstract class Tween<T> {
  final T begin;
  final T end;

  const Tween({required this.begin, required this.end});

  T lerp(double t);  // t: 0.0-1.0, returns interpolated value

  Animation<T> animate(Animation<double> parent) {
    return _TweenAnimation(parent, this);
  }
}
```

### 5. ColorTween (tween.dart)

```dart
class ColorTween extends Tween<Color> {
  const ColorTween({required Color begin, required Color end})
      : super(begin: begin, end: end);

  @override
  Color lerp(double t) {
    // TUI constraint: ANSI 16 colors are discrete
    // Snap to nearest color at 0.5 threshold
    return t < 0.5 ? begin : end;
  }
}
```

**TUI-Specific:** No smooth RGB interpolation - snap at midpoint.

### 6. CurvedAnimation (curved_animation.dart)

Applies curve transformation to parent animation.

```dart
class CurvedAnimation extends Animation<double> {
  final Animation<double> parent;
  final Curve curve;
  final Curve? reverseCurve;

  CurvedAnimation({
    required this.parent,
    required this.curve,
    this.reverseCurve,
  }) {
    parent.addListener(_notifyListeners);
    parent.addStatusListener(_notifyStatusListeners);
  }

  @override
  double get value => curve.transform(parent.value);

  void _notifyListeners() => _listeners.forEach((l) => l());
}
```

### 7. Curve (curves.dart)

```dart
abstract class Curve {
  double transform(double t);  // t: 0.0-1.0 → returns 0.0-1.0
}
```

**Implementations:**
```dart
class Curves {
  static const Curve linear = _Linear();      // t
  static const Curve easeIn = _EaseIn();      // t * t
  static const Curve easeOut = _EaseOut();    // t * (2 - t)
}
```

---

## Widget Integration

### Pattern (Manual - No Mixin)

Each widget manages its own `AnimationController` directly:

```dart
class ButtonState extends State<Button> with FocusableState {
  late AnimationController _controller;
  late Animation<Color> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
    );
    _colorAnim = ColorTween(
      begin: widget.backgroundColor,
      end: widget.focusColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.addListener(() => setState(() {}));
  }

  @override
  void onFocusChange(bool focused) {
    focused ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _colorAnim.value,
      child: Text(widget.label),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

**Why no mixin?** 3 widgets with similar patterns, but explicit management is clearer and easier to understand.

---

## Target Widgets

| Widget | Animation | Duration | Curve |
|--------|-----------|----------|-------|
| Button | focus/unfocus | 150ms | easeOut |
| Checkbox | checked/unchecked | 100ms | linear |
| Radio | selected/deselected | 100ms | linear |

---

## Flutter → RadarTUI Adaptations

| Flutter | RadarTUI | Reason |
|---------|----------|--------|
| `TickerProvider` mixin | Direct `SchedulerBinding` | Simpler, no ticker overhead |
| `vsync` parameter | Removed | Uses SchedulerBinding.instance |
| Complex curves (bounce, elastic) | Linear, easeIn, easeOut | TUI doesn't need physics |
| Smooth RGB color interpolation | Snap at 0.5 threshold | ANSI 16 colors are discrete |
| `super.key` in constructors | No `super.key` | Key system not implemented |

---

## Testing Strategy

### Unit Tests

**test/unit/animation/animation_test.dart:**
- `value` getter returns correct range
- `addListener`/`removeListener` work
- `status` changes correctly

**test/unit/animation/animation_controller_test.dart:**
- `forward()` animates 0.0 → 1.0
- `reverse()` animates 1.0 → 0.0
- `stop()` freezes at current position
- `reset()` jumps to 0.0
- `dispose()` cleans up resources
- Respects `duration` timing

**test/unit/animation/tween_test.dart:**
- `lerp(0.0)` returns `begin`
- `lerp(1.0)` returns `end`
- `animate()` wraps parent correctly

**test/unit/animation/curves_test.dart:**
- `linear.transform(t)` returns `t`
- `easeIn.transform(t)` returns `t * t`
- `easeOut.transform(t)` returns `t * (2 - t)`

### Widget Tests

**test/widgets/button_test.dart:**
- Focus triggers `forward()`
- Unfocus triggers `reverse()`
- `_colorAnim.value` changes on animation

**test/widgets/checkbox_test.dart:**
- Check triggers animation
- Uncheck triggers animation

**test/widgets/radio_test.dart:**
- Select triggers animation
- Deselect triggers animation

### Integration Tests

**test/integration/focus_animation_test.dart:**
- Focus traversal with animation timing
- Rapid focus changes (cancel/stop behavior)
- Animation completes before next focus change

---

## Implementation Notes

1. **SchedulerBinding Integration:**
   - AnimationController calls `SchedulerBinding.instance.scheduleFrame()`
   - Frame callback updates controller value based on elapsed time
   - No separate ticker/timer system needed

2. **Listener Management:**
   - Use `List<VoidCallback>` for listeners
   - `addListener` appends, `removeListener` removes first match
   - Copy list before iteration to avoid concurrent modification

3. **Color Interpolation:**
   - ColorTween snaps at `t < 0.5 ? begin : end`
   - Future enhancement: support multi-step color transitions (begin → mid → end)

4. **Performance:**
   - 100-200ms animations complete in 6-12 frames at 60fps
   - Terminal rendering is slower than GUI, animations won't be too fast

---

## Scope

**In Scope:**
- Animation<T>, AnimationController
- Tween<T>, ColorTween
- CurvedAnimation, Curves (3 curves)
- Button, Checkbox, Radio animations

**Out of Scope:**
- Complex curves (bounce, elastic, physics-based)
- Position/size animations
- Implicit animations (AnimatedContainer, etc.)
- AnimationBuilder widgets
- Mouse/touch event handling

---

## Future Enhancements

1. Add more curves if needed (easeInOut, etc.)
2. Multi-step ColorTween for smoother transitions
3. AnimationBuilder widget for declarative animations
4. Implicit animations (AnimatedOpacity, etc.)
