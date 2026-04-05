import '../../../radartui.dart';
import 'selectable_defaults.dart';

/// A scrollable grid of selectable items with keyboard navigation.
///
/// Uses [selectedBuilder] and [unselectedBuilder] to customize the appearance
/// of items. Supports arrow-key navigation and Enter to select.
class GridView<T> extends StatefulWidget {
  /// Creates a [GridView] with the given [items] and optional builders.
  const GridView({
    super.key,
    required this.items,
    Widget Function(T item)? selectedBuilder,
    Widget Function(T item)? unselectedBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.initialSelectedIndex = 0,
    this.onItemSelected,
    this.wrapAroundNavigation = false,
  })  : selectedBuilder = selectedBuilder ?? defaultSelectedBuilder,
        unselectedBuilder = unselectedBuilder ?? defaultUnselectedBuilder;

  /// The list of data items to display in the grid.
  final List<T> items;

  /// Builder for the currently selected item's appearance.
  final Widget Function(T item) selectedBuilder;

  /// Builder for unselected items' appearance.
  final Widget Function(T item) unselectedBuilder;

  /// The number of columns in the grid.
  final int crossAxisCount;

  /// The vertical spacing between rows.
  final int mainAxisSpacing;

  /// The horizontal spacing between columns.
  final int crossAxisSpacing;

  /// The index of the initially selected item.
  final int initialSelectedIndex;

  /// Called when the user activates a selected item.
  final void Function(int index, T item)? onItemSelected;

  /// Whether navigation wraps around at grid boundaries.
  final bool wrapAroundNavigation;

  @override
  State<GridView<T>> createState() => _GridViewState<T>();
}

class _GridViewState<T> extends State<GridView<T>>
    with FocusableState<GridView<T>> {
  int selectedIndex = 0;

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
    if (totalItems == 0) return;

    if (event.code == KeyCode.arrowUp) {
      _moveSelection(-widget.crossAxisCount);
    } else if (event.code == KeyCode.arrowDown) {
      _moveSelection(widget.crossAxisCount);
    } else if (event.code == KeyCode.arrowLeft) {
      _moveSelection(-1);
    } else if (event.code == KeyCode.arrowRight) {
      _moveSelection(1);
    } else if (event.isActivationKey) {
      if (selectedIndex >= 0 && selectedIndex < totalItems) {
        widget.onItemSelected?.call(selectedIndex, widget.items[selectedIndex]);
      }
    }
  }

  void _moveSelection(int delta) {
    setState(() {
      final totalItems = widget.items.length;
      if (totalItems == 0) return;

      if (widget.wrapAroundNavigation) {
        selectedIndex = (selectedIndex + delta) % totalItems;
        if (selectedIndex < 0) {
          selectedIndex += totalItems;
        }
      } else {
        selectedIndex = (selectedIndex + delta).clamp(0, totalItems - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final isSelected = i == selectedIndex && hasFocus;
      children.add(
        isSelected
            ? widget.selectedBuilder(item)
            : widget.unselectedBuilder(item),
      );
    }

    return _GridRenderWidget(
      children: children,
      crossAxisCount: widget.crossAxisCount,
      mainAxisSpacing: widget.mainAxisSpacing,
      crossAxisSpacing: widget.crossAxisSpacing,
    );
  }
}

class _GridRenderWidget extends MultiChildRenderObjectWidget {
  const _GridRenderWidget({
    required super.children,
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  });

  final int crossAxisCount;
  final int mainAxisSpacing;
  final int crossAxisSpacing;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderGridView(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final renderGrid = renderObject as RenderGridView;
    renderGrid.crossAxisCount = crossAxisCount;
    renderGrid.mainAxisSpacing = mainAxisSpacing;
    renderGrid.crossAxisSpacing = crossAxisSpacing;
  }
}

/// Parent data for children of [RenderGridView], storing their offset.
class GridParentData extends ParentData {
  /// The position of this child within the grid.
  Offset offset = Offset.zero;
}

/// Render object that lays out children in a grid with configurable columns and spacing.
class RenderGridView extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, GridParentData> {
  /// Creates a [RenderGridView] with the given column count and spacing.
  RenderGridView({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  });

  /// The number of columns in the grid.
  int crossAxisCount;

  /// The vertical spacing between rows.
  int mainAxisSpacing;

  /// The horizontal spacing between columns.
  int crossAxisSpacing;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! GridParentData) {
      child.parentData = GridParentData();
    }
  }

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;

    for (final child in children) {
      setupParentData(child);
      child.layout(boxConstraints.loosen());
    }

    if (children.isEmpty) {
      size = boxConstraints.constrain(const Size(1, 1));
      return;
    }

    final availableWidth = boxConstraints.maxWidth;
    final totalSpacing = crossAxisSpacing * (crossAxisCount - 1);
    final cellWidth = (availableWidth - totalSpacing) ~/ crossAxisCount;
    final maxRowHeight = _computeMaxRowHeight();
    final rowCount = (children.length / crossAxisCount).ceil();

    _positionChildren(cellWidth, maxRowHeight);

    final totalHeight =
        rowCount * maxRowHeight + (rowCount - 1) * mainAxisSpacing;
    size = boxConstraints.constrain(Size(availableWidth, totalHeight));
  }

  int _computeMaxRowHeight() {
    int maxRowHeight = 1;
    for (final child in children) {
      final childHeight = child.size?.height ?? 1;
      if (childHeight > maxRowHeight) {
        maxRowHeight = childHeight;
      }
    }
    return maxRowHeight;
  }

  void _positionChildren(int cellWidth, int maxRowHeight) {
    int x = 0;
    int y = 0;

    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      final parentData = child.parentData as GridParentData;

      parentData.offset = Offset(x, y);

      x += cellWidth + crossAxisSpacing;

      if ((i + 1) % crossAxisCount == 0) {
        x = 0;
        y += maxRowHeight + mainAxisSpacing;
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      final parentData = child.parentData as GridParentData;
      context.paintChild(child, offset + parentData.offset);
    }
  }
}
