import '../services.dart';
import 'basic/focus.dart';
import 'focus_manager.dart';
import 'framework.dart';

/// A mixin for [State] subclasses that need focus management.
///
/// Automatically registers and unregisters a [FocusNode] with the [FocusManager],
/// handling ownership of the node (provided vs. internally created).
mixin FocusableState<T extends StatefulWidget> on State<T> {
  late FocusNode _focusNode;
  bool _isFocusNodeOwned = false;
  bool _hasFocus = false;

  /// Override to provide an external [FocusNode], or return null to use an internal one.
  FocusNode? get providedFocusNode => null;

  /// Called when a key event is received while this widget has focus.
  void onKeyEvent(KeyEvent event);

  /// Whether this widget currently has focus.
  bool get hasFocus => _hasFocus;

  /// The [FocusNode] used by this widget.
  FocusNode get focusNode => _focusNode;

  /// Called when the focus state changes. Override to respond to focus changes.
  void onFocusChange(bool focused) {}

  void _onFocusChange() {
    final bool focused = _focusNode.hasFocus;
    setState(() {
      _hasFocus = focused;
    });
    onFocusChange(focused);
  }

  void _swapFocusNode(FocusNode newProvidedNode) {
    _focusNode.removeListener(_onFocusChange);
    FocusManager.instance.unregisterNode(_focusNode);
    if (_isFocusNodeOwned) {
      _focusNode.dispose();
    }

    _focusNode = newProvidedNode;
    _isFocusNodeOwned = false;
    FocusManager.instance.registerNode(_focusNode);
    _focusNode.onKeyEvent = onKeyEvent;
    _focusNode.addListener(_onFocusChange);
    _hasFocus = _focusNode.hasFocus;
  }

  @override
  void initState() {
    super.initState();
    _focusNode = providedFocusNode ?? FocusNode();
    _isFocusNodeOwned = providedFocusNode == null;
    FocusManager.instance.registerNode(_focusNode);
    _focusNode.onKeyEvent = onKeyEvent;
    _focusNode.addListener(_onFocusChange);
    _hasFocus = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newProvidedNode = providedFocusNode;
    if (newProvidedNode != null && newProvidedNode != _focusNode) {
      _swapFocusNode(newProvidedNode!);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    FocusManager.instance.unregisterNode(_focusNode);
    if (_isFocusNodeOwned) {
      _focusNode.dispose();
    }
    super.dispose();
  }
}
