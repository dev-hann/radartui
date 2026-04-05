import '../../../radartui.dart';

Widget _defaultSelectedBuilder<T>(T item) {
  return Text('> $item');
}

Widget _defaultUnselectedBuilder<T>(T item) {
  return Text('  $item');
}

/// A scrollable list of selectable items with keyboard navigation.
///
/// Supports custom [selectedBuilder] and [unselectedBuilder] for rendering
/// each item. Arrow keys navigate, Enter/Space selects.
class ListView<T> extends StatefulWidget {
  /// Creates a [ListView] with the given [items] and optional builders.
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
  })  : selectedBuilder = selectedBuilder ?? _defaultSelectedBuilder,
        unselectedBuilder = unselectedBuilder ?? _defaultUnselectedBuilder;

  /// The list of items to display.
  final List<T> items;

  /// A builder that creates the widget for the currently selected item.
  final Widget Function(T item) selectedBuilder;

  /// A builder that creates the widget for unselected items.
  final Widget Function(T item) unselectedBuilder;

  /// The index of the item initially selected.
  final int initialSelectedIndex;

  /// A callback invoked when the user presses Enter or Space on an item.
  final void Function(int index, T item)? onItemSelected;

  /// Whether navigation wraps around at the top and bottom of the list.
  final bool wrapAroundNavigation;

  /// An optional external scroll controller.
  final ScrollController? controller;

  /// An optional fixed height for each item row.
  final int? itemExtent;

  @override
  State<ListView<T>> createState() => _ListViewState<T>();
}

class _ListViewState<T> extends State<ListView<T>>
    with FocusableState<ListView<T>>, ScrollableState<ListView<T>> {
  int selectedIndex = 0;
  int _viewportHeight = 0;

  @override
  ScrollController? get providedScrollController => widget.controller;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex.clamp(
      0,
      widget.items.length - 1,
    );
  }

  @override
  void onKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.arrowUp ||
        (event.code == KeyCode.char && event.char == 'k')) {
      _moveSelection(-1);
    } else if (event.code == KeyCode.arrowDown ||
        (event.code == KeyCode.char && event.char == 'j')) {
      _moveSelection(1);
    } else if (event.isActivationKey) {
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

    final scrollOffset = scrollController.offset;
    final bottomVisible = scrollOffset + _viewportHeight - 1;

    if (index < scrollOffset) {
      scrollController.animateTo(index);
    } else if (index > bottomVisible) {
      scrollController.animateTo(index - _viewportHeight + 1);
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

    final scrollOffset = scrollController.offset.clamp(0, itemCount - 1);
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
