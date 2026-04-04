import '../../../radartui.dart';

Widget _defaultSelectedBuilder<T>(T item) {
  return Text('> $item');
}

Widget _defaultUnselectedBuilder<T>(T item) {
  return Text('  $item');
}

class ScrollController extends ChangeNotifier {
  int _offset = 0;

  int get offset => _offset;

  set offset(int value) {
    if (_offset != value) {
      _offset = value;
      notifyListeners();
    }
  }

  void animateTo(int newOffset) {
    offset = newOffset;
  }
}

class ListView<T> extends StatefulWidget {
  const ListView({
    super.key,
    required this.items,
    Widget Function(T item)? selectedBuilder,
    Widget Function(T item)? unselectedBuilder,
    this.initialSelectedIndex = 0,
    this.onItemSelected,
    this.wrapAroundNavigation = false,
    this.controller,
    this.itemExtent,
  }) : selectedBuilder = selectedBuilder ?? _defaultSelectedBuilder,
       unselectedBuilder = unselectedBuilder ?? _defaultUnselectedBuilder;
  final List<T> items;
  final Widget Function(T item) selectedBuilder;
  final Widget Function(T item) unselectedBuilder;
  final int initialSelectedIndex;
  final void Function(int index, T item)? onItemSelected;
  final bool wrapAroundNavigation;
  final ScrollController? controller;
  final int? itemExtent;

  @override
  State<ListView<T>> createState() => _ListViewState<T>();
}

class _ListViewState<T> extends State<ListView<T>>
    with FocusableState<ListView<T>> {
  int selectedIndex = 0;
  late ScrollController _scrollController;
  bool _ownsController = false;
  int _viewportHeight = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex.clamp(
      0,
      widget.items.length - 1,
    );

    if (widget.controller != null) {
      _scrollController = widget.controller!;
    } else {
      _scrollController = ScrollController();
      _ownsController = true;
    }

    _scrollController.addListener(_onScrollChanged);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollChanged);
    if (_ownsController) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScrollChanged() {
    setState(() {});
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.arrowUp ||
        (event.code == KeyCode.char && event.char == 'k')) {
      _moveSelection(-1);
    } else if (event.code == KeyCode.arrowDown ||
        (event.code == KeyCode.char && event.char == 'j')) {
      _moveSelection(1);
    } else if (event.code == KeyCode.enter ||
        event.code == KeyCode.space ||
        (event.code == KeyCode.char && event.char == ' ')) {
      if (selectedIndex >= 0 && selectedIndex < widget.items.length) {
        widget.onItemSelected?.call(selectedIndex, widget.items[selectedIndex]);
      }
    }
  }

  void _moveSelection(int direction) {
    setState(() {
      if (widget.wrapAroundNavigation) {
        selectedIndex = (selectedIndex + direction) % widget.items.length;
        if (selectedIndex < 0) {
          selectedIndex = widget.items.length - 1;
        }
      } else {
        selectedIndex = (selectedIndex + direction).clamp(
          0,
          widget.items.length - 1,
        );
      }
      _ensureVisible(selectedIndex);
    });
  }

  void _ensureVisible(int index) {
    if (_viewportHeight <= 0) return;

    final scrollOffset = _scrollController.offset;
    final bottomVisible = scrollOffset + _viewportHeight - 1;

    if (index < scrollOffset) {
      _scrollController.animateTo(index);
    } else if (index > bottomVisible) {
      _scrollController.animateTo(index - _viewportHeight + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = context.findAncestorWidgetOfExactType<MediaQuery>();
    _viewportHeight = mediaQuery?.data.size.height ?? 24;

    final itemCount = widget.items.length;
    if (itemCount == 0) {
      return const SizedBox();
    }

    final scrollOffset = _scrollController.offset.clamp(0, itemCount - 1);
    final visibleCount = _viewportHeight.clamp(1, itemCount);
    final endIndex = (scrollOffset + visibleCount).clamp(0, itemCount);

    final children = <Widget>[];

    for (int i = scrollOffset; i < endIndex; i++) {
      final item = widget.items[i];
      final isSelected = i == selectedIndex && hasFocus;
      children.add(
        isSelected
            ? widget.selectedBuilder(item)
            : widget.unselectedBuilder(item),
      );
    }

    return Column(children: children);
  }
}
