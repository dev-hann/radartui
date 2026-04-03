import '../../../radartui.dart';

class Button extends StatefulWidget {
  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.style,
    this.focusNode,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final ButtonStyle? style;
  final FocusNode? focusNode;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with FocusableState<Button> {
  late AnimationController _controller;
  late Animation<Color> _colorAnim;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
    );
    _colorAnim = ColorTween(
      begin: widget.style?.backgroundColor ?? Color.blue,
      end: widget.style?.focusBackgroundColor ?? Color.brightBlue,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.addListener(() => setState(() {}));
  }

  @override
  void onFocusChange(bool focused) {
    super.onFocusChange(focused);
    if (focused) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (!widget.enabled) return;

    if (event.code == KeyCode.enter ||
        event.code == KeyCode.space ||
        (event.code == KeyCode.char && event.char == ' ')) {
      widget.onPressed?.call();
    }
  }

  void _onTap() {
    if (!widget.enabled) return;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final currentBackgroundColor = _colorAnim.value;
    final style = (widget.style ?? const ButtonStyle()).copyWith(
      backgroundColor: currentBackgroundColor,
    );

    return _ButtonRenderWidget(
      text: widget.text,
      enabled: widget.enabled,
      focused: hasFocus,
      style: style,
      onTap: _onTap,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ButtonRenderWidget extends RenderObjectWidget {
  const _ButtonRenderWidget({
    required this.text,
    required this.enabled,
    required this.focused,
    required this.style,
    this.onTap,
  });
  final String text;
  final bool enabled;
  final bool focused;
  final ButtonStyle style;
  final VoidCallback? onTap;

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
  RenderButton({
    required this.text,
    required this.enabled,
    required this.focused,
    required this.style,
    this.onTap,
  });
  String text;
  bool enabled;
  bool focused;
  ButtonStyle style;
  VoidCallback? onTap;

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

    if (focused) {
      _drawBorder(context, offset);
    }

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

    for (int x = 0; x < size!.width; x++) {
      context.buffer.writeStyled(offset.x + x, offset.y, '─', borderStyle);
      context.buffer.writeStyled(
        offset.x + x,
        offset.y + size!.height - 1,
        '─',
        borderStyle,
      );
    }

    for (int y = 0; y < size!.height; y++) {
      context.buffer.writeStyled(offset.x, offset.y + y, '│', borderStyle);
      context.buffer.writeStyled(
        offset.x + size!.width - 1,
        offset.y + y,
        '│',
        borderStyle,
      );
    }

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
  final Color foregroundColor;
  final Color backgroundColor;
  final Color focusColor;
  final Color focusBackgroundColor;
  final Color disabledColor;
  final Color disabledBackgroundColor;
  final EdgeInsets padding;
  final bool bold;

  ButtonStyle copyWith({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? focusColor,
    Color? focusBackgroundColor,
    Color? disabledColor,
    Color? disabledBackgroundColor,
    EdgeInsets? padding,
    bool? bold,
  }) {
    return ButtonStyle(
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      focusColor: focusColor ?? this.focusColor,
      focusBackgroundColor: focusBackgroundColor ?? this.focusBackgroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      padding: padding ?? this.padding,
      bold: bold ?? this.bold,
    );
  }
}
