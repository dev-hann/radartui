import 'package:radartui/radartui.dart';

import '../framework.dart';
import 'focus.dart';
import 'text.dart';
import 'column.dart';
import '../../services/key_parser.dart';
import '../../services/logger.dart';

class ListView extends StatefulWidget {
  final List<String> items;
  final String? selectedPrefix;
  final String? unselectedPrefix;
  final String? focusedBorder;
  final String? unfocusedBorder;
  final int initialSelectedIndex;
  final void Function(int index, String item)? onItemSelected;
  final FocusNode? focusNode;

  const ListView({
    required this.items,
    this.focusNode,
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
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    AppLogger.log('🔵 ListView.initState() - ${hashCode}');
    selectedIndex = widget.initialSelectedIndex.clamp(
      0,
      widget.items.length - 1,
    );
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.onKeyEvent = _handleKeyEvent;
    _focusNode.addListener(_onFocusChanged);
    // 초기 focus 상태 동기화
    _hasFocus = _focusNode.hasFocus;
    AppLogger.log('🔵 ListView.initState() - focus: $_hasFocus, focusNode: ${_focusNode.hashCode}');
    super.initState();
  }

  @override
  void dispose() {
    // The widget owns the focus node, so it should not dispose it here.
    // The owner of the node is responsible for disposing it.
    _focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(ListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      // Clean up listeners from the old node
      _focusNode.removeListener(_onFocusChanged);
      _focusNode.onKeyEvent = null;

      // Set up the new node
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.onKeyEvent = _handleKeyEvent;
      _focusNode.addListener(_onFocusChanged);
      // 새로운 focus node의 상태로 동기화
      _hasFocus = _focusNode.hasFocus;
    }
    
    // 🔧 FIX: 네비게이션 후 올바른 스코프에 재등록 보장
    _focusNode.ensureRegistered();
  }

  void _handleKeyEvent(KeyEvent event) {
    AppLogger.log('🎯 ListView._handleKeyEvent() - key: "${event.key}", focus: $_hasFocus, selectedIndex: $selectedIndex');
    switch (event.key) {
      case 'ArrowUp':
      case 'k':
        AppLogger.log('🔼 Moving selection UP');
        _moveSelection(-1);
        break;
      case 'ArrowDown':
      case 'j':
        AppLogger.log('🔽 Moving selection DOWN');
        _moveSelection(1);
        break;
      case 'Enter':
      case ' ':
        AppLogger.log('✅ Selecting item $selectedIndex');
        if (selectedIndex >= 0 && selectedIndex < widget.items.length) {
          widget.onItemSelected?.call(
            selectedIndex,
            widget.items[selectedIndex],
          );
        }
        break;
      default:
        AppLogger.log('❓ Unhandled key: "${event.key}"');
        break;
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
    AppLogger.log('📍 Selection moved: $oldIndex -> $selectedIndex (direction: $direction)');
  }

  void _onFocusChanged() {
    AppLogger.log('🔄 ListView._onFocusChanged() - hasFocus: ${_focusNode.hasFocus}');
    setState(() {
      // focus 상태 동기화 및 UI 갱신
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLogger.log('🎨 ListView.build() - selectedIndex: $selectedIndex, hasFocus: $_hasFocus');
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

      AppLogger.log('🔍 Item $index: $item - selected: $isSelected, prefix: "$prefix"');
      children.add(Text('$prefix$item'));
    }

    if (borderPrefix != null) {
      children.add(Text(borderPrefix));
    }

    return Column(children: children);
  }
}
