import 'framework.dart';
import 'scroll_controller.dart';

/// A mixin for [State] subclasses that need scroll management.
///
/// Automatically manages a [ScrollController], handling ownership (provided vs.
/// internally created) and rebuilding on scroll changes.
mixin ScrollableState<T extends StatefulWidget> on State<T> {
  late ScrollController _scrollController;
  bool _ownsScrollController = false;
  ScrollController? _providedController;

  /// Override to provide an external [ScrollController], or return null to use an internal one.
  ScrollController? get providedScrollController => null;

  /// The [ScrollController] used by this widget.
  ScrollController get scrollController => _scrollController;

  void _onScrollChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _providedController = providedScrollController;
    _scrollController = _providedController ?? ScrollController();
    _ownsScrollController = _providedController == null;
    _scrollController.addListener(_onScrollChanged);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ScrollController? newController = providedScrollController;
    if (newController != _providedController) {
      _scrollController.removeListener(_onScrollChanged);
      if (_ownsScrollController) {
        _scrollController.dispose();
      }
      _providedController = newController;
      _scrollController = newController ?? ScrollController();
      _ownsScrollController = newController == null;
      _scrollController.addListener(_onScrollChanged);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    if (_ownsScrollController) {
      _scrollController.dispose();
    }
    super.dispose();
  }
}
