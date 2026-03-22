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
  final List<FrameCallback> _postFrameCallbacks = [];

  void scheduleFrame() {
    if (_frameScheduled) return;
    _frameScheduled = true;
    scheduleMicrotask(_handleFrame);
  }

  void _handleFrame() {
    handleFrame();
    _frameScheduled = false;
  }

  void handleFrame() {
    _executePostFrameCallbacks();
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
}
