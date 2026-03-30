import '../../../radartui.dart';

class TabController extends ChangeNotifier {
  TabController({required this.length, int initialIndex = 0})
    : _index = initialIndex,
      _previousIndex = initialIndex;

  final int length;
  int _index;
  int _previousIndex;

  int get index => _index;
  int get previousIndex => _previousIndex;

  set index(int value) {
    if (value == _index) return;
    _previousIndex = _index;
    _index = value.clamp(0, length - 1);
    notifyListeners();
  }
}

class TabBar extends StatefulWidget {
  const TabBar({required this.tabs, this.controller, this.onTap});

  final List<String> tabs;
  final TabController? controller;
  final void Function(int)? onTap;

  @override
  State<TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<TabBar> {
  late TabController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TabController(length: widget.tabs.length);
    _controller.addListener(_onTabChanged);
    FocusManager.instance.registerNode(_focusNode);
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChange);
    _hasFocus = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(TabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_onTabChanged);
      _controller =
          widget.controller ?? TabController(length: widget.tabs.length);
      _controller.addListener(_onTabChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTabChanged);
    FocusManager.instance.unregisterNode(_focusNode);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.arrowLeft) {
      if (_controller.index > 0) {
        _controller.index--;
        widget.onTap?.call(_controller.index);
      }
    } else if (event.code == KeyCode.arrowRight) {
      if (_controller.index < widget.tabs.length - 1) {
        _controller.index++;
        widget.onTap?.call(_controller.index);
      }
    } else if (event.code == KeyCode.enter ||
        (event.code == KeyCode.char && event.char == ' ')) {
      widget.onTap?.call(_controller.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < widget.tabs.length; i++) {
      final isSelected = i == _controller.index;
      final tab = widget.tabs[i];
      children.add(
        Container(
          color: isSelected && _hasFocus ? Color.blue : Color.black,
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            isSelected ? '[$tab]' : ' $tab ',
            style: TextStyle(
              color: isSelected ? Color.white : Color.brightBlack,
              bold: isSelected,
            ),
          ),
        ),
      );
    }
    return Row(children: children);
  }
}

class TabBarView extends StatefulWidget {
  const TabBarView({required this.children, required this.controller});

  final List<Widget> children;
  final TabController controller;

  @override
  State<TabBarView> createState() => _TabBarViewState();
}

class _TabBarViewState extends State<TabBarView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(TabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onTabChanged);
      widget.controller.addListener(_onTabChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.controller.index,
      children: widget.children,
    );
  }
}
