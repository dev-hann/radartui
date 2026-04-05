import 'dart:async';
import '../../../radartui.dart';

/// Represents a text selection range within a string.
class TextSelection {
  /// Creates a [TextSelection] with the given [start] and [end] positions.
  const TextSelection({required this.start, required this.end});

  /// The start offset of the selection (inclusive).
  final int start;

  /// The end offset of the selection (exclusive).
  final int end;

  /// Whether this selection has valid (non-negative) positions with [end] >= [start].
  bool get isValid => start >= 0 && end >= start;

  /// The number of characters in the selection.
  int get length => end - start;

  /// Extracts the selected substring from [fullText].
  String textInRange(String fullText) {
    if (!isValid) return '';
    return fullText.substring(start, end);
  }
}

/// A simple in-memory clipboard for cut, copy, and paste operations.
abstract class Clipboard {
  static String? _data;

  /// Stores [text] in the clipboard.
  static Future<void> setData(String text) async {
    _data = text;
  }

  /// Retrieves the current clipboard content, if any.
  static Future<String?> getData() async {
    return _data;
  }

  /// Whether the clipboard currently contains data.
  static bool get hasData => _data != null && _data!.isNotEmpty;
}

/// A controller for managing text content, cursor position, and selection state.
///
/// Notifies listeners when the text or selection changes. Use with [TextField]
/// for programmatic control over text input.
class TextEditingController extends ChangeNotifier {
  String _text = '';
  int _cursorPosition = 0;
  int? _selectionStart;
  int? _selectionEnd;

  /// The current text content.
  String get text => _text;

  /// The current cursor position within the text.
  int get cursorPosition => _cursorPosition;

  /// The current text selection, or `null` if no text is selected.
  TextSelection? get selection {
    if (_selectionStart == null || _selectionEnd == null) return null;
    return TextSelection(start: _selectionStart!, end: _selectionEnd!);
  }

  /// Whether a range of text is currently selected.
  bool get hasSelection => _selectionStart != null && _selectionEnd != null;

  /// Sets the full text content and resets the cursor and selection.
  set text(String value) {
    if (_text != value) {
      _text = value;
      _cursorPosition = _cursorPosition.clamp(0, _text.length);
      clearSelection();
      notifyListeners();
    }
  }

  /// Moves the cursor to [position], clearing any selection.
  set cursorPosition(int position) {
    final newPosition = position.clamp(0, _text.length);
    if (_cursorPosition != newPosition) {
      _cursorPosition = newPosition;
      clearSelection();
      notifyListeners();
    }
  }

  /// Sets the selection range from [start] to [end].
  void setSelection(int start, int end) {
    _selectionStart = start.clamp(0, _text.length);
    _selectionEnd = end.clamp(_selectionStart!, _text.length);
    notifyListeners();
  }

  /// Clears the current text selection without modifying the text.
  void clearSelection() {
    _selectionStart = null;
    _selectionEnd = null;
  }

  /// Selects all text in the controller.
  void selectAll() {
    _selectionStart = 0;
    _selectionEnd = _text.length;
    notifyListeners();
  }

  /// Copies the selected text to the clipboard.
  Future<void> copy() async {
    if (hasSelection) {
      await Clipboard.setData(selection!.textInRange(_text));
    }
  }

  /// Copies the selected text to the clipboard and removes it from the text.
  Future<void> cut() async {
    if (hasSelection) {
      await Clipboard.setData(selection!.textInRange(_text));
      deleteSelection();
    }
  }

  /// Inserts clipboard content at the cursor, replacing any selection.
  Future<void> paste() async {
    final clipboardText = await Clipboard.getData();
    if (clipboardText != null && clipboardText.isNotEmpty) {
      if (hasSelection) {
        deleteSelection();
      }
      insertText(clipboardText);
    }
  }

  /// Deletes the currently selected text range.
  void deleteSelection() {
    if (!hasSelection) return;
    final sel = selection!;
    _text = _text.substring(0, sel.start) + _text.substring(sel.end);
    _cursorPosition = sel.start;
    clearSelection();
    notifyListeners();
  }

  /// Inserts [text] at the cursor position, replacing any selection first.
  void insertText(String text) {
    if (hasSelection) {
      deleteSelection();
    }
    _text = _text.substring(0, _cursorPosition) +
        text +
        _text.substring(_cursorPosition);
    _cursorPosition += text.length;
    notifyListeners();
  }

  /// Deletes the character before the cursor (backspace).
  void deleteBackward() {
    if (hasSelection) {
      deleteSelection();
      return;
    }
    if (_cursorPosition > 0) {
      _text = _text.substring(0, _cursorPosition - 1) +
          _text.substring(_cursorPosition);
      _cursorPosition--;
      notifyListeners();
    }
  }

  /// Deletes the character after the cursor (delete key).
  void deleteForward() {
    if (hasSelection) {
      deleteSelection();
      return;
    }
    if (_cursorPosition < _text.length) {
      _text = _text.substring(0, _cursorPosition) +
          _text.substring(_cursorPosition + 1);
      notifyListeners();
    }
  }

  /// Moves the cursor one character to the left.
  void moveCursorLeft() {
    if (_cursorPosition > 0) {
      _cursorPosition--;
      clearSelection();
      notifyListeners();
    }
  }

  /// Moves the cursor one character to the right.
  void moveCursorRight() {
    if (_cursorPosition < _text.length) {
      _cursorPosition++;
      clearSelection();
      notifyListeners();
    }
  }

  /// Moves the cursor to the beginning of the text.
  void moveCursorToStart() {
    _cursorPosition = 0;
    clearSelection();
    notifyListeners();
  }

  /// Moves the cursor to the end of the text.
  void moveCursorToEnd() {
    _cursorPosition = _text.length;
    clearSelection();
    notifyListeners();
  }

  /// Moves the cursor one word to the left.
  void moveCursorWordLeft() {
    if (_cursorPosition == 0) return;
    int pos = _cursorPosition - 1;
    while (pos > 0 && _text[pos - 1] != ' ') {
      pos--;
    }
    _cursorPosition = pos;
    clearSelection();
    notifyListeners();
  }

  /// Moves the cursor one word to the right.
  void moveCursorWordRight() {
    if (_cursorPosition >= _text.length) return;
    int pos = _cursorPosition;
    while (pos < _text.length && _text[pos] == ' ') {
      pos++;
    }
    while (pos < _text.length && _text[pos] != ' ') {
      pos++;
    }
    while (pos < _text.length && _text[pos] == ' ') {
      pos++;
    }
    _cursorPosition = pos;
    clearSelection();
    notifyListeners();
  }

  /// Clears all text and resets the cursor to the start.
  void clear() {
    _text = '';
    _cursorPosition = 0;
    clearSelection();
    notifyListeners();
  }
}

/// A single-line or multi-line text input field.
///
/// Supports keyboard navigation, text selection, clipboard operations,
/// and configurable [maxLength]. Use [TextEditingController] for
/// programmatic access to the text and selection state.
class TextField extends StatefulWidget {
  /// Creates a [TextField] with optional [controller], [placeholder], and callbacks.
  const TextField({
    super.key,
    this.controller,
    this.placeholder,
    this.style,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
  });

  /// An optional external controller for the text content and selection.
  final TextEditingController? controller;

  /// Placeholder text displayed when the field is empty.
  final String? placeholder;

  /// The text style applied to the input text.
  final TextStyle? style;

  /// The maximum number of characters allowed.
  final int? maxLength;

  /// Called whenever the text content changes.
  final Function(String)? onChanged;

  /// Called when the user presses Enter.
  final Function(String)? onSubmitted;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> with FocusableState<TextField> {
  late TextEditingController _controller;
  bool _isControllerOwned = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _isControllerOwned = true;
    }

    _controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onControllerChanged);

      if (_isControllerOwned) {
        _controller.dispose();
      }

      if (widget.controller != null) {
        _controller = widget.controller!;
        _isControllerOwned = false;
      } else {
        _controller = TextEditingController();
        _isControllerOwned = true;
      }

      _controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_isControllerOwned) {
      _controller.dispose();
    }
    super.dispose();
  }

  bool _isChangeScheduled = false;

  void _onControllerChanged() {
    if (_isChangeScheduled) return;

    _isChangeScheduled = true;
    scheduleMicrotask(() {
      _isChangeScheduled = false;
      if (!mounted) return;
      setState(() {});
      widget.onChanged?.call(_controller.text);
    });
  }

  void requestFocus() {
    FocusManager.instance.requestFocus(focusNode);
  }

  @override
  void onKeyEvent(KeyEvent event) {
    switch (event.code) {
      case KeyCode.char:
        _handleCharInput(event.char);
      case KeyCode.backspace:
        _controller.deleteBackward();
      case KeyCode.delete:
        _controller.deleteForward();
      case KeyCode.arrowLeft:
        _controller.moveCursorLeft();
      case KeyCode.arrowRight:
        _controller.moveCursorRight();
      case KeyCode.home:
        _controller.moveCursorToStart();
      case KeyCode.end:
        _controller.moveCursorToEnd();
      case KeyCode.enter:
        if (widget.onSubmitted != null) {
          widget.onSubmitted!(_controller.text);
        }
      default:
        break;
    }
  }

  void _handleCharInput(String? char) {
    if (char == null) return;
    if (widget.maxLength == null ||
        _controller.text.length < widget.maxLength!) {
      _controller.insertText(char);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _TextField(
      text: _controller.text,
      cursorPosition: _controller.cursorPosition,
      placeholder: widget.placeholder,
      style: widget.style,
      hasFocus: hasFocus,
    );
  }
}

class _TextField extends RenderObjectWidget {
  const _TextField({
    required this.text,
    required this.cursorPosition,
    this.placeholder,
    this.style,
    required this.hasFocus,
  });
  final String text;
  final int cursorPosition;
  final String? placeholder;
  final TextStyle? style;
  final bool hasFocus;

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderTextField createRenderObject(BuildContext context) => RenderTextField(
        text: text,
        cursorPosition: cursorPosition,
        placeholder: placeholder,
        style: style,
        hasFocus: hasFocus,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final renderTextField = renderObject as RenderTextField;
    renderTextField.text = text;
    renderTextField.cursorPosition = cursorPosition;
    renderTextField.placeholder = placeholder;
    renderTextField.style = style;
    renderTextField.hasFocus = hasFocus;
  }
}

/// Render object that paints a text input field with cursor and border.
class RenderTextField extends RenderBox {
  /// Creates a [RenderTextField] with the given text and display configuration.
  RenderTextField({
    required this.text,
    required this.cursorPosition,
    this.placeholder,
    this.style,
    required this.hasFocus,
  });

  /// The current text content to display.
  String text;

  /// The position of the cursor within the text.
  int cursorPosition;

  /// Placeholder text shown when [text] is empty.
  String? placeholder;

  /// The text style applied to the input text.
  TextStyle? style;

  /// Whether the text field currently has keyboard focus.
  bool hasFocus;

  @override
  void performLayout(Constraints constraints) {
    final displayText =
        text.isEmpty && placeholder != null ? placeholder! : text;
    final desiredWidth = (displayText.length + 1).clamp(
      1,
      Constraints.infinity,
    );
    final boxConstraints = constraints.asBoxConstraints;
    size = boxConstraints.constrain(Size(desiredWidth, 1));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final displayText =
        text.isEmpty && placeholder != null ? placeholder! : text;
    final displayStyle = _resolveDisplayStyle();

    if (hasFocus) {
      _drawBorder(context, offset, size!);
    }

    final scrollOffset = _computeScrollOffset(displayText.length);
    _paintText(context, offset, displayText, displayStyle, scrollOffset);

    if (hasFocus) {
      _paintCursor(context, offset, displayText, scrollOffset);
    }
  }

  TextStyle _resolveDisplayStyle() {
    final baseStyle = style ?? const TextStyle(color: Color.white);
    if (text.isEmpty && placeholder != null) {
      return TextStyle(
        color: Color.brightBlack,
        backgroundColor: baseStyle.backgroundColor,
        bold: false,
        italic: true,
        underline: false,
      );
    }
    return baseStyle;
  }

  int _computeScrollOffset(int textLength) {
    final availableWidth = size!.width;
    if (textLength >= availableWidth && cursorPosition >= availableWidth) {
      return cursorPosition - availableWidth + 1;
    }
    return 0;
  }

  void _paintText(
    PaintingContext context,
    Offset offset,
    String displayText,
    TextStyle displayStyle,
    int scrollOffset,
  ) {
    final availableWidth = size!.width;
    final textLength = displayText.length;
    final visibleEnd = (scrollOffset + availableWidth).clamp(0, textLength);

    for (int i = scrollOffset; i < visibleEnd; i++) {
      final screenX = offset.x + i - scrollOffset;
      context.buffer.writeStyled(
        screenX,
        offset.y,
        displayText[i],
        displayStyle,
      );
    }
  }

  void _paintCursor(
    PaintingContext context,
    Offset offset,
    String displayText,
    int scrollOffset,
  ) {
    final availableWidth = size!.width;
    final cursorScreenX = offset.x + cursorPosition - scrollOffset;

    if (cursorScreenX < offset.x ||
        cursorScreenX >= offset.x + availableWidth) {
      return;
    }

    const cursorStyle = TextStyle(
      color: Color.black,
      backgroundColor: Color.cyan,
      bold: true,
    );

    if (cursorPosition < text.length) {
      context.buffer.writeStyled(
        cursorScreenX,
        offset.y,
        text[cursorPosition],
        cursorStyle,
      );
    } else {
      context.buffer.writeStyled(cursorScreenX, offset.y, '█', cursorStyle);
    }
  }

  void _drawBorder(PaintingContext context, Offset offset, Size borderSize) {
    const borderStyle = TextStyle(color: Color.cyan, bold: true);
    final int width = borderSize.width.toInt();
    final int bufferHeight = context.buffer.terminal.height;
    final int bufferWidth = context.buffer.terminal.width;

    _drawBorderEdges(
      context,
      offset,
      width,
      bufferHeight,
      bufferWidth,
      borderStyle,
    );
    _drawBorderCorners(
      context,
      offset,
      width,
      bufferHeight,
      bufferWidth,
      borderStyle,
    );
  }

  void _drawBorderEdges(
    PaintingContext context,
    Offset offset,
    int width,
    int bufferHeight,
    int bufferWidth,
    TextStyle borderStyle,
  ) {
    if (offset.y > 0) {
      _drawHorizontalLine(
          context, offset.x, offset.y - 1, width, bufferWidth, borderStyle);
    }
    if (offset.y + 1 < bufferHeight) {
      _drawHorizontalLine(
          context, offset.x, offset.y + 1, width, bufferWidth, borderStyle);
    }
    if (offset.x > 0) {
      context.buffer.writeStyled(offset.x - 1, offset.y, '│', borderStyle);
    }
    if (offset.x + width < bufferWidth) {
      context.buffer.writeStyled(offset.x + width, offset.y, '│', borderStyle);
    }
  }

  void _drawHorizontalLine(
    PaintingContext context,
    int startX,
    int y,
    int width,
    int bufferWidth,
    TextStyle style,
  ) {
    for (int x = 0; x < width; x++) {
      final posX = startX + x;
      if (posX >= 0 && posX < bufferWidth) {
        context.buffer.writeStyled(posX, y, '─', style);
      }
    }
  }

  void _drawBorderCorners(
    PaintingContext context,
    Offset offset,
    int width,
    int bufferHeight,
    int bufferWidth,
    TextStyle borderStyle,
  ) {
    _drawCorner(context, offset.x - 1, offset.y - 1, '┌', borderStyle);
    _drawCorner(context, offset.x + width, offset.y - 1, '┐', borderStyle);
    _drawCorner(context, offset.x - 1, offset.y + 1, '└', borderStyle);
    _drawCorner(context, offset.x + width, offset.y + 1, '┘', borderStyle);
  }

  void _drawCorner(
    PaintingContext context,
    int x,
    int y,
    String ch,
    TextStyle style,
  ) {
    if (x >= 0 && y >= 0) {
      context.buffer.writeStyled(x, y, ch, style);
    }
  }
}
