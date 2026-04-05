import 'animation.dart';

/// An animation that applies a [Curve] to transform the value of a [parent] animation.
class CurvedAnimation extends Animation<double> {
  /// Creates a [CurvedAnimation].
  CurvedAnimation({
    required this.parent,
    required this.curve,
    this.reverseCurve,
  }) {
    parent.addListener(_notifyListeners);
    parent.addStatusListener(_notifyStatusListeners);
  }

  /// The parent animation whose value is being transformed.
  final Animation<double> parent;

  /// The curve used when the animation is running forward.
  final Curve curve;

  /// The curve used when the animation is running in reverse, defaults to [curve].
  final Curve? reverseCurve;

  final List<VoidCallback> _listeners = [];
  final List<AnimationStatusListener> _statusListeners = [];

  /// The current value, transformed by the appropriate curve.
  @override
  double get value {
    final Curve activeCurve =
        parent.status == AnimationStatus.reverse && reverseCurve != null
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
    for (final listener in List<AnimationStatusListener>.from(
      _statusListeners,
    )) {
      listener(status);
    }
  }
}
