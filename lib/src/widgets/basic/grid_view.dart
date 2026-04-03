import '../../../radartui.dart';

Widget _defaultSelectedBuilder<T>(T item) {
  return Text('> $item');
}

Widget _defaultUnselectedBuilder<T>(T item) {
  return Text('  $item');
}

class GridView<T> extends StatefulWidget {
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
  })  : selectedBuilder = selectedBuilder ?? _defaultSelectedBuilder,
        unselectedBuilder = unselectedBuilder ?? _defaultUnselectedBuilder;

  final List<T> items;
  final Widget Function(T item) selectedBuilder;
  final Widget Function(T item) unselectedBuilder;
  final int crossAxisCount;
  final int mainAxisSpacing;
  final int crossAxisSpacing;
  final int initialSelectedIndex;
  final void Function(int index, T item)? onItemSelected;
  final bool wrapAroundNavigation;

  @override
  State<GridView<T>> createState() => _GridViewState<T>();
}

class _GridViewState<T> extends State<GridView<T>> {
  int selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    selectedIndex =
        widget.initialSelectedIndex.clamp(0, widget.items.length - 1);
    FocusManager.instance.registerNode(_focusNode);
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChanged);
    _hasFocus = _focusNode.hasFocus;
  }

  @override
  void dispose() {
    FocusManager.instance.unregisterNode(_focusNode);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
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
    } else if (event.code == KeyCode.enter ||
        event.code == KeyCode.space ||
        (event.code == KeyCode.char && event.char == ' ')) {
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
      final isSelected = i == selectedIndex && _hasFocus;
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
  void updateRenderObject(
    BuildContext context,
    RenderObject renderObject,
  ) {
    final renderGrid = renderObject as RenderGridView;
    renderGrid.crossAxisCount = crossAxisCount;
    renderGrid.mainAxisSpacing = mainAxisSpacing;
    renderGrid.crossAxisSpacing = crossAxisSpacing;
  }
}

class GridParentData extends ParentData {
  Offset offset = Offset.zero;
}

class RenderGridView extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, GridParentData> {
  RenderGridView({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
  });

  int crossAxisCount;
  int mainAxisSpacing;
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

    int maxRowHeight = 1;
    for (final child in children) {
      final childHeight = child.size?.height ?? 1;
      if (childHeight > maxRowHeight) {
        maxRowHeight = childHeight;
      }
    }

    final rowCount = (children.length / crossAxisCount).ceil();

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

    final totalHeight =
        rowCount * maxRowHeight + (rowCount - 1) * mainAxisSpacing;
    size = boxConstraints.constrain(Size(availableWidth, totalHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in children) {
      final parentData = child.parentData as GridParentData;
      context.paintChild(child, offset + parentData.offset);
    }
  }
}
