import 'dart:async';
import '../binding.dart';
import '../foundation.dart';
import '../services.dart';
import '../widgets.dart';

class TestBinding extends BindingBase
    with SchedulerBinding, ServicesBinding, RendererBinding, WidgetsBinding {
  TestBinding({int width = 80, int height = 24})
      : terminal = TestTerminal(width: width, height: height),
        keyboard = TestKeyboard() {
    outputBuffer = TestOutputBuffer(terminal);
  }
  static TestBinding? _testInstance;

  static TestBinding? get maybeInstance => _testInstance;

  static TestBinding get instance => BindingBase.checkInstance(_testInstance);

  @override
  final TestTerminal terminal;

  @override
  final TestKeyboard keyboard;

  @override
  late final TestOutputBuffer outputBuffer;

  @override
  void initInstances() {
    super.initInstances();
    _testInstance = this;
  }

  static TestBinding ensureInitialized() {
    if (_testInstance == null) {
      return TestBinding();
    }
    return _testInstance!;
  }

  void runWidget(Widget widget) {
    FocusManager.instance.dispose();
    FocusManager.instance.setTestKeyEvents(keyboard.keyEvents);
    FocusManager.instance.initialize();

    _rootElement = widget.createElement();
    _rootElement!.mount(null);
    _build(_rootElement!);
    _layout(_rootElement!);
    outputBuffer.smartClear();
    paintElement(_rootElement!);
  }

  Element? _rootElement;

  @override
  Element? get rootElement => _rootElement;

  void unmount() {
    if (_rootElement != null) {
      _unmountElement(_rootElement!);
      _rootElement = null;
    }
    FocusManager.instance.dispose();
    keyboard.dispose();
    _testInstance = null;
    WidgetsBinding.resetInstance();
    RendererBinding.resetInstance();
    ServicesBinding.resetInstance();
    SchedulerBinding.resetInstance();
  }

  void _unmountElement(Element element) {
    element.visitChildren(_unmountElement);
    element.unmount();
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

  void pump([Duration? duration]) {
    if (_rootElement != null) {
      _build(_rootElement!);
      _layout(_rootElement!);
      outputBuffer.smartClear();
      paintElement(_rootElement!);
    }
    if (duration != null) {
      final endTime = DateTime.now().add(duration);
      while (DateTime.now().isBefore(endTime)) {}
    }
  }

  Future<void> pumpAndSettle() async {
    var previousOutput = terminal.getPlainText();
    for (int i = 0; i < 100; i++) {
      pump();
      await Future<void>.delayed(Duration.zero);
      final currentOutput = terminal.getPlainText();
      if (currentOutput == previousOutput && i > 0) {
        break;
      }
      previousOutput = currentOutput;
    }
  }
}

class TestTerminal implements Terminal {
  TestTerminal({int width = 80, int height = 24})
      : _width = width,
        _height = height,
        _grid = List.generate(
          height,
          (_) => List.generate(width, (_) => ' '),
        );
  int _width;
  int _height;
  final List<List<String>> _grid;
  int _cursorX = 0;
  int _cursorY = 0;

  @override
  int get width => _width;

  @override
  int get height => _height;

  void setSize(int newWidth, int newHeight) {
    final newGrid = List.generate(
      newHeight,
      (_) => List.generate(newWidth, (_) => ' '),
    );
    for (var y = 0; y < _height && y < newHeight; y++) {
      for (var x = 0; x < _width && x < newWidth; x++) {
        newGrid[y][x] = _grid[y][x];
      }
    }
    for (var y = 0; y < _height; y++) {
      for (var x = 0; x < _width; x++) {
        _grid[y][x] = newGrid[y][x];
      }
    }
    _width = newWidth;
    _height = newHeight;
  }

  @override
  void clear() {
    for (var y = 0; y < _height; y++) {
      for (var x = 0; x < _width; x++) {
        _grid[y][x] = ' ';
      }
    }
  }

  @override
  void hideCursor() {}

  @override
  void showCursor() {}

  @override
  void setCursorPosition(int x, int y) {
    _cursorX = x.clamp(0, _width - 1);
    _cursorY = y.clamp(0, _height - 1);
  }

  @override
  void reset() {
    clear();
    _cursorX = 0;
    _cursorY = 0;
  }

  @override
  TerminalBackend get backend => _TestTerminalBackend(this);

  @override
  void write(String data) {
    for (final char in data.split('')) {
      if (char == '\n') {
        _cursorX = 0;
        _cursorY++;
        if (_cursorY >= _height) break;
      } else if (_cursorX < _width && _cursorY < _height) {
        _grid[_cursorY][_cursorX] = char;
        _cursorX++;
      }
    }
  }

  void writeToGrid(int x, int y, String char) {
    if (x >= 0 && x < _width && y >= 0 && y < _height) {
      _grid[y][x] = char;
    }
  }

  String cellAt(int x, int y) {
    if (x >= 0 && x < _width && y >= 0 && y < _height) {
      return _grid[y][x];
    }
    return '';
  }

  String getPlainText() {
    final buffer = StringBuffer();
    for (var y = 0; y < _height; y++) {
      final line = _grid[y].join('').trimRight();
      buffer.writeln(line);
    }
    return buffer.toString().trimRight();
  }

  bool contains(String text) {
    return getPlainText().contains(text);
  }

  bool containsPattern(RegExp pattern) {
    return pattern.hasMatch(getPlainText());
  }

  String get line {
    return _grid.isNotEmpty ? _grid[0].join('').trimRight() : '';
  }

  List<String> get lines {
    return _grid.map((row) => row.join('').trimRight()).toList();
  }

  List<String> get nonEmptyLines {
    return lines.where((line) => line.isNotEmpty).toList();
  }

  List<List<String>> get grid {
    return _grid.map((row) => List<String>.from(row)).toList();
  }
}

class _TestTerminalBackend implements TerminalBackend {
  _TestTerminalBackend(this._terminal);
  final TestTerminal _terminal;

  @override
  int get width => _terminal.width;

  @override
  int get height => _terminal.height;

  @override
  void write(String data) => _terminal.write(data);

  @override
  void setCursorPosition(int x, int y) => _terminal.setCursorPosition(x, y);

  @override
  void hideCursor() => _terminal.hideCursor();

  @override
  void showCursor() => _terminal.showCursor();

  @override
  void clear() => _terminal.clear();
}

class TestOutputBuffer implements OutputBuffer {
  TestOutputBuffer(this.terminal);
  @override
  final TestTerminal terminal;
  final List<String> _output = [];

  @override
  void writeStyled(int x, int y, String char, TextStyle? style) {
    _output.add('($x,$y):$char');
    terminal.writeToGrid(x, y, char);
  }

  @override
  void flush() {}

  @override
  void clearAll() {
    _output.clear();
    terminal.clear();
  }

  @override
  void smartClear() {
    _output.clear();
    terminal.clear();
  }

  @override
  void resize() {}

  @override
  void clear() {
    _output.clear();
    terminal.clear();
  }

  @override
  bool needsFullClear() => false;

  @override
  void conditionalClear() {
    _output.clear();
    terminal.clear();
  }

  @override
  void write(int x, int y, String char) {
    _output.add('($x,$y):$char');
    terminal.writeToGrid(x, y, char);
  }

  List<String> get output => _output;
}

class TestKeyboard implements RawKeyboard {
  final StreamController<KeyEvent> _controller =
      StreamController<KeyEvent>.broadcast();

  @override
  Stream<KeyEvent> get keyEvents => _controller.stream;

  void sendKeyEvent(KeyEvent event) {
    _controller.add(event);
  }

  void sendKey(KeyCode code, {String? char, bool isShiftPressed = false}) {
    sendKeyEvent(KeyEvent(
      code: code,
      char: char,
      isShiftPressed: isShiftPressed,
    ));
  }

  void sendChar(String char) {
    sendKeyEvent(KeyEvent(code: KeyCode.char, char: char));
  }

  void sendEnter() {
    sendKeyEvent(const KeyEvent(code: KeyCode.enter));
  }

  void sendSpace() {
    sendKeyEvent(const KeyEvent(code: KeyCode.char, char: ' '));
  }

  void sendTab() {
    sendKeyEvent(const KeyEvent(code: KeyCode.tab));
  }

  void sendShiftTab() {
    sendKeyEvent(const KeyEvent(code: KeyCode.tab, isShiftPressed: true));
  }

  void sendBackspace() {
    sendKeyEvent(const KeyEvent(code: KeyCode.backspace));
  }

  void sendDelete() {
    sendKeyEvent(const KeyEvent(code: KeyCode.delete));
  }

  void sendArrowLeft() {
    sendKeyEvent(const KeyEvent(code: KeyCode.arrowLeft));
  }

  void sendArrowRight() {
    sendKeyEvent(const KeyEvent(code: KeyCode.arrowRight));
  }

  void sendArrowUp() {
    sendKeyEvent(const KeyEvent(code: KeyCode.arrowUp));
  }

  void sendArrowDown() {
    sendKeyEvent(const KeyEvent(code: KeyCode.arrowDown));
  }

  void sendHome() {
    sendKeyEvent(const KeyEvent(code: KeyCode.home));
  }

  void sendEnd() {
    sendKeyEvent(const KeyEvent(code: KeyCode.end));
  }

  void sendEscape() {
    sendKeyEvent(const KeyEvent(code: KeyCode.escape));
  }

  void typeText(String text) {
    for (final char in text.split('')) {
      sendChar(char);
    }
  }

  @override
  void initialize() {}

  @override
  void inputTest(String input) {}

  @override
  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}
