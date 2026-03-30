import 'dart:io';
import '../foundation.dart';
import '../services.dart';
import '../widgets.dart';
import 'binding_base.dart';
import 'renderer_binding.dart';
import 'scheduler_binding.dart';
import 'services_binding.dart';

typedef ShutdownCallback = void Function();

mixin WidgetsBinding
    on BindingBase, SchedulerBinding, ServicesBinding, RendererBinding {
  static WidgetsBinding? _instance;

  static WidgetsBinding get instance => BindingBase.checkInstance(_instance);
  static bool get isInitialized => _instance != null;

  static void resetInstance() {
    _instance = null;
  }

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
  }

  Element? _rootElement;
  final List<Widget> _overlayWidgets = [];
  final List<Element> _overlayElements = [];
  final List<ShutdownCallback> _shutdownCallbacks = [];
  bool _isShuttingDown = false;

  Element? get rootElement => _rootElement;

  void runApp(Widget app) {
    terminal.clear();
    terminal.hideCursor();

    _rootElement = app.createElement();
    _rootElement!.mount(null);
    scheduleFrame();

    ProcessSignal.sigint.watch().listen((_) => shutdown());
    ProcessSignal.sigterm.watch().listen((_) => shutdown());
    ProcessSignal.sigwinch.watch().listen((_) {
      outputBuffer.resize();
    });
  }

  void addShutdownCallback(ShutdownCallback callback) {
    _shutdownCallbacks.add(callback);
  }

  void removeShutdownCallback(ShutdownCallback callback) {
    _shutdownCallbacks.remove(callback);
  }

  void addOverlay(Widget overlay) {
    _overlayWidgets.add(overlay);
    final element = overlay.createElement();
    element.mount(null);
    _overlayElements.add(element);
    scheduleFrame();
  }

  void removeOverlay(Widget overlay) {
    final index = _overlayWidgets.indexOf(overlay);
    if (index != -1) {
      _overlayWidgets.removeAt(index);
      final element = _overlayElements.removeAt(index);
      element.unmount();
      scheduleFrame();
    }
  }

  @override
  void handleFrame() {
    if (_rootElement != null) {
      _build(_rootElement!);
      _layout(_rootElement!);
      outputBuffer.smartClear();
      paintElement(_rootElement!);
    }

    for (final element in _overlayElements) {
      _build(element);
      _layout(element);
      paintElement(element);
    }

    super.handleFrame();
  }

  void _build(Element element) {
    if (element.dirty) {
      if (element is ComponentElement) {
        element.rebuild();
      }
      element.dirty = false;
    }
    element.visitChildren(_build);
  }

  void _layout(Element element) {
    element.renderObject?.layout(
      BoxConstraints(maxWidth: terminal.width, maxHeight: terminal.height),
    );
    element.visitChildren(_layout);
  }

  void scheduleFrameWithClear() {
    outputBuffer.clearAll();
    scheduleFrame();
  }

  void visibleCursor(bool visible) {
    if (visible) {
      terminal.showCursor();
    } else {
      terminal.hideCursor();
    }
  }

  void shutdown() {
    if (_isShuttingDown) return;
    _isShuttingDown = true;

    for (final callback in _shutdownCallbacks.reversed) {
      try {
        callback();
      } catch (e) {
        AppLogger.log('Error in shutdown callback: $e');
      }
    }
    _shutdownCallbacks.clear();

    disposeServices();
    AppLogger.dispose();
    terminal.showCursor();
    terminal.clear();
    exit(0);
  }
}
