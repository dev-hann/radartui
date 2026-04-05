import 'dart:async';
import 'binding_base.dart';

/// Signature for frame-related callbacks.
typedef FrameCallback = void Function(Duration timeStamp);

/// Binding that schedules and dispatches frames via microtasks.
mixin SchedulerBinding on BindingBase {
  static SchedulerBinding? _instance;

  /// The singleton instance of this binding.
  static SchedulerBinding get instance => BindingBase.checkInstance(_instance);

  /// Resets the singleton instance, useful for testing.
  static void resetInstance() {
    _instance = null;
  }

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  bool _frameScheduled = false;
  bool _needsReschedule = false;
  final List<FrameCallback> _postFrameCallbacks = [];
  final List<FrameCallback> _persistentFrameCallbacks = [];

  /// Schedules a frame to be processed as a microtask.
  void scheduleFrame() {
    if (_frameScheduled) {
      _needsReschedule = true;
      return;
    }
    _frameScheduled = true;
    scheduleMicrotask(_handleFrame);
  }

  void _handleFrame() {
    handleFrame();
    _frameScheduled = false;
    if (_needsReschedule) {
      _needsReschedule = false;
      scheduleFrame();
    }
  }

  /// Called once per frame to dispatch persistent and post-frame callbacks.
  void handleFrame() {
    _executePersistentFrameCallbacks();
    _executePostFrameCallbacks();
  }

  /// Registers a [callback] that is invoked on every frame.
  void addPersistentFrameCallback(FrameCallback callback) {
    _persistentFrameCallbacks.add(callback);
  }

  /// Removes a previously registered persistent frame [callback].
  void removePersistentFrameCallback(FrameCallback callback) {
    _persistentFrameCallbacks.remove(callback);
  }

  /// Registers a [callback] that is invoked once at the end of the next frame.
  void addPostFrameCallback(FrameCallback callback) {
    _postFrameCallbacks.add(callback);
    scheduleFrame();
  }

  void _executePostFrameCallbacks() {
    if (_postFrameCallbacks.isNotEmpty) {
      final callbacks = List<FrameCallback>.from(_postFrameCallbacks);
      _postFrameCallbacks.clear();
      for (final callback in callbacks) {
        callback(Duration.zero);
      }
    }
  }

  void _executePersistentFrameCallbacks() {
    if (_persistentFrameCallbacks.isNotEmpty) {
      final callbacks = List<FrameCallback>.from(_persistentFrameCallbacks);
      for (final callback in callbacks) {
        callback(Duration.zero);
      }
    }
  }
}
