import '../services.dart';
import 'basic/focus.dart';
import 'focus_manager.dart';
import 'framework.dart';

mixin FocusableState<T extends StatefulWidget> on State<T> {
  late FocusNode _focusNode;
  bool _isFocusNodeOwned = false;
  bool _hasFocus = false;

  FocusNode? get providedFocusNode => null;

  void onKeyEvent(KeyEvent event);

  bool get hasFocus => _hasFocus;

  FocusNode get focusNode => _focusNode;

  void onFocusChange(bool focused) {}

  void _onFocusChange() {
    final bool focused = _focusNode.hasFocus;
    setState(() {
      _hasFocus = focused;
    });
    onFocusChange(focused);
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
