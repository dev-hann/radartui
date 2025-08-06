import 'dart:async';
import 'dart:io';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/services/output_buffer.dart';
import 'package:radartui/src/services/terminal.dart';
import 'package:radartui/src/widgets/framework.dart';

class SchedulerBinding {
  static final instance = SchedulerBinding._();
  SchedulerBinding._();

  final terminal = Terminal();
  late final outputBuffer = OutputBuffer(terminal);
  final RawKeyboard keyboard = RawKeyboard(); // Added RawKeyboard
  Element? _rootElement;
  bool _frameScheduled = false;

  void runApp(Widget app) {
    try {
      if (stdin.hasTerminal) {
        stdin.lineMode = false;
        stdin.echoMode = false;
      }
    } on StdinException {}
    keyboard.initialize(); // Initialize keyboard
    _rootElement = app.createElement();
    _rootElement!.mount(null);
    scheduleFrame();
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
    terminal.clear();
    final context = PaintingContext(outputBuffer);
    element.renderObject?.paint(context, Offset.zero);
    outputBuffer.flush();
  }
}

class RawKeyboard {
  StreamSubscription<List<int>>? _stdinSubscription;
  final _controller = StreamController<String>();

  void initialize() {
    if (!stdin.hasTerminal) return;
    try {
      stdin.lineMode = false;
    } on StdinException {}
    try {
      stdin.echoMode = false;
    } on StdinException {}
    _stdinSubscription = stdin.listen((List<int> data) {
      print('RawKeyboard received: ${data.map((e) => e.toRadixString(16)).join(' ')}'); // Debug print
      _controller.add(String.fromCharCodes(data));
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