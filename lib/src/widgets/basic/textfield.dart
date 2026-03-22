import 'dart:async';
import '../../../radartui.dart';

class TextSelection {
  final int start;
  final int end;
  
  const TextSelection({required this.start, required this.end});
  
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
  final TextEditingController? controller;
  final String? placeholder;
  final TextStyle? style;
  final int? maxLength;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const TextField({
    super.key,
    this.controller,
    this.placeholder,
    this.style,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
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
    
    _focusNode = FocusNode();
    FocusManager.instance.registerNode(_focusNode);
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChanged);
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
    
    // Unregister from FocusManager before disposing
    FocusManager.instance.unregisterNode(_focusNode);
    _focusNode.dispose();
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

  void _onFocusChanged() {
    // Use immediate setState to prevent interference with rapid text input
    setState(() {});
  }

  // Public method to request focus like ListView pattern
  void requestFocus() {
    FocusManager.instance.requestFocus(_focusNode);
  }

  void _handleKeyEvent(KeyEvent event) {
    switch (event.code) {
      case KeyCode.char:
        if (event.char != null) {
          if (widget.maxLength == null || _controller.text.length < widget.maxLength!) {
            _controller.insertText(event.char!);
          }
        }
        break;
      case KeyCode.backspace:
        _controller.deleteBackward();
        break;
      case KeyCode.delete:
        _controller.deleteForward();
        break;
      case KeyCode.arrowLeft:
        _controller.moveCursorLeft();
        break;
      case KeyCode.arrowRight:
        _controller.moveCursorRight();
        break;
      case KeyCode.home:
        _controller.moveCursorToStart();
        break;
      case KeyCode.end:
        _controller.moveCursorToEnd();
        break;
      case KeyCode.enter:
        if (widget.onSubmitted != null) {
          widget.onSubmitted!(_controller.text);
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build directly without Focus wrapper - like ListView does
    return _TextField(
      text: _controller.text,
      cursorPosition: _controller.cursorPosition,
      placeholder: widget.placeholder,
      style: widget.style,
      hasFocus: _focusNode.hasFocus,
    );
  }
}

class _TextField extends RenderObjectWidget {
  final String text;
  final int cursorPosition;
  final String? placeholder;
  final TextStyle? style;
  final bool hasFocus;

  const _TextField({
    required this.text,
    required this.cursorPosition,
    this.placeholder,
    this.style,
    required this.hasFocus,
  });

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
  String text;
  int cursorPosition;
  String? placeholder;
  TextStyle? style;
  bool hasFocus;

  RenderTextField({
    required this.text,
    required this.cursorPosition,
    this.placeholder,
    this.style,
    required this.hasFocus,
  });

  @override
  void performLayout(Constraints constraints) {
    final displayText = text.isEmpty && placeholder != null ? placeholder! : text;
    final desiredWidth = (displayText.length + 1).clamp(1, Constraints.infinity);
    final boxConstraints = constraints.asBoxConstraints;
    size = boxConstraints.constrain(Size(desiredWidth, 1));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final displayText = text.isEmpty && placeholder != null ? placeholder! : text;
    
    // Enhanced styling for better TUI appearance
    final baseStyle = style ?? const TextStyle(color: Color.white);
    final placeholderStyle = TextStyle(
      color: Color.brightBlack,
      backgroundColor: baseStyle.backgroundColor,
      bold: false,
      italic: true,
      underline: false,
    );
    final displayStyle = text.isEmpty && placeholder != null ? placeholderStyle : baseStyle;
    
    // Draw border if focused
    if (hasFocus) {
      _drawBorder(context, offset, size!);
    }

    final availableWidth = size!.width;
    final textLength = displayText.length;
    
    // Calculate scroll offset to keep cursor visible
    int scrollOffset = 0;
    if (textLength >= availableWidth) {
      // Ensure cursor is visible within the available width
      if (cursorPosition >= availableWidth) {
        scrollOffset = cursorPosition - availableWidth + 1;
      }
    }
    
    // Render visible portion of text
    final visibleStart = scrollOffset;
    final visibleEnd = (scrollOffset + availableWidth).clamp(0, textLength);
    
    for (int i = visibleStart; i < visibleEnd; i++) {
      final screenX = offset.x + i - scrollOffset;
      context.buffer.writeStyled(screenX, offset.y, displayText[i], displayStyle);
    }

    // Render enhanced cursor
    if (hasFocus) {
      final cursorScreenX = offset.x + cursorPosition - scrollOffset;
      
      // Only render cursor if it's within visible area
      if (cursorScreenX >= offset.x && cursorScreenX < offset.x + availableWidth) {
        if (cursorPosition < text.length) {
          // Cursor on existing character - use reverse video effect
          const cursorStyle = TextStyle(
            color: Color.black,
            backgroundColor: Color.cyan,
            bold: true,
          );
          context.buffer.writeStyled(cursorScreenX, offset.y, text[cursorPosition], cursorStyle);
        } else {
          // Cursor at end of text - show block cursor
          const cursorStyle = TextStyle(
            color: Color.black,
            backgroundColor: Color.cyan,
            bold: true,
          );
          context.buffer.writeStyled(cursorScreenX, offset.y, '█', cursorStyle);
        }
      }
    }
  }
  
  void _drawBorder(PaintingContext context, Offset offset, Size size) {
    const borderStyle = TextStyle(color: Color.cyan, bold: true);
    final width = size.width.toInt();
    final bufferHeight = context.buffer.terminal.height;
    final bufferWidth = context.buffer.terminal.width;

    if (offset.y > 0) {
      for (int x = 0; x < width; x++) {
        final posX = offset.x + x;
        if (posX >= 0 && posX < bufferWidth) {
          context.buffer.writeStyled(posX, offset.y - 1, '─', borderStyle);
        }
      }
    }

    if (offset.y + 1 < bufferHeight) {
      for (int x = 0; x < width; x++) {
        final posX = offset.x + x;
        if (posX >= 0 && posX < bufferWidth) {
          context.buffer.writeStyled(posX, offset.y + 1, '─', borderStyle);
        }
      }
    }

    if (offset.x > 0) {
      context.buffer.writeStyled(offset.x - 1, offset.y, '│', borderStyle);
    }

    if (offset.x + width < bufferWidth) {
      context.buffer.writeStyled(offset.x + width, offset.y, '│', borderStyle);
    }

    if (offset.x > 0 && offset.y > 0) {
      context.buffer.writeStyled(offset.x - 1, offset.y - 1, '┌', borderStyle);
    }
    if (offset.x + width < bufferWidth && offset.y > 0) {
      context.buffer.writeStyled(offset.x + width, offset.y - 1, '┐', borderStyle);
    }
    if (offset.x > 0 && offset.y + 1 < bufferHeight) {
      context.buffer.writeStyled(offset.x - 1, offset.y + 1, '└', borderStyle);
    }
    if (offset.x + width < bufferWidth && offset.y + 1 < bufferHeight) {
      context.buffer.writeStyled(offset.x + width, offset.y + 1, '┘', borderStyle);
    }
  }
}