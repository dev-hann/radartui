import 'package:radartui/radartui.dart';
import 'package:radartui/src/widgets/basic/focus.dart';
import 'package:radartui/src/services/key_parser.dart';
import 'dart:async';

class ListView extends StatefulWidget {
  final List<String> items;
  final String? selectedPrefix;
  final String? unselectedPrefix;
  final String? focusedBorder;
  final String? unfocusedBorder;
  final int initialSelectedIndex;
  final void Function(int index, String item)? onItemSelected;
  final FocusNode? focusNode;
  final bool autofocus;

  const ListView({
    required this.items,
    this.selectedPrefix = '> ',
    this.unselectedPrefix = '  ',
    this.focusedBorder = '[ ]',
    this.unfocusedBorder = '   ',
    this.initialSelectedIndex = 0,
    this.onItemSelected,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<ListView> createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  late int selectedIndex;
  late FocusNode _focusNode;
  StreamSubscription<KeyEvent>? _keySubscription;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex.clamp(0, widget.items.length - 1);
    _focusNode = widget.focusNode ?? FocusNode();
    
    _setupKeyboardListener();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // FocusScope에 등록 - didChangeDependencies에서 context 안전하게 접근
    final scope = FocusScopeProvider.of(context);
    scope?._addNode(_focusNode);
    
    if (widget.autofocus) {
      _focusNode.requestFocus();
    }
  }

  void _setupKeyboardListener() {
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((event) {
      // 포커스가 있을 때만 키보드 이벤트 처리
      if (_focusNode.hasFocus) {
        _handleKeyEvent(event);
      }
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    switch (event.key) {
      case 'ArrowUp':
      case 'k':
        _moveSelection(-1);
        break;
      case 'ArrowDown':
      case 'j':
        _moveSelection(1);
        break;
      case 'Enter':
      case ' ':
        if (selectedIndex >= 0 && selectedIndex < widget.items.length) {
          widget.onItemSelected?.call(selectedIndex, widget.items[selectedIndex]);
        }
        break;
    }
  }

  void _moveSelection(int direction) {
    setState(() {
      selectedIndex = (selectedIndex + direction).clamp(0, widget.items.length - 1);
    });
  }

  void _onFocusChanged() {
    setState(() {}); // 포커스 상태 변경 시 다시 그리기
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasFocus = _focusNode.hasFocus;
    final borderPrefix = hasFocus ? widget.focusedBorder : widget.unfocusedBorder;
    
    return Column(
      children: [
        if (borderPrefix != null) Text(borderPrefix),
        ...widget.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == selectedIndex && hasFocus;
          final prefix = isSelected ? widget.selectedPrefix : widget.unselectedPrefix;
          
          return Text('$prefix$item');
        }).toList(),
        if (borderPrefix != null) Text(borderPrefix),
      ],
    );
  }
}