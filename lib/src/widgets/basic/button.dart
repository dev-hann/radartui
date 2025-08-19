import 'package:radartui/radartui.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final ButtonStyle? style;
  final FocusNode? focusNode;

  const Button({
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.style,
    this.focusNode,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode(); // FocusNode auto-registers on creation
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!widget.enabled) return;

    if (event.code == KeyCode.enter || event.code == KeyCode.space) {
      widget.onPressed?.call();
    }
  }

  void _onTap() {
    if (!widget.enabled) return;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return _ButtonRenderWidget(
      text: widget.text,
      enabled: widget.enabled,
      focused: _focusNode.hasFocus,
      style: widget.style ?? const ButtonStyle(),
      onTap: _onTap,
    );
  }
}

class _ButtonRenderWidget extends RenderObjectWidget {
  final String text;
  final bool enabled;
  final bool focused;
  final ButtonStyle style;
  final VoidCallback? onTap;

  const _ButtonRenderWidget({
    required this.text,
    required this.enabled,
    required this.focused,
    required this.style,
    this.onTap,
  });

  @override
  RenderObjectElement createElement() => RenderObjectElement(this);

  @override
  RenderButton createRenderObject(BuildContext context) => RenderButton(
    text: text,
    enabled: enabled,
    focused: focused,
    style: style,
    onTap: onTap,
  );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final renderButton = renderObject as RenderButton;
    renderButton.text = text;
    renderButton.enabled = enabled;
    renderButton.focused = focused;
    renderButton.style = style;
    renderButton.onTap = onTap;
  }
}

class RenderButton extends RenderBox {
  String text;
  bool enabled;
  bool focused;
  ButtonStyle style;
  VoidCallback? onTap;

  RenderButton({
    required this.text,
    required this.enabled,
    required this.focused,
    required this.style,
    this.onTap,
  });

  @override
  void performLayout(Constraints constraints) {
    final padding = style.padding;
    final width = text.length + padding.left + padding.right;
    final height = 1 + padding.top + padding.bottom;
    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final padding = style.padding;
    final textStyle = _getTextStyle();
    final backgroundColor = _getBackgroundColor();

    // Draw background
    for (int y = 0; y < size!.height; y++) {
      for (int x = 0; x < size!.width; x++) {
        context.buffer.writeStyled(
          offset.x + x,
          offset.y + y,
          ' ',
          TextStyle(backgroundColor: backgroundColor),
        );
      }
    }

    // Draw border if focused
    if (focused) {
      _drawBorder(context, offset);
    }

    // Draw text
    final textX = offset.x + padding.left;
    final textY = offset.y + padding.top;
    for (int i = 0; i < text.length; i++) {
      context.buffer.writeStyled(textX + i, textY, text[i], textStyle);
    }
  }

  void _drawBorder(PaintingContext context, Offset offset) {
    final borderStyle = TextStyle(
      color: style.focusColor,
      backgroundColor: _getBackgroundColor(),
    );

    // Top and bottom borders
    for (int x = 0; x < size!.width; x++) {
      context.buffer.writeStyled(offset.x + x, offset.y, '─', borderStyle);
      context.buffer.writeStyled(
        offset.x + x,
        offset.y + size!.height - 1,
        '─',
        borderStyle,
      );
    }

    // Left and right borders
    for (int y = 0; y < size!.height; y++) {
      context.buffer.writeStyled(offset.x, offset.y + y, '│', borderStyle);
      context.buffer.writeStyled(
        offset.x + size!.width - 1,
        offset.y + y,
        '│',
        borderStyle,
      );
    }

    // Corners
    context.buffer.writeStyled(offset.x, offset.y, '┌', borderStyle);
    context.buffer.writeStyled(
      offset.x + size!.width - 1,
      offset.y,
      '┐',
      borderStyle,
    );
    context.buffer.writeStyled(
      offset.x,
      offset.y + size!.height - 1,
      '└',
      borderStyle,
    );
    context.buffer.writeStyled(
      offset.x + size!.width - 1,
      offset.y + size!.height - 1,
      '┘',
      borderStyle,
    );
  }

  TextStyle _getTextStyle() {
    Color textColor;
    if (!enabled) {
      textColor = style.disabledColor;
    } else if (focused) {
      textColor = style.focusColor;
    } else {
      textColor = style.foregroundColor;
    }

    return TextStyle(
      color: textColor,
      backgroundColor: _getBackgroundColor(),
      bold: style.bold,
    );
  }

  Color _getBackgroundColor() {
    if (!enabled) {
      return style.disabledBackgroundColor;
    } else if (focused) {
      return style.focusBackgroundColor;
    } else {
      return style.backgroundColor;
    }
  }
}

class ButtonStyle {
  final Color foregroundColor;
  final Color backgroundColor;
  final Color focusColor;
  final Color focusBackgroundColor;
  final Color disabledColor;
  final Color disabledBackgroundColor;
  final EdgeInsets padding;
  final bool bold;

  const ButtonStyle({
    this.foregroundColor = Color.white,
    this.backgroundColor = Color.blue,
    this.focusColor = Color.brightWhite,
    this.focusBackgroundColor = Color.brightBlue,
    this.disabledColor = Color.brightBlack,
    this.disabledBackgroundColor = Color.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
    this.bold = false,
  });
}
