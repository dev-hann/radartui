import '../services.dart';
import '../widgets.dart';
import 'finder.dart';
import 'test_binding.dart';

class WidgetTester {
  WidgetTester() : binding = TestBinding.instance;
  final TestBinding binding;

  Element? get rootElement => binding.rootElement;

  void pumpWidget(Widget widget) {
    binding.runWidget(widget);
  }

  void pump([Duration? duration]) {
    binding.pump(duration);
  }

  Future<void> pumpAndSettle() async {
    await binding.pumpAndSettle();
  }

  void sendKeyEvent(KeyEvent event) {
    binding.keyboard.sendKeyEvent(event);
  }

  void sendKey(KeyCode code, {String? char, bool isShiftPressed = false}) {
    binding.keyboard.sendKey(code, char: char, isShiftPressed: isShiftPressed);
  }

  void sendChar(String char) {
    binding.keyboard.sendChar(char);
  }

  void sendEnter() {
    binding.keyboard.sendEnter();
  }

  void sendSpace() {
    binding.keyboard.sendSpace();
  }

  void sendTab() {
    binding.keyboard.sendTab();
  }

  void sendShiftTab() {
    binding.keyboard.sendShiftTab();
  }

  void sendBackspace() {
    binding.keyboard.sendBackspace();
  }

  void sendDelete() {
    binding.keyboard.sendDelete();
  }

  void sendArrowLeft() {
    binding.keyboard.sendArrowLeft();
  }

  void sendArrowRight() {
    binding.keyboard.sendArrowRight();
  }

  void sendArrowUp() {
    binding.keyboard.sendArrowUp();
  }

  void sendArrowDown() {
    binding.keyboard.sendArrowDown();
  }

  void sendHome() {
    binding.keyboard.sendHome();
  }

  void sendEnd() {
    binding.keyboard.sendEnd();
  }

  void sendEscape() {
    binding.keyboard.sendEscape();
  }

  void typeText(String text) {
    binding.keyboard.typeText(text);
  }

  void tap(Finder finder) {
    final element = finder.evaluate();
    if (element == null) {
      throw StateError('No widget found');
    }
    sendEnter();
  }

  void tapSpace(Finder finder) {
    final element = finder.evaluate();
    if (element == null) {
      throw StateError('No widget found');
    }
    sendSpace();
  }

  T? state<T extends State<StatefulWidget>>() {
    final root = rootElement;
    if (root == null) return null;

    T? result;
    void visit(Element element) {
      if (element is StatefulElement && element.state is T) {
        result = element.state as T;
        return;
      }
      element.visitChildren(visit);
    }

    visit(root);
    return result;
  }

  T? widget<T extends Widget>() {
    final element = findByType<T>().evaluate();
    if (element == null) return null;
    return element.widget as T;
  }

  void unmount() {
    binding.unmount();
  }

  TestTerminal get terminal => binding.terminal;

  String getPlainText() => terminal.getPlainText();

  String cellAt(int x, int y) => terminal.cellAt(x, y);

  bool contains(String text) => terminal.contains(text);

  bool containsPattern(RegExp pattern) => terminal.containsPattern(pattern);

  String get line => terminal.line;

  List<String> get lines => terminal.lines;

  List<String> get nonEmptyLines => terminal.nonEmptyLines;

  void assertBufferLines(List<String> expected) {
    final actual = lines;
    final maxHeight =
        actual.length > expected.length ? actual.length : expected.length;
    final diffs = <String>[];
    var hasDiff = false;

    for (var i = 0; i < maxHeight; i++) {
      final actualLine = i < actual.length ? actual[i] : '';
      final expectedLine = i < expected.length ? expected[i] : '';

      if (actualLine != expectedLine) {
        hasDiff = true;
        diffs.add('Line $i:');
        diffs.add('  Expected: "$expectedLine"');
        diffs.add('  Actual:   "$actualLine"');
      }
    }

    if (hasDiff) {
      throw AssertionError('Buffer lines do not match:\n${diffs.join('\n')}');
    }
  }

  void assertBuffer(List<List<String>> expected) {
    final actual = terminal.grid;
    final diffs = <String>[];
    var hasDiff = false;

    for (var y = 0; y < actual.length || y < expected.length; y++) {
      final actualRow = y < actual.length ? actual[y] : <String>[];
      final expectedRow = y < expected.length ? expected[y] : <String>[];

      for (var x = 0; x < actualRow.length || x < expectedRow.length; x++) {
        final actualCell = x < actualRow.length ? actualRow[x] : '';
        final expectedCell = x < expectedRow.length ? expectedRow[x] : '';

        if (actualCell != expectedCell) {
          hasDiff = true;
          diffs.add(
              'Cell ($x, $y): Expected "$expectedCell", Actual "$actualCell"');
        }
      }
    }

    if (hasDiff) {
      throw AssertionError(
          'Buffer does not match:\n${diffs.take(20).join('\n')}');
    }
  }

  void assertLine(int lineIndex, String expected) {
    final actualLines = lines;
    if (lineIndex >= actualLines.length) {
      throw AssertionError(
          'Line $lineIndex out of range (max: ${actualLines.length - 1})');
    }
    final actual = actualLines[lineIndex];
    if (actual != expected) {
      throw AssertionError(
          'Line $lineIndex does not match:\n  Expected: "$expected"\n  Actual:   "$actual"');
    }
  }

  void assertContains(String text) {
    if (!contains(text)) {
      throw AssertionError(
          'Buffer does not contain "$text"\nActual output:\n${getPlainText()}');
    }
  }

  void assertCellAt(int x, int y, String expected) {
    final actual = cellAt(x, y);
    if (actual != expected) {
      throw AssertionError(
          'Cell at ($x, $y) does not match:\n  Expected: "$expected"\n  Actual:   "$actual"');
    }
  }
}
