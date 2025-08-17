import 'dart:async';
import '../../foundation/color.dart';
import '../../foundation/offset.dart';
import '../../foundation/size.dart';
import '../../rendering/render_box.dart';
import '../../rendering/render_object.dart';
import '../../services/key_parser.dart';
import 'focus.dart';
import '../framework.dart';

class TextEditingController {
  String _text = '';
  int _cursorPosition = 0;
  final List<Function()> _listeners = [];

  String get text => _text;
  int get cursorPosition => _cursorPosition;

  set text(String value) {
    if (_text != value) {
      _text = value;
      _cursorPosition = _cursorPosition.clamp(0, _text.length);
      notifyListeners();
    }
  }

  set cursorPosition(int position) {
    final newPosition = position.clamp(0, _text.length);
    if (_cursorPosition != newPosition) {
      _cursorPosition = newPosition;
      notifyListeners();
    }
  }

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void insertText(String text) {
    _text = _text.substring(0, _cursorPosition) + 
            text + 
            _text.substring(_cursorPosition);
    _cursorPosition += text.length;
    notifyListeners();
  }

  void deleteBackward() {
    if (_cursorPosition > 0) {
      _text = _text.substring(0, _cursorPosition - 1) + 
              _text.substring(_cursorPosition);
      _cursorPosition--;
      notifyListeners();
    }
  }

  void deleteForward() {
    if (_cursorPosition < _text.length) {
      _text = _text.substring(0, _cursorPosition) + 
              _text.substring(_cursorPosition + 1);
      notifyListeners();
    }
  }

  void moveCursorLeft() {
    if (_cursorPosition > 0) {
      _cursorPosition--;
      notifyListeners();
    }
  }

  void moveCursorRight() {
    if (_cursorPosition < _text.length) {
      _cursorPosition++;
      notifyListeners();
    }
  }

  void moveCursorToStart() {
    _cursorPosition = 0;
    notifyListeners();
  }

  void moveCursorToEnd() {
    _cursorPosition = _text.length;
    notifyListeners();
  }

  void clear() {
    _text = '';
    _cursorPosition = 0;
    notifyListeners();
  }

  void dispose() {
    _listeners.clear();
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
    _focusNode.dispose();
    super.dispose();
  }

  bool _isProcessingChange = false;
  
  void _onControllerChanged() {
    if (_isProcessingChange) return;
    
    _isProcessingChange = true;
    try {
      // Immediately update the UI
      setState(() {});
      
      // Call onChanged immediately to avoid timing issues
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    } finally {
      _isProcessingChange = false;
    }
  }

  void _onFocusChanged() {
    // Use microtask to avoid conflicts with other focus changes happening simultaneously
    scheduleMicrotask(() {
      setState(() {});
    });
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
    return Focus(
      focusNode: _focusNode,
      child: _TextField(
        text: _controller.text,
        cursorPosition: _controller.cursorPosition,
        placeholder: widget.placeholder,
        style: widget.style,
        hasFocus: _focusNode.hasFocus,
      ),
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
  Size? size;

  RenderTextField({
    required this.text,
    required this.cursorPosition,
    this.placeholder,
    this.style,
    required this.hasFocus,
  });

  void performLayout(Constraints constraints) {
    final displayText = text.isEmpty && placeholder != null ? placeholder! : text;
    final desiredWidth = displayText.length + 1;
    final boxConstraints = constraints as BoxConstraints;
    size = boxConstraints.constrain(Size(desiredWidth, 1));
  }

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
    
    // Draw simple focused border (underline)
    for (int x = 0; x < width; x++) {
      context.buffer.writeStyled(
        offset.x + x, 
        offset.y - 1, 
        '─', 
        borderStyle
      );
      context.buffer.writeStyled(
        offset.x + x, 
        offset.y + 1, 
        '─', 
        borderStyle
      );
    }
    
    // Draw side borders
    context.buffer.writeStyled(offset.x - 1, offset.y, '│', borderStyle);
    context.buffer.writeStyled(offset.x + width, offset.y, '│', borderStyle);
    
    // Draw corners
    context.buffer.writeStyled(offset.x - 1, offset.y - 1, '┌', borderStyle);
    context.buffer.writeStyled(offset.x + width, offset.y - 1, '┐', borderStyle);
    context.buffer.writeStyled(offset.x - 1, offset.y + 1, '└', borderStyle);
    context.buffer.writeStyled(offset.x + width, offset.y + 1, '┘', borderStyle);
  }
}