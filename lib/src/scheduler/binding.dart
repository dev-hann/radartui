import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/services/key_parser.dart';
import 'package:radartui/src/services/output_buffer.dart';
import 'package:radartui/src/services/terminal.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/services/logger.dart';

typedef VoidCallback = void Function();
typedef FrameCallback = void Function(Duration timeStamp);

class SchedulerBinding {
  static final instance = SchedulerBinding._();
  SchedulerBinding._();

  final terminal = Terminal();
  late final outputBuffer = OutputBuffer(terminal);
  final RawKeyboard keyboard = RawKeyboard(); // Added RawKeyboard
  Element? _rootElement;
  bool _frameScheduled = false;
  final List<FrameCallback> _postFrameCallbacks = [];

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

  void scheduleFrame() {
    if (_frameScheduled) return;
    _frameScheduled = true;
    scheduleMicrotask(handleFrame);
  }

  void addPostFrameCallback(FrameCallback callback) {
    _postFrameCallbacks.add(callback);
    scheduleFrame();
  }

  void handleFrame() {
    _build(_rootElement!);
    _layout(_rootElement!);
    _paint(_rootElement!);
    _frameScheduled = false;
    
    // 프레임 처리가 완료된 후 post-frame 콜백들을 실행
    if (_postFrameCallbacks.isNotEmpty) {
      final callbacks = List<FrameCallback>.from(_postFrameCallbacks);
      _postFrameCallbacks.clear();
      final timeStamp = Duration.zero; // 간단한 구현을 위해 더미 타임스탬프 사용
      for (final callback in callbacks) {
        try {
          callback(timeStamp);
        } catch (e) {
          AppLogger.log('Error in post-frame callback: $e');
        }
      }
    }
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

  void _paint(Element element) {
    outputBuffer.clear(); // Clear buffer before painting new frame
    final context = PaintingContext(outputBuffer);
    element.renderObject?.paint(context, Offset.zero);
    outputBuffer.flush();
  }
}

class RawKeyboard {
  StreamSubscription? _stdinSubscription;
  final _controller = StreamController<KeyEvent>.broadcast();
  bool _rawModeSupported = false;

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
        onDone: () {
          AppLogger.log('Stdin done - raw mode');
        },
      );
    } else {
      // Fallback: use line mode and parse line-based input
      AppLogger.log('Raw mode not supported, using line mode fallback');
      _initializeLineMode();
    }
  }

  void _initializeLineMode() {
    // In line mode, we read complete lines and simulate key events
    _stdinSubscription = stdin
        .transform(utf8.decoder)
        .transform(LineSplitter())
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
      _controller.add(const KeyEvent('Enter'));
    } else if (trimmed == 'j') {
      _controller.add(const KeyEvent('j'));
    } else if (trimmed == 'k') {
      _controller.add(const KeyEvent('k'));
    } else if (trimmed == 'q') {
      _controller.add(const KeyEvent('q'));
    } else {
      // For other input, treat as text
      for (final char in trimmed.split('')) {
        _controller.add(KeyEvent(char));
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
