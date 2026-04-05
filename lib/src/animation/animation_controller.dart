import '../binding/scheduler_binding.dart';
import 'animation.dart';

/// A controller for an animation that drives a [double] value over a [duration].
class AnimationController extends Animation<double> {
  /// Creates an [AnimationController].
  AnimationController({
    this.duration = Duration.zero,
    double initialValue = 0.0,
    this.lowerBound = 0.0,
    this.upperBound = 1.0,
  }) : _value = initialValue;

  /// The length of time this animation should last.
  final Duration duration;

  /// The lowest value this animation can assume.
  final double lowerBound;

  /// The highest value this animation can assume.
  final double upperBound;

  double _value;
  AnimationStatus _status = AnimationStatus.dismissed;
  DateTime? _startTime;
  bool _hasPersistentCallback = false;

  final AnimationListeners<double> _listeners = AnimationListeners<double>();

  /// The current value of the animation, clamped to [lowerBound]–[upperBound].
  @override
  double get value => _value.clamp(lowerBound, upperBound);

  /// The current status of the animation.
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

  /// Starts the animation forward, optionally from the given [from] value.
  void forward({double? from}) {
    if (from != null) _value = from;
    _status = AnimationStatus.forward;
    _startTime = DateTime.now();
    _scheduleFrame();
    _listeners.notifyStatusListeners(_status);
  }

  /// Starts the animation in reverse, optionally from the given [from] value.
  void reverse({double? from}) {
    if (from != null) _value = from;
    _status = AnimationStatus.reverse;
    _startTime = DateTime.now();
    _scheduleFrame();
    _listeners.notifyStatusListeners(_status);
  }

  /// Stops the animation and updates the status based on the current value.
  void stop() {
    _status = _value <= lowerBound
        ? AnimationStatus.dismissed
        : _value >= upperBound
            ? AnimationStatus.completed
            : _status;
    _startTime = null;
    _listeners.notifyStatusListeners(_status);
  }

  /// Resets the animation value to [lowerBound] and status to dismissed.
  void reset() {
    _value = lowerBound;
    _status = AnimationStatus.dismissed;
    _startTime = null;
    _listeners.notifyListeners();
    _listeners.notifyStatusListeners(_status);
  }

  /// Cleans up resources used by this controller.
  void dispose() {
    stop();
    _removePersistentCallback();
    _startTime = null;
  }

  void _scheduleFrame() {
    if (!_hasPersistentCallback) {
      _hasPersistentCallback = true;
      SchedulerBinding.instance.addPersistentFrameCallback(_handleFrame);
    }
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
    _removePersistentCallback();
    _listeners.notifyListeners();
    _listeners.notifyStatusListeners(_status);
  }

  void _removePersistentCallback() {
    if (_hasPersistentCallback) {
      _hasPersistentCallback = false;
      SchedulerBinding.instance.removePersistentFrameCallback(_handleFrame);
    }
  }
}
