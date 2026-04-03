import '../foundation/typedefs.dart';
export '../foundation/typedefs.dart' show VoidCallback;

export 'animation_controller.dart';
export 'curved_animation.dart';
export 'curves.dart';
export 'tween.dart';

typedef AnimationStatusListener = void Function(AnimationStatus status);

enum AnimationStatus { dismissed, forward, reverse, completed }

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
