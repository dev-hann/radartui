import 'package:radartui/radartui.dart';

class ListView extends StatefulWidget {
  final List<String> items;
  final String? selectedPrefix;
  final String? unselectedPrefix;
  final String? focusedBorder;
  final String? unfocusedBorder;
  final int initialSelectedIndex;
  final void Function(int index, String item)? onItemSelected;

  const ListView({
    required this.items,
    this.selectedPrefix = '> ',
    this.unselectedPrefix = '  ',
    this.focusedBorder = '[ ]',
    this.unfocusedBorder = '   ',
    this.initialSelectedIndex = 0,
    this.onItemSelected,
  });

  @override
  State<ListView> createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  int selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    selectedIndex = widget.initialSelectedIndex.clamp(
      0,
      widget.items.length - 1,
    );
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChanged);
    // 초기 focus 상태 동기화
    _hasFocus = _focusNode.hasFocus;
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event.code == KeyCode.arrowUp ||
        (event.code == KeyCode.char && event.char == 'k')) {
      _moveSelection(-1);
    } else if (event.code == KeyCode.arrowDown ||
        (event.code == KeyCode.char && event.char == 'j')) {
      _moveSelection(1);
    } else if (event.code == KeyCode.enter ||
        (event.code == KeyCode.char && event.char == ' ')) {
      if (selectedIndex >= 0 && selectedIndex < widget.items.length) {
        widget.onItemSelected?.call(selectedIndex, widget.items[selectedIndex]);
      }
    }
  }

  void _moveSelection(int direction) {
    final oldIndex = selectedIndex;
    setState(() {
      selectedIndex = (selectedIndex + direction).clamp(
        0,
        widget.items.length - 1,
      );
    });
    AppLogger.log(
      '📍 Selection moved: $oldIndex -> $selectedIndex (direction: $direction)',
    );
  }

  void _onFocusChanged() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderPrefix =
        _hasFocus ? widget.focusedBorder : widget.unfocusedBorder;

    final children = <Widget>[];

    if (borderPrefix != null) {
      children.add(Text(borderPrefix));
    }

    for (final entry in widget.items.asMap().entries) {
      final index = entry.key;
      final item = entry.value;
      final isSelected = index == selectedIndex && _hasFocus;
      final prefix =
          isSelected ? widget.selectedPrefix : widget.unselectedPrefix;
      children.add(Text('$prefix$item'));
    }

    if (borderPrefix != null) {
      children.add(Text(borderPrefix));
    }

    return Column(children: children);
  }
}
