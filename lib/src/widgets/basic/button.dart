import '../../../radartui.dart';

/// A pressable button widget that responds to keyboard input.
///
/// Use [onPressed] for click handling. Supports [style] and [focusStyle]
/// customization, and [enabled] for disabled state.
class Button extends StatefulWidget {
  /// Creates a [Button] displaying [text] with an optional [onPressed] callback.
  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.style,
    this.focusNode,
  });

  /// The label text displayed on the button.
  final String text;

  /// Called when the button is activated via Enter or Space.
  final VoidCallback? onPressed;

  /// Whether the button is interactive.
  final bool enabled;

  /// The visual style configuration for the button.
  final ButtonStyle? style;

  /// An optional focus node for keyboard navigation.
  final FocusNode? focusNode;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with FocusableState<Button> {
  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void onKeyEvent(KeyEvent event) {
    if (!widget.enabled) return;

    if (event.isActivationKey) {
      widget.onPressed?.call();
    }
  }

  void _onTap() {
    if (!widget.enabled) return;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? const ButtonStyle();

    return _ButtonRenderWidget(
      text: widget.text,
      enabled: widget.enabled,
      focused: hasFocus,
      style: style,
      onTap: _onTap,
    );
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

/// Render object that paints a button with background, text, and focus styling.
class RenderButton extends RenderBox {
  RenderButton({
    required String text,
    required bool enabled,
    required bool focused,
    required ButtonStyle style,
    this.onTap,
  })  : _text = text,
        _enabled = enabled,
        _focused = focused,
        _style = style {
    _cachedTextWidth = stringWidth(_text);
  }

  String _text;
  String get text => _text;
  set text(String value) {
    if (_text == value) return;
    _text = value;
    _cachedTextWidth = stringWidth(_text);
  }

  bool _enabled;
  bool get enabled => _enabled;
  set enabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    _invalidateStyleCache();
  }

  bool _focused;
  bool get focused => _focused;
  set focused(bool value) {
    if (_focused == value) return;
    _focused = value;
    _invalidateStyleCache();
  }

  ButtonStyle _style;
  ButtonStyle get style => _style;
  set style(ButtonStyle value) {
    if (_style == value) return;
    _style = value;
    _invalidateStyleCache();
  }

  VoidCallback? onTap;

  TextStyle? _cachedTextStyle;
  TextStyle? _cachedBgStyle;
  late int _cachedTextWidth;

  void _invalidateStyleCache() {
    _cachedTextStyle = null;
    _cachedBgStyle = null;
  }

  @override
  void performLayout(Constraints constraints) {
    final padding = style.padding;
    final width = _cachedTextWidth + padding.left + padding.right;
    final height = 1 + padding.top + padding.bottom;
    size = Size(width, height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final EdgeInsets padding = _style.padding;
    _ensureStylesCached();
    final TextStyle textStyle = _cachedTextStyle!;
    final TextStyle bgStyle = _cachedBgStyle!;

    for (int y = 0; y < size!.height; y++) {
      context.fillBackground(offset.x, offset.y + y, size!.width, bgStyle);
    }

    final int textY = offset.y + padding.top;
    context.writeString(offset.x + padding.left, textY, text, textStyle);
  }

  void _ensureStylesCached() {
    if (_cachedTextStyle != null && _cachedBgStyle != null) return;
    final Color bgColor = _getBackgroundColor();
    _cachedBgStyle = TextStyle(backgroundColor: bgColor);
    Color textColor;
    if (!_enabled) {
      textColor = _style.disabledColor;
    } else if (_focused) {
      textColor = _style.focusColor;
    } else {
      textColor = _style.foregroundColor;
    }
    _cachedTextStyle = TextStyle(
      color: textColor,
      backgroundColor: bgColor,
      bold: _style.bold,
    );
  }

  Color _getBackgroundColor() {
    if (!_enabled) {
      return _style.disabledBackgroundColor;
    } else if (_focused) {
      return _style.focusBackgroundColor;
    } else {
      return _style.backgroundColor;
    }
  }
}

/// Defines the visual style properties for a [Button].
class ButtonStyle {
  /// Creates a [ButtonStyle] with customizable colors, padding, and bold flag.
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

  /// The text color in the normal (unfocused, enabled) state.
  final Color foregroundColor;

  /// The background color in the normal state.
  final Color backgroundColor;

  /// The text color when the button has focus.
  final Color focusColor;

  /// The background color when the button has focus.
  final Color focusBackgroundColor;

  /// The text color when the button is disabled.
  final Color disabledColor;

  /// The background color when the button is disabled.
  final Color disabledBackgroundColor;

  /// Padding around the button label.
  final EdgeInsets padding;

  /// Whether the button text is rendered bold.
  final bool bold;

  /// Creates a copy of this style with the given fields replaced.
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
