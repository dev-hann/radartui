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
    keyboard.initialize(); // Initialize keyboard (handles stdin configuration)
    terminal.clear(); // Clear screen once at startup
    _rootElement = app.createElement();
    _rootElement!.mount(null);
    scheduleFrame();

    // Register a shutdown hook to dispose logger and restore terminal
    ProcessSignal.sigint.watch().listen((signal) {
      AppLogger.log("End $signal");
      keyboard.dispose();
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
  StreamSubscription<List<int>>? _stdinSubscription;
  final _controller = StreamController<KeyEvent>();

  void initialize() {
    // Try to set terminal modes, but continue even if it fails
    try {
      stdin.lineMode = false;
    } on StdinException catch (e) {}
    try {
      stdin.echoMode = false;
    } on StdinException catch (e) {}

    // Always try to listen to stdin, even if terminal mode setup failed
    _stdinSubscription = stdin.listen(
      (List<int> data) {
        final keyEvent = KeyParser.parse(data);
        _controller.add(keyEvent);
      },
      onError: (e) {},
      onDone: () {},
    );
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
    SchedulerBinding.instance.terminal.reset();
    SchedulerBinding.instance.terminal.showCursor();
  }
}
