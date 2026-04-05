import '../foundation/typedefs.dart';
export '../foundation/typedefs.dart' show VoidCallback;

export 'animation_controller.dart';
export 'curved_animation.dart';
export 'curves.dart';
export 'tween.dart';

/// Signature for listeners that receive [AnimationStatus] changes.
typedef AnimationStatusListener = void Function(AnimationStatus status);

/// The status of an animation at a given point in time.
enum AnimationStatus {
  /// The animation is stopped at the beginning.
  dismissed,

  /// The animation is running from beginning to end.
  forward,

  /// The animation is running backwards, from end to beginning.
  reverse,

  /// The animation is stopped at the end.
  completed,
}

/// An animation with a value of type [T].
abstract class Animation<T> {
  /// The current value of the animation.
  T get value;

  /// The current status of the animation.
  AnimationStatus get status;

  /// Whether this animation is stopped at the beginning.
  bool get isDismissed => status == AnimationStatus.dismissed;

  /// Whether this animation is stopped at the end.
  bool get isCompleted => status == AnimationStatus.completed;

  /// Calls [listener] every time the animation value changes.
  void addListener(VoidCallback listener);

  /// Stops calling [listener] when the animation value changes.
  void removeListener(VoidCallback listener);

  /// Calls [listener] every time the animation status changes.
  void addStatusListener(AnimationStatusListener listener);

  /// Stops calling [listener] when the animation status changes.
  void removeStatusListener(AnimationStatusListener listener);
}

/// Manages lists of animation listeners and status listeners.
class AnimationListeners<T> {
  final List<VoidCallback> _listeners = [];
  final List<AnimationStatusListener> _statusListeners = [];

  /// Registers a [listener] for value changes.
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Unregisters a [listener] for value changes.
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Registers a [listener] for status changes.
  void addStatusListener(AnimationStatusListener listener) {
    _statusListeners.add(listener);
  }

  /// Unregisters a [listener] for status changes.
  void removeStatusListener(AnimationStatusListener listener) {
    _statusListeners.remove(listener);
  }

  /// Notifies all registered value listeners.
  void notifyListeners() {
    final listeners = List<VoidCallback>.from(_listeners);
    for (final listener in listeners) {
      listener();
    }
  }

  /// Notifies all registered status listeners with the given [status].
  void notifyStatusListeners(AnimationStatus status) {
    final listeners = List<AnimationStatusListener>.from(_statusListeners);
    for (final listener in listeners) {
      listener(status);
    }
  }
}
