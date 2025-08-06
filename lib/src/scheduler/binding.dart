import 'dart:async';
import 'dart:io';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/services/output_buffer.dart';
import 'package:radartui/src/services/terminal.dart';
import 'package:radartui/src/widgets/framework.dart';
import 'package:radartui/src/services/logger.dart'; // Added import

class SchedulerBinding {
  static final instance = SchedulerBinding._();
  SchedulerBinding._();

  final terminal = Terminal();
  late final outputBuffer = OutputBuffer(terminal);
  final RawKeyboard keyboard = RawKeyboard(); // Added RawKeyboard
  Element? _rootElement;
  bool _frameScheduled = false;

  void runApp(Widget app) {
    AppLogger.initialize(); // Initialize logger
    AppLogger.log('App started.');

    try {
      AppLogger.log('stdin.hasTerminal: ${stdin.hasTerminal}');
      if (stdin.hasTerminal) {
        stdin.lineMode = false;
        stdin.echoMode = false;
      }
    } on StdinException {
      AppLogger.log('StdinException during terminal mode setup.');
    }
    keyboard.initialize(); // Initialize keyboard
    terminal.clear(); // Clear screen once at startup
    _rootElement = app.createElement();
    _rootElement!.mount(null);
    scheduleFrame();

    // Register a shutdown hook to dispose logger and restore terminal
    ProcessSignal.sigint.watch().listen((signal) {
      AppLogger.log('SIGINT received. Shutting down.');
      AppLogger.dispose();
      terminal.showCursor();
      exit(0);
    });
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
  }

  void _paint(Element element) {
    final context = PaintingContext(outputBuffer);
    element.renderObject?.paint(context, Offset.zero);
    outputBuffer.flush();
  }
}

class RawKeyboard {
  StreamSubscription<List<int>>? _stdinSubscription;
  final _controller = StreamController<String>();

  void initialize() {
    if (!stdin.hasTerminal) {
      AppLogger.log('Not in a terminal. Raw keyboard input disabled.');
      return;
    }
    try {
      stdin.lineMode = false;
    } on StdinException {
      AppLogger.log('StdinException setting lineMode.');
    }
    try {
      stdin.echoMode = false;
    } on StdinException {
      AppLogger.log('StdinException setting echoMode.');
    }
    _stdinSubscription = stdin.listen((List<int> data) {
      AppLogger.log('RawKeyboard received: ${data.map((e) => e.toRadixString(16)).join(' ')}');
      _controller.add(String.fromCharCodes(data));
    }, onError: (e) {
      AppLogger.log('RawKeyboard listen error: $e');
    }, onDone: () {
      AppLogger.log('RawKeyboard listen done');
    });
  }

  Stream<String> get keyEvents => _controller.stream;

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
