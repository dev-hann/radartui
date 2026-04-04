import 'framework.dart';
import 'scroll_controller.dart';

mixin ScrollableState<T extends StatefulWidget> on State<T> {
  late ScrollController _scrollController;
  bool _ownsScrollController = false;

  ScrollController? get providedScrollController => null;

  ScrollController get scrollController => _scrollController;

  void _onScrollChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = providedScrollController ?? ScrollController();
    _ownsScrollController = providedScrollController == null;
    _scrollController.addListener(_onScrollChanged);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newController = providedScrollController;
    if (newController != _scrollController) {
      _scrollController.removeListener(_onScrollChanged);
      if (_ownsScrollController) {
        _scrollController.dispose();
      }
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
