import 'dart:async';
import '../../../radartui.dart';
import '../../foundation/drawing_constants.dart';

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TextSelection && start == other.start && end == other.end;
  }

  @override
  int get hashCode => Object.hash(start, end);
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
    _cursorPosition = _findPrevWordBoundary(_cursorPosition);
    clearSelection();
    notifyListeners();
  }

  int _findPrevWordBoundary(int startPos) {
    int pos = startPos - 1;
    while (pos > 0 && _text[pos - 1] != ' ') {
      pos--;
    }
    return pos;
  }

  /// Moves the cursor one word to the right.
  void moveCursorWordRight() {
    if (_cursorPosition >= _text.length) return;
    _cursorPosition = _findNextWordBoundary(_cursorPosition);
    clearSelection();
    notifyListeners();
  }

  int _findNextWordBoundary(int startPos) {
    int pos = startPos;
    while (pos < _text.length && _text[pos] == ' ') {
      pos++;
    }
    while (pos < _text.length && _text[pos] != ' ') {
      pos++;
    }
    while (pos < _text.length && _text[pos] == ' ') {
      pos++;
    }
    return pos;
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
  RenderTextField({
    required String text,
    required int cursorPosition,
    String? placeholder,
    TextStyle? style,
    required bool hasFocus,
  })  : _text = text,
        _cursorPosition = cursorPosition,
        _placeholder = placeholder,
        _style = style,
        _hasFocus = hasFocus;

  static const TextStyle _cursorStyle = TextStyle(
    color: Color.black,
    backgroundColor: Color.cyan,
    bold: true,
  );
  static const TextStyle _borderStyle = TextStyle(
    color: Color.cyan,
    bold: true,
  );

  String _text;
  int _cursorPosition;
  String? _placeholder;
  TextStyle? _style;
  bool _hasFocus;

  /// The current text content.
  String get text => _text;

  /// Sets the text content.
  set text(String v) {
    if (_text == v) return;
    _text = v;
    markNeedsLayout();
  }

  /// The position of the cursor within the text.
  int get cursorPosition => _cursorPosition;

  /// Sets the cursor position.
  set cursorPosition(int v) {
    if (_cursorPosition == v) return;
    _cursorPosition = v;
    markNeedsLayout();
  }

  /// Placeholder text shown when [text] is empty.
  String? get placeholder => _placeholder;

  /// Sets the placeholder text.
  set placeholder(String? v) {
    if (_placeholder == v) return;
    _placeholder = v;
    _cachedPlaceholderStyle = null;
    markNeedsLayout();
  }

  /// The text style applied to the input text.
  TextStyle? get style => _style;

  /// Sets the text style.
  set style(TextStyle? v) {
    if (_style == v) return;
    _style = v;
    _cachedPlaceholderStyle = null;
    markNeedsPaint();
  }

  /// Whether the text field currently has keyboard focus.
  bool get hasFocus => _hasFocus;

  /// Sets the focus state.
  set hasFocus(bool v) {
    if (_hasFocus == v) return;
    _hasFocus = v;
    markNeedsPaint();
  }

  TextStyle? _cachedPlaceholderStyle;
  TextStyle? _placeholderCacheKey;

  TextStyle _resolveDisplayStyle() {
    final baseStyle = _style ?? const TextStyle(color: Color.white);
    if (_text.isEmpty && _placeholder != null) {
      if (_cachedPlaceholderStyle == null || _placeholderCacheKey != _style) {
        _cachedPlaceholderStyle = TextStyle(
          color: Color.brightBlack,
          backgroundColor: baseStyle.backgroundColor,
          bold: false,
          italic: true,
          underline: false,
        );
        _placeholderCacheKey = _style;
      }
      return _cachedPlaceholderStyle!;
    }
    return baseStyle;
  }

  String get _displayText =>
      _text.isEmpty && _placeholder != null ? _placeholder! : _text;

  @override
  void performLayout(Constraints constraints) {
    final desiredWidth = (_displayText.length + 1).clamp(
      1,
      Constraints.infinity,
    );
    final boxConstraints = constraints.asBoxConstraints;
    size = boxConstraints.constrain(Size(desiredWidth, 1));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final displayText = _displayText;
    final displayStyle = _resolveDisplayStyle();

    if (_hasFocus) {
      _drawBorder(context, offset, size!);
    }

    final scrollOffset = _computeScrollOffset(displayText.length);
    _paintText(context, offset, displayText, displayStyle, scrollOffset);

    if (_hasFocus) {
      _paintCursor(context, offset, displayText, scrollOffset);
    }
  }

  int _computeScrollOffset(int textLength) {
    final availableWidth = size!.width;
    if (textLength >= availableWidth && _cursorPosition >= availableWidth) {
      return _cursorPosition - availableWidth + 1;
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
    final int visibleEnd =
        (scrollOffset + availableWidth).clamp(0, displayText.length);

    if (scrollOffset < visibleEnd) {
      final String visibleText =
          displayText.substring(scrollOffset, visibleEnd);
      context.writeString(offset.x, offset.y, visibleText, displayStyle);
    }
  }

  void _paintCursor(
    PaintingContext context,
    Offset offset,
    String displayText,
    int scrollOffset,
  ) {
    final availableWidth = size!.width;
    final cursorScreenX = offset.x + _cursorPosition - scrollOffset;

    if (cursorScreenX < offset.x ||
        cursorScreenX >= offset.x + availableWidth) {
      return;
    }

    if (_cursorPosition < _text.length) {
      context.buffer.writeStyled(
        cursorScreenX,
        offset.y,
        _text[_cursorPosition],
        _cursorStyle,
      );
    } else {
      context.buffer.writeStyled(
        cursorScreenX,
        offset.y,
        BoxDrawingConstants.fullBlockCursor,
        _cursorStyle,
      );
    }
  }

  void _drawBorder(PaintingContext context, Offset offset, Size borderSize) {
    final int width = borderSize.width.toInt();
    final bufferHeight = context.buffer.terminal.height;
    final bufferWidth = context.buffer.terminal.width;

    _drawHorizontalLine(context, offset, width, bufferHeight, bufferWidth, -1);
    _drawHorizontalLine(context, offset, width, bufferHeight, bufferWidth, 1);
    _drawVerticalBorder(context, offset, bufferWidth, -1);
    _drawVerticalBorder(context, offset, bufferWidth, width);
    _drawCorner(context, offset, -1, -1, BoxDrawingConstants.topLeft);
    _drawCorner(context, offset, width, -1, BoxDrawingConstants.topRight);
    _drawCorner(context, offset, -1, 1, BoxDrawingConstants.bottomLeft);
    _drawCorner(context, offset, width, 1, BoxDrawingConstants.bottomRight);
  }

  void _drawHorizontalLine(
    PaintingContext context,
    Offset offset,
    int width,
    int bufferHeight,
    int bufferWidth,
    int yOffset,
  ) {
    final int targetY = offset.y + yOffset;
    if (!_isValidPosition(offset.x, targetY, bufferHeight, bufferWidth)) {
      return;
    }
    final int clipStart = offset.x.clamp(0, bufferWidth);
    final int clipEnd = (offset.x + width).clamp(0, bufferWidth);
    final int clippedWidth = clipEnd - clipStart;
    if (clippedWidth <= 0) return;
    context.writeString(
      clipStart,
      targetY,
      BoxDrawingConstants.horizontal * clippedWidth,
      _borderStyle,
    );
  }

  void _drawVerticalBorder(
    PaintingContext context,
    Offset offset,
    int bufferWidth,
    int xOffset,
  ) {
    final int targetX = offset.x + xOffset;
    if (!_isValidPosition(targetX, offset.y, 1, bufferWidth)) {
      return;
    }
    context.buffer.writeStyled(
      targetX,
      offset.y,
      BoxDrawingConstants.vertical,
      _borderStyle,
    );
  }

  void _drawCorner(
    PaintingContext context,
    Offset offset,
    int xOffset,
    int yOffset,
    String cornerChar,
  ) {
    final int targetX = offset.x + xOffset;
    final int targetY = offset.y + yOffset;
    if (targetX >= 0 && targetY >= 0) {
      context.buffer.writeStyled(targetX, targetY, cornerChar, _borderStyle);
    }
  }

  bool _isValidPosition(int x, int y, int bufferHeight, int bufferWidth) {
    return x >= 0 && x < bufferWidth && y >= 0 && y < bufferHeight;
  }
}
