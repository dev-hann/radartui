import 'dart:async';
import 'dart:io';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/services/key_parser.dart';
import 'package:radartui/src/services/output_buffer.dart';
import 'package:radartui/src/services/terminal.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/services/logger.dart';

class SchedulerBinding {
  static final instance = SchedulerBinding._();
  SchedulerBinding._();

  final terminal = Terminal();
  late final outputBuffer = OutputBuffer(terminal);
  final RawKeyboard keyboard = RawKeyboard(); // Added RawKeyboard
  Element? _rootElement;
  bool _frameScheduled = false;

  void runApp(Widget app) {
    AppLogger.initialize();
    AppLogger.log('App started.');

    keyboard.initialize();
    terminal.clear();
    _rootElement = app.createElement();
    _rootElement!.mount(null);
    scheduleFrame();

    // Register shutdown hooks
    ProcessSignal.sigint.watch().listen((_) => shutdown('SIGINT'));
    ProcessSignal.sigterm.watch().listen((_) => shutdown('SIGTERM'));
  }

  void shutdown(String signal) {
    AppLogger.log('$signal received. Shutting down.');
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

  void handleFrame() {
    _build(_rootElement!);
    _layout(_rootElement!);
    _paint(_rootElement!);
    _frameScheduled = false;
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
    element.renderObject?.layout(BoxConstraints(
      maxWidth: terminal.width,
      maxHeight: terminal.height,
    ));
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
  StreamSubscription<List<int>>? _stdinSubscription;
  final _controller = StreamController<KeyEvent>();

  void initialize() {
    AppLogger.log('RawKeyboard initializing, hasTerminal: ${stdin.hasTerminal}');
    
    // Try to set terminal modes, but continue even if it fails
    try {
      stdin.lineMode = false;
      AppLogger.log('Set lineMode = false');
    } on StdinException catch (e) {
      AppLogger.log('StdinException setting lineMode: $e');
    }
    try {
      stdin.echoMode = false;
      AppLogger.log('Set echoMode = false');
    } on StdinException catch (e) {
      AppLogger.log('StdinException setting echoMode: $e');
    }
    
    // Always try to listen to stdin, even if terminal mode setup failed
    AppLogger.log('Setting up stdin listener...');
    _stdinSubscription = stdin.listen((List<int> data) {
      AppLogger.log('RawKeyboard received: ${data.map((e) => e.toRadixString(16)).join(' ')}');
      final keyEvent = KeyParser.parse(data);
      AppLogger.log('Parsed key event: $keyEvent');
      _controller.add(keyEvent);
    }, onError: (e) {
      AppLogger.log('RawKeyboard listen error: $e');
    }, onDone: () {
      AppLogger.log('RawKeyboard listen done');
    });
    AppLogger.log('Stdin listener setup complete');
  }

  Stream<KeyEvent> get keyEvents => _controller.stream;

  void dispose() {
    _stdinSubscription?.cancel();
    if (stdin.hasTerminal) {
      try {
        stdin.lineMode = true;
      } on StdinException {}
      try {
        stdin.echoMode = true;
      } on StdinException {}
    }
    _controller.close();
  }
}
