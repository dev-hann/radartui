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
    for (final listener
        in List<AnimationStatusListener>.from(_statusListeners)) {
      listener(status);
    }
  }
}
