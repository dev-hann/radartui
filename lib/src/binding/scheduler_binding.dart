import 'dart:async';
import 'binding_base.dart';

typedef FrameCallback = void Function(Duration timeStamp);

mixin SchedulerBinding on BindingBase {
  static SchedulerBinding? _instance;

  static SchedulerBinding get instance => BindingBase.checkInstance(_instance);

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

  void handleFrame() {
    _executePersistentFrameCallbacks();
    _executePostFrameCallbacks();
  }

  void addPersistentFrameCallback(FrameCallback callback) {
    _persistentFrameCallbacks.add(callback);
  }

  void removePersistentFrameCallback(FrameCallback callback) {
    _persistentFrameCallbacks.remove(callback);
  }

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
