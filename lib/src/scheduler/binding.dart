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
    updateStdinMode(false);

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

  void updateStdinMode(bool value) {
    stdin.lineMode = value;
    stdin.echoMode = value;
  }

  Stream<KeyEvent> get keyEvents => _controller.stream;

  void dispose() {
    updateStdinMode(true);
    _stdinSubscription?.cancel();
    _controller.close();
  }
}
