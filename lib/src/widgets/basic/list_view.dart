import '../../../radartui.dart';
import 'selectable_defaults.dart';

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
  })  : selectedBuilder = selectedBuilder ?? defaultSelectedBuilder,
        unselectedBuilder = unselectedBuilder ?? defaultUnselectedBuilder;

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
    final totalItems = widget.items.length;
    switch (event.code) {
      case KeyCode.arrowUp:
        _moveSelection(-1);
      case KeyCode.arrowDown:
        _moveSelection(1);
      case KeyCode.char:
        _handleCharKey(event.char, totalItems);
      default:
        _handleActivationKey(event.isActivationKey, totalItems);
    }
  }

  void _handleCharKey(String? char, int totalItems) {
    if (char == _vimUpKey) {
      _moveSelection(-1);
    } else if (char == _vimDownKey) {
      _moveSelection(1);
    }
  }

  static const String _vimUpKey = 'k';
  static const String _vimDownKey = 'j';

  void _handleActivationKey(bool isActivationKey, int totalItems) {
    if (isActivationKey && selectedIndex >= 0 && selectedIndex < totalItems) {
      widget.onItemSelected?.call(selectedIndex, widget.items[selectedIndex]);
    }
  }

  void _moveSelection(int direction) {
    setState(() {
      final totalItems = widget.items.length;
      if (widget.wrapAroundNavigation) {
        selectedIndex =
            wrapSelectableIndex(selectedIndex + direction, totalItems);
      } else {
        selectedIndex = (selectedIndex + direction).clamp(
          0,
          totalItems - 1,
        );
      }
      scrollController.ensureVisible(selectedIndex, _viewportHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = context.findAncestorWidgetOfExactType<MediaQuery>();
    _viewportHeight = mediaQuery?.data.size.height ?? 24;

    final itemCount = widget.items.length;
    if (widget.items.isEmpty) {
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
