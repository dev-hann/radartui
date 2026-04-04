import '../../../radartui.dart';

class SingleChildScrollView extends StatefulWidget {
  const SingleChildScrollView({
    super.key,
    required this.child,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.focusNode,
  });

  final Widget child;
  final ScrollController? controller;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final FocusNode? focusNode;

  @override
  State<SingleChildScrollView> createState() => _SingleChildScrollViewState();
}

class _SingleChildScrollViewState extends State<SingleChildScrollView>
    with FocusableState<SingleChildScrollView> {
  late ScrollController _scrollController;
  bool _ownsController = false;
  int _contentExtent = 0;

  @override
  FocusNode? get providedFocusNode => widget.focusNode;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _scrollController = widget.controller!;
      _ownsController = false;
    } else {
      _scrollController = ScrollController();
      _ownsController = true;
    }
    _scrollController.addListener(_onScrollChanged);
  }

  @override
  void didUpdateWidget(covariant SingleChildScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _scrollController.removeListener(_onScrollChanged);
      if (_ownsController) {
        _scrollController.dispose();
      }
      _initController();
    }
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

  void _handleContentSizeChanged(int extent) {
    _contentExtent = extent;
  }

  @override
  void onKeyEvent(KeyEvent event) {
    final mediaQuery = context.findAncestorWidgetOfExactType<MediaQuery>();
    final int viewportSize;
    if (widget.scrollDirection == Axis.vertical) {
      viewportSize = mediaQuery?.data.size.height ?? 24;
    } else {
      viewportSize = mediaQuery?.data.size.width ?? 80;
    }
    final int maxScroll = (_contentExtent - viewportSize).clamp(0, 999999);
    final delta = _computeScrollDelta(event, viewportSize);

    if (delta != 0) {
      _scrollController.offset = (_scrollController.offset + delta).clamp(
        0,
        maxScroll,
      );
    }
  }

  int _computeScrollDelta(KeyEvent event, int viewportSize) {
    if (event.code == KeyCode.pageDown) {
      return (viewportSize - 1).clamp(1, viewportSize);
    } else if (event.code == KeyCode.pageUp) {
      return -(viewportSize - 1).clamp(1, viewportSize);
    } else if (widget.scrollDirection == Axis.vertical) {
      if (event.code == KeyCode.arrowDown) return 1;
      if (event.code == KeyCode.arrowUp) return -1;
    } else {
      if (event.code == KeyCode.arrowRight) return 1;
      if (event.code == KeyCode.arrowLeft) return -1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget effectiveChild = widget.child;
    if (widget.padding != null) {
      effectiveChild = Padding(padding: widget.padding!, child: effectiveChild);
    }

    return _ScrollViewport(
      scrollOffset: _scrollController.offset,
      scrollDirection: widget.scrollDirection,
      onContentSizeChanged: _handleContentSizeChanged,
      child: effectiveChild,
    );
  }
}

class _ScrollViewport extends SingleChildRenderObjectWidget {
  const _ScrollViewport({
    required this.scrollOffset,
    required this.scrollDirection,
    this.onContentSizeChanged,
    required super.child,
  });

  final int scrollOffset;
  final Axis scrollDirection;
  final void Function(int)? onContentSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderScrollViewport(
        scrollOffset: scrollOffset,
        scrollDirection: scrollDirection,
        onContentSizeChanged: onContentSizeChanged,
      );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    final viewport = renderObject as _RenderScrollViewport;
    viewport.scrollOffset = scrollOffset;
    viewport.scrollDirection = scrollDirection;
    viewport.onContentSizeChanged = onContentSizeChanged;
  }
}

class _RenderScrollViewport extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderScrollViewport({
    required this.scrollOffset,
    required this.scrollDirection,
    this.onContentSizeChanged,
  });

  int scrollOffset;
  Axis scrollDirection;
  void Function(int)? onContentSizeChanged;

  @override
  void performLayout(Constraints constraints) {
    final boxConstraints = constraints.asBoxConstraints;

    if (child != null) {
      final childConstraints = _buildChildConstraints(boxConstraints);
      child!.layout(childConstraints);
      _notifyContentSize();
    }

    size = Size(boxConstraints.maxWidth, boxConstraints.maxHeight);
  }

  BoxConstraints _buildChildConstraints(BoxConstraints parentConstraints) {
    if (scrollDirection == Axis.vertical) {
      return BoxConstraints(
        minWidth: parentConstraints.minWidth,
        maxWidth: parentConstraints.maxWidth,
        minHeight: 0,
        maxHeight: Constraints.infinity,
      );
    }
    return BoxConstraints(
      minWidth: 0,
      maxWidth: Constraints.infinity,
      minHeight: parentConstraints.minHeight,
      maxHeight: parentConstraints.maxHeight,
    );
  }

  void _notifyContentSize() {
    final extent = scrollDirection == Axis.vertical
        ? child!.size!.height
        : child!.size!.width;
    onContentSizeChanged?.call(extent);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;

    final int childExtent = scrollDirection == Axis.vertical
        ? child!.size!.height
        : child!.size!.width;
    final int viewportExtent =
        scrollDirection == Axis.vertical ? size!.height : size!.width;
    final int maxOffset = (childExtent - viewportExtent).clamp(0, 999999);
    final int effectiveOffset = scrollOffset.clamp(0, maxOffset);

    int dx = 0;
    int dy = 0;
    if (scrollDirection == Axis.vertical) {
      dy = -effectiveOffset;
    } else {
      dx = -effectiveOffset;
    }
    context.paintChild(child!, offset + Offset(dx, dy));
  }
}
