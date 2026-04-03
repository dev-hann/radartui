import '../binding/scheduler_binding.dart';
import 'animation.dart';

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
  void removeListener(VoidCallback listener) =>
      _listeners.removeListener(listener);

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
