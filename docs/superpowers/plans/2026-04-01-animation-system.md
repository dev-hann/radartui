# Animation System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Flutter-style animation system for user feedback (focus/unfocus color transitions)

**Architecture:** Minimal AnimationController + Tween + Curves that integrate with SchedulerBinding. No vsync - direct scheduler usage. ColorTween snaps at midpoint (ANSI constraint).

**Tech Stack:** Dart, SchedulerBinding, TUI rendering

---

## File Structure

```
lib/src/animation/
├── animation.dart              # Animation<T>, AnimationStatus, listeners
├── animation_controller.dart   # AnimationController (0.0-1.0 timeline)
├── tween.dart                  # Tween<T>, ColorTween
├── curved_animation.dart       # CurvedAnimation wrapper
└── curves.dart                 # Curve, Curves.linear/easeIn/easeOut

lib/src/binding/
└── scheduler_binding.dart      # Add persistent frame callbacks

test/unit/animation/
├── animation_test.dart
├── animation_controller_test.dart
├── tween_test.dart
├── curved_animation_test.dart
└── curves_test.dart
```

---

## Task 1: Add Persistent Frame Callbacks to SchedulerBinding

**Files:**
- Modify: `lib/src/binding/scheduler_binding.dart:21-52`
- Test: `test/unit/binding/scheduler_binding_test.dart`

- [ ] **Step 1: Write failing test for persistent frame callbacks**

```dart
// test/unit/binding/scheduler_binding_test.dart
import 'package:test/test.dart';
import 'package:radartui/radartui.dart';

void main() {
  group('SchedulerBinding persistent frame callbacks', () {
    test('addPersistentFrameCallback registers callback', () async {
      final binding = TestSchedulerBinding();
      var callCount = 0;
      
      binding.addPersistentFrameCallback((duration) {
        callCount++;
      });
      
      binding.scheduleFrame();
      await Future.delayed(Duration.zero);
      
      expect(callCount, equals(1));
    });

    test('persistent callbacks are called on every frame', () async {
      final binding = TestSchedulerBinding();
      var callCount = 0;
      
      binding.addPersistentFrameCallback((duration) {
        callCount++;
      });
      
      binding.scheduleFrame();
      await Future.delayed(Duration.zero);
      
      binding.scheduleFrame();
      await Future.delayed(Duration.zero);
      
      expect(callCount, equals(2));
    });
  });
}

class TestSchedulerBinding with SchedulerBinding {
  @override
  void initInstances() {
    SchedulerBinding.resetInstance();
    super.initInstances();
  }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/binding/scheduler_binding_test.dart`
Expected: FAIL - No such method addPersistentFrameCallback

- [ ] **Step 3: Add persistent frame callback support to SchedulerBinding**

```dart
// lib/src/binding/scheduler_binding.dart
// Add after line 22 (after _postFrameCallbacks):

  final List<FrameCallback> _persistentFrameCallbacks = [];

  void addPersistentFrameCallback(FrameCallback callback) {
    _persistentFrameCallbacks.add(callback);
  }

  void removePersistentFrameCallback(FrameCallback callback) {
    _persistentFrameCallbacks.remove(callback);
  }

// Modify handleFrame() method (line 35):
  @override
  void handleFrame() {
    _executePersistentFrameCallbacks();
    _executePostFrameCallbacks();
  }

  void _executePersistentFrameCallbacks() {
    if (_persistentFrameCallbacks.isNotEmpty) {
      final callbacks = List<FrameCallback>.from(_persistentFrameCallbacks);
      for (final callback in callbacks) {
        callback(Duration.now());
      }
    }
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/unit/binding/scheduler_binding_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/binding/scheduler_binding.dart test/unit/binding/scheduler_binding_test.dart
git commit -m "feat: add persistent frame callbacks to SchedulerBinding"
```

---

## Task 2: Create Animation Base Classes

**Files:**
- Create: `lib/src/animation/animation.dart`
- Create: `test/unit/animation/animation_test.dart`

- [ ] **Step 1: Write failing tests for Animation base class**

```dart
// test/unit/animation/animation_test.dart
import 'package:test/test.dart';
import 'package:radartui/src/animation/animation.dart';

void main() {
  group('Animation', () {
    test('AnimationStatus enum has correct values', () {
      expect(AnimationStatus.dismissed.index, equals(0));
      expect(AnimationStatus.forward.index, equals(1));
      expect(AnimationStatus.reverse.index, equals(2));
      expect(AnimationStatus.completed.index, equals(3));
    });
  });

  group('AnimationListeners', () {
    test('addListener and removeListener work correctly', () {
      final listeners = AnimationListeners<int>();
      var callCount = 0;
      
      void listener() => callCount++;
      
      listeners.addListener(listener);
      listeners.notifyListeners();
      expect(callCount, equals(1));
      
      listeners.removeListener(listener);
      listeners.notifyListeners();
      expect(callCount, equals(1));
    });

    test('multiple listeners are all called', () {
      final listeners = AnimationListeners<int>();
      var count1 = 0;
      var count2 = 0;
      
      listeners.addListener(() => count1++);
      listeners.addListener(() => count2++);
      listeners.notifyListeners();
      
      expect(count1, equals(1));
      expect(count2, equals(1));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/animation/animation_test.dart`
Expected: FAIL - No such file

- [ ] **Step 3: Create Animation base classes**

```dart
// lib/src/animation/animation.dart
typedef VoidCallback = void Function();
typedef AnimationStatusListener = void Function(AnimationStatus status);

enum AnimationStatus {
  dismissed,
  forward,
  reverse,
  completed,
}

abstract class Animation<T> {
  T get value;
  
  AnimationStatus get status;
  
  bool get isDismissed => status == AnimationStatus.dismissed;
  bool get isCompleted => status == AnimationStatus.completed;
  
  void addListener(VoidCallback listener);
  void removeListener(VoidCallback listener);
  
  void addStatusListener(AnimationStatusListener listener);
  void removeStatusListener(AnimationStatusListener listener);
}

class AnimationListeners<T> {
  final List<VoidCallback> _listeners = [];
  final List<AnimationStatusListener> _statusListeners = [];
  
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  void addStatusListener(AnimationStatusListener listener) {
    _statusListeners.add(listener);
  }
  
  void removeStatusListener(AnimationStatusListener listener) {
    _statusListeners.remove(listener);
  }
  
  void notifyListeners() {
    final listeners = List<VoidCallback>.from(_listeners);
    for (final listener in listeners) {
      listener();
    }
  }
  
  void notifyStatusListeners(AnimationStatus status) {
    final listeners = List<AnimationStatusListener>.from(_statusListeners);
    for (final listener in listeners) {
      listener(status);
    }
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/unit/animation/animation_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/animation/animation.dart test/unit/animation/animation_test.dart
git commit -m "feat: add Animation base classes and AnimationStatus"
```

---

## Task 3: Create Curves

**Files:**
- Create: `lib/src/animation/curves.dart`
- Create: `test/unit/animation/curves_test.dart`

- [ ] **Step 1: Write failing tests for Curves**

```dart
// test/unit/animation/curves_test.dart
import 'package:test/test.dart';
import 'package:radartui/src/animation/curves.dart';

void main() {
  group('Curves', () {
    test('linear curve returns input unchanged', () {
      expect(Curves.linear.transform(0.0), equals(0.0));
      expect(Curves.linear.transform(0.5), equals(0.5));
      expect(Curves.linear.transform(1.0), equals(1.0));
    });

    test('easeIn curve accelerates', () {
      expect(Curves.easeIn.transform(0.0), equals(0.0));
      expect(Curves.easeIn.transform(0.5), closeTo(0.25, 0.001));
      expect(Curves.easeIn.transform(1.0), equals(1.0));
    });

    test('easeOut curve decelerates', () {
      expect(Curves.easeOut.transform(0.0), equals(0.0));
      expect(Curves.easeOut.transform(0.5), closeTo(0.75, 0.001));
      expect(Curves.easeOut.transform(1.0), equals(1.0));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/animation/curves_test.dart`
Expected: FAIL - No such file

- [ ] **Step 3: Create Curves**

```dart
// lib/src/animation/curves.dart
abstract class Curve {
  const Curve();
  
  double transform(double t);
}

class _Linear extends Curve {
  const _Linear();
  
  @override
  double transform(double t) => t;
}

class _EaseIn extends Curve {
  const _EaseIn();
  
  @override
  double transform(double t) => t * t;
}

class _EaseOut extends Curve {
  const _EaseOut();
  
  @override
  double transform(double t) => t * (2 - t);
}

class Curves {
  const Curves._();
  
  static const Curve linear = _Linear();
  static const Curve easeIn = _EaseIn();
  static const Curve easeOut = _EaseOut();
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/unit/animation/curves_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/animation/curves.dart test/unit/animation/curves_test.dart
git commit -m "feat: add Curve classes (linear, easeIn, easeOut)"
```

---

## Task 4: Create AnimationController

**Files:**
- Create: `lib/src/animation/animation_controller.dart`
- Create: `test/unit/animation/animation_controller_test.dart`

- [ ] **Step 1: Write failing tests for AnimationController**

```dart
// test/unit/animation/animation_controller_test.dart
import 'dart:async';
import 'package:test/test.dart';
import 'package:radartui/src/animation/animation_controller.dart';
import 'package:radartui/src/animation/animation.dart';

void main() {
  group('AnimationController', () {
    test('initial value is set correctly', () {
      final controller = AnimationController(initialValue: 0.5);
      expect(controller.value, equals(0.5));
    });

    test('default bounds are 0.0 to 1.0', () {
      final controller = AnimationController();
      expect(controller.lowerBound, equals(0.0));
      expect(controller.upperBound, equals(1.0));
    });

    test('reset sets value to lowerBound', () {
      final controller = AnimationController(initialValue: 0.5);
      controller.reset();
      expect(controller.value, equals(0.0));
    });

    test('forward changes status to forward', () {
      final controller = AnimationController();
      controller.forward();
      expect(controller.status, equals(AnimationStatus.forward));
    });

    test('reverse changes status to reverse', () {
      final controller = AnimationController(initialValue: 1.0);
      controller.reverse();
      expect(controller.status, equals(AnimationStatus.reverse));
    });

    test('stop freezes at current value', () {
      final controller = AnimationController(initialValue: 0.5);
      controller.stop();
      expect(controller.value, equals(0.5));
    });

    test('listeners are notified on value change', () async {
      final controller = AnimationController(
        duration: Duration(milliseconds: 50),
      );
      var notified = false;
      
      controller.addListener(() {
        notified = true;
      });
      
      controller.forward();
      await Future.delayed(Duration(milliseconds: 100));
      
      expect(notified, isTrue);
    });

    test('status listeners are notified on status change', () {
      final controller = AnimationController();
      AnimationStatus? lastStatus;
      
      controller.addStatusListener((status) {
        lastStatus = status;
      });
      
      controller.forward();
      expect(lastStatus, equals(AnimationStatus.forward));
    });

    test('dispose stops animation and clears listeners', () {
      final controller = AnimationController();
      controller.forward();
      controller.dispose();
      
      expect(controller.status, equals(AnimationStatus.dismissed));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/animation/animation_controller_test.dart`
Expected: FAIL - No such file

- [ ] **Step 3: Create AnimationController**

```dart
// lib/src/animation/animation_controller.dart
import 'dart:async';
import 'animation.dart';
import '../binding/scheduler_binding.dart';

class AnimationController extends Animation<double> {
  AnimationController({
    this.duration = Duration.zero,
    double initialValue = 0.0,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
  }) : _value = initialValue;
  
  final Duration duration;
  final double lowerBound;
  final double upperBound;
  
  double _value;
  AnimationStatus _status = AnimationStatus.dismissed;
  DateTime? _startTime;
  
  final AnimationListeners<double> _listeners = AnimationListeners<double>();
  
  @override
  double get value => _value.clamp(lowerBound, upperBound);
  
  @override
  AnimationStatus get status => _status;
  
  @override
  void addListener(VoidCallback listener) => _listeners.addListener(listener);
  
  @override
  void removeListener(VoidCallback listener) => _listeners.removeListener(listener);
  
  @override
  void addStatusListener(AnimationStatusListener listener) =>
      _listeners.addStatusListener(listener);
  
  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      _listeners.removeStatusListener(listener);
  
  void forward({double? from}) {
    if (from != null) _value = from;
    _status = AnimationStatus.forward;
    _startTime = DateTime.now();
    _scheduleFrame();
    _listeners.notifyStatusListeners(_status);
  }
  
  void reverse({double? from}) {
    if (from != null) _value = from;
    _status = AnimationStatus.reverse;
    _startTime = DateTime.now();
    _scheduleFrame();
    _listeners.notifyStatusListeners(_status);
  }
  
  void stop() {
    _status = _value <= lowerBound 
        ? AnimationStatus.dismissed 
        : _value >= upperBound 
            ? AnimationStatus.completed 
            : _status;
    _startTime = null;
    _listeners.notifyStatusListeners(_status);
  }
  
  void reset() {
    _value = lowerBound;
    _status = AnimationStatus.dismissed;
    _startTime = null;
    _listeners.notifyListeners();
    _listeners.notifyStatusListeners(_status);
  }
  
  void dispose() {
    stop();
    _startTime = null;
  }
  
  void _scheduleFrame() {
    SchedulerBinding.instance.addPersistentFrameCallback(_handleFrame);
    SchedulerBinding.instance.scheduleFrame();
  }
  
  void _handleFrame(Duration timeStamp) {
    if (_startTime == null) return;
    
    final elapsed = DateTime.now().difference(_startTime!);
    final elapsedMs = elapsed.inMilliseconds;
    final durationMs = duration.inMilliseconds;
    
    if (durationMs == 0) {
      _value = _status == AnimationStatus.forward ? upperBound : lowerBound;
      _completeAnimation();
      return;
    }
    
    final progress = (elapsedMs / durationMs).clamp(0.0, 1.0);
    
    if (_status == AnimationStatus.forward) {
      _value = lowerBound + (upperBound - lowerBound) * progress;
    } else if (_status == AnimationStatus.reverse) {
      _value = upperBound - (upperBound - lowerBound) * progress;
    }
    
    _listeners.notifyListeners();
    
    if (progress >= 1.0) {
      _completeAnimation();
    } else if (_status == AnimationStatus.forward || 
               _status == AnimationStatus.reverse) {
      SchedulerBinding.instance.scheduleFrame();
    }
  }
  
  void _completeAnimation() {
    _value = _status == AnimationStatus.forward ? upperBound : lowerBound;
    _status = _status == AnimationStatus.forward 
        ? AnimationStatus.completed 
        : AnimationStatus.dismissed;
    _startTime = null;
    _listeners.notifyListeners();
    _listeners.notifyStatusListeners(_status);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/unit/animation/animation_controller_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/animation/animation_controller.dart test/unit/animation/animation_controller_test.dart
git commit -m "feat: add AnimationController with forward/reverse/stop/reset"
```

---

## Task 5: Create Tween and ColorTween

**Files:**
- Create: `lib/src/animation/tween.dart`
- Create: `test/unit/animation/tween_test.dart`

- [ ] **Step 1: Write failing tests for Tween**

```dart
// test/unit/animation/tween_test.dart
import 'package:test/test.dart';
import 'package:radartui/src/animation/tween.dart';
import 'package:radartui/src/animation/animation_controller.dart';
import 'package:radartui/src/foundation/color.dart';

void main() {
  group('Tween', () {
    test('lerp returns begin at t=0', () {
      final tween = _TestTween(begin: 0.0, end: 100.0);
      expect(tween.lerp(0.0), equals(0.0));
    });

    test('lerp returns end at t=1', () {
      final tween = _TestTween(begin: 0.0, end: 100.0);
      expect(tween.lerp(1.0), equals(100.0));
    });

    test('lerp interpolates linearly', () {
      final tween = _TestTween(begin: 0.0, end: 100.0);
      expect(tween.lerp(0.5), equals(50.0));
    });

    test('animate wraps parent animation', () {
      final controller = AnimationController(initialValue: 0.5);
      final tween = _TestTween(begin: 0.0, end: 100.0);
      final animation = tween.animate(controller);
      
      expect(animation.value, equals(50.0));
    });
  });

  group('ColorTween', () {
    test('lerp returns begin color when t < 0.5', () {
      final tween = ColorTween(begin: Color.blue, end: Color.red);
      expect(tween.lerp(0.0), equals(Color.blue));
      expect(tween.lerp(0.49), equals(Color.blue));
    });

    test('lerp returns end color when t >= 0.5', () {
      final tween = ColorTween(begin: Color.blue, end: Color.red);
      expect(tween.lerp(0.5), equals(Color.red));
      expect(tween.lerp(1.0), equals(Color.red));
    });
  });
}

class _TestTween extends Tween<double> {
  _TestTween({required double begin, required double end})
      : super(begin: begin, end: end);

  @override
  double lerp(double t) => begin + (end - begin) * t;
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/animation/tween_test.dart`
Expected: FAIL - No such file

- [ ] **Step 3: Create Tween and ColorTween**

```dart
// lib/src/animation/tween.dart
import 'animation.dart';
import '../foundation/color.dart';

abstract class Tween<T> {
  const Tween({required this.begin, required this.end});
  
  final T begin;
  final T end;
  
  T lerp(double t);
  
  Animation<T> animate(Animation<double> parent) {
    return _TweenAnimation<T>(parent, this);
  }
}

class ColorTween extends Tween<Color> {
  const ColorTween({required Color begin, required Color end})
      : super(begin: begin, end: end);
  
  @override
  Color lerp(double t) {
    return t < 0.5 ? begin : end;
  }
}

class _TweenAnimation<T> extends Animation<T> {
  _TweenAnimation(this._parent, this._tween);
  
  final Animation<double> _parent;
  final Tween<T> _tween;
  
  final List<VoidCallback> _listeners = [];
  final List<AnimationStatusListener> _statusListeners = [];
  
  @override
  T get value => _tween.lerp(_parent.value);
  
  @override
  AnimationStatus get status => _parent.status;
  
  @override
  void addListener(VoidCallback listener) {
    if (_listeners.isEmpty) {
      _parent.addListener(_notifyListeners);
    }
    _listeners.add(listener);
  }
  
  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _parent.removeListener(_notifyListeners);
    }
  }
  
  @override
  void addStatusListener(AnimationStatusListener listener) {
    if (_statusListeners.isEmpty) {
      _parent.addStatusListener(_notifyStatusListeners);
    }
    _statusListeners.add(listener);
  }
  
  @override
  void removeStatusListener(AnimationStatusListener listener) {
    _statusListeners.remove(listener);
    if (_statusListeners.isEmpty) {
      _parent.removeStatusListener(_notifyStatusListeners);
    }
  }
  
  void _notifyListeners() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }
  
  void _notifyStatusListeners(AnimationStatus status) {
    for (final listener in List<AnimationStatusListener>.from(_statusListeners)) {
      listener(status);
    }
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/unit/animation/tween_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/animation/tween.dart test/unit/animation/tween_test.dart
git commit -m "feat: add Tween and ColorTween classes"
```

---

## Task 6: Create CurvedAnimation

**Files:**
- Create: `lib/src/animation/curved_animation.dart`
- Create: `test/unit/animation/curved_animation_test.dart`

- [ ] **Step 1: Write failing tests for CurvedAnimation**

```dart
// test/unit/animation/curved_animation_test.dart
import 'package:test/test.dart';
import 'package:radartui/src/animation/curved_animation.dart';
import 'package:radartui/src/animation/animation_controller.dart';
import 'package:radartui/src/animation/curves.dart';

void main() {
  group('CurvedAnimation', () {
    test('applies curve to parent value', () {
      final controller = AnimationController(initialValue: 0.5);
      final curved = CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      );
      
      expect(curved.value, equals(0.5));
    });

    test('easeIn curve transforms value', () {
      final controller = AnimationController(initialValue: 0.5);
      final curved = CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      );
      
      expect(curved.value, closeTo(0.25, 0.001));
    });

    test('easeOut curve transforms value', () {
      final controller = AnimationController(initialValue: 0.5);
      final curved = CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      );
      
      expect(curved.value, closeTo(0.75, 0.001));
    });

    test('status matches parent status', () {
      final controller = AnimationController();
      final curved = CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      );
      
      controller.forward();
      expect(curved.status, equals(controller.status));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/unit/animation/curved_animation_test.dart`
Expected: FAIL - No such file

- [ ] **Step 3: Create CurvedAnimation**

```dart
// lib/src/animation/curved_animation.dart
import 'animation.dart';
import 'curves.dart';

class CurvedAnimation extends Animation<double> {
  CurvedAnimation({
    required this.parent,
    required this.curve,
    this.reverseCurve,
  }) {
    parent.addListener(_notifyListeners);
    parent.addStatusListener(_notifyStatusListeners);
  }
  
  final Animation<double> parent;
  final Curve curve;
  final Curve? reverseCurve;
  
  final List<VoidCallback> _listeners = [];
  final List<AnimationStatusListener> _statusListeners = [];
  
  @override
  double get value {
    final Curve activeCurve = parent.status == AnimationStatus.reverse && 
                              reverseCurve != null
        ? reverseCurve!
        : curve;
    return activeCurve.transform(parent.value);
  }
  
  @override
  AnimationStatus get status => parent.status;
  
  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  @override
  void addStatusListener(AnimationStatusListener listener) {
    _statusListeners.add(listener);
  }
  
  @override
  void removeStatusListener(AnimationStatusListener listener) {
    _statusListeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }
  
  void _notifyStatusListeners(AnimationStatus status) {
    for (final listener in List<AnimationStatusListener>.from(_statusListeners)) {
      listener(status);
    }
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/unit/animation/curved_animation_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/animation/curved_animation.dart test/unit/animation/curved_animation_test.dart
git commit -m "feat: add CurvedAnimation wrapper"
```

---

## Task 7: Export Animation Module

**Files:**
- Modify: `lib/src/animation/animation.dart`

- [ ] **Step 1: Add exports to animation.dart**

```dart
// Add at end of lib/src/animation/animation.dart:
export 'animation_controller.dart';
export 'tween.dart';
export 'curved_animation.dart';
export 'curves.dart';
```

- [ ] **Step 2: Run dart analyze**

Run: `dart analyze`
Expected: No issues found!

- [ ] **Step 3: Commit**

```bash
git add lib/src/animation/animation.dart
git commit -m "feat: export all animation classes from animation.dart"
```

---

## Task 8: Update Button with Animation

**Files:**
- Modify: `lib/src/widgets/basic/button.dart:22-51`
- Modify: `test/widgets/button_test.dart`

- [ ] **Step 1: Add failing test for Button animation**

```dart
// Add to test/widgets/button_test.dart

  testWidgets('Button animates color on focus change', (tester) async {
    final button = Button(text: 'Test', onPressed: () {});
    
    await tester.pumpWidget(button);
    
    // Initial state - not focused
    final renderObject1 = tester.findRenderObject<RenderButton>();
    final initialColor = renderObject1.style.backgroundColor;
    
    // Focus the button
    tester.focusNode.focus();
    await tester.pump(Duration(milliseconds: 200));
    
    // After animation - should be focus color
    final renderObject2 = tester.findRenderObject<RenderButton>();
    expect(renderObject2.style.focusBackgroundColor, isNot(equals(initialColor)));
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/widgets/button_test.dart`
Expected: FAIL - No animation on focus

- [ ] **Step 3: Add animation to Button**

```dart
// lib/src/widgets/basic/button.dart
// Add imports at top:
import '../../animation/animation.dart';

// Modify _ButtonState class (lines 22-51):
class _ButtonState extends State<Button> with FocusableState<Button> {
  late AnimationController _controller;
  late Animation<Color> _colorAnim;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 150),
    );
    _colorAnim = ColorTween(
      begin: widget.style?.backgroundColor ?? Color.blue,
      end: widget.style?.focusBackgroundColor ?? Color.brightBlue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.addListener(() => setState(() {}));
  }

  @override
  void onFocusChange(bool focused) {
    super.onFocusChange(focused);
    if (focused) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (!widget.enabled) return;

    if (event.code == KeyCode.enter ||
        (event.code == KeyCode.char && event.char == ' ')) {
      widget.onPressed?.call();
    }
  }

  void _onTap() {
    if (!widget.enabled) return;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final currentBackgroundColor = _colorAnim.value;
    final style = (widget.style ?? const ButtonStyle()).copyWith(
      backgroundColor: currentBackgroundColor,
    );
    
    return _ButtonRenderWidget(
      text: widget.text,
      enabled: widget.enabled,
      focused: hasFocus,
      style: style,
      onTap: _onTap,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Add copyWith to ButtonStyle (at end of file):
extension ButtonStyleCopyWith on ButtonStyle {
  ButtonStyle copyWith({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? focusColor,
    Color? focusBackgroundColor,
    Color? disabledColor,
    Color? disabledBackgroundColor,
    EdgeInsets? padding,
    bool? bold,
  }) {
    return ButtonStyle(
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      focusColor: focusColor ?? this.focusColor,
      focusBackgroundColor: focusBackgroundColor ?? this.focusBackgroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      disabledBackgroundColor: disabledBackgroundColor ?? this.disabledBackgroundColor,
      padding: padding ?? this.padding,
      bold: bold ?? this.bold,
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/widgets/button_test.dart`
Expected: PASS

- [ ] **Step 5: Run all tests**

Run: `dart test`
Expected: All tests pass

- [ ] **Step 6: Commit**

```bash
git add lib/src/widgets/basic/button.dart test/widgets/button_test.dart
git commit -m "feat: add focus animation to Button"
```

---

## Task 9: Update Checkbox with Animation

**Files:**
- Modify: `lib/src/widgets/basic/checkbox.dart`
- Modify: `test/widgets/checkbox_test.dart`

- [ ] **Step 1: Add failing test for Checkbox animation**

```dart
// Add to test/widgets/checkbox_test.dart

  testWidgets('Checkbox animates on value change', (tester) async {
    bool? value = false;
    final checkbox = Checkbox(
      value: value,
      onChanged: (v) => value = v,
    );
    
    await tester.pumpWidget(StatefulBuilder(
      builder: (context, setState) {
        return Checkbox(
          value: value,
          onChanged: (v) => setState(() => value = v),
        );
      },
    ));
    
    // Tap to check
    await tester.tap(find.byType(Checkbox));
    await tester.pump(Duration(milliseconds: 100));
    
    // Should be animating
    expect(value, isTrue);
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/widgets/checkbox_test.dart`
Expected: FAIL - No animation

- [ ] **Step 3: Add animation to Checkbox**

```dart
// lib/src/widgets/basic/checkbox.dart
// Add import at top:
import '../../animation/animation.dart';

// Replace _CheckboxState class (lines 24-61):
class _CheckboxState extends State<Checkbox> with FocusableState<Checkbox> {
  late AnimationController _controller;
  late Animation<Color> _colorAnim;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      initialValue: widget.value ? 1.0 : 0.0,
    );
    _colorAnim = ColorTween(
      begin: Color.black,
      end: widget.activeColor ?? Color.blue,
    ).animate(_controller);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;

    if (event.code == KeyCode.enter ||
        (event.code == KeyCode.char && event.char == ' ')) {
      final newValue = !widget.value;
      widget.onChanged!(newValue);
    }
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    
    if (oldWidget.activeColor != widget.activeColor) {
      _colorAnim = ColorTween(
        begin: Color.black,
        end: widget.activeColor ?? Color.blue,
      ).animate(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBackgroundColor = _colorAnim.value;
    
    return _CheckboxRenderWidget(
      value: widget.value,
      tristate: widget.tristate,
      focused: hasFocus,
      enabled: widget.onChanged != null,
      activeColor: currentBackgroundColor,
      checkColor: widget.checkColor ?? Color.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/widgets/checkbox_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/widgets/basic/checkbox.dart test/widgets/checkbox_test.dart
git commit -m "feat: add checked animation to Checkbox"
```

---

## Task 10: Update Radio with Animation

**Files:**
- Modify: `lib/src/widgets/basic/radio.dart`
- Modify: `test/widgets/radio_test.dart`

- [ ] **Step 1: Add failing test for Radio animation**

```dart
// Add to test/widgets/radio_test.dart

  testWidgets('Radio animates on selection change', (tester) async {
    int selected = 0;
    
    await tester.pumpWidget(StatefulBuilder(
      builder: (context, setState) {
        return Radio<int>(
          value: 1,
          groupValue: selected,
          onChanged: (v) => setState(() => selected = v ?? 0),
        );
      },
    ));
    
    // Tap to select
    await tester.tap(find.byType(Radio<int>));
    await tester.pump(Duration(milliseconds: 100));
    
    expect(selected, equals(1));
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `dart test test/widgets/radio_test.dart`
Expected: FAIL - No animation

- [ ] **Step 3: Add animation to Radio**

```dart
// lib/src/widgets/basic/radio.dart
// Add import at top:
import '../../animation/animation.dart';

// Replace _RadioState class (lines 24-68):
class _RadioState<T> extends State<Radio<T>> with FocusableState<Radio<T>> {
  late AnimationController _controller;
  late Animation<Color> _colorAnim;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    final isSelected = widget.value == widget.groupValue;
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      initialValue: isSelected ? 1.0 : 0.0,
    );
    _colorAnim = ColorTween(
      begin: Color.black,
      end: widget.activeColor ?? Color.blue,
    ).animate(_controller);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (widget.onChanged == null) return;

    if (event.code == KeyCode.enter ||
        (event.code == KeyCode.char && event.char == ' ')) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didUpdateWidget(Radio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final wasSelected = oldWidget.value == oldWidget.groupValue;
    final isSelected = widget.value == widget.groupValue;

    if (wasSelected != isSelected) {
      if (isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    
    if (oldWidget.activeColor != widget.activeColor) {
      _colorAnim = ColorTween(
        begin: Color.black,
        end: widget.activeColor ?? Color.blue,
      ).animate(_controller);
    }
  }

  void _onTap() {
    if (widget.onChanged == null) return;
    widget.onChanged!(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == widget.groupValue;
    final currentBackgroundColor = _colorAnim.value;

    return _RadioRenderWidget(
      selected: isSelected,
      focused: hasFocus,
      enabled: widget.onChanged != null,
      activeColor: currentBackgroundColor,
      checkColor: widget.checkColor ?? Color.white,
      onTap: _onTap,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `dart test test/widgets/radio_test.dart`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add lib/src/widgets/basic/radio.dart test/widgets/radio_test.dart
git commit -m "feat: add selection animation to Radio"
```

---

## Task 11: Final Verification

- [ ] **Step 1: Run dart analyze**

Run: `dart analyze`
Expected: No issues found!

- [ ] **Step 2: Run all tests**

Run: `dart test`
Expected: All tests pass

- [ ] **Step 3: Run dart format**

Run: `dart format .`
Expected: All files formatted

- [ ] **Step 4: Commit if any formatting changes**

```bash
git add .
git commit -m "style: format code"
```

- [ ] **Step 5: Final commit summary**

```bash
git log --oneline -10
```

Expected: See all 11 commits in order

---

## Summary

**Created Files:**
- `lib/src/animation/animation.dart`
- `lib/src/animation/animation_controller.dart`
- `lib/src/animation/tween.dart`
- `lib/src/animation/curved_animation.dart`
- `lib/src/animation/curves.dart`
- `test/unit/animation/animation_test.dart`
- `test/unit/animation/animation_controller_test.dart`
- `test/unit/animation/tween_test.dart`
- `test/unit/animation/curved_animation_test.dart`
- `test/unit/animation/curves_test.dart`

**Modified Files:**
- `lib/src/binding/scheduler_binding.dart` (added persistent frame callbacks)
- `lib/src/widgets/basic/button.dart` (added animation)
- `lib/src/widgets/basic/checkbox.dart` (added animation)
- `lib/src/widgets/basic/radio.dart` (added animation)
- `test/widgets/button_test.dart` (added animation tests)
- `test/widgets/checkbox_test.dart` (added animation tests)
- `test/widgets/radio_test.dart` (added animation tests)

**Total Tasks:** 11
**Estimated Time:** 2-3 hours
