import 'dart:async';
import '../../../radartui.dart';

class TextSelection {
  const TextSelection({required this.start, required this.end});
  final int start;
  final int end;

  bool get isValid => start >= 0 && end >= start;
  int get length => end - start;
  String textInRange(String fullText) {
    if (!isValid) return '';
    return fullText.substring(start, end);
  }
}

abstract class Clipboard {
  static String? _data;

  static Future<void> setData(String text) async {
    _data = text;
  }

  static Future<String?> getData() async {
    return _data;
  }

  static bool get hasData => _data != null && _data!.isNotEmpty;
}

class TextEditingController extends ChangeNotifier {
  String _text = '';
  int _cursorPosition = 0;
  int? _selectionStart;
  int? _selectionEnd;

  String get text => _text;
  int get cursorPosition => _cursorPosition;

  TextSelection? get selection {
    if (_selectionStart == null || _selectionEnd == null) return null;
    return TextSelection(start: _selectionStart!, end: _selectionEnd!);
  }

  bool get hasSelection => _selectionStart != null && _selectionEnd != null;

  set text(String value) {
    if (_text != value) {
      _text = value;
      _cursorPosition = _cursorPosition.clamp(0, _text.length);
      clearSelection();
      notifyListeners();
    }
  }

  set cursorPosition(int position) {
    final newPosition = position.clamp(0, _text.length);
    if (_cursorPosition != newPosition) {
      _cursorPosition = newPosition;
      clearSelection();
      notifyListeners();
    }
  }

  void setSelection(int start, int end) {
    _selectionStart = start.clamp(0, _text.length);
    _selectionEnd = end.clamp(_selectionStart!, _text.length);
    notifyListeners();
  }

  void clearSelection() {
    _selectionStart = null;
    _selectionEnd = null;
  }

  void selectAll() {
    _selectionStart = 0;
    _selectionEnd = _text.length;
    notifyListeners();
  }

  Future<void> copy() async {
    if (hasSelection) {
      await Clipboard.setData(selection!.textInRange(_text));
    }
  }

  Future<void> cut() async {
    if (hasSelection) {
      await Clipboard.setData(selection!.textInRange(_text));
      deleteSelection();
    }
  }

  Future<void> paste() async {
    final clipboardText = await Clipboard.getData();
    if (clipboardText != null && clipboardText.isNotEmpty) {
      if (hasSelection) {
        deleteSelection();
      }
      insertText(clipboardText);
    }
  }

  void deleteSelection() {
    if (!hasSelection) return;
    final sel = selection!;
    _text = _text.substring(0, sel.start) + _text.substring(sel.end);
    _cursorPosition = sel.start;
    clearSelection();
    notifyListeners();
  }

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

  void moveCursorLeft() {
    if (_cursorPosition > 0) {
      _cursorPosition--;
      clearSelection();
      notifyListeners();
    }
  }

  void moveCursorRight() {
    if (_cursorPosition < _text.length) {
      _cursorPosition++;
      clearSelection();
      notifyListeners();
    }
  }

  void moveCursorToStart() {
    _cursorPosition = 0;
    clearSelection();
    notifyListeners();
  }

  void moveCursorToEnd() {
    _cursorPosition = _text.length;
    clearSelection();
    notifyListeners();
  }

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

  void clear() {
    _text = '';
    _cursorPosition = 0;
    clearSelection();
    notifyListeners();
  }
}

class TextField extends StatefulWidget {
  const TextField({
    super.key,
    this.controller,
    this.placeholder,
    this.style,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
  });
  final TextEditingController? controller;
  final String? placeholder;
  final TextStyle? style;
  final int? maxLength;
  final Function(String)? onChanged;
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

class RenderTextField extends RenderBox {
  RenderTextField({
    required this.text,
    required this.cursorPosition,
    this.placeholder,
    this.style,
    required this.hasFocus,
  });
  String text;
  int cursorPosition;
  String? placeholder;
  TextStyle? style;
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
    if (offset.x > 0 && offset.y > 0) {
      context.buffer.writeStyled(offset.x - 1, offset.y - 1, '┌', borderStyle);
    }
    if (offset.x + width < bufferWidth && offset.y > 0) {
      context.buffer.writeStyled(
        offset.x + width,
        offset.y - 1,
        '┐',
        borderStyle,
      );
    }
    if (offset.x > 0 && offset.y + 1 < bufferHeight) {
      context.buffer.writeStyled(offset.x - 1, offset.y + 1, '└', borderStyle);
    }
    if (offset.x + width < bufferWidth && offset.y + 1 < bufferHeight) {
      context.buffer.writeStyled(
        offset.x + width,
        offset.y + 1,
        '┘',
        borderStyle,
      );
    }
  }
}
