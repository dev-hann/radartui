import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../foundation.dart';
import '../rendering.dart';
import '../services.dart';
import '../widgets.dart';

typedef VoidCallback = void Function();
typedef FrameCallback = void Function(Duration timeStamp);

class SchedulerBinding {
  static final instance = SchedulerBinding._();
  SchedulerBinding._();

  final terminal = Terminal();
  late final outputBuffer = OutputBuffer(terminal);
  final RawKeyboard keyboard = RawKeyboard(); // Added RawKeyboard
  void inputTest(String input) {
    keyboard.inputTest(input);
  }

  Element? _rootElement;
  bool _frameScheduled = false;
  final List<FrameCallback> _postFrameCallbacks = [];
  final List<Widget> _overlayWidgets = [];
  final List<Element> _overlayElements = [];

  void runApp(Widget app) {
    AppLogger.initialize();

    keyboard.initialize();
    terminal.clear();
    _rootElement = app.createElement();
    _rootElement!.mount(null);
    scheduleFrame();

    // Register shutdown hooks
    ProcessSignal.sigint.watch().listen((_) => shutdown('SIGINT'));
    ProcessSignal.sigterm.watch().listen((_) => shutdown('SIGTERM'));
    ProcessSignal.sigwinch.watch().listen((_) {
      outputBuffer.resize();
    });
  }

  void shutdown(String signal) {
    keyboard.dispose();
    AppLogger.dispose();
    terminal.showCursor();
    terminal.clear();
    exit(0);
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

  void scheduleFrame({bool clearScreen = false}) {
    if (_frameScheduled) return;
    _frameScheduled = true;
    if (clearScreen) {
      scheduleMicrotask(_handleFrameWithClear);
    } else {
      scheduleMicrotask(_handleFrameWithSmartClear);
    }
  }

  void scheduleFrameWithClear() => scheduleFrame(clearScreen: true);

  void _handleFrameWithClear() => _handleFrame(clearAll: true);

  void addPostFrameCallback(FrameCallback callback) {
    _postFrameCallbacks.add(callback);
    scheduleFrame();
  }

  void _handleFrameWithSmartClear() => _handleFrame(clearAll: false);

  void _handleFrame({required bool clearAll}) {
    _build(_rootElement!);
    _layout(_rootElement!);

    if (clearAll) {
      outputBuffer.clearAll();
    } else {
      outputBuffer.smartClear();
    }

    _paint(_rootElement!);

    for (final element in _overlayElements) {
      _build(element);
      _layout(element);
      _paintOverlay(element);
    }

    _frameScheduled = false;
    _executePostFrameCallbacks();
  }

  void _executePostFrameCallbacks() {
    if (_postFrameCallbacks.isNotEmpty) {
      final callbacks = List<FrameCallback>.from(_postFrameCallbacks);
      _postFrameCallbacks.clear();
      final timeStamp = Duration.zero;
      for (final callback in callbacks) {
        try {
          callback(timeStamp);
        } catch (e) {
          AppLogger.log('Error in post-frame callback: $e');
        }
      }
    }
  }

  void handleFrame() => _handleFrameWithSmartClear();

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

  void _paint(Element element) => _paintElement(element);

  void _paintOverlay(Element element) => _paintElement(element);

  void _paintElement(Element element) {
    final context = PaintingContext(outputBuffer);
    element.renderObject?.paint(context, Offset.zero);
    outputBuffer.flush();
  }
}

class RawKeyboard {
  StreamSubscription? _stdinSubscription;
  final _controller = StreamController<KeyEvent>.broadcast();
  bool _rawModeSupported = false;

  void inputTest(String input) {
    _controller.add(KeyEvent(code: KeyCode.char, char: input));
  }

  void initialize() {
    // Try to set terminal modes and track if it's supported
    _rawModeSupported = updateStdinMode(false);

    if (_rawModeSupported) {
      // Raw mode: listen for individual key events
      _stdinSubscription = stdin.listen(
        (List<int> data) {
          try {
            final keyEvent = KeyParser.parse(data);
            _controller.add(keyEvent);
          } catch (e) {
            AppLogger.log('Error parsing key event: $e');
          }
        },
        onError: (e) {
          AppLogger.log('Stdin error: $e');
        },
        onDone: () {},
      );
    } else {
      // Fallback: use line mode and parse line-based input
      AppLogger.log('Raw mode not supported, using line mode fallback');
      _initializeLineMode();
    }
  }

  void _initializeLineMode() {
    _stdinSubscription = stdin
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (String line) {
            AppLogger.log('Line mode input: "$line"');
            _processLineInput(line);
          },
          onError: (e) {
            AppLogger.log('Line mode stdin error: $e');
          },
          onDone: () {
            AppLogger.log('Line mode stdin done');
          },
        );
  }

  void _processLineInput(String line) {
    // Process line-based input and generate key events
    // For navigation, we can support simple commands:
    // "j" -> down, "k" -> up, "enter" or "" -> select
    final trimmed = line.trim().toLowerCase();

    if (trimmed.isEmpty) {
      // Empty line = Enter key
      _controller.add(const KeyEvent(code: KeyCode.enter));
    } else if (trimmed == 'j') {
      _controller.add(const KeyEvent(code: KeyCode.char, char: 'j'));
    } else if (trimmed == 'k') {
      _controller.add(const KeyEvent(code: KeyCode.char, char: 'k'));
    } else if (trimmed == 'q') {
      _controller.add(const KeyEvent(code: KeyCode.char, char: 'q'));
    } else {
      // For other input, treat as text
      for (final char in trimmed.split('')) {
        _controller.add(KeyEvent(code: KeyCode.char, char: char));
      }
    }
  }

  bool updateStdinMode(bool value) {
    try {
      stdin.lineMode = value;
      stdin.echoMode = value;
      return true;
    } catch (e) {
      AppLogger.log('Failed to set terminal mode: $e');
      return false;
    }
  }

  Stream<KeyEvent> get keyEvents => _controller.stream;

  void dispose() {
    updateStdinMode(true);
    _stdinSubscription?.cancel();
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
