import 'package:radartui/src/foundation/color.dart';
import 'package:radartui/src/foundation/offset.dart';
import 'package:radartui/src/foundation/size.dart';
import 'package:radartui/src/rendering/render_box.dart';
import 'package:radartui/src/rendering/render_object.dart';
import 'package:radartui/src/services/key_parser.dart';
import 'package:radartui/src/widgets/basic/focus.dart';
import 'package:radartui/src/widgets/framework.dart';

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

  void _onControllerChanged() {
    setState(() {});
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  void _onFocusChanged() {
    setState(() {});
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
    size = Size(displayText.length + 1, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final displayText = text.isEmpty && placeholder != null ? placeholder! : text;
    final displayStyle = text.isEmpty && placeholder != null 
        ? TextStyle(color: Color.brightBlack)
        : style;

    for (int i = 0; i < displayText.length; i++) {
      context.buffer.writeStyled(offset.x + i, offset.y, displayText[i], displayStyle);
    }

    if (hasFocus) {
      final cursorStyle = TextStyle(
        backgroundColor: Color.white,
        color: Color.black,
      );
      
      if (cursorPosition < text.length) {
        context.buffer.writeStyled(
          offset.x + cursorPosition, 
          offset.y, 
          text[cursorPosition], 
          cursorStyle
        );
      } else {
        context.buffer.writeStyled(
          offset.x + cursorPosition, 
          offset.y, 
          ' ', 
          cursorStyle
        );
      }
    }
  }
}