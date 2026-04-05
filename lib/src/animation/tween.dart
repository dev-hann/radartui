import '../foundation/color.dart';
import 'animation.dart';

/// Interpolates between a [begin] and [end] value of type [T].
abstract class Tween<T> {
  /// Creates a [Tween] with the given [begin] and [end] values.
  const Tween({required this.begin, required this.end});

  /// The value at the start of the interpolation (t = 0.0).
  final T begin;

  /// The value at the end of the interpolation (t = 1.0).
  final T end;

  /// Returns the interpolated value at the given fraction [t] (0.0–1.0).
  T lerp(double t);

  /// Creates an [Animation] driven by [parent] that applies this tween.
  Animation<T> animate(Animation<double> parent) {
    return _TweenAnimation<T>(parent, this);
  }
}

/// A [Tween] that interpolates between two [Color] values.
class ColorTween extends Tween<Color> {
  /// Creates a [ColorTween].
  const ColorTween({required super.begin, required super.end});

  @override
  Color lerp(double t) {
    final int beginValue = begin.value;
    final int endValue = end.value;

    if (beginValue == endValue) return begin;

    final int startIdx = beginValue % 16;
    final int endIdx = endValue % 16;

    if (startIdx == endIdx) return begin;

    return t < 0.5 ? begin : end;
  }

  /// Returns the nearest ANSI 16-color for the given fraction [t] (0.0–1.0).
  static Color nearColorTo(double t) {
    final int idx = (t * 15).round().clamp(0, 15);
    return Color(idx);
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
    for (final listener in List<AnimationStatusListener>.from(
      _statusListeners,
    )) {
      listener(status);
    }
  }
}
