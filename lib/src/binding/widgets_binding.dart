import 'dart:io';
import '../foundation.dart';
import '../services.dart';
import '../widgets.dart';
import 'binding_base.dart';
import 'renderer_binding.dart';
import 'scheduler_binding.dart';
import 'services_binding.dart';

/// Signature for callbacks invoked during [WidgetsBinding.shutdown].
typedef ShutdownCallback = void Function();

/// Binding that glues the widget framework to the terminal and manages the
/// widget tree lifecycle.
mixin WidgetsBinding
    on BindingBase, SchedulerBinding, ServicesBinding, RendererBinding {
  static WidgetsBinding? _instance;

  /// The singleton instance of this binding.
  static WidgetsBinding get instance => BindingBase.checkInstance(_instance);

  /// Whether this binding has been initialized.
  static bool get isInitialized => _instance != null;

  /// Resets the singleton instance, useful for testing.
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

  /// The root element of the widget tree, or `null` if no app is running.
  Element? get rootElement => _rootElement;

  /// Boots the given [app] widget, handles signals, and starts rendering.
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

  /// Attaches the given [app] as the root widget without starting signal
  /// handlers.
  void attachRootWidget(Widget app) {
    terminal.clear();
    terminal.hideCursor();
    _rootElement = app.createElement();
    _rootElement!.mount(null);
  }

  /// Performs a single build-layout-paint cycle for the root element.
  void renderFrame() {
    if (_rootElement != null) {
      _build(_rootElement!);
      _layout(_rootElement!);
      outputBuffer.smartClear();
      paintElement(_rootElement!);
    }
  }

  /// Registers a [callback] to be invoked during [shutdown].
  void addShutdownCallback(ShutdownCallback callback) {
    _shutdownCallbacks.add(callback);
  }

  /// Removes a previously registered shutdown [callback].
  void removeShutdownCallback(ShutdownCallback callback) {
    _shutdownCallbacks.remove(callback);
  }

  /// Adds an [overlay] widget on top of the current widget tree.
  void addOverlay(Widget overlay) {
    _overlayWidgets.add(overlay);
    final element = overlay.createElement();
    element.mount(null);
    _overlayElements.add(element);
    scheduleFrame();
  }

  /// Removes a previously added [overlay] widget.
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

  /// Schedules a new frame after clearing the entire output buffer.
  void scheduleFrameWithClear() {
    outputBuffer.clearAll();
    scheduleFrame();
  }

  /// Shows or hides the terminal cursor.
  void visibleCursor(bool visible) {
    if (visible) {
      terminal.showCursor();
    } else {
      terminal.hideCursor();
    }
  }

  /// Gracefully shuts down the application, running all registered shutdown
  /// callbacks and restoring the terminal state.
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
